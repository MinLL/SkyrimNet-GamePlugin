---
title: Prompt for translated dialogue options
area: For Mod Authors
kind: change
credit: [dekana]
---
`transformers/player_option_translation` translates or rewrites the player's dialogue options. It gets `originalDialogue`, `lineCount`, `speechPattern` and `translationLanguage`, and must answer one line per option.
