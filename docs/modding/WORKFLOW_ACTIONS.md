# SkyrimNet Action Creation Workflow

> **Purpose:** This is an interactive workflow for AI assistants to help users create NPC actions that execute Papyrus functions from mods.

## What Are Actions?

Actions are YAML files that:
- Define behaviors NPCs can perform in response to dialogue
- Map to specific Papyrus script functions
- Include eligibility rules (who can perform the action)
- Expose parameters the LLM can fill at runtime

---

## PHASE 1: Discovery - Understanding the Mod

### Step 1.1: Identify the Target Mod

**ASK THE USER:**
- "Which mod are we integrating?" 
- "What functionality do you want NPCs to be able to use?"
- "Is the mod currently installed and running in-game?"
- "Do you have the mod's source code in the workspace? (Papyrus .psc files)"

### Step 1.2: Check for Source Code in Workspace

**IMPORTANT:** Source code is invaluable for understanding mod internals.

**If source is available:**
- Read Papyrus scripts (.psc files) to understand function signatures, parameters, and logic
- Look for function comments and docstrings
- Identify which functions are meant to be called externally vs internal helpers
- Understand the flow and prerequisites for functions

**If source is NOT available:**
- Search the web for mod documentation
- Ask user to provide any available documentation
- Rely more heavily on MCP exploration

> **⚠️ CRITICAL:** Source code helps you *understand* the mod, but **MCP tools are the source of truth** for live game data. Always verify quest IDs, script names, and function signatures via MCP—the source may be outdated or different from what's loaded in-game.

### Step 1.3: Find the Mod's Plugin

**Query loaded plugins:**

```
mcp_skyrimnet-mcp_get_plugins
```

**Look for** the mod's .esp/.esm/.esl file in the list.

### Step 1.4: Find the Mod's Quests (MCP - Source of Truth)

**Query quests from the mod:**

```
mcp_skyrimnet-mcp_get_quests:
  plugin: "ModName.esp"
```

Or search by name:
```
mcp_skyrimnet-mcp_get_quests:
  name_contains: "PartialQuestName"
```

**PRESENT to user:** List of quests found, ask which one handles the functionality they want.

---

## PHASE 2: Script Exploration - Finding Callable Functions

> **Note:** If you have source code, read it first to understand what functions do. Then use MCP to verify the exact signatures and that they're accessible at runtime.

### Step 2.1: Get Scripts on the Quest (MCP)

**Query scripts attached to the quest:**

```
mcp_skyrimnet-mcp_get_quest_scripts:
  quest_editor_id: "QuestEditorID"
```

**Returns:** Script names and types bound to the quest.

### Step 2.2: Get Available Functions via MCP (CRITICAL - Source of Truth)

**Query callable functions from the script:**

```
mcp_skyrimnet-mcp_get_quest_script_functions:
  quest_editor_id: "QuestEditorID"
  script_name: "ScriptName"
```

**Returns:**
- Function names
- Return types
- Parameters with exact types (Actor, Int, Float, Bool, String, Form)
- Docstrings (if available)

> **⚠️ ALWAYS use MCP results**, even if you have source code. The MCP returns what's actually loaded in-game, which may differ from source files.

### Step 2.3: Analyze Functions for Action Potential

**GOOD candidates for actions:**
- ✅ Clear action-oriented names (StartFollow, GiveItem, CastSpell)
- ✅ Accept Actor parameters
- ✅ Perform visible game actions
- ✅ Simple parameter lists

**AVOID:**
- ❌ Internal state functions (SetState, UpdateProgress, _Internal*)
- ❌ Quest stage modifications (SetStage, CompleteObjective)
- ❌ Complex object parameters you can't construct
- ❌ Functions with no gameplay effect

### Step 2.4: Check Script Properties (Optional)

**Get current state/properties:**

```
mcp_skyrimnet-mcp_get_quest_script_properties:
  quest_editor_id: "QuestEditorID"
  script_name: "ScriptName"
```

**Useful for:** Understanding what game state the mod tracks, informing eligibility conditions.

### Step 2.5: Present Findings to User

