#!/usr/bin/env python3
"""
Partition the shipped character bios into `skyrimnet.base` and per-source-mod
`skyrimnet.bios-{mod}` hub packs (CONTENT_STORE_DESIGN.md ruling 26).

Attribution source: the translation CSVs under prompts/translation/ - they are
the only place a bio is tied to the plugin (ESP/ESM) its NPC comes from:

  unique/*.csv   pluginName, refId,  sanitizedEnglishKey  -> bio `{key}_{last 3 hex of refId}`
  generic/*.csv  pluginName, formId, sanitizedEnglishKey  -> bio `{key}_generic`

(The engine builds the unique bio name as `{key}_{formId & 0xFFF:03X}` -
see Core include/Skyrim/utils/UUIDResolver.h - so the match is exact, not a
suffix guess.)

Rules
  * Base plugins (Skyrim.esm, Update.esm, the three DLC ESMs, and cc*.esl/esm
    Creation Club) -> stays in skyrimnet.base.
  * One mod plugin            -> that mod's pack.
  * Several claimants         -> base if any claimant is base; otherwise the
                                 bio ships in EVERY claimant's pack (ETaC Complete
                                 vs ETaC modular, HP/LP follower variants - the NPC
                                 really is in each). Identical bytes, so the
                                 cross-pack conflict is benign. Listed for review.
  * No CSV row at all         -> base (status quo) and listed for triage.
  * overrides.csv             -> wins over everything above (bioKey, target, note)
                                 where target is `base` or one or more plugin
                                 file names joined by ` | `.
  * mod-titles.csv            -> optional display title / slug per plugin file.
  * Plugin names that fold to the same slug (`ETaC - Complete.esp` with an
    en-dash vs a hyphen) are ONE pack; every spelling is listed in `mods[]`,
    the most-claimed spelling as required.

Usage
  partition_bios.py report  [--gameplugin PATH]            # stats + triage lists
  partition_bios.py write   --out DIR [--min-skyrimnet X]  # emit base/ and packs/

Reads bytes and writes bytes: prompt content is never reformatted.
"""
from __future__ import annotations

import argparse
import collections
import csv
import json
import re
import shutil
import sys
from pathlib import Path

HERE = Path(__file__).resolve().parent
DEFAULT_GAMEPLUGIN = HERE.parent.parent
DATA_REL = Path("SKSE/Plugins/SkyrimNet")
CHARACTERS_REL = DATA_REL / "original_prompts/characters"
UNIQUE_CSV_REL = DATA_REL / "prompts/translation/unique"
GENERIC_CSV_REL = DATA_REL / "prompts/translation/generic"

OVERRIDES_CSV = HERE / "overrides.csv"
MOD_TITLES_CSV = HERE / "mod-titles.csv"

BASE_PLUGINS = {"skyrim.esm", "update.esm", "dawnguard.esm", "hearthfires.esm", "dragonborn.esm"}
PACK_AUTHOR = "skyrimnet"
PACK_ID_PREFIX = "bios-"
PACK_VERSION = "1.0.0"
ID_SEGMENT_RE = re.compile(r"^[a-z0-9_-]{1,64}$")

Assignment = dict[str, list[str]]  # bio -> ["base"] | [plugin file, ...]


def is_base_plugin(plugin: str) -> bool:
    p = plugin.lower()
    return p in BASE_PLUGINS or p.startswith("cc")


def strip_ext(plugin_file: str) -> str:
    return re.sub(r"\.(esp|esm|esl)$", "", plugin_file, flags=re.I)


def slugify(plugin_file: str) -> str:
    s = re.sub(r"[^a-z0-9]+", "-", strip_ext(plugin_file).lower()).strip("-")
    s = re.sub(r"-{2,}", "-", s)
    if not ID_SEGMENT_RE.match(PACK_ID_PREFIX + s):
        sys.exit(f"cannot derive a valid slug from plugin '{plugin_file}' -> '{s}'")
    return s


def read_csv_rows(directory: Path):
    for path in sorted(directory.glob("*.csv")):
        with path.open(encoding="utf-8-sig", newline="") as fh:
            for row in csv.DictReader(fh):
                yield row


def load_optional_csv(path: Path):
    if not path.exists():
        return []
    with path.open(encoding="utf-8-sig", newline="") as fh:
        return [r for r in csv.DictReader(fh) if any((v or "").strip() for v in r.values())]


