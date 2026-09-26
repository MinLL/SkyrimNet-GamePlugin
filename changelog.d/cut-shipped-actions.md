---
title: Fewer built-in actions
area: Game Integration
kind: change
credit: [MinLL]
---
NPCs no longer open trade, rent out rooms, or run the follower commands (follow, wait, open inventory, give a task) through SkyrimNet actions; use vanilla dialogue for those. Non-follower NPCs still accompany you, stop, and wait on request. Mods whose actions called `SkyrimNetInternal`'s `OpenTrade_*`, `RentRoom_*` or `Companion*` functions need their own script now.
