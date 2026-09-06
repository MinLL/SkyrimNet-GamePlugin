---
description: "Port a Beta 24 loose-file SkyrimNet mod to the Beta 25 content-store layout"
---

# Migrate to Beta 25

You port a mod author's Beta 24 SkyrimNet content — a loose `config/actions`, `config/triggers`,
`prompts/**` tree — to the Beta 25 content-store layout, ready to ship as an external layer inside
their mod.

The mechanical transform is **not** yours to perform. `content-convert` applies the naming, path,
extension, and manifest rules; a hand-migration will disagree with the installer sooner or later.
Your job is the judgment the tool cannot make: finding the tree, authoring the manifest fields, and
reading the tool's report back to the author.

The rule reference is the migration guide, `docs/modding/MIGRATING_TO_BETA25.md`
(MinLL/SkyrimNet-GamePlugin#563). This skill automates its Route B (external layer). If the guide
is not in the working tree, read it from the PR.

## The tool

`content-convert.exe` is built from the SkyrimNet core repo (`cmake/Tools.cmake`) and ships beside
the installed plugin. It runs headless — no game, no content store.

```
content-convert <src-tree> <out-dir> --target-version <semver> --manifest <fields.json>
                [--base-tree <dir>] [--fingerprints <dir>]
```

- `<src-tree>` — the directory holding the mod's `config/` and `prompts/` folders.
- `<out-dir>` — a **staging** directory you create. Never point this at a live `external/`.
- `--base-tree` — the installed `plugins/skyrimnet/base/`; files byte-identical to what SkyrimNet
  ships are skipped instead of shipped again.
- `--fingerprints` — the installed `SKSE/Plugins/SkyrimNet/` directory, which holds
  `legacy-fingerprints.json`; content SkyrimNet used to ship is skipped the same way.

Exit code 0 means every file converted and the manifest passed the same identity gate installing a
plugin applies. Anything else means the layer is incomplete.

## Step 1: Find the loose tree

Locate the mod's `SkyrimNet/config` and `SkyrimNet/prompts` folders — usually under
`SKSE/Plugins/SkyrimNet/` in the mod's install. Confirm with the author which directory is the
source before converting anything; the tool only ever reads it, but converting the wrong tree
wastes their review.

## Step 2: Author the manifest fields

Write `manifest-input.json` next to the staging directory:

```json
{
  "id": "{author}.{slug}",
  "title": "Display Name",
  "tagline": "One line the store list shows",
  "description": "What this pack adds.",
  "version": "1.0.0",
  "author": "{author}",
  "nsfw": false,
  "tags": ["actions", "companions"],
  "mods": [{ "name": "Mod Display Name", "file": "TheMod.esp", "required": true }]
}
```

- `id` is `{author}.{slug}`, both segments `[a-z0-9_-]`, exactly one dot. The `skyrimnet` author
  namespace is reserved.
- `mods[]` names the ESPs the content is written against. Read the mod's plugin file name off its
  ESP rather than guessing it from the mod's display name.
- Ask the author for `title`, `tagline`, `description`, and `tags`. These are theirs, not yours.

## Step 3: Convert

```
content-convert <src-tree> <staging-dir> --target-version 0.25.0 \
  --manifest manifest-input.json \
  --base-tree "<install>/plugins/skyrimnet/base" \
  --fingerprints "<install>/SKSE/Plugins/SkyrimNet"
```

Use the SkyrimNet version the author is targeting for `--target-version`.

**On a nonzero exit, stop.** Relay the printed issues and orphaned action settings verbatim and
work through them with the author — a rejected file means the layer would be missing content, and a
partial pack is worse than an unmigrated one. Do not hand-write the rejected files into the output.

Orphaned action settings are expected on any rename, not a failure: they tell the author which
per-action enable/cooldown settings to re-apply once the pack is installed.

## Step 4: Report

On exit 0, tell the author:

- Where the converted layer is, and that it goes into their mod as
  `SKSE/Plugins/SkyrimNet/external/{id}/` — the layer directory name is the plugin id.
- Which files were renamed (the tool prints them), because their own documentation and any external
  references to those action names need the same update.
- Any orphaned action settings to re-apply after installing.

Then point them at the Hub. Shipping inside a mod works and is fully supported, but the SkyrimNet
Plugin Hub is the preferred distribution path: users install and update from the dashboard, get
compatibility warnings before install rather than after, and the pack is discoverable. The
converted layer is already a valid hub bundle — the same `manifest.json` and the same directory
shape — so publishing later costs the author nothing they have not already done.
