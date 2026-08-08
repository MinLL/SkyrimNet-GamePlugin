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

### Step 3.2: Choose Audience

| Audience | Who Perceives It |
|----------|------------------|
| `player` | Only the player (default) |
| `originator` | Actor that caused the event |
| `target` | Target of the event |
| `originator_or_target` | Either one |
| `everyone` | All nearby actors |
| `nearby_npcs` | NPCs only (not player) |

### Step 3.3: Design Content Template

**Available variables in `response.content`:**

| Variable | Description |
|----------|-------------|
| `{{ player_name }}` or `{{ player.name }}` | Player's name |
| `{{ event_json.field }}` | Any field from event extraData |
| `{{ time_desc }}` | Relative time description |
| `{{ location }}` | Current location name |
| `{{ gameTimeStr }}` | In-game date/time |

**For `diary_entry` / `dynamic_bio_update`, also set:**
- `targetScope`: `triggering_actor`, `player`, `all_pinned_actors`, `all_nearby_actors`
- `nearbyRadius`: Radius in game units (default 2000)

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

response:
  type: "player_thought"
  content: "Template with {{ variables }}"
  # For diary_entry / dynamic_bio_update:
  # targetScope: "triggering_actor"
  # nearbyRadius: 2000

audience: "player"

enabled: true
probability: 1.0
cooldownSeconds: 30
priority: 1
```

### Step 4.2: Schema Condition Operators

| Operator | Description |
|----------|-------------|
| `equals` / `not_equals` | Exact match |
| `contains` / `not_contains` | Substring match |
| `greater_than` / `less_than` | Numeric comparison |
| `greater_than_or_equal` / `less_than_or_equal` | Numeric with equality |
| `starts_with` / `ends_with` | String prefix/suffix |
| `matches_regex` | Regular expression |

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
| `book_read` | Book reading | `book_name`, `book_title`, `book_text` |
| `book_read_manual` | Capture Crosshair hotkey book event - emitted once after Book Menu closes for first accepted capture in session | `book_name`, `book_title`, `book_text`, `book_vision_description` |
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
| `*` | Wildcard - ALL events | (varies) |

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

