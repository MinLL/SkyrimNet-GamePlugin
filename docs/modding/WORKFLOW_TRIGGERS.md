# SkyrimNet Trigger Creation Workflow

> **Purpose:** This is an interactive workflow for AI assistants to help users create triggers that detect game events and generate responses.

## What Are Triggers?

Triggers are YAML files that:
- Watch for specific game events (spell casts, combat, mod events, etc.)
- Filter events based on conditions
- Generate responses (thoughts, narration, diary entries, etc.)

---

## PHASE 1: Discovery - Understanding What the User Wants

### Step 1.1: Clarify the Goal

**ASK THE USER:**
- "What game event or situation do you want to react to?"
- "What should happen when this event occurs? (player thought, narration, NPC awareness, diary entry?)"
- "Is this for a specific mod? Do you have its source code in the workspace?"

**GATHER:**
- The triggering scenario (e.g., "when I cast a healing spell", "when a mod event fires")
- The desired response type
- Who should be aware of this event

### Step 1.2: Check Source Code (if mod-related)

**If this trigger is for a specific mod and source is available:**
- Read Papyrus scripts to understand when/how events are sent
- Look for `SendModEvent()` calls to find exact event names and parameters
- Understand the context in which events fire

> **⚠️ CRITICAL:** Source code helps you *understand* when events fire, but **MCP's `get_monitored_events` is the source of truth** for actual event data. Always verify event names, field names, and values via MCP.

### Step 1.3: Identify the Event Source

**DETERMINE if this is:**

| Scenario | Approach |
|----------|----------|
| "Something just happened in-game" | Use `get_monitored_events` to see what fired |
| "A specific mod does X" | Read source for context, then query `get_monitored_events` filtered by `mod_event` |
| "When a spell/effect happens" | Check `spell_cast` or `active_effect` events |
| "During combat/death/etc" | Standard game events - check event type list |

---

## PHASE 2: Event Exploration - Finding the Right Event

### Step 2.1: Query Live Events via MCP (REQUIRED - Source of Truth)

**ALWAYS query live events from the running game, even if you have source code:**

```
mcp_skyrimnet-mcp_get_monitored_events:
  - count: 100
  - include_animations: false  (reduce noise unless looking for animations)
```

If looking for a specific type:
```
mcp_skyrimnet-mcp_get_monitored_events:
  - count: 50
  - event_type: "mod_event"  (or spell_cast, active_effect, etc.)
```

> Source code tells you what *should* happen; MCP shows what *actually* happens. Field names and values in live events may differ from source.

### Step 2.2: Analyze Event Structure

**For each relevant event, note:**

```json
{
  "eventType": "...",        // → becomes eventCriteria.eventType
  "source": "...",           // → who triggered it
  "summary": "...",          // → human-readable description
  "extraData": {             // → fields for schemaConditions
    "field1": "value1",
    "field2": 123
  }
}
```

**Map `extraData` fields to `schemaConditions`:**
- `extraData.event_name` → `fieldPath: "event_name"`
- `extraData.spell` → `fieldPath: "spell"`
- `extraData.action` → `fieldPath: "action"`

### Step 2.3: Present Findings to User

**SHOW THE USER:**
- The event(s) that match their description
- The exact field values available
- Propose which fields to filter on

**ASK:** "I found [event type] with these fields. Does this look like what you want to trigger on?"

---

## PHASE 3: Response Design

### Step 3.1: Choose Response Type

| Type | Use For | Example |
|------|---------|---------|
| `player_thought` | Internal thoughts only player sees | "I feel the magic coursing through me" |
| `player_dialogue` | Player speaks out loud | "That spell took a lot out of me..." |
| `direct_narration` | Narrative text NPCs react to | "*The healing magic washes over the wounded warrior*" |
| `persistent_generic` | Register event without NPC dialogue | Background event logging |
| `diary_entry` | Create diary entry for actor(s) | Reflection on significant events |
| `dynamic_bio_update` | Update character biography | Long-term character development |
| `npc_thought` | Unvoiced internal thought for the target NPC(s), private to the thinker | "That stranger smells of blood" |
| `enable_virtual_npc` / `disable_virtual_npc` | Enable or disable a virtual NPC by name; set `targetName` instead of `content` | Wake a spirit companion |
| `activate_voice_effect` / `deactivate_voice_effect` | Apply or clear a voice effect recipe on the target actor(s); set `effectId` (activate only) and `targetScope` | Werewolf voice during transformation |

### Step 3.2: Choose Audience

