# SkyrimNet Prompt Creation Workflow

> **Purpose:** This is an interactive workflow for AI assistants to help users create or modify prompt templates that control how AI generates dialogue, thoughts, and other content.

## What Are Prompts?

Prompts are `.prompt` files that:
- Define instructions sent to AI language models
- Use Inja template syntax (similar to Jinja2) for dynamic content
- Can access game state via decorator functions
- Are organized into main prompts and submodule components

**Key directories:**
- `prompts/` - Main prompt files (dialogue_response, player_thoughts, etc.)
- `prompts/submodules/character_bio/` - Character biography components
- `prompts/submodules/system_head/` - System prompt components
- `prompts/submodules/guidelines/` - Roleplay guidelines
- `prompts/submodules/user_final_instructions/` - Final user instructions
- `prompts/components/` - Reusable component templates

---

## PHASE 1: Discovery - Understanding the Goal

### Step 1.1: Clarify What's Needed

**ASK THE USER:**
- "What do you want to achieve?" (modify NPC behavior, add mod awareness, change dialogue style?)
- "Is this for a specific mod integration or general prompt modification?"
- "Should this affect all NPCs, specific types, or only certain conditions?"
- "Do you have the mod's source code in the workspace?" (if mod-related)

### Step 1.2: Check Source Code (if mod-related)

**If this prompt is for a specific mod and source is available:**
- Read Papyrus scripts to understand what state the mod tracks
- Identify factions, globals, magic effects used for state
- Understand when states change and what they represent

> **⚠️ CRITICAL:** Source code helps you *understand* what the mod tracks, but **MCP tools are the source of truth** for editor IDs and current state. Always verify effect names, faction IDs, and global names via MCP.

### Step 1.3: Determine Prompt Type

| Goal | Prompt Location | Type |
|------|-----------------|------|
| Add mod status to character bio | `submodules/character_bio/` | Submodule |
| Change how NPCs speak | `submodules/guidelines/` or main prompts | Submodule or Main |
| Add conditional instructions | `submodules/user_final_instructions/` | Submodule |
| Create entirely new feature | Main `prompts/` directory | Main prompt |
| Modify system setup | `submodules/system_head/` | Submodule |

### Step 1.4: Explore Existing Prompts

**If modifying existing behavior:**
- Read the relevant prompt files to understand current structure
- Identify where changes should be made
- Look for existing patterns to follow

---

## PHASE 2: Decorator Discovery - Finding Available Functions

### Step 2.1: Query Available Decorators via MCP (CRITICAL - Source of Truth)

**Decorators are functions that fetch game data for use in prompts.**

```
mcp_skyrimnet-mcp_get_decorators
```

Filter by category:
```
mcp_skyrimnet-mcp_get_decorators:
  category: "Actor"
```

Search by name:
```
mcp_skyrimnet-mcp_get_decorators:
  name_contains: "faction"
```

### Step 2.2: Key Decorator Categories

| Category | Examples | Use For |
|----------|----------|---------|
| `Actor` | `decnpc(uuid)`, `actor_has_keyword(uuid, editorId)`, `distance_between(uuid1, uuid2)` | NPC/player info |
| `Player` | `player` (JSON: `player.name`, `player.UUID`), `is_player(uuid)`, `is_follower(uuid)` | Player-specific data |
| `Quest` | `is_quest_active(questId)`, `get_quest_stage(questId, onlyWhileActive)`, `get_quest_journal(...)` | Quest state |
| `Combat` | `is_in_combat(uuid)`, `get_combat_targets(uuid)`, `get_actor_value(uuid, "Health")`, `has_weapon_drawn(uuid)` | Combat info |
| `World` / `Environment` | `location`, `get_location(uuid)`, `is_indoors`, `currentWeather`, `season` | World state |
| `World` (time) | `gameTime`, `currentTime`, `short_time(timeString)` | Time info |
| `Faction` | `is_in_faction(uuid, factionId)`, `get_faction_rank(uuid, factionId)` | Faction checks |
| `Relationship` | `get_relationship_rank(uuid, targetUuid)` | NPC relationships |
| `Game System` | `get_global_value(editorId)`, `is_plugin_loaded(name)`, `formid_to_uuid(formId)` | Mod global variables, load order |
| `Magic` | `has_magic_effect(uuid, effectId)`, `has_spell(uuid, spellId)` | Spell/effect state |
| `Movement` | `is_sneaking(uuid)`, `is_mounted(uuid)`, `is_unconscious(uuid)` | Movement state |