def attribute(gameplugin: Path):
    chars_dir = gameplugin / CHARACTERS_REL
    bios = sorted(p.stem for p in chars_dir.glob("*.prompt"))
    bio_set = set(bios)
    by_lower = {b.lower(): b for b in bios}

    claims: dict[str, set[str]] = collections.defaultdict(set)
    for row in read_csv_rows(gameplugin / UNIQUE_CSV_REL):
        key, ref = row["sanitizedEnglishKey"].strip(), row["refId"].strip()
        if not key or not ref:
            continue
        bio = f"{key}_{int(ref, 16) & 0xFFF:03X}"
        hit = bio if bio in bio_set else by_lower.get(bio.lower())
        if hit:
            claims[hit].add(row["pluginName"].strip())
    for row in read_csv_rows(gameplugin / GENERIC_CSV_REL):
        bio = f"{row['sanitizedEnglishKey'].strip()}_generic"
        if bio in bio_set:
            claims[bio].add(row["pluginName"].strip())

    plugin_totals = collections.Counter(p for ps in claims.values() for p in ps)

    overrides = {r["bioKey"].strip(): r for r in load_optional_csv(OVERRIDES_CSV)}
    unknown_overrides = sorted(set(overrides) - bio_set)

    assignment: Assignment = {}
    triage_unattributed: list[str] = []
    triage_multi: list[tuple[str, list[str], list[str]]] = []
    for bio in bios:
        if bio in overrides:
            assignment[bio] = [t.strip() for t in overrides[bio]["target"].split("|") if t.strip()]
            continue
        ps = sorted(claims.get(bio, ()))
        if not ps:
            assignment[bio] = ["base"]
            triage_unattributed.append(bio)
        elif len(ps) == 1:
            assignment[bio] = ["base"] if is_base_plugin(ps[0]) else ps
        else:
            chosen = ["base"] if any(is_base_plugin(p) for p in ps) else ps
            assignment[bio] = chosen
            triage_multi.append((bio, ps, chosen))

    return bios, assignment, plugin_totals, triage_unattributed, triage_multi, unknown_overrides


def pack_groups(assignment: Assignment, plugin_totals):
    """Group bios by pack slug -> (bios, [plugin spellings, most-claimed first]).
    The base group is keyed "base" with an empty spelling list."""
    by_slug: dict[str, list[str]] = collections.defaultdict(list)
    spellings: dict[str, set[str]] = collections.defaultdict(set)
    for bio, targets in assignment.items():
        for t in targets:
            key = "base" if t == "base" else slugify(t)
            if bio not in by_slug[key]:
                by_slug[key].append(bio)
            if t != "base":
                spellings[key].add(t)
    return {
        k: (v, sorted(spellings[k], key=lambda p: (-plugin_totals[p], p)))
        for k, v in by_slug.items()
    }


def size_bucket(n: int) -> str:
    return "1" if n == 1 else "2-4" if n < 5 else "5-9" if n < 10 else "10-29" if n < 30 else "30+"


def cmd_report(args):
    gameplugin = Path(args.gameplugin).resolve()
    bios, assignment, totals, unattributed, multi, bad_overrides = attribute(gameplugin)
    groups = pack_groups(assignment, totals)
    base_bios = groups.get("base", ([], []))[0]
    mods = {k: v for k, v in groups.items() if k != "base"}
    distinct_pack_bios = len({b for v, _ in mods.values() for b in v})
    print(f"bios: {len(bios)}")
    print(f"base: {len(base_bios)}   packs: {len(mods)}   distinct pack bios: {distinct_pack_bios}")
    sizes = collections.Counter(size_bucket(len(v)) for v, _ in mods.values())
    print("pack sizes:", dict(sorted(sizes.items())))
    merged = {k: n for k, (_, n) in mods.items() if len(n) > 1}
    print(f"packs merging several plugin spellings: {len(merged)} {merged}")
    print(f"unattributed (-> base, needs triage): {len(unattributed)}")
    print(f"multi-claim (shipped in every claimant pack, needs review): {len(multi)}")
    if bad_overrides:
        print(f"WARNING overrides.csv names {len(bad_overrides)} unknown bios: {bad_overrides[:10]}")

    out = HERE / "report"
    out.mkdir(exist_ok=True)
    (out / "unattributed.txt").write_text("\n".join(unattributed) + "\n", encoding="utf-8")
    with (out / "multi-claim.csv").open("w", encoding="utf-8", newline="") as fh:
        w = csv.writer(fh)
        w.writerow(["bioKey", "claimants", "shippedIn"])
        for bio, ps, chosen in multi:
            w.writerow([bio, " | ".join(ps), " | ".join(chosen)])
    with (out / "packs.csv").open("w", encoding="utf-8", newline="") as fh:
        w = csv.writer(fh)
        w.writerow(["slug", "bioCount", "pluginFiles"])
        for slug, (items, names) in sorted(mods.items(), key=lambda kv: (-len(kv[1][0]), kv[0])):
            w.writerow([slug, len(items), " | ".join(names)])
    with (out / "assignment.csv").open("w", encoding="utf-8", newline="") as fh:
        w = csv.writer(fh)
        w.writerow(["bioKey", "targets"])
        for bio in bios:
            w.writerow([bio, " | ".join(assignment[bio])])
    print(f"wrote {out}/unattributed.txt, multi-claim.csv, packs.csv, assignment.csv")