**SHOW:**
- Available functions with their signatures
- Which functions look suitable for NPC actions
- Any relevant properties/state

**ASK:** "Which of these functions would you like to create actions for?"

---

## PHASE 3: Eligibility Design

### Step 3.1: Understand Eligibility Requirements

**ASK THE USER:**
- "Who should be able to perform this action?" (merchants, followers, faction members?)
- "What conditions must be met?" (not in combat, specific faction, etc.)

### Step 3.2: Find Available Decorators

**Query decorator functions for eligibility:**

```
mcp_skyrimnet-mcp_get_decorators:
  category: "Actor"
```

Or search by name:
```
mcp_skyrimnet-mcp_get_decorators:
  name_contains: "faction"
```

**Common decorators for eligibility:**

| Decorator | Arguments | Returns | Use For |
|-----------|-----------|---------|---------|
| `is_in_faction` | `actor`, `factionEditorID` | boolean | Faction membership |
| `get_faction_rank` | `actor`, `factionEditorID` | integer | Faction rank |
| `get_actor_value` | `actor`, `avName` | number | Skills, stats |
| `is_follower` | `actor` | boolean | Follower check |
| `is_in_combat` | `actor` | boolean | Combat state |
| `is_hostile_to_actor` | `actor`, `otherActor` | boolean | Hostility |
| `distance_between` | `actor`, `otherActor` | number | Proximity (game units) |
| `actor_has_keyword` | `actor`, `keywordEditorID` | boolean | Keyword check |
| `is_unconscious` / `is_knocked_down` | `actor` | boolean | Incapacitated |
| `has_magic_effect` | `actor`, `effectEditorID` | boolean | Active effect |
| `get_relationship_rank` | `actor1`, `actor2` | number | Relationship |
| `get_global_value` | `globalEditorID` | number | Global variable |

Names are exact; `decoratorName` is looked up in the same decorator registry prompts use, so confirm each one with `get_decorators` (there is no `is_following_player`, `has_keyword`, `is_dead` or `is_essential`).

### Step 3.3: Find Faction/Global IDs (if needed)

**For faction checks:**
```
mcp_skyrimnet-mcp_get_factions:
  name_contains: "Merchant"
```

**For global variables:**
```
mcp_skyrimnet-mcp_get_globals:
  plugin: "ModName.esp"
```

---

## PHASE 4: Build the Action

### Step 4.1: Map Function Parameters

**For each parameter in the Papyrus function, determine the mapping:**

| Papyrus Type | Mapping Type | When to Use |
|--------------|--------------|-------------|
| `Actor` (self/speaker) | `speaker` | The NPC performing the action |
| `Actor` (target) | `dynamic` | LLM chooses target |
| `Int` / `Float` (fixed) | `static` | Known value |
| `Int` / `Float` (variable) | `dynamic` | LLM chooses value |
| `Bool` | `static` or `dynamic` | Depends on context |
| `String` | `static` or `dynamic` | Depends on context |
| `Form` | `static` | Form ID hex string |

### Step 4.2: Write the Description (IMPORTANT)

**The description tells the LLM when to use this action.**

**DO:**
- Describe what the action DOES
- Explain WHEN the LLM should choose it (from roleplay perspective)
- Use `{{ player.name }}` for player references

