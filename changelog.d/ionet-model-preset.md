---
title: IO Intelligence (io.net) model preset
area: LLM & Routing
kind: feature
---
Pick **IO Intelligence** in the dashboard's preset list to run SkyrimNet on io.net's hosted open-weight models: DeepSeek V4.1 Flash for dialogue, combat and diaries, GLM-5.3 for agents, profiles and memory, Llama 3.3 70B for evaluations and translation, Kimi K3 for vision. Add a Custom Provider named `ionet` with your IO Intelligence API key first; the preset routes every variant through it.
- Most of these models need tier-2 model access on IO Intelligence; Llama 3.3 70B runs on the base tier.
- The recommended-models list gains an `ionet` section, so the model picker suggests the same models per variant.
