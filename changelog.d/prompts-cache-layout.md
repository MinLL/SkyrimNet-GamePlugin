---
title: NPC replies are laid out for prompt caching
area: Dialogue
kind: feature
---
The default prompts for NPC replies, the player's dialogue and thoughts, and the Universal Translator now keep what
stays the same at the front, so providers with prompt caching can reuse it. Replies arrive faster and cost less, and
larger event histories become affordable.

- The prompts from the "Skyrimnet Prompts - Cache Enabled" plugin are now the defaults. An installed hub copy stops being
  used, and you can uninstall it.
- NPC replies end with the lines said since the NPC last spoke, so the latest line is the last thing the model reads.
- Lines between other people are marked as overheard, so companions stop answering each other's asides.
