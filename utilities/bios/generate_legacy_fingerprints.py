#!/usr/bin/env python3
"""
Generate SKSE/Plugins/SkyrimNet/legacy-fingerprints.json: the git blob SHA of
every file SkyrimNet ever shipped in its prompt/config trees, across the whole
history of this repo.

Why: the pre-store engine seeded shipped bios into the live `prompts/` tree at
startup, which under MO2 landed in the user's overwrite — thousands of stock
files the legacy import assistant must not offer as "your content", and that
the cleanup action may safely delete. A file whose bytes match one of these
fingerprints is provably a copy of something SkyrimNet shipped (any version),
carrying no user information.

The set is CLOSED: seeding died with the content store, so only blobs shipped
before the restructure can appear in anyone's overwrite. Regeneration is only
needed if history itself grows a new source path.

Committed output ships inside the mod (the build copies SKSE/Plugins/SkyrimNet
wholesale), read by Core's ContentLegacyFingerprints.

Usage: python generate_legacy_fingerprints.py   (from anywhere in the repo)
"""
from __future__ import annotations

import json
import subprocess
import sys
from datetime import datetime, timezone
from pathlib import Path

REPO = Path(__file__).resolve().parents[2]
OUT = REPO / "SKSE/Plugins/SkyrimNet/legacy-fingerprints.json"

# Every path that ever held shipped prompt/config content. Blobs are
# LF-normalized by git's text handling at commit time, so consumers must
# compare both raw and CRLF->LF-normalized bytes.
HISTORY_PATHS = [
    "SKSE/Plugins/SkyrimNet/prompts",
    "SKSE/Plugins/SkyrimNet/original_prompts",
    "SKSE/Plugins/SkyrimNet/config",
    "plugins/skyrimnet/base/prompts",
]


def git(*args: str) -> str:
    return subprocess.run(["git", "-C", str(REPO), *args], capture_output=True,
                          text=True, check=True).stdout


def main() -> None:
    commits = git("rev-list", "--all", "--", *HISTORY_PATHS).split()
    blobs: set[str] = set()
    for commit in commits:
        for path in HISTORY_PATHS:
            for line in git("ls-tree", "-r", commit, "--", path).splitlines():
                # <mode> blob <sha>\t<path>
                meta = line.split("\t", 1)[0].split()
                if len(meta) == 3 and meta[1] == "blob":
                    blobs.add(meta[2])
    doc = {
        "schema_version": 1,
        "generated_at": datetime.now(timezone.utc).strftime("%Y-%m-%dT%H:%M:%SZ"),
        "commits_scanned": len(commits),
        "blobs": sorted(blobs),
    }
    OUT.write_text(json.dumps(doc, indent=0) + "\n", encoding="utf-8", newline="\n")
    print(f"{len(blobs)} fingerprints from {len(commits)} commits -> {OUT}")


if __name__ == "__main__":
    main()