Names are exact and case-sensitive; the full list with signatures is `get_decorators` (or the Decorators page of the dashboard). A name that is not registered fails the render with `function not found`.

### Step 2.3: The Core `decnpc()` Decorator

**Most important decorator - returns comprehensive NPC data:**

```
{% set npc_data = decnpc(actorUUID) %}

{{ npc_data.name }}              {# Display name #}
{{ npc_data.race }}              {# Race name #}
{{ npc_data.gender }}            {# "Male" or "Female" #}
{{ npc_data.class }}             {# Class name #}
{{ npc_data.level }}             {# Level #}

{# Stats #}
{{ npc_data.health }}
{{ npc_data.magicka }}
{{ npc_data.stamina }}

{# Skills (0-100) #}
{{ npc_data.oneHanded }}
{{ npc_data.destruction }}
{{ npc_data.speech }}
... (all skills available)

{# Profile data #}
{{ npc_data.summary }}
{{ npc_data.background }}
{{ npc_data.personality }}
{{ npc_data.speechStyle }}

{# Pronouns #}
{{ npc_data.subjectivePronoun }}   {# he/she/they #}
{{ npc_data.objectivePronoun }}    {# him/her/them #}
{{ npc_data.possessivePronoun }}   {# his/her/their #}
{{ npc_data.reflexivePronoun }}    {# himself/herself/themselves #}

{# Relationship #}
{{ npc_data.relationshipRank }}    {# -4 to 4 #}
```

---

## PHASE 3: Template Syntax Reference

### Step 3.1: Inja Basics

**Expressions (render values):**
```
{{ variable }}
{{ decorator_function(arg) }}
{{ npc.name }}
```

**Statements (control flow):**
```
{% if condition %}
  content
{% elif other_condition %}
  alternative
{% else %}
  default
{% endif %}

{% for item in list %}
  {{ item }}
{% endfor %}

{% set variable = value %}
```

**Comments:**
```
{# This is ignored in output #}
```

### Step 3.2: Conditionals

```
{% if is_in_combat(actorUUID) %}
Combat content
{% elif get_actor_value(actorUUID, "Health") < 50 %}
Low health content
{% else %}
Normal content
{% endif %}
```

**Operators:**
- Logical: `and`, `or`, `not`
- Comparison: `<`, `>`, `==`, `!=`, `>=`, `<=`
- Membership: `value in list`

### Step 3.3: Loops

```
{% for nearby in get_nearby_npc_list(npc.UUID) %}
- {{ decnpc(nearby.UUID).name }} ({{ nearby.distance }}m away)
{% endfor %}
```

**Loop variables:**
- `loop.index` - 0-based index
- `loop.index1` - 1-based index
- `loop.is_first` - True on first iteration
- `loop.is_last` - True on last iteration

### Step 3.4: Variable Assignment

```
{% set actor = decnpc(actorUUID) %}
{% set is_hostile = is_in_combat(actorUUID) %}
{% set health_percent = get_actor_value(actorUUID, "Health") %}
```

### Step 3.5: Built-in Functions

| Function | Description |
|----------|-------------|
| `upper(str)` / `lower(str)` / `capitalize(str)` | Convert case (also usable as filters: `{{ name | capitalize }}`) |
| `length(arr)` | Count elements |
| `first(arr)` / `last(arr)` | First/last element |
| `join(arr, sep)` | Join with separator |
| `round(num, digits)` | Round number |
| `default(val, fallback)` | Use fallback if undefined |
| `exists("key")` / `existsIn(obj, "key")` | Check if key exists |
| `contains(container, value)` | Substring or element check (SkyrimNet string utility) |
| `replace(str, old, new)` | Replace text |

See `prompt-file-syntax.md` for the full Inja built-in list.

### Step 3.6: Whitespace Control

```
{{- variable -}}      {# Trim both sides #}
{% if x -%}           {# Trim after #}
{%- endif %}          {# Trim before #}
```

### Step 3.7: Important Inja Limitations

