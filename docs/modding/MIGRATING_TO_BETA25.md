# Migrating SkyrimNet Content to Beta 25

For authors of bios, prompts, triggers, actions and knowledge packs. Beta 25 (0.25.0) changes
how content is delivered and where it lives. The file formats do not change.

## TL;DR

Beta 25 stops reading `prompts/`, `config/triggers/` and `config/actions/`. Content is now a
plugin folder with a manifest. For most plugins the fastest migration is done entirely in the
dashboard:

1. Install Beta 25 with your old files still in the old folders.
2. **Plugins > Import Old Content**, tick your files, import.
3. **Plugins > My Plugins > New Plugin**, name it, tick the files, **Package**.
4. Either **Sign In** and **Publish** to put it on the Hub, or copy
   `library/{author}.{slug}/` (manifest plus content folders) into your mod archive at
   `Data/SKSE/Plugins/SkyrimNet/external/{author}.{slug}/`.

Import renames trigger and action files to match their `name` field. Knowledge packs need a
re-export from Beta 25 first. Everything else below is detail.

## What changed

Until Beta 24, content was loose files under `Data/SKSE/Plugins/SkyrimNet/`:

```
prompts/
config/triggers/
config/actions/
```

Beta 25 does not read those folders. Files left there are ignored, not deleted.

Content is now delivered as a **plugin**: a folder with a `manifest.json` and the content files
inside it. On the player's machine every plugin is one layer of what SkyrimNet calls the
**content library**; the highest-priority layer that has a file provides it. A plugin reaches a
player one of two ways:

| Route | How it gets to the player |
|---|---|
| **Plugin Hub** | You publish from the SkyrimNet dashboard. Players install and update from the Plugins page. |
| **External layer** | You ship the plugin folder inside your mod archive. The mod manager installs it. |

