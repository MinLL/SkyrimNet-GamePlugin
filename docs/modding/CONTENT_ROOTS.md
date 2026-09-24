# Content Roots and the Release Each Needs

A plugin folder (`library/{author}.{slug}/` locally, `external/{author}.{slug}/` inside a mod,
or a hub submission) holds one directory per content root. This page lists every root, what a
file under it is, which in-file field must equal the filename, and the SkyrimNet release that
reads it. Formats are described in the workflow docs beside this one; migration from the
pre-Beta 25 folders is in `MIGRATING_TO_BETA25.md`.

## The roots

| Root | File | Filename must equal | Release | Hub-gated |
|---|---|---|---|---|
| `prompts/` | `.prompt` template | the path is the identity | Beta 25 (0.25.0) | no |
| `triggers/` | `.yaml` trigger | `name` | Beta 25 (0.25.0) | no |
| `actions/` | `.yaml` action | `name` | Beta 25 (0.25.0) | no |
| `knowledge/` | `.sknpack` knowledge pack | the path (entries by `key`) | Beta 25 (0.25.0) | no |
| `entities/` | `.entity.yaml` virtual entity | the path (records by `entityName`) | Beta 25 (0.25.0) | no |
| `voice_effects/` | `.yaml` voice effect recipe | `id` | Beta 25 (0.25.0) | yes |
| `items/` | `.yaml` item customization | form stem of `form` | Beta 25 (0.25.0) | yes |
| `spells/` | `.yaml` spell customization | form stem of `form` | Beta 25 (0.25.0) | yes |
| `furniture/` | `.yaml` furniture name | form stem of `form` | Beta 25 (0.25.0) | yes |
| `identity/` | `.yaml` identity link (`kind: link`, the default) or `kind: succession` | slug of `name` | Beta 25 (0.25.0) | yes |
| `filters/` | `.yaml` `kind: actor` / `memory` list contribution, or `kind: dialogue_rule` / `tts_rule` | contributions: anything; rules: `id` | Beta 25 (0.25.0) | yes |
| `translator/` | `.yaml` `kind: npc` / `faction` / `race` / `global` speech rule | npc: form stem of `form`; faction, race: `entityEditorId`; global: `global.yaml` | Beta 25 (0.25.0) | yes |
| `dialogue_actions/` | `.yaml` `kind: lists` contribution or `kind: instruction` | lists: anything; instructions: `key` | Beta 25 (0.25.0) | yes |

The eight roots from `voice_effects/` down are the config-system roots: the customizations a
user otherwise keeps in their own `config/`, shipped as content, one record per file, with the
same install, disable, reorder, pin and override tools as a prompt. Beta 25 (0.25.0) reads all
eight, and a plugin shipping one must declare a `min_skyrimnet_version` of at least 0.25.0,
because an engine older than the release does not know the root — the hub installer refuses the
whole plugin, and a third-party `external/` layer logs a warning naming the directory and skips
it.

## Rules that apply to every record root

- **The filename is the identity.** `name`, `id`, `key` and `entityEditorId` compare
  case-insensitively with the **filename stem**: the filename up to its first dot
  (`draugr.yaml` → `draugr`, `foo.entity.yaml` → `foo`). The slug of an identity link's
  `name` is the name lowercased with every run of characters outside `a-z0-9` replaced by one
  `_` (`Serana's Shadow` → `serana_s_shadow.yaml`).
- **Form-keyed records** (`items/`, `spells/`, `furniture/`, `translator/` `kind: npc`) carry
  `form: "Plugin.esp|0x01396B"`: the defining plugin's full filename, `|`, and the
  plugin-relative form id (24 bits, or 12 for an `.esl`). Quote it; a bare `0x01396B` is a
  YAML integer. The filename is the reference's **form stem**, compared exactly. The plugin
  filename is split at its **last** dot; the stem is the name lowercased with every byte outside
  `a-z0-9_` replaced by `_` and cut at 40 UTF-8 bytes, then `-esm` or `-esl` for those
  extensions, then — when a byte was replaced, the name was cut, the name is empty, or the
  extension is not `.esp`/`.esm`/`.esl` — `-` and the FNV-1a 32-bit hash (8 lowercase hex
  digits) of the lowercased full filename, extension included, then `_` and the id as six
  upper-case hex digits. `Skyrim.esm|0x01396B` → `skyrim-esm_01396B.yaml`;
  `Mod A.esp|0x000123` → `mod_a-a44f2ca6_000123.yaml`. The dashboard names these files; do not
  rename them by hand. An `.esl` file's id is at most `0xFFF`, and the hub refuses a wider one;
  an ESL-flagged `.esp` cannot be told from its name, so write its 12-bit id as the dashboard
  does.
- **Identity links name an NPC as `npc:Plugin.esp:0xLocalID`** (`identityA`/`identityB` on a
  link, `from`/`to` on a succession): the same plugin and plugin-relative id as a `form`, split
  by `:`. The runtime form id spelling, `npc:0A012345`, depends on load order; the hub refuses
  it.
- **`enabled:` in a record is the user's on/off toggle** wherever a record carries it. Spell and
  item records say whether the form appears in NPC equipment and spell lists in prompts with
  `show_in_prompts: true|false` (true when omitted); `enabled` on those two roots is refused by
  the hub. `npc_usable`, the field's old name, is an unknown field there — not read, not refused.
- **`kind:` picks the record type within a root** where a root holds more than one.
- **A dialogue or TTS rule needs a `pattern`**: a non-empty regular expression of at most 1024
  bytes; the hub refuses one that is missing, empty, over-long or does not compile.
- **`priority` on a filter rule or translator rule is an integer**: lower runs first, 100 when
  omitted, ties broken by path.
- **Dialogue-action instructions** may name a `category`, which overrides the line's own
  classification: `quest`, `follower`, `merchant`, `trainer`, `carriage`, `innkeeper`, `bard`,
  `marriage`, `crime` or `other`.
- **Contributions union.** A `filters/` `kind: actor` or `kind: memory` file (any of
  `FactionWhitelist`, `FactionBlacklist`, `RaceWhitelist`, `RaceBlacklist`, `GenderWhitelist`,
  `GenderBlacklist`, each a list of strings), and a `dialogue_actions/` `kind: lists` file
  (`whitelist`, `blacklist`), add their entries to the user's lists; the user's remedy is the
  file's toggle. A whitelist contribution widens what may speak or fire. Give each file an
  optional `name` and `description`: the dashboard lists every contribution by them. Keep one
  purpose per file, as base does, so a user can switch off exactly what they don't want.
- **Size.** 64 KB per voice-effect recipe, 32 KB per record elsewhere, 1 MB per knowledge pack.