> **⚠️ Inja is NOT Jinja2.** Inja is simpler and more limited. Only use syntax documented here.

**Key differences:**
- Array manipulation functions (`append`, `extend`, etc.) return NEW arrays—they don't modify originals
- Assignments with `{% set %}` don't modify input data, only the render context
- Not all Jinja2 features exist—don't assume they do

---

## PHASE 4: Style and Best Practices (CRITICAL)

### Step 4.1: Actor References - ALWAYS Use `decnpc()`

**NEVER use generic "you" or "your" when referring to actors.** Always use their name and pronouns from `decnpc()`.

**BAD - Don't do this:**
```
You are a Nord warrior. Your sword is sharp.
```

**GOOD - Do this:**
```
{% set actor = decnpc(actorUUID) %}
{{ actor.name }} is a {{ actor.race }} warrior. {{ actor.subjectivePronoun | capitalize }} carries {{ actor.possessivePronoun }} sword.
```

### Step 4.2: Variable Naming - Be Specific

**Use specific variable names to avoid conflicts:**

| BAD | GOOD |
|-----|------|
| `{% set name = ... %}` | `{% set actorName = ... %}` |
| `{% set race = ... %}` | `{% set actorRace = ... %}` |
| `{% set level = ... %}` | `{% set actorLevel = ... %}` |

**Standard pattern for actor data:**
```
{% set actor = decnpc(actorUUID) %}
{% set actorName = actor.name %}
{% set subj = actor.subjectivePronoun %}
{% set obj = actor.objectivePronoun %}
{% set poss = actor.possessivePronoun %}
{% set refl = actor.reflexivePronoun %}
```

### Step 4.3: Pronoun Usage

**Always access pronouns from `decnpc()` return object:**

| Pronoun Type | Property | Examples |
|--------------|----------|----------|
| Subjective | `subjectivePronoun` | she/he/they |
| Objective | `objectivePronoun` | her/him/them |
| Possessive | `possessivePronoun` | her/his/their |
| Reflexive | `reflexivePronoun` | herself/himself/themselves |

**Example:**
```
{% set actor = decnpc(actorUUID) %}
{{ actor.name }} raised {{ actor.possessivePronoun }} sword. 
{{ actor.subjectivePronoun | capitalize }} defended {{ actor.reflexivePronoun }}.
```

### Step 4.4: Section Markers (Main Prompts Only)

**Section markers define message structure in main prompts:**

```
[ system ]
System instructions here...
[ end system ]

[ user ]
User/context information here...
[ end user ]

[ assistant ]
Assistant response pattern (if needed)...
[ end assistant ]

[ cache ]
Content that can be cached...
[ end cache ]

[ raw ]
Content where special markers should not be parsed...
[ end raw ]
```

> **⚠️ CRITICAL:** Section markers must **NOT** be used in submodules (like `character_bio`). They are only for top-level prompts.

### Step 4.5: Indentation and Whitespace

**Consistent indentation is critical for readable prompts.**

**Rules:**
- Use **4 spaces** for indentation throughout all output (not tabs)
- Maintain consistent nesting levels
- Be mindful of how template output affects final whitespace

**Nesting Guidelines:**
- Apply appropriate nesting levels for hierarchical content:
    - Top-level sections: no indentation
    - Subsection headers: 4 spaces
    - Content under subsections: 8 spaces
    - Nested list items: increase by 4 spaces per level
    - Code blocks: use proper language-specific indentation
- Maintain consistent indentation within code examples and template snippets
- Ensure proper alignment of multi-line structures (arrays, objects, conditionals)

**Example of proper nesting:**
```
## Top Level Section

    ### Subsection Header
    
        Content under this subsection goes here.
        
            - Nested list item level 1
                - Nested list item level 2
                    - Nested list item level 3
```

**Whitespace in Template Output:**

Template tags can introduce unwanted whitespace. Use whitespace control when needed:

```
{# WITHOUT whitespace control - may add blank lines #}
{% if condition %}
Content here
{% endif %}

{# WITH whitespace control - cleaner output #}
{% if condition -%}
    Content here
{%- endif %}
```