**DON'T:**
- Repeat eligibility conditions (they're already checked!)
- Be vague or generic

**BAD:**
```yaml
description: "Opens trade menu. Only works for merchants not in combat."
```

**GOOD:**
```yaml
description: "Use ONLY if {{ player.name }} asks to trade and you agree. Otherwise, do NOT use this action."
```

### Step 4.3: Construct YAML Structure

```yaml
name: "ActionName"
description: "Description for LLM decision-making"

questEditorId: "QuestEditorID"
scriptName: "ScriptName"
executionFunctionName: "FunctionName"

parameterMapping:
  - type: "speaker"        # First param: the NPC
  - type: "dynamic"
    name: "param_name"
    description: "Description for LLM"
  - type: "static"
    value: "fixed_value"

eligibilityRules:
  - conditions:
      - decoratorName: "decorator_name"
        arguments: ["currentActor", "OtherArg"]  # Use currentActor or player
        comparisonOperator: "=="                 # ==, !=, >, <, >=, <=, contains, not_contains, is_null, is_not_null, is_empty, is_not_empty
        expectedValue: true
    logicalOperator: "AND"
    required: true

tags: []

eventString: "{{ actor.name }} performed the action for {{ player.name }}"
isShortLived: false

enabled: true
defaultPriority: 5
```

### Step 4.4: Eligibility Rule Logic

**CRITICAL: How rules combine:**

```
Final Eligibility = Rule1 AND Rule2 AND Rule3 ...

Each rule's result = condition1 [logicalOperator] condition2 ...
```

**To express "A AND (B OR C)":**
```yaml
eligibilityRules:
  # Rule 1: A (required)
  - conditions:
      - decoratorName: "check_A"
        arguments: ["currentActor"]
        comparisonOperator: "=="
        expectedValue: true
    logicalOperator: "AND"
    required: true
  
  # Rule 2: B OR C (required)  
  - conditions:
      - decoratorName: "check_B"
        arguments: ["currentActor"]
        comparisonOperator: "=="
        expectedValue: true
      - decoratorName: "check_C"
        arguments: ["currentActor"]
        comparisonOperator: "=="
        expectedValue: true
    logicalOperator: "OR"  # Combines B and C
    required: true
```

**⚠️ WARNING:** `required: false` rules are IGNORED entirely!

### Step 4.5: Actor Reference Values

**In eligibility conditions, use these special tokens:**

| Token | Meaning |
|-------|---------|
| `currentActor` | The NPC being evaluated |
| `player` | The player character |

**DO NOT** use `actor.UUID` or other variable formats in eligibility rules.

---

## PHASE 5: Validation (REQUIRED)

### Step 5.1: Validate with MCP

**ALWAYS validate before finalizing:**

```
mcp_skyrimnet-mcp_validate_custom_action:
  yaml_content: |
    name: "YourActionName"
    # ... full YAML content ...
```

**Check response:**
- `valid: true` + `actionName` → Proceed
- `valid: false` + `error` → Fix and re-validate

### Step 5.2: Test Function (CAUTION)

**Optionally test the function directly (modifies game state!):**

```
mcp_skyrimnet-mcp_execute_quest_function:
  quest_editor_id: "QuestEditorID"
  script_name: "ScriptName"
  function_name: "FunctionName"
  arguments: ["arg1", "arg2"]  # Must match signature exactly
```

### Step 5.3: Review with User

**PRESENT:**
- Complete YAML
- What NPCs can use it (eligibility)
- What parameters the LLM will provide
- The function being called

**ASK:** "Does this action look correct? Would you like to adjust eligibility or parameters?"

---

## Event String Templates

**Available variables for `eventString`:**

| Variable | Description |
|----------|-------------|
| `{{ actor.name }}` | NPC performing the action |
| `{{ actor.UUID }}` | NPC's UUID |
| `{{ player.name }}` | Player's name |
| `{{ player.UUID }}` | Player's UUID |
| `{{ action_name }}` | Name of the action |
| `{{ param_name }}` | Any dynamic parameter by name |

**For pronouns, use `decnpc()`:**
```
{{ decnpc(actor.UUID).possessivePronoun }}  → his/her/their
{{ decnpc(actor.UUID).subjectivePronoun }}  → he/she/they
{{ decnpc(actor.UUID).objectivePronoun }}   → him/her/them
```

---

## Complete Examples

### Example: Trade Action

```yaml
name: "OpenTrade"
description: "Use ONLY if {{ player.name }} asks to trade and you agree. Otherwise, do NOT use this action."

# Your mod's quest and script; OpenTrade_Execute calls akActor.ShowBarterMenu()
questEditorId: "MyMod_Quest"
scriptName: "MyMod_Actions"
executionFunctionName: "OpenTrade_Execute"

parameterMapping: []

eligibilityRules:
  - conditions:
      - decoratorName: "is_in_faction"
        arguments: ["currentActor", "JobMerchantFaction"]
        comparisonOperator: "!="
        expectedValue: -2
    logicalOperator: "AND"
    required: true

tags: []
enabled: true
defaultPriority: 5
```

### Example: Follow Action with Event String

```yaml
name: "AccompanyTarget"
description: "Start accompanying {{ player.name }}. Only use when {{ player.name }} explicitly asks you to follow them."

questEditorId: "SkyrimNetQuest"
scriptName: "SkyrimNetInternal"
executionFunctionName: "StartFollow_Execute"

parameterMapping: []

eligibilityRules:
  - conditions:
      - decoratorName: "is_follower"
        arguments: ["currentActor"]
        comparisonOperator: "=="
        expectedValue: false
    logicalOperator: "AND"
    required: true

eventString: "{{ actor.name }} began following {{ player.name }}"
isShortLived: false

enabled: true
defaultPriority: 5
```

### Example: Complex Eligibility (AND with OR)

```yaml
name: "DF_DemandOral"
description: "Put {{ player.name }}'s mouth to use. Use when you want to assert dominance."

questEditorId: "_DTools"
scriptName: "_dftools"
executionFunctionName: "SexOral"

parameterMapping:
  - type: "speaker"

eligibilityRules:
  # Must be the Devious Follower master
  - conditions:
      - decoratorName: "is_in_faction"
        arguments: ["currentActor", "_DMaster"]
        comparisonOperator: "=="
        expectedValue: true
    logicalOperator: "AND"
    required: true
  
  # Either has sex rule OR willpower is broken
  - conditions:
      - decoratorName: "is_in_faction"
        arguments: ["player", "_DFSexRule"]
        comparisonOperator: "=="
        expectedValue: true
      - decoratorName: "get_global_value"
        arguments: ["_DWill"]
        comparisonOperator: "<="
        expectedValue: 2
    logicalOperator: "OR"
    required: true

tags: []

eventString: "{{ actor.name }} used {{ player.name }}'s mouth."
isShortLived: false

enabled: true
defaultPriority: 5
```

### Example: Dynamic Parameters

```yaml
name: "SetCombatStyle"
description: "Change your combat approach when {{ player.name }} requests it."

questEditorId: "FollowerModQuest"
scriptName: "FollowerScript"
executionFunctionName: "SetCombatStyle"

parameterMapping:
  - type: "speaker"
  - type: "dynamic"
    name: "style"
    description: "Combat style: 'aggressive', 'defensive', or 'ranged'"

eligibilityRules:
  - conditions:
      - decoratorName: "is_follower"
        arguments: ["currentActor"]
        comparisonOperator: "=="
        expectedValue: true
    logicalOperator: "AND"
    required: true

eventString: "{{ actor.name }} changed to {{ style }} combat style"
isShortLived: true

enabled: true
defaultPriority: 5
```

---

## MCP Tools Quick Reference

| Tool | Purpose |
|------|---------|
| `get_plugins` | List loaded mods |
| `get_quests` | Find quests by plugin/name |
| `get_quest_scripts` | Get scripts on a quest |
| `get_quest_script_functions` | **Get callable functions with signatures** |
| `get_quest_script_properties` | Get script state/properties |
| `get_quest_property_value` | Read specific property value |
| `execute_quest_function` | Test function (use carefully!) |
| `get_decorators` | Find eligibility check functions |
| `get_factions` | Find faction editor IDs |
| `get_globals` | Find global variable IDs |
| `get_keywords` | Find keyword editor IDs |
| `validate_custom_action` | **Validate action YAML** |

---

## Workflow Checklist

- [ ] Identified target mod and plugin
- [ ] Found relevant quest(s) with `get_quests`
- [ ] Listed scripts with `get_quest_scripts`
- [ ] **Explored functions with `get_quest_script_functions`**
- [ ] Selected suitable function(s) for actions
- [ ] Designed eligibility rules with appropriate decorators
- [ ] Mapped function parameters correctly
- [ ] Wrote clear description for LLM
- [ ] **Validated with `validate_custom_action`**
- [ ] Reviewed final YAML with user