def build_manifest(plugin_files: list[str], slug: str, title: str, count: int, min_skyrimnet: str):
    plural = "s" if count != 1 else ""
    primary = plugin_files[0]
    return {
        "id": f"{PACK_AUTHOR}.{PACK_ID_PREFIX}{slug}",
        "type": "bundle",
        "title": f"{title} - Character Bios",
        "tagline": f"Hand-written SkyrimNet bios for {count} NPC{plural} from {title}.",
        "description": (
            f"Official SkyrimNet character bios for NPCs added by {title} ({primary}).\n\n"
            f"Install this if {primary} is in your load order. NPCs without a static bio "
            "still get one generated automatically from their game data; this pack replaces that "
            "with the community-curated version.\n\n"
            "Bios are the work of the SkyrimNet community."
        ),
        "author": PACK_AUTHOR,
        "version": PACK_VERSION,
        "min_skyrimnet_version": min_skyrimnet,
        "tags": ["bios", "characters"],
        "nsfw": False,
        "icon": "users",
        "mods": [{"name": title, "file": f, "required": i == 0} for i, f in enumerate(plugin_files)],
        "requirements": [],
    }


def cmd_write(args):
    gameplugin = Path(args.gameplugin).resolve()
    out = Path(args.out).resolve()
    bios, assignment, totals, unattributed, multi, bad_overrides = attribute(gameplugin)
    if bad_overrides:
        sys.exit(f"overrides.csv names unknown bios: {bad_overrides}")
    titles = {r["pluginFile"].strip(): r for r in load_optional_csv(MOD_TITLES_CSV)}
    groups = pack_groups(assignment, totals)
    chars_dir = gameplugin / CHARACTERS_REL

    if out.exists():
        shutil.rmtree(out)
    base_bios = groups.get("base", ([], []))[0]
    base_chars = out / "base" / "prompts" / "characters"
    base_chars.mkdir(parents=True)
    for bio in base_bios:
        shutil.copy2(chars_dir / f"{bio}.prompt", base_chars / f"{bio}.prompt")

    written = 0
    for auto_slug, (items, names) in sorted(groups.items()):
        if auto_slug == "base":
            continue
        meta = next((titles[n] for n in names if n in titles), {})
        slug = (meta.get("slug") or "").strip() or auto_slug
        title = (meta.get("title") or "").strip() or strip_ext(names[0])
        pack_dir = out / "packs" / f"{PACK_AUTHOR}.{PACK_ID_PREFIX}{slug}"
        if pack_dir.exists():
            sys.exit(f"slug collision on '{slug}' (check mod-titles.csv slug overrides)")
        (pack_dir / "prompts" / "characters").mkdir(parents=True)
        for bio in items:
            shutil.copy2(chars_dir / f"{bio}.prompt", pack_dir / "prompts" / "characters" / f"{bio}.prompt")
        manifest = build_manifest(names, slug, title, len(items), args.min_skyrimnet)
        (pack_dir / "manifest.json").write_text(
            json.dumps(manifest, indent=2, ensure_ascii=False) + "\n", encoding="utf-8")
        written += 1
    print(f"wrote {len(base_bios)} base bios and {written} packs under {out}")


def main():
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("--gameplugin", default=str(DEFAULT_GAMEPLUGIN))
    sub = ap.add_subparsers(dest="cmd", required=True)
    sub.add_parser("report").set_defaults(fn=cmd_report)
    w = sub.add_parser("write")
    w.add_argument("--out", required=True)
    w.add_argument("--min-skyrimnet", default="0.24.0")
    w.set_defaults(fn=cmd_write)
    args = ap.parse_args()
    args.fn(args)


if __name__ == "__main__":
    main()