**When to use whitespace trimming:**
- `{{- var }}` - Trim whitespace BEFORE the expression
- `{{ var -}}` - Trim whitespace AFTER the expression  
- `{{- var -}}` - Trim BOTH sides
- `{%- ... %}` - Trim before statement
- `{% ... -%}` - Trim after statement

**Common patterns:**

```
{# Inline values without extra spaces #}
{{ actor.name }} is a {{- actor.race -}} warrior.

{# Loop without blank lines between items #}
{% for item in items -%}
- {{ item }}
{% endfor %}

{# Conditional without extra blank lines #}
{% if condition -%}
    Content
{%- endif %}
```

**Preserving intentional whitespace:**

Sometimes you WANT whitespace. Don't over-trim:

```
{# Good - paragraph breaks preserved #}
{{ actor.name }} is a warrior.

{{ actor.subjectivePronoun | capitalize }} carries a sword.

{# Bad - everything runs together #}
{{- actor.name }} is a warrior.
{{- actor.subjectivePronoun | capitalize }} carries a sword.
```

### Step 4.6: Render Mode Pattern

**Define render mode perspective once at the top of submodules:**

```
{# Define perspective - do this ONCE at the top #}
{% set first_person = (render_mode == "transform" or render_mode == "full" or render_mode == "thoughts") %}

{% if first_person %}
  {# Show internal state, feelings, private thoughts #}
  {{ actor.name }} feels the rage building inside {{ actor.objectivePronoun }}.
{% elif render_mode == "target" %}
  {# Show only externally observable information #}
  {{ actor.name }} appears tense, jaw clenched.
{% endif %}
```

| Render Mode | Perspective | Show |
|-------------|-------------|------|
| `transform`, `full`, `thoughts` | First person | Internal state, feelings |
| `target` | Third person | Only observable information |
| `short_inline`, `interject_inline` | Brief | Minimal relevant info |

### Step 4.7: Code Block Formatting in Output

**When your prompt generates structured output (lists, sections):**

```
{# Good - consistent structure #}
## {{ actor.name }}'s Status

**Health:** {{ actor.health }}
**Stamina:** {{ actor.stamina }}

**Skills:**
- One-Handed: {{ actor.oneHanded }}
- Archery: {{ actor.archery }}

{# Bad - inconsistent spacing and structure #}
## {{ actor.name }}'s Status
**Health:** {{ actor.health }}
**Stamina:**{{ actor.stamina }}
**Skills:**
-One-Handed: {{ actor.oneHanded }}
- Archery:{{ actor.archery }}
```

---

## PHASE 5: Prompt Structure Patterns

### Step 5.1: Chat-Style Prompts (Main Prompts)

```
[ system ]
System instructions here.
{{ render_subcomponent("system_head", "full") }}
[ end system ]

{{ render_template("components\\event_history") }}

[ user ]
User/context information here.
{{ render_subcomponent("user_final_instructions", "full") }}
[ end user ]
```

### Step 5.2: Submodule Prompts (Character Bio, etc.)

```
{# Comment explaining what this submodule does #}

{# Check if this should render (mod installed, condition met, etc.) #}
{% if some_condition %}

{% set actor = decnpc(actorUUID) %}
{% set first_person = (render_mode == "full" or render_mode == "thoughts") %}

## Section Header

{% if first_person %}
Content written for first-person context...
{% else %}
Content written for third-person context...
{% endif %}

{% endif %}
```

### Step 5.3: Rendering Other Templates

```
{# Render a template file #}
{{ render_template("components\\event_history") }}

{# Render character profile in specific mode #}
{{ render_character_profile("full", npc.UUID) }}
{{ render_character_profile("short_inline", npc.UUID) }}

{# Render submodules #}
{{ render_subcomponent("system_head", "full") }}
{{ render_subcomponent("character_bio", "thoughts") }}
```

### Step 5.4: Template Rendering Functions

| Function | Purpose |
|----------|---------|
| `render_template("path\\to\\template")` | Include another template file |
| `render_subcomponent("componentName", "mode")` | Render a subcomponent with render mode |
| `render_character_profile("mode", uuid)` | Render character biography |

---

## PHASE 6: Creating Mod Integration Submodules

### Step 6.1: File Naming Convention

For character bio submodules:
```
prompts/submodules/character_bio/NNNN_description.prompt
```