Both can be used for the same plugin (see [Doing both](#doing-both)).

## The Plugin Hub

The Hub is a community catalogue built into the dashboard, under **Plugins** in the sidebar.
Players browse it, install with one click, see updates, reorder priority, disable, roll back and
uninstall. If two plugins provide the same file, the dashboard shows which one wins and lets the
player pick.

For authors:

- When you publish a new version, players who installed the plugin see an update available on
  the Plugins page and choose when to apply it. Uninstall removes exactly the files you shipped.
- Player edits to your files are stored in their own layer. Your updates never overwrite an
  edit, and an edit never blocks your update.
- Bios, prompts, triggers and knowledge packs are reviewed automatically. Plugins that contain
  actions are reviewed by a person, because actions call script functions in other mods.
- Publishing needs a fateless.ai account, signed in from the dashboard. Your username is your
  author name. Browsing and installing need no account.
- A **listing** is a Hub entry with no files that links to your mod page. Use one if your
  content ships inside your mod but you want it in the catalogue.

## Folder layout on the player's machine

Under `Data/SKSE/Plugins/SkyrimNet/`:

| Folder | Contents |
|---|---|
| `library/` | Plugins installed from the Hub, and plugins the player packaged locally. Written only by SkyrimNet. |
| `external/` | Plugins shipped inside other mods. |
| `overlay/` | The player's own dashboard edits. |
| `saves/` | Per-playthrough character bios. |

Priority, highest first: per-playthrough files, the player's edits, installed and external
plugins in the player's chosen order (a newly found external layer starts at the top), SkyrimNet's
shipped defaults.

Do not ship files into `library/`. A folder there that SkyrimNet did not install is ignored.
`external/` is the folder for content delivered by hand.

## Migrating the files

### Layout

```
{author}.{slug}/
    manifest.json
    prompts/       same sub-folders as before
    triggers/
    actions/
    knowledge/
```

| Before | After |
|---|---|
| `prompts/**` | `prompts/**`, unchanged |
| `config/triggers/*.yaml` | `triggers/*.yaml` |
| `config/actions/*.yaml` | `actions/*.yaml` |
| `.sknpack` files | `knowledge/*.sknpack`, re-exported from Beta 25 |

Prompts resolve as before. `prompts/characters/Lydia.prompt` is still Lydia's bio,
`prompts/submodules/character_bio/0301_mymod.prompt` is still picked up as a submodule, and a
file at the same path as a shipped one replaces it.

### Trigger and action filenames

The filename must equal the in-file `name`, compared case-insensitively: letters, digits, `_`
and `-` only, and the part before the first dot is what is compared. Casing is yours to keep, and
it is what the LLM sees — `givegold.yaml` carrying `name: GiveGold` is a valid file.

```yaml
# actions/givegold.yaml
name: GiveGold
```

The import assistant names the file by the lowercased name and rewrites the `name` field only when
it carries characters a filename cannot: `Banter2.yaml` with `name: Combat Banter` becomes
`combat_banter.yaml` with `name: Combat_Banter`, while `cat_economy.yaml` with `name: Economy`
becomes `economy.yaml` with the `name` untouched.

Per-action `enabled` and `cooldown` settings are keyed by action name. Renaming an action resets
those settings for players who changed them. The dashboard lists the affected actions for them.

Extensions are exact and case-sensitive: `.yaml`, `.prompt`, `.sknpack`. `.yml` and `.YAML`
are rejected.

### Knowledge packs

World knowledge now has two kinds of entries:

- **Persistent packs** are `.sknpack` files delivered by plugins (or sitting in the player's
  overlay). They apply to every playthrough and carry a **Persistent** badge on the World
  Knowledge page. SkyrimNet projects each installed pack into a save's
  database when that save loads and again whenever content changes, and it owns those rows: an
  update to the pack changes the entries in place, and uninstalling or disabling the plugin
  removes or deactivates them. Players cannot edit these rows directly. They can turn individual
  entries off per playthrough, edit an entry for the current playthrough only (which makes a
  personal copy and deactivates yours), or edit it for all playthroughs (which writes a copy of
  the pack into their overlay that shadows yours until they revert).
- **Save-specific entries** are rows the player creates on the World Knowledge page, or that the
  game generates. They belong to one save and are never shipped in a plugin.

Beta 25 packs carry a stable key per entry, which is what lets an update change an entry in
place without resetting the player's per-entry toggles. Packs exported before Beta 25 cannot be
shipped in a plugin. To convert one: import it on the World Knowledge page in Beta 25, then
press **Export to Overlay**. The pack lands in your overlay ready to package. Group names
ship with the pack; membership stays per playthrough.

### Manifest

```json
{
  "id": "yourname.your-plugin",
  "type": "bundle",
  "title": "Your Plugin",
  "tagline": "One sentence for the browse card.",
  "description": "Longer description. Markdown allowed.",
  "author": "yourname",
  "tags": ["followers", "dialogue"],
  "nsfw": false,
  "icon": "sparkles",
  "version": "1.0.0",
  "min_skyrimnet_version": "0.25.0"
}
```

- `id` is `author.slug`: lowercase, letters, digits, `_`, `-`, one dot between the halves. The
  folder name must equal the id. `skyrimnet` and `skyrimnet-*` are reserved authors.
- `version` is strict semver: `1.0.0`, not `1.0` or `v1.0.0`. Bump it whenever files change;
  that is what offers players an update and decides which copy wins.
- `min_skyrimnet_version`: the dashboard stamps it at publish. For an external layer, write the
  version you tested against. On the Hub, a player on an older build gets the plugin installed
  but disabled, with a message. For an external layer it is informational.
- `mods` (optional): `[{ "name": "My Follower", "file": "MyFollower.esp", "required": true }]`.
  Missing mods produce a warning at install, never a block.

Packaging and publishing from the dashboard writes this file for you.

### Not allowed in a plugin

- Per-playthrough bios (`prompts/_saves/**`). Players carry these over with the import assistant.
- Generated bios (`characters/dynamic/**`, `*.dynamic.prompt`). SkyrimNet regenerates them.
- Anything outside the four content folders.
- Non-ASCII file or folder names.

## Route A: Hub

Requires Beta 25 with Skyrim running.

1. **Get the files into your overlay.** If they are still in the old folders, open **Plugins >
   Import Old Content**, tick them, import. Triggers and actions are renamed to the new rule
   automatically. Files identical to shipped content are skipped. Nothing is moved or deleted.
   Alternatively, create the files in the dashboard editors.
2. **Package.** **Plugins > My Plugins > New Plugin** opens the Package Plugin page: title,
   author, version, tick the files, **Package**. The files move from the overlay into a local
   plugin at the top of your priority order. Local plugins are editable in place (**Manage** on
   the plugin's row).
3. **Publish.** Sign in, then **Publish** on the plugin's row under My Plugins, fill in the
   metadata, **Publish**. Every file is validated first. Action plugins additionally ask which
   mod each action calls into and for an in-game test attestation.
4. **Review.** The submission shows on the **Submissions** tab of My Plugins while it is in
   review. Automatic review takes minutes for non-action plugins. Rejections say why, on the row.

**Updates:** **Manage** the local plugin (files and version), then **Publish** again. A version
bump is required when any file changed. **Edit** on a published plugin changes only its Hub
listing (title, description, tags), not its files.

## Route B: external layer

Ship the plugin folder inside your mod archive at:

```
Data/SKSE/Plugins/SkyrimNet/external/{author}.{slug}/
```

SkyrimNet registers it at start-up, enabled, at the top of the priority order, and lists it on
the Installed Plugins page with an **External** badge. Removing the mod removes it from play.

To build the folder, package it in the dashboard (Route A, steps 1 and 2) and copy
`manifest.json` plus the content folders out of `library/{author}.{slug}/`, or write the manifest
by hand.

- Folder name must equal the manifest `id`, or the whole folder is rejected with a visible error.
- Same file rules as the Hub. A file that breaks one is skipped with a warning; the rest loads.
- SkyrimNet never writes inside `external/`. Player edits go to their overlay.
- Disabling the mod in the mod manager keeps the player's settings for it until it returns.
- Updates are your mod updates. Bump `version` when files change.

To check a build: install the archive, confirm the plugin appears under Installed Plugins. A
rejected folder shows there with the reason. Skipped files are warnings in `SkyrimNet.log`.

## Doing both

One active copy per plugin id. Higher version wins; on a tie a local copy wins, then the
external copy over the Hub copy. Keep the id identical on both routes. A common setup is the plugin inside the mod,
the same plugin on the Hub, and a listing pointing at the mod page.

## For your players

Worth putting in your mod description:

- Old files in the old folders are untouched but no longer read.
- Install the plugin from the Hub, or update the mod if it now ships the plugin.
- **Plugins > Import Old Content** copies old files into the player's own layer. That is for
  their personal tweaks and per-playthrough bios, not for your content: an imported copy hides
  every later update of yours.
- Renamed actions need their enabled and cooldown settings set again, once.
- Modpacks must not include `library/`, `overlay/`, `saves/` or `content-registry.json`. Those are
  per-player state. Ship curated content as an external layer.

## Checklist

- [ ] Files moved into the plugin layout; `config/` prefix dropped
- [ ] Trigger and action filenames equal their in-file `name` (case-insensitively; keep your casing)
- [ ] Extensions exactly `.prompt`, `.yaml`, `.sknpack`
- [ ] Knowledge packs re-exported from Beta 25
- [ ] No per-playthrough or generated bios
- [ ] `manifest.json` with valid `id`, semver `version`, `min_skyrimnet_version`
- [ ] Folder name equals `id` (external layers)
- [ ] Plugin appears under Installed Plugins with no skipped files in the log
- [ ] Mod page updated

Trigger, action and prompt references are unchanged: `WORKFLOW_TRIGGERS.md`,
`WORKFLOW_ACTIONS.md`, `WORKFLOW_PROMPTS.md`.
