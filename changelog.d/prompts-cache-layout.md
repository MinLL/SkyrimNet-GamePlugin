---
title: Default prompts are laid out for prompt caching
area: Dialogue
kind: feature
---
On a provider with prompt caching, NPC replies, the player's dialogue and thoughts, and the Universal Translator reuse
the parts of the prompt that stay the same between turns, which lowers cost and time to first word.

- These are the prompts from the "Skyrimnet Prompts - Cache Enabled" plugin. An installed hub copy stops being used.
- NPC replies end with the lines said since the NPC last spoke, so the model reads the latest line last.
- Lines between other people are marked as overheard, so companions stop answering each other's asides.
- NPC replies also cache their response format, voice tags and action list, so far more of each prompt is reused.
- A plugin that overrides `0500_response_format`, `0650_audio_tags` or `0750_embedded_actions` needs a `stable_split` check, or that section appears twice in NPC replies.
- Your own edits to these prompts keep their old layout and go uncached.
- SeverActions' companion blocks are not cached yet.
