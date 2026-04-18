# Model Agents and Usage
Skyrimnet leverages different models to perform different functions like NPC roleplaying, memory generation and retrieval, and meta evaluation.

All of these models work together to bring Skyrim to life in seamless fashion.

Models and their parameters can be viewed and changed under Advanced Configuration>OpenRouter in the UI.

## Default Model

### Text Generation
Takes the character and scene context of the NPC that is speaking and generates dialogue.

### Game Master
The Game Master analyzes the current scene, characters, events and actions to initiate a dynamic, natural interaction between NPCs and/or the player character.

### Memory Generation
Memories are generated from recent dialogue and events. Memories are evaluated based on their importance and given a score, ranking them against other memories for that character. Memories are explorable under the Memories section of the UI

## Character Profile Generation

### Profile Generation
This will create a profile automatically for NPC's that do not have a pre-built Profile (IE. non vanilla NPCs that aren't already included)

### Dynamic Profile Updates
Character profiles are periodically updated, using recent events and important memories. The sections it updates can be configured under Advanced Configuration>DynamicBio

## Action_Evaluation

### Action Usage
Evaluating the context of the current dialogue, this model will determine the appropriate action to use, (IE. Follow player, Wait, Slap_target)

## Meta

### Mood Evaluation
This function analyzes the NPC's mood, determining the emotional state of NPCs based on their dialogue and recent interactions. It analyzes dialogue context, speaker information, and recent events to determine the most appropriate mood for voice modulation and facial expressions.

### Speaking Turn Evaluation
This will determine which single Skyrim NPC should speak next, if anyone. This determination is made dynamically but evaluating social interactions, relationships, personalities, and current events. NPCs who have a clear and compelling reason to react, comment, or interject will do so by this models determination. If nobody has a strong reason to speak, the dialogue chain ends.

### Memory Search
Based on the recent events and current context, this generates a search query optimized for semantic similarity and keyword matching. These memories are then used for the context of the default model.

