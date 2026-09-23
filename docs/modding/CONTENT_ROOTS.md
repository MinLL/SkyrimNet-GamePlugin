# Content Roots and the Release Each Needs

A plugin folder (`library/{author}.{slug}/` locally, `external/{author}.{slug}/` inside a mod,
or a hub submission) holds one directory per content root. This page lists every root, what a
file under it is, which in-file field must equal the filename, and the oldest SkyrimNet release
that reads it. Formats are described in the workflow docs beside this one; migration from the
pre-Beta 25 folders is in `MIGRATING_TO_BETA25.md`.

## The roots

| Root | File | Filename must equal | Needs SkyrimNet |
|---|---|---|---|
| `prompts/` | `.prompt` template | the path is the identity | Beta 25, no hub gate |
| `triggers/` | `.yaml` trigger | `name` | Beta 25, no hub gate |
| `actions/` | `.yaml` action | `name` | Beta 25, no hub gate |
| `knowledge/` | `.sknpack` knowledge pack | the path (entries by `key`) | Beta 25, no hub gate |
| `entities/` | `.entity.yaml` virtual entity | the path (records by `entityName`) | Beta 25, no hub gate |
| `voice_effects/` | `.yaml` voice effect recipe | `id` | 0.25.0 |
| `items/` | `.yaml` item customization | form stem of `form` | 0.25.0 |
| `spells/` | `.yaml` spell customization | form stem of `form` | 0.25.0 |
| `furniture/` | `.yaml` furniture name | form stem of `form` | 0.25.0 |
| `identity/` | `.yaml` identity link (`kind: link`, the default) or `kind: succession` | slug of `name` | 0.25.0 |
| `filters/` | `.yaml` `kind: actor` / `memory` list contribution, or `kind: dialogue_rule` / `tts_rule` | contributions: anything; rules: `id` | 0.25.0 |
| `translator/` | `.yaml` `kind: npc` / `faction` / `race` / `global` speech rule | npc: form stem of `form`; faction, race: `entityEditorId`; global: `global.yaml` | 0.25.0 |
| `dialogue_actions/` | `.yaml` `kind: lists` contribution or `kind: instruction` | lists: anything; instructions: `key` | 0.25.0 |

The eight roots from `voice_effects/` down are the config-system roots: the customizations
that used to live only in a user's own `config/` now ship as content, one record per file,
with the same install, disable, reorder, pin and override tools as a prompt. An engine older
than the release in the last column does not know the root: the hub installer refuses the
whole plugin, and a third-party `external/` layer logs a warning naming the directory and
skips it. Set `min_skyrimnet_version` accordingly; the hub refuses to publish a plugin whose
manifest declares less than the root needs.

## Rules that apply to every record root

- **The filename is the identity.** `name`, `id`, `key` and `entityEditorId` compare
  case-insensitively with the filename minus its extension. The slug of an identity link's
  `name` is the name lowercased with every run of characters outside `a-z0-9` replaced by one
  `_` (`Serana's Shadow` → `serana_s_shadow.yaml`).
- **Form-keyed records** (`items/`, `spells/`, `furniture/`, `translator/` `kind: npc`) carry
  `form: "Plugin.esp|0x01396B"`: the defining plugin's full filename, `|`, and the
  plugin-relative form id (24 bits, or 12 for an ESL-flagged plugin). Quote it; a bare
  `0x01396B` is a YAML integer. The filename is the reference's **form stem**, exactly:
  the plugin name lowercased with bytes outside `a-z0-9_` as `_`, `-esm` or `-esl` for those
  extensions, a `-xxxxxxxx` FNV-1a hash when anything was replaced or the name was over 40
  bytes, then `_` and the id as six upper-case hex digits. `Skyrim.esm|0x01396B` →
  `skyrim-esm_01396B.yaml`; `Mod A.esp|0x000123` → `mod_a-a44f2ca6_000123.yaml`. The
  dashboard names these files; do not rename them by hand.
- **`enabled:` in a record is the user's on/off toggle**, on every root. Spell and item
  records say whether NPCs may use the form with `npc_usable: true|false`; `enabled` on
  those two roots is refused by the hub.
- **`kind:` picks the record type within a root** where a root holds more than one.
- **Dialogue-action instructions** name a `category`: `quest`, `follower`, `merchant`,
  `trainer`, `carriage`, `innkeeper`, `bard`, `marriage`, `crime` or `other`.
- **Contributions union.** A `filters/` `kind: actor` or `kind: memory` file, and a
  `dialogue_actions/` `kind: lists` file, adds its entries to the user's lists; the user's
  remedy is the file's toggle. A whitelist contribution widens what may speak or fire.
- **Size.** 64 KB per voice-effect recipe, 32 KB per record elsewhere, 1 MB per knowledge pack.
