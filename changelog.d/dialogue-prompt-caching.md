---
title: NPC replies reuse the provider's prompt cache
area: LLM & Routing
kind: change
---
If you pay per token for NPC dialogue, most of each reply's prompt is now the same as the last one's, so providers that cache prompts bill it at the cached rate. With **use caching** on, replays of real play sessions cost 45% less on Gemini 3.6 Flash and 29% less on Claude Sonnet 4.6, with replies judged as good as before.

- The NPC's own profile (summary, background, personality, speech) opens the prompt. Their current state, the scene and the person they are speaking to come after the event history.
- The event history starts at a point that moves forward in steps instead of with every new event, so up to an eighth of the oldest events may go unshown.
- For mod authors: dialogue renders the character profile twice, first in the new `"stable"` mode (the parts that do not change turn to turn), then in `"full"` with `stable_split` set. A bio part that changes during play belongs in `"full"` only.