| Audience | Who Perceives It |
|----------|------------------|
| `player` | Only the player (default) |
| `originator` | Actor that caused the event |
| `target` | Target of the event |
| `originator_or_target` | Either one |
| `everyone` | All nearby actors |
| `nearby_npcs` | NPCs only (not player) |
| `enabled_virtual_npcs` | All currently enabled virtual NPCs |

### Step 3.3: Design Content Template

**Available variables in `response.content`** (set per event by the trigger engine, on top of the prompt engine's default variables):

| Variable | Description |
|----------|-------------|
| `{{ originator }}` | Display name of the event's originating actor (see below for which actor that is) |
| `{{ originator_uuid }}` | That actor's UUID; usable in decorators, e.g. `{{ decnpc(originator_uuid).possessivePronoun }}` |
| `{{ target }}` / `{{ target_uuid }}` | The event's target actor name / UUID, when the event has one |
| `{{ actor.name }}` / `{{ actor.UUID }}` | The originating actor as a JSON object (same actor as `originator`) |
| `{{ target_actor.name }}` / `{{ target_actor.UUID }}` | The target actor as a JSON object |
| `{{ player_name }}` or `{{ player.name }}` | Player's name (`{{ player.UUID }}` for the UUID) |
| `{{ event_json.field }}` | Any field from the event's `extraData`, e.g. `{{ event_json.spell }}` |
| `{{ event_type }}` | The event type string |
| `{{ event_location }}` | Location recorded on the event |
| `{{ location }}` | Player's current location name |
| `{{ gameTime }}` | In-game date/time string |
| `{{ timestamp }}` | Unix timestamp (seconds) |

Which actor is `originator` depends on the event. For most events it is the actor the event is about (`actor`, `victim`, `aggressor`, ...). For `active_effect` it is the actor the effect was applied to (`event_json.target`) and `target` is the caster, so a self-cast effect names the caster either way.

A variable the engine does not know is a render error, not empty text: the trigger logs the error and posts the template verbatim, braces included. Only use names from this table, `event_json` fields the event actually carries, or decorator calls.

**For `diary_entry`, `dynamic_bio_update`, `npc_thought` and the voice-effect types, also set:**
- `targetScope`: `triggering_actor`, `player`, `all_pinned_actors`, `all_nearby_actors`, `all_enabled_virtual_npcs`
- `nearbyRadius`: Radius in game units for `all_nearby_actors` (default 2000)

**For `enable_virtual_npc` / `disable_virtual_npc`:** set `targetName` (the virtual NPC's name; templates allowed). **For `activate_voice_effect`:** set `effectId` (a voice effect recipe id).

---

## PHASE 4: Build the Trigger

### Step 4.1: Construct YAML Structure

```yaml
name: "unique_trigger_name"
description: "Human-readable description"

eventCriteria:
  eventType: "EVENT_TYPE_HERE"
  schemaConditions:
    - fieldPath: "field_name"
      operator: "equals"
      value: "expected_value"
      caseSensitive: false  # optional, default true
  # logicalOperator: "OR"    # optional, default AND: how the conditions above combine

response:
  type: "player_thought"
  content: "Template with {{ variables }}"
  # For diary_entry / dynamic_bio_update / npc_thought / voice effects:
  # targetScope: "triggering_actor"
  # nearbyRadius: 2000
  # For enable_virtual_npc / disable_virtual_npc:
  # targetName: "Spirit Guide"
  # For activate_voice_effect:
  # effectId: "werewolf"

audience: "player"

enabled: true
probability: 1.0
cooldownSeconds: 30
priority: 1
interrupt: false   # optional: true purges queued dialogue/audio before responding
```

`eventCriteria` may also be a list of rule objects (each with its own `eventType` and `schemaConditions`); the rules are OR-ed, so the trigger fires when any one of them matches.

### Step 4.2: Schema Condition Operators

Operator names are exact; an unknown operator never matches and only logs a warning.

| Operator | Field type | Description |
|----------|------------|-------------|
| `equals` / `not_equals` | any | Exact match |
| `contains` / `not_contains` | string, array | Substring match (string) or element match (array) |
| `starts_with` / `ends_with` | string | String prefix/suffix |
| `regex` | string | Regular expression (`std::regex_search`) |
| `greater_than` / `less_than` | number | Numeric comparison |
| `greater_equal` / `less_equal` | number | Numeric with equality |
| `length_equals` / `length_greater` / `length_less` | array | Array length checks |
| `has_field` / `not_has_field` | object | Object has / lacks a property |

String comparisons honour `caseSensitive` (default `true`). There is no `matches_regex`, `greater_than_or_equal` or `less_than_or_equal`; use `regex`, `greater_equal` and `less_equal`.

---

## PHASE 5: Validation (REQUIRED)

### Step 5.1: Validate with MCP

**ALWAYS validate before finalizing:**

```
mcp_skyrimnet-mcp_validate_custom_trigger:
  yaml_content: |
    name: "your_trigger_name"
    # ... full YAML content ...
```

**Check response:**
- `valid: true` → Proceed
- `valid: false` + `error` → Fix the issue and re-validate

### Step 5.2: Review with User

**PRESENT:**
- The complete YAML
- What events it will match
- What response will be generated

**ASK:** "Does this trigger look correct? Would you like to adjust anything?"

---

## Event Type Reference

| Event Type | Description | Key `extraData` Fields |
|------------|-------------|------------------------|
| `spell_cast` | Spell casting | `actor`, `spell`, `spell_id`, `spell_editor_id` |
| `active_effect` | Magic effect applied/removed | `action` (applied/removed), `effect`, `effect_editor_id`, `caster`, `target`, `caster_uuid`, `target_uuid` |
| `hit` | Combat hit | `aggressor`, `target`, `weapon_id`, `flags` |
| `combat` | Combat state change | `actor`, `target`, `new_state` (Combat/NonCombat) |
| `death` | Actor death | `victim`, `killer`, `death_type`, `is_dead`, `is_summoned` |
| `activation` | Object/furniture use | `actor`, `target_name`, `activator_editor_id` |
| `equip` | Equipment change | `actor`, `item`, `action`, `equipped` |
| `sleep_start` / `sleep_stop` | Sleep events | `actor` |
| `book_read` | Book reading (automatic on Book Menu close, or via the Capture Crosshair hotkey while reading — hotkey captures emit once after the menu closes) | `book_name`, `book_title`, `book_text`, `is_note`, `book_vision_description` |
| `quest_stage` | Quest progression | `quest`, `quest_id`, `stage` |
| `quest_start_stop` | Quest start/end | `quest`, `quest_id`, `started` (boolean) |
| `location_change` | Location changed | `actor`, `from_location`, `to_location` |
| `container_changed` | Items moved | `item`, `item_count`, `from_container`, `to_container` |
| `enter_bleedout` | Actor collapses | `actor` |
| `animation_event` | Animation played | `tag`, `actor_name`, `actor_form_id`, `actor_uuid`, `payload`, `graph_vars` |
| `mod_event` | SKSE mod event | `event_name`, `str_arg`, `num_arg`, `sender_name`, `sender_form_id` |
| `crime` | Criminal activity | `criminal`, `crime_type`, `victim`, `bounty` |
| `dragon_soul` | Dragon soul absorbed | `absorber`, `dragon_name` |
| `dialogue` | AI-generated dialogue | `speaker`, `dialogue`, `listener` |
| `notification` | Corner notification shown to the player | `message` |
| `messagebox` | Message box shown to the player | `message`, `buttons`, `button_count`, `title`, `source_plugin`, `editor_id` |
| `trade_start` / `trade_complete` | Barter menu opened / closed | `merchant`, `merchant_form_id`; complete adds `items_bought`, `items_sold`, `gold_spent`, `gold_received`, `net_gold` |
| `lock_changed` | Lock picked or locked | `actor`, `object_name`, `action` (locked/unlocked), `lock_level` |
| `quest_objective_state` | Quest objective state change | `quest`, `objective`, `old_state`, `new_state` |
| `cell_attach_detach` | Cell attach/detach | `actor`, `from_cell`, `to_cell`, `action` (attach/detach) |
| `scene` / `scene_action` / `scene_phase` | Engine scene lifecycle | `scene_name`, `action`, `participants` / `actor`, `action` / `phase`, `phase_number` |
| `package_apply` / `package_remove` | SkyrimNet package override applied/removed | `actor`, `package_type` |
| `diary_entry_created` | An NPC diary entry was written | `actor`, `emotion`, `importance_score`, `entry_id`, `entry_contents` |
| `custom` | Custom event from Papyrus | `description`, `data` |
| `direct_narration` / `persistent_generic` / `player_thoughts` / `npc_thoughts` | SkyrimNet's own outputs (narration, generic events, thoughts) | `narration` / `line` / `dialogue`, `speaker` |
| `dialogue_npc` / `dialogue_player` / `dialogue_player_stt` / `dialogue_player_text` / `dialogue_background` / `dialogue_player_monologue` / `dialogue_player_telepathy` / `dialogue_npc_telepathy` | Vanilla and player dialogue variants | `speaker`, `dialogue`, `listener` |
| `*` | Wildcard - ALL events | (varies) |

Each event also sets the trigger's `originator` and `target` actors: for `active_effect` the originator is the affected actor and the target is the caster; for `hit` the originator is the aggressor and the target the victim; for `death` the originator is the victim and the target the killer; for `dialogue` the originator is the speaker. `get_monitored_events` shows the live shape, and `validate_custom_trigger` rejects an `eventType` the engine does not know.

---

## Complete Examples

### Example: Mod Event Trigger

```yaml
name: "osla_high_arousal_thought"
description: "Player notices high arousal from OSLA mod"

eventCriteria:
  eventType: "mod_event"
  schemaConditions:
    - fieldPath: "event_name"
      operator: "equals"
      value: "OSLA_ActorArousalUpdated"
    - fieldPath: "sender_form_id"
      operator: "equals"
      value: "00000014"  # Player form ID
    - fieldPath: "num_arg"
      operator: "greater_than"
      value: 75

response:
  type: "player_thought"
  content: "My thoughts drift to... distracting places."

audience: "player"
enabled: true
probability: 0.3
cooldownSeconds: 300
priority: 1
```

### Example: Notification Trigger

```yaml
name: "shrine_blessing_thought"
description: "Player reflects on a blessing announced by a corner notification"

eventCriteria:
  eventType: "notification"
  schemaConditions:
    - fieldPath: "message"
      operator: "regex"
      value: "Blessing of .*"

response:
  type: "player_thought"
  content: "The shrine's words linger: {{ event_json.message }}"

audience: "player"
enabled: true
probability: 1.0
cooldownSeconds: 60
priority: 1
```

The whole notification text arrives as `message`; gate on a pattern with a `contains` or `regex`
condition and render the text with `{{ event_json.message }}`. SkyrimNet's own notifications are
excluded, so a trigger never fires on the plugin's own output.

### Example: Spell Cast with Narration

```yaml
name: "healing_spell_narration"
description: "Narrate when player casts healing magic"

eventCriteria:
  eventType: "spell_cast"
  schemaConditions:
    - fieldPath: "spell"
      operator: "contains"
      value: "Heal"
      caseSensitive: false
    - fieldPath: "actor"
      operator: "equals"
      value: "{{ player_name }}"

response:
  type: "direct_narration"
  content: "*Warm golden light flows from {{ player_name }}'s hands as the healing magic takes effect.*"

audience: "nearby_npcs"
enabled: true
probability: 0.5
cooldownSeconds: 60
priority: 1
```

### Example: Active Effect Trigger

```yaml
name: "buff_expired_awareness"
description: "Player notices when protective spell fades"

eventCriteria:
  eventType: "active_effect"
  schemaConditions:
    - fieldPath: "action"
      operator: "equals"
      value: "removed"
    - fieldPath: "target_uuid"
      operator: "equals"
      value: "{{ player.UUID }}"
    - fieldPath: "effect"
      operator: "contains"
      value: "Armor"

response:
  type: "player_thought"
  content: "The {{ event_json.effect }} spell fades. I feel exposed once more."

audience: "player"
enabled: true
probability: 0.7
cooldownSeconds: 10
priority: 1
```

### Example: Emote Narration Naming the Actor

```yaml
name: "emote_bow_narration"
description: "Narrate to nearby NPCs when someone performs the bow emote spell"

eventCriteria:
  eventType: "active_effect"
  schemaConditions:
    - fieldPath: "effect"
      operator: "equals"
      value: "IdlePlayBowME"
      caseSensitive: false
    - fieldPath: "action"
      operator: "equals"
      value: "applied"

response:
  type: "direct_narration"
  content: "{{ originator }} bows deeply, {{ decnpc(originator_uuid).possessivePronoun }} eyes lowered."

audience: "nearby_npcs"
enabled: true
cooldownSeconds: 5
priority: 6
```

`originator` here is the actor the effect landed on; for a self-cast emote that is the caster.

---

## Workflow Checklist

- [ ] Clarified what event/situation user wants to react to
- [ ] Queried `get_monitored_events` to find real event data
- [ ] Identified the correct `eventType` and `extraData` fields
- [ ] Chose appropriate response type and audience
- [ ] Designed content template with variables
- [ ] Set reasonable probability and cooldown
- [ ] **Validated with `validate_custom_trigger`**
- [ ] Reviewed final YAML with user