- Numbers control load order (lower = earlier in bio)
- Use `0xxx` for core info, `03xx-04xx` for mod integrations

### Step 6.2: Standard Submodule Pattern

```
{# ModName - Brief description of what this adds #}
{# Only active when [conditions] #}

{# Determine render perspective #}
{% set first_person = (render_mode == "full" or render_mode == "thoughts" or render_mode == "transform") %}

{# Check if mod data is available (effect, faction, global, etc.) #}
{% set mod_active = has_magic_effect(actorUUID, "ModEffect") %}
{# OR #}
{% set mod_active = is_in_faction(actorUUID, "ModFaction") %}
{# OR #}
{% set mod_value = get_global_value("ModGlobal") %}
{% set mod_active = mod_value > 0 %}

{% if mod_active and first_person %}
{% set actor = decnpc(actorUUID) %}
{% set actorName = actor.name %}
{% set subj = actor.subjectivePronoun %}
{% set obj = actor.objectivePronoun %}
{% set poss = actor.possessivePronoun %}

## Mod Feature Status

{# Describe the mod's effect on this character #}
{{ actorName }} is affected by [mod feature].

{# Use conditionals for different states #}
{% if some_condition %}
Description of state 1...
{% else %}
Description of state 2...
{% endif %}

{% endif %}
```

### Step 6.3: Finding Mod Indicators via MCP (Source of Truth)

**Use MCP to find what the mod exposes (even if you have source code):**

Magic effects:
```
mcp_skyrimnet-mcp_get_magic_effects:
  plugin: "ModName.esp"
```

Factions:
```
mcp_skyrimnet-mcp_get_factions:
  plugin: "ModName.esp"
```

Global variables:
```
mcp_skyrimnet-mcp_get_globals:
  plugin: "ModName.esp"
```

Keywords:
```
mcp_skyrimnet-mcp_get_keywords:
  plugin: "ModName.esp"
```

### Step 6.4: Checking for Mod Data

**Common patterns for detecting mod state:**

```
{# Check magic effect #}
{% set has_effect = has_magic_effect(actorUUID, "EffectEditorID") %}

{# Check faction membership #}
{% set in_faction = is_in_faction(actorUUID, "FactionEditorID") %}

{# Check global variable #}
{% set global_val = get_global_value("GlobalEditorID") %}

{# Check keyword #}
{% set has_keyword = has_keyword(actorUUID, "KeywordEditorID") %}
```

---

## PHASE 7: Validation (REQUIRED)

### Step 7.1: Validate Template Syntax

**ALWAYS validate before finalizing:**

```
mcp_skyrimnet-mcp_validate_prompt:
  prompt_content: |
    {% set actor = decnpc(actorUUID) %}
    {{ actor.name }} content here...
```

**Check response:**
- `valid: true` → Proceed
- `valid: false` + `error` → Fix syntax error and re-validate

### Step 7.2: Common Validation Errors

| Error | Cause | Fix |
|-------|-------|-----|
| `Expected closing tag` | Missing `{% endif %}` or `{% endfor %}` | Add closing tag |
| `Unknown function` | Decorator name typo | Check `get_decorators` for correct name |
| `Variable not found` | Undefined variable | Define with `{% set %}` or check context |
| `Unexpected token` | Syntax error | Check brackets, quotes, operators |

### Step 7.3: Review with User

**PRESENT:**
- The complete prompt content
- What conditions trigger it
- What information it adds

**ASK:** "Does this prompt look correct? Would you like to adjust the wording or conditions?"

---

## Complete Examples

### Example: Bathing Mod Integration

```
{# Bathing in Skyrim - Tracks hygiene state #}

{% set first_person = (render_mode == "full" or render_mode == "thoughts") %}

{# Check for cleanliness effects #}
{% set is_clean = has_magic_effect(actorUUID, "mzinDirtinessTier0Effect") %}
{% set is_dirty = has_magic_effect(actorUUID, "mzinDirtinessTier2Effect") %}
{% set is_filthy = has_magic_effect(actorUUID, "mzinDirtinessTier3Effect") %}

{% set has_any_state = is_clean or is_dirty or is_filthy %}

{% if has_any_state and first_person %}
{% set actor = decnpc(actorUUID) %}
{% set subj = actor.subjectivePronoun %}
{% set poss = actor.possessivePronoun %}

## Hygiene

{% if is_clean %}
{{ actor.name }} feels refreshingly clean. {{ subj | capitalize }} skin is spotless.
{% elif is_dirty %}
{{ actor.name }} is noticeably dirty. {{ poss | capitalize }} clothes are grimy.
{% elif is_filthy %}
{{ actor.name }} is covered in filth, desperately needing a bath.
{% endif %}

{% endif %}
```

