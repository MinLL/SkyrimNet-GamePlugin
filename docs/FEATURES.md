# SkyrimNet features

A full tour of what SkyrimNet does. For an introduction and how to install it, see the [README](../README.md).

- [Why SkyrimNet is built this way](#why-skyrimnet-is-built-this-way)
- [Conversation](#conversation)
- [Language models](#language-models)
- [Memory that behaves like memory](#memory-that-behaves-like-memory)
- [Speech](#speech)
- [Vanilla dialogue](#vanilla-dialogue)
- [In-game chat overlay](#in-game-chat-overlay)
- [Vision (OmniSight)](#vision-omnisight)
- [Triggers](#triggers-react-to-anything-with-yaml)
- [Bard songs](#bard-songs-ai-composed-ai-performed)
- [NPC thoughts and telepathy](#npc-thoughts-and-telepathy)
- [NPC actions](#npc-actions)
- [Content Library](#content-library)
- [Web dashboard](#web-dashboard-at-localhost8080)
- [Cloud GPU (VastAI)](#cloud-gpu-vastai)
- [Modder API](#modder-api)
- [MCP server](#mcp-server-claude-editors-custom-ai-tools)

## Why SkyrimNet is built this way

SkyrimNet is a native Windows DLL that loads inside Skyrim itself, a single SKSE plugin. There is no separate program to run, no virtual machine and no server window to keep alive. That has practical benefits:

- **Speed.** Every layer is built to minimize the time between you speaking and an NPC replying. Game state is read straight from memory, with no syncing between processes. Text-to-speech starts speaking the first sentence while the model is still writing the second. Eligibility for actions is pre-warmed while your voice is being transcribed, so the action-selection prompt doesn't wait on it.
- **Stability.** SkyrimNet almost never crashes the game. Game data is touched only through guarded patterns (reference-counted entity wrappers, validity checks before every use, strict lock ordering), and all heavy work runs on worker threads, so a stuck network call or a slow model can never freeze or stutter the game.
- **Setup.** First launch generates working defaults for every system. A guided web wizard gets you talking. No virtual machines, no separate apps, no command-line tools.
- **Performance.** On default settings SkyrimNet puts very little demand on your system. Local Piper TTS runs on the CPU; no GPU is required. The game thread never waits on a network request, a database query or a TTS render.
- **Extensibility.** A Papyrus API and a public C++ API let other mods register actions, decorators and event hooks. Prompt templates read live game data through over a hundred built-in decorators, and YAML-defined actions can call functions on any Papyrus quest script, so a mod can add new NPC behavior without rebuilding anything.

## Conversation

NPCs hold context-aware conversations powered by your chosen language model.

- **Streaming.** Text-to-speech begins reading the first sentence while the model is still writing the second one. Replies feel immediate.
- **Hand-written NPC bios.** Skyrim's named characters, including the DLC and Creation Club, ship with curated personalities, and bio packs for popular mods are in the [Content Library](#content-library). NPCs without a bio get one generated from their game data.
- **Continuous scene mode.** NPCs can keep a conversation going with each other while you watch. The next speaker is chosen as the current line finishes.
- **Realistic perception.** An NPC only reacts to what they could plausibly see or hear. People upstairs do not respond to conversations downstairs. Whisper mode (hotkey or `^` prefix in chat) shrinks the radius further so you can pull someone aside.
- **GameMaster.** An optional director starts scenes and conversations between NPCs on its own, so the world feels alive when you are not talking.
- **Virtual NPCs.** Define narrators, inner voices or disembodied speakers that have no in-game body but can still talk, remember and react.
- **Direct targeting.** Type `@Lydia` (with Tab autocompletion) to address a specific NPC.

## Language models

SkyrimNet assigns different models to different jobs: a smart model for dialogue, a fast and cheap one for picking actions and speakers, a vision model for OmniSight, and so on.

- **[Fateless](https://fateless.ai/inference):** one account for dialogue, voices, speech recognition and bard songs, with models tuned for every job and no API keys. Needs SkyrimNet Beta29 or later.
- **OpenRouter**, with ready-made Budget, Balanced and Performance presets.
- **Any OpenAI-compatible service.**
- **Local models** on your own GPU through LM Studio, Ollama, KoboldCpp or llama.cpp, for example NVIDIA Nemotron 3.5 Bolt. Small local models trade some quality for privacy and no running cost.

You can mix these, for example Fateless for dialogue and a local engine for voices.

## Memory that behaves like memory

Each NPC has their own private memory store. Memories are written from that character's first-person point of view and retrieved by meaning, not just keyword matching.

- **Vector recall.** A local embedding model finds memories related to the current situation, so a guard might remember "that time someone tried to bribe a guard in this market", not just memories with the literal word "bribe".
- **Importance and decay.** A memory of being attacked outweighs a passing pleasantry. Memories fade over time at a rate based on how important they were.
- **Diaries.** NPCs can write diary entries summarizing their day. Each entry becomes a searchable memory.
- **World Knowledge.** Facts bigger than one NPC ("A dragon attacked Helgen", "The Stormcloaks took Whiterun") can be scoped with simple conditions: only NPCs in Whiterun, only members of a faction, or only once a quest reaches a stage. Conditions are short template expressions like `contains(get_location(actorUUID), "Whiterun")` or `get_quest_stage("MQ104") >= 13`. Each entry is either **always included** when its condition passes, or pulled in **by relevance** when the conversation touches it.
- **Knowledge Packs.** Bundle world knowledge into named collections, export them as `.sknpack` files, share and import them, and toggle them as a unit. Useful for shipping lore alongside a quest mod.
- **NPC Groups.** Define your own groups ("Whiterun Guards", "Companions Inner Circle"), assign actors in the web UI or by right-clicking a name in the in-game chat, and use them in world knowledge conditions, triggers and the chat's group mode.

## Speech

A choice of text-to-speech engines, local and cloud:

| Engine | Where it runs | Voice cloning |
|--------|---------------|---------------|
| **Piper** | Locally, in the game's process (CPU) | No, pre-trained voices |
| **PocketTTS** | Locally, in the game's process (GPU optional) | Live cloning |
| **XTTS** | On a server you choose (your PC, a rented cloud GPU, or LAN) | Live cloning |
| **Zonos** | On a server you choose | Live cloning, emotion-aware |
| **Chatterbox** | On a server you choose | Live cloning |
| **Higgs** | On a server you choose | Live cloning, audio tags |
| **OpenAI-compatible TTS** | Boson.ai, or a compatible local or network server | Registered voices, audio tags |
| **ElevenLabs** | Cloud API | Voice cloning, audio tags |
| **Inworld** | Cloud API | Voice cloning, audio tags |
| **Fateless** | Fateless account | Shared and custom voices, audio tags |
| **Kokoro** | Locally (narrator only) | No |

Piper is the default. It runs entirely on the CPU and needs no setup. Downloaded models are SHA-pinned and verified, so a half-downloaded model never sneaks into your install.

**Voice Effects** apply per-NPC audio transformations: pitch shift, formant shift, reverb, distortion, echo, ring modulation, EQ and more. Built-in recipes cover Werewolf, Vampire Lord, Draugr, Dragon Priest, Dremora, Ghost, and overlays for thoughts and narration. Recipes are YAML, hot-reloadable, and editable in the web UI with an audio preview.

**Speech-to-text** uses local Whisper by default (CUDA, Vulkan, OpenCL or CPU, whichever your PC supports), with models from `tiny` to `large-v3-turbo` downloaded for you. Fateless and OpenAI's cloud Whisper API are alternatives.

## Vanilla dialogue

SkyrimNet works with Skyrim's own dialogue as well as freeform conversation:

- **Your picks, voiced.** When you choose a line in the vanilla dialogue menu, SkyrimNet speaks it in your character's voice, and prepares a voiced reply for NPC lines that never had voice acting.
- **Dialogue Actions.** NPCs can fire their original quest and service lines when the conversation calls for it. You control which lines are allowed, and can attach guidance to each, under Settings › Dialogue Actions.
- **Dialogue choice.** A hotkey asks the AI to pick the dialogue-menu option that fits what you want to say. It only highlights the option; you still confirm it.

## In-game chat overlay

A chat panel, drawn by Prisma UI or Magelight UI, replaces Skyrim's basic text-input dialog.

- Persistent message history with timestamps
- Direct targeting (`@Lydia hello`) with Tab autocomplete
- **Whisper** (`^`) and **Group** (`&`) modifiers, combinable in either order
- Slash commands: `/think`, `/transform`, `/silent`, `/monologue`, `/compose`, `/playsong`, `/summon`, `/npcthink`, `/telepathy` (and `~` as a shorthand)
- Edit or delete any earlier event: fix a typo, redo a line, undo a mistake
- Right-click menu on any name (talk, whisper, manage groups, copy)
- A live strip showing who can currently hear you
- Font, opacity, anchor and width set from inside the game

## Vision (OmniSight)

SkyrimNet can take screenshots of actors, items, locations, furniture and the current scene, and ask a vision model to describe them. The descriptions feed into the prompts NPCs see, so an NPC can comment on the strange amulet you're wearing or the fact that the room is on fire. Items render on transparent backgrounds at high resolution. Identical items are described only once. Descriptions can be locked from the web UI to protect curated wording.

## Triggers (react to anything with YAML)

A trigger is a small YAML file that says "when X happens, do Y". Triggers can:

- Fire a **player thought** ("the flames dance at my command…")
- Fire a **player dialogue** line
- Fire an **NPC thought** (unvoiced, private to the NPC's own memory)
- Add a **direct narration** that nearby NPCs treat as fact
- Add a silent **persistent event** to world context
- Generate a **diary entry** for one or more NPCs
- Generate a **dynamic bio** for one or more NPCs
- **Enable or disable a virtual NPC** (great for context-sensitive narrators)
- **Apply or clear a voice effect** on a target

Conditions support nested field access, numeric and string comparison, regex, template expressions, cooldowns, probability, priority and dialogue-interrupt flags. The web UI has a YAML editor with schema validation.

## Bard songs (AI-composed, AI-performed)

Bards in inns sing new songs. Lyrics are written by your language model from the bard's perspective, using their memories and recent events, and the music is generated through Suno or Fateless. Songs are cached per save and can be re-downloaded later. You can compose songs of your own with `/compose <topic>` and perform them with `/playsong <title>`. Audio is spatial, so songs get quieter as you walk away, and the vanilla bard voice and instrument idles are suppressed during AI playback.

## NPC thoughts and telepathy

NPCs can have unvoiced internal thoughts that shape their later dialogue without anyone hearing them. Thoughts can come from world events through triggers, from Papyrus scripts, or on demand from the chat overlay with `/npcthink Lydia what are you thinking about right now?`.

An optional telepathy perk adds an in-fiction mechanic on top. With it, you can speak privately to a single NPC with `/telepathy Lydia we need to leave, now`: nobody else perceives the exchange, and the NPC replies over the same channel. A separate "eavesdrop" lesser power lets you overhear nearby NPCs' thoughts.

## NPC actions

NPCs choose actions (give gold, follow, attack, surrender, sing, craft) from a library you can extend. Actions can be:

- **YAML-defined**, calling functions on Papyrus quest scripts
- **Papyrus-registered** at runtime
- **Native C++** from another SKSE plugin
- Grouped into nested categories, so the model picks a broad intent first and the specifics second, with a cheaper prompt for the second step

Action eligibility is cached and pre-warmed while you speak, so by the time your sentence is transcribed, the model already knows which actions each nearby NPC can take.

## Content Library

Prompts, bios, triggers, actions and knowledge come as plugins in the Content Library. Install community plugins from the hub inside the dashboard, keep your own edits as a local layer on top, and see which plugin provides what when two of them overlap. Mods can ship their own SkyrimNet content inside their mod folder.

## Web dashboard at `localhost:8080`

A control panel in your browser, also available in game:

- **Home**: server status, nearby NPCs, live event stream, recent model requests, pinned characters with quick teleport
- **Characters**: edit NPC bios next to live actor data, generate bios for nearby actors, AI-driven bio updates with a diff preview
- **Memories**: search, edit and filter memories, and test semantic recall
- **World Knowledge, Knowledge Packs and NPC Groups**
- **Triggers**: write and test YAML triggers with schema validation
- **Voice Effects** and **Voice Samples**
- **OmniSight**: screenshot gallery with descriptions
- **Prompts**: edit any template, hot-reloaded
- **Actions**: toggle actions, set cooldowns, edit custom actions
- **Diary**: view and edit diary entries
- **Agents**: chat with AI agents that can query game state through the built-in MCP server
- **Content Library**: install, update and manage plugins
- **Settings**: every option, searchable, with visual hotkey capture
- **Game Data Explorer**: quests, spells, factions, items, NPCs, races, magic effects, plugins, globals, message boxes
- **Logs, Traces, Performance and Event Monitor**: full insight into what is happening

Dark and light themes are both first-class.

## Cloud GPU (VastAI)

If your PC can't run XTTS or other heavy voice models, SkyrimNet can rent a GPU on VastAI for you. "Smart Create" searches for offers matching your reliability, price and GPU preferences, starts several instances at once, keeps the first one that comes up healthy, destroys the rest, and wires the endpoint into your TTS settings. Background monitoring can clean up and recreate instances as needed.

## Modder API

SkyrimNet has a Papyrus API (`SkyrimNetApi`) and a public C++ DLL API (see [CppAPI](../CppAPI)). Mods can:

- Register custom actions, decorators and event hooks
- Create memories and world knowledge entries, with embeddings
- Mark actors as busy with a stated reason, so SkyrimNet defers to your mod
- Send directed dialogue, narration or persistent events
- Set or clear voice effects on any actor
- Subscribe to lifecycle ModEvents (`SkyrimNet_SpeechStarted`, `SkyrimNet_MemoryCreated`, `SkyrimNet_DiaryCreated` and others)
- Ship SkyrimNet content inside their own mod folders, which Mod Organizer 2's virtual file system picks up automatically

The **Inja template system** is the main extension point for prompt authors. Over a hundred built-in decorators expose player and NPC state, equipment, combat, factions, magic, location, time, memory and more. Templates reload automatically without restarting the game. Guides are in [docs/modding](modding), and [SkyrimNet-ExamplePlugin](https://github.com/MinLL/SkyrimNet-ExamplePlugin) has complete Papyrus and C++ plugins to build from.

## MCP server (Claude, editors, custom AI tools)

SkyrimNet runs a Model Context Protocol server on port 8889 with dozens of tools for external AI assistants. Point Claude Desktop, a VS Code MCP extension or your own client at it to:

- Query quests, spells, factions, items, NPCs, races, magic effects, plugins, globals and message boxes
- Read, write and search NPC memories
- Manage world knowledge, packs and NPC groups
- Check which actions any actor can take
- Render any prompt template with full context
- Render items to images for vision models
- Run Skyrim console commands
- Validate trigger, action and item YAML before saving
- Reload prompts, triggers and actions live