### Example: Conditional Instructions Submodule

```
{# Combat awareness - adds context during combat #}

{% if is_in_combat(npc.UUID) %}
## Combat Situation

You are currently in combat. Focus on:
- Survival and tactical decisions
- Brief, urgent responses
- Awareness of threats and allies

{% set target = get_combat_target(npc.UUID) %}
{% if target %}
Your current target: {{ target.name }}
{% endif %}
{% endif %}
```

### Example: Faction-Based Personality Modifier

```
{# Companions Guild personality traits #}

{% set is_companion = is_in_faction(actorUUID, "CompanionsFaction") %}

{% if is_companion %}
{% set actor = decnpc(actorUUID) %}
{% set rank = get_faction_rank(actorUUID, "CompanionsFaction") %}

## Companions Guild

{{ actor.name }} is a member of the Companions.

{% if rank >= 3 %}
As a senior member, {{ actor.subjectivePronoun }} carries the weight of leadership and tradition.
{% elif rank >= 1 %}
{{ actor.subjectivePronoun | capitalize }} has proven {{ actor.reflexivePronoun }} in battle.
{% else %}
{{ actor.subjectivePronoun | capitalize }} is still proving {{ actor.reflexivePronoun }} to the guild.
{% endif %}

{% endif %}
```

### Example: Global Variable-Based State

```
{# Survival Mode - cold exposure tracking #}

{% set cold_level = get_global_value("Survival_ColdLevel") %}
{% set first_person = (render_mode == "full" or render_mode == "thoughts") %}

{% if cold_level > 0 and first_person %}
{% set actor = decnpc(actorUUID) %}

## Environmental Exposure

{% if cold_level >= 3 %}
{{ actor.name }} is freezing, barely able to function in the bitter cold.
{% elif cold_level >= 2 %}
{{ actor.name }} shivers constantly, the cold seeping into {{ actor.possessivePronoun }} bones.
{% else %}
{{ actor.name }} feels the chill, but manages to stay functional.
{% endif %}

{% endif %}
```

---

## Context Variables Reference

**Variables available in prompts (depending on context):**

| Variable | Available In | Description |
|----------|--------------|-------------|
| `npc.UUID` | All NPC prompts | Speaking NPC's UUID |
| `npc.name` | All NPC prompts | Speaking NPC's name |
| `player.UUID` | All prompts | Player's UUID |
| `player.name` / `player_name` | All prompts | Player's name |
| `player_subjective_pronoun` etc. | All prompts | Player pronouns (`subjective`, `objective`, `possessive`, `reflexive`) |
| `actorUUID` | Character bio submodules | Actor being described |
| `render_mode` | Submodules | Current render mode |
| `location` | All prompts | Player's current location name |
| `is_indoors` | All prompts | Whether the player is in an interior |
| `gameTime` / `currentTime` | All prompts | In-game date/time string / real clock time |
| `currentWeather` | All prompts | Current weather |
| `triggeringEvent` | Event-triggered prompts | Event that triggered |

---

## Workflow Checklist

- [ ] Clarified what the prompt should achieve
- [ ] Determined correct prompt location (main/submodule)
- [ ] **Queried `get_decorators` for available functions**
- [ ] If mod integration: found mod's effects/factions/globals via MCP
- [ ] **Used `decnpc()` for all actor references (no generic "you")**
- [ ] **Used specific variable names (`actorName` not `name`)**
- [ ] **Used proper pronouns from `decnpc()` return object**
- [ ] **Consistent indentation (4 spaces, nested) and whitespace control**
- [ ] Wrote template with proper conditionals
- [ ] Handled different render modes if needed
- [ ] **Did NOT use section markers in submodules**
- [ ] **Validated with `validate_prompt`**
- [ ] Reviewed final content with user

