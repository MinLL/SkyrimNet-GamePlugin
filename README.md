# SkyrimNet

[![ko-fi](https://ko-fi.com/img/githubbutton_sm.svg)](https://ko-fi.com/S6S51B7MJA) 

[![Discord](https://img.shields.io/badge/Chat-on%20Discord-7289DA?logo=discord&logoColor=white)](https://discord.gg/gHHS7HpJS9)

SkyrimNet makes every NPC in Skyrim into a real conversationalist. They hold their own opinions, remember what happened to them, react to what's going on around them, and decide what to do next — all voiced through the text-to-speech engine of your choice, all powered by your choice of large language model.

It is the only project of its kind that runs as a single SKSE plugin. No WSL. No Python launcher. No background server window to keep alive. Install the mod, launch the game, open `localhost:8080` in your browser, and you're talking to NPCs in a few minutes.

## Why SkyrimNet is built this way

Most AI mods for Skyrim work by running a separate program — typically an external exe, or an entire web serving stack inside the Linux virtual machine — that the mod talks to over a network connection. This incurs a significant setup cost (Users don't want to install Linux to play a Skyrim mod). This introduces latency, a considerable amount of system load, and many sources of bugs/issues.

SkyrimNet is different. It is a native Windows DLL that loads inside Skyrim itself. The benefits are practical, not theoretical:

- **Speed.** Every layer is built to minimize the time between you speaking and an NPC replying. Game state is read straight from memory (no syncing, no serialization round-trips between processes). TTS starts speaking the first sentence while the model is still writing the second. Eligibility for actions is pre-warmed while your voice is being transcribed so the action-selection prompt doesn't wait on it. The goal is for replies to feel immediate, not "fast for an LLM."
- **Stability.** SkyrimNet (almost never) crashes the game. Game data is touched only through guarded patterns — reference-counted entity wrappers, validity checks before every use, strict lock ordering — and all heavy work is isolated onto worker threads, so a stuck network call or a slow LLM can never freeze, stutter, or take down the game process. Users care about this a lot, and so do we.
- **Setup.** First launch generates working defaults for every system. A guided web wizard collects your API keys and gets you talking. No virtual machines to configure, no separate apps to install, no command-line tools.
- **Performance.** On default settings SkyrimNet puts very little demand on your system. Local Piper TTS runs on the CPU; no GPU is required. The game thread is never blocked on a network request, a database query, or a TTS render — every piece of heavy work runs asynchronously and streams its results back into the game as they become available. You should not notice SkyrimNet running in the background.
- **Extensibility.** SkyrimNet ships a Papyrus API and a public C++ DLL API so other mods can register custom actions, decorators, and event hooks. The Inja-based prompt templating system reads live game data through over a hundred built-in decorators (player and NPC state, equipment, combat, factions, magic, location, time, memory retrieval, and more), so prompts can be context-aware without writing any code. YAML-defined actions can call arbitrary functions on any Papyrus script attached to a quest — which means a third-party mod can drop in entirely new NPC behavior without rebuilding anything.

## What SkyrimNet does

### Conversation

NPCs hold context-aware conversations powered by your chosen language model. SkyrimNet talks to OpenRouter (or any OpenAI-compatible endpoint), and you can assign different models to different jobs — a fast, cheap model for action selection, a smarter model for dialogue.

- **Streaming.** Text-to-speech begins reading the first sentence while the model is still writing the second one. Replies feel immediate.
- **3,000+ pre-written NPC bios.** Vanilla Skyrim NPCs and popular mod characters all ship with hand-curated personalities. NPCs without a bio get one generated automatically from their game data.
- **Continuous scene mode.** NPCs can keep a conversation going with each other while you watch. The next speaker is chosen as the current line finishes.
- **Realistic perception.** An NPC only reacts to what they could plausibly see or hear. People upstairs do not respond to conversations downstairs. Whisper mode (hotkey or `^` prefix in chat) shrinks the radius further so you can pull someone aside.
- **Virtual NPCs.** Define narrators, inner voices, or disembodied speakers that have no in-game body but can still talk, remember, and react.
- **Direct targeting.** Type `@Lydia` (with Tab autocompletion) to address a specific NPC without going through the model's target-selection step.

### Memory that behaves like memory

Each NPC has their own private memory store. Memories are written from that character's first-person point of view and retrieved by meaning, not just keyword matching.

- **Vector recall.** A local, GPU-accelerated embedding model finds memories that are semantically related to the current situation — so a guard might remember "that time someone tried to bribe a guard in this market," not just memories that contain the literal word "bribe."
- **Importance and decay.** A memory of being attacked outweighs a memory of a passing pleasantry. Memories fade over time at a rate proportional to how important they were.
- **Diaries.** NPCs can compose diary entries summarizing their day. Each entry becomes a searchable memory.
- **World Knowledge.** Facts that are bigger than one NPC ("A dragon attacked Helgen", "The Stormcloaks took Whiterun") can be scoped using simple conditions — for example, only NPCs in Whiterun, only members of a specific faction, or only once a particular quest has reached a particular stage. Conditions are written as short template expressions like `is_in_location("Whiterun")` or `get_quest_stage("MQ104") >= 13`, so a fact can enter the world the moment a quest milestone fires and stay scoped to the characters it should reach. Each entry can be either **always injected** into every prompt whose condition passes, or pulled in **semantically** when the current conversation is relevant to it — quest-critical facts stay in scope while incidental lore only surfaces when it matters.
- **Knowledge Packs.** Bundle world knowledge into named collections, export them as `.sknpack` files, share them, import them, and toggle them on or off as a unit. Useful for shipping curated lore alongside a quest mod.
- **NPC Groups.** Define your own groups ("Whiterun Guards", "Companions Inner Circle"), assign actors to them through the web UI or by right-clicking a name in the in-game chat, and reference them from world knowledge conditions, triggers, and the in-game chat's group mode.

### Speech

Eight selectable text-to-speech engines, mixing local and cloud options:

| Engine | Where it runs | Voice cloning |
|--------|---------------|---------------|
| **Piper** | Locally, in the game's process | No — uses pre-trained voices |
| **PocketTTS** | Locally, in the game's process (GPU optional) | Live cloning |
| **XTTS** | On a server you choose (your PC, a rented cloud GPU, or LAN) | Live cloning |
| **ElevenLabs** | Cloud API | Live cloning |
| **Inworld** | Cloud API | Live cloning |
| **Zonos** | On a server you choose (your PC, a rented cloud GPU, or LAN) | Live cloning, emotion-aware |
| **Chatterbox** | On a server you choose (your PC, a rented cloud GPU, or LAN) | Live cloning |
| **Kokoro** | Locally (narrator only) | No |

Piper is the default. It runs entirely on the CPU and needs no setup. All models are SHA-pinned and verified at download, so a half-downloaded model never sneaks into your install.

**Voice Effects** apply per-NPC audio transformations: pitch shift, formant shift, reverb, distortion, echo, ring modulation, EQ, and more (thirteen stage types in total). Built-in recipes cover Werewolf, Vampire Lord, Draugr, Dragon Priest, Dremora, Ghost, and overlay effects for thoughts and narration. Recipes are YAML, hot-reloadable, and editable in the web UI with audio preview that doesn't require triggering a full conversation.

**Speech-to-text** uses local Whisper by default — CUDA, Vulkan, OpenCL, or CPU, whichever your machine supports — with models from `tiny` to `large-v3-turbo` available and auto-downloaded. OpenAI's cloud Whisper API is available as an alternative.

### In-game chat overlay

A PrismaUI-based chat panel replaces Skyrim's primitive text-input dialog. It feels like a modern chat client running inside the game world.

- Persistent message history with timestamps
- Direct targeting (`@Lydia hello`) with Tab autocomplete
- **Whisper** (`^`) and **Group** (`&`) modifiers, combinable in either order
- Slash commands: `/think`, `/transform`, `/silent`, `/monologue`, `/compose`, `/playsong`, `/summon`, `/npcthink`, `/telepathy` (and `~` as a shorthand)
- Inline editing and deletion of any prior event — fix a typo, redo a line, or undo a mistake
- Right-click context menu for any name (talk, whisper, manage groups, copy)
- Live audience strip showing who can currently hear you
- Customizable font, opacity, anchor, and width from inside the game

### Vision (OmniSight)

SkyrimNet can take screenshots of actors, items, locations, furniture, and the current scene, then ask a vision model to describe them. The descriptions feed back into the prompts NPCs see, so an NPC can comment on the strange amulet you're wearing or the fact that the room is on fire. Items render on transparent backgrounds at high resolution. Identical items are deduplicated by content hash so they only get described once. Descriptions can be locked from the web UI to protect curated wording from being overwritten.

### Triggers (react to anything with YAML)

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

Conditions support nested field access, numeric and string comparison, regex, template expressions, cooldowns, probability, priority, and dialogue-interrupt flags. The web UI ships a YAML editor with schema validation.

### Bard songs (AI-composed, AI-performed)

Real bards in real inns sing real songs. Lyrics are written by your language model from the bard's perspective using their memories and recent events. Music is generated by Suno. Songs are cached per save, evicted in FIFO order when the cache fills, and can be re-downloaded later from Suno using the original task ID. The player can compose songs of their own with `/compose <topic>` and perform them later with `/playsong <title>`. Audio is spatial — songs get quieter as you walk away — and the vanilla bard voice and instrument idles are suppressed during AI playback so the two never overlap.

### NPC thoughts and Telepathy

NPCs can have unvoiced internal thoughts that influence their later dialogue without being heard by anyone. Thoughts can be triggered by world events through the trigger system, by Papyrus scripts, or on-demand from the chat overlay with `/npcthink Lydia what are you thinking about right now?`.

An optional telepathy perk system layers an in-fiction mechanic on top of it. With the canonical perk, the player can send dialogue privately to a single NPC with `/telepathy Lydia we need to leave, now` — nobody else perceives the exchange, and NPCs reply over the same channel. A separate "eavesdrop" lesser power lets the player overhear nearby NPC thoughts.

### NPC actions

NPCs choose actions — give gold, follow, attack, surrender, sing — from a library you can extend. Action definitions can be:

- **YAML-defined**, calling functions on Papyrus quest scripts
- **Papyrus-registered** at runtime
- **Native C++** from another SKSE plugin
- Grouped into nested categories so the model picks a high-level intent first and drills into specifics second — the drill-down step uses a cheaper, lightweight prompt to keep token costs down

Action eligibility is cached and pre-warmed during voice recording, so by the time your sentence finishes transcribing, the model already knows which actions are valid for each nearby NPC.

### Web dashboard at `localhost:8080`

A React-based control panel with roughly thirty pages:

- **Dashboard** — server status, GameMaster state, nearby NPCs, live event stream, recent LLM requests, thread-pool statistics, pinned characters with quick-teleport
- **Characters** — edit static or dynamic NPC bios, view live actor data alongside, generate new bios from nearby actors, request AI-driven bio updates with diff preview, automatic backups
- **Memories** — vector-search testing, full CRUD, filter by actor / type / importance / content / time, semantic similarity testing
- **World Knowledge / Knowledge Packs / NPC Groups** — full lifecycle for shared, condition-scoped knowledge
- **Triggers** — author and test YAML triggers with schema validation
- **Voice Effects** — recipe editor with audio preview
- **Voice Samples** — upload per-voice audio clips for cloning engines
- **OmniSight** — screenshot gallery with descriptions, lock/unlock, manual refresh
- **Prompts** — edit any Inja template; hot-reload via MCP
- **Action Library / Papyrus Quest Actions** — toggle actions, set cooldowns, edit custom action YAML
- **Diary** — view, edit, delete generated diary entries
- **Agents** — chat with LLM agents that have tool-calling access to game state through the built-in MCP server
- **VastAI** — manage cloud GPU instances with one-click "Smart Create"
- **Config** — live config editing with schema validation, search across all configs, visual hotkey capture, separate variants for CUDA vs non-CUDA builds
- **Universal Translator** — translate dialogue or arbitrary text
- **Game Data Explorer** — browse quests, spells, factions, items, NPCs, races, magic effects, plugins, globals, message boxes
- **Logs / Traces / Performance / Event Monitor / Debug** — full observability into everything async

Both dark and light themes are first-class.

### Cloud GPU (VastAI)

If you don't have the GPU power to run XTTS or other heavy models locally, the VastAI page can rent one for you. The "Smart Create" button:

1. Searches VastAI for offers matching your reliability, price, and GPU preferences
2. Provisions several instances simultaneously for redundancy
3. Picks the first one that comes up healthy
4. Destroys the rest
5. Wires the endpoint into your TTS config automatically

Configurable filters cover GPU model whitelist, max price per hour, minimum host reliability, and preferred regions. Background monitoring will auto-clean and (optionally) auto-create instances as needed.

### Modder API

SkyrimNet exposes a Papyrus API (`SkyrimNetApi`) and a public C++ DLL API for other mods to build on. Mods can:

- Register custom actions, decorators, and event hooks
- Create memories and world knowledge entries with full vector embeddings
- Mark actors as busy with a stated reason, so SkyrimNet defers to your mod's logic
- Dispatch directed dialogue, narration, or persistent events
- Set or clear voice effects on any actor
- Subscribe to lifecycle ModEvents (`SkyrimNet_SpeechStarted`, `SkyrimNet_MemoryCreated`, `SkyrimNet_DiaryCreated`, and others)
- Ship category YAML files inside their own mod folders — MO2 virtualization picks them up automatically
- And much more.

The **Inja template system** is the main extension point for prompt authors. Over a hundred built-in decorators expose player and NPC state, equipment, combat, factions, magic, location, time, memory retrieval, and more. Templates hot-reload automatically without restarting the game.

### MCP server (Claude, editors, custom AI tools)

SkyrimNet runs a Model Context Protocol server on port 8889 that exposes 44+ tools to external AI assistants. Point Claude Desktop, a VS Code MCP extension, or your own client at it to:

- Query quests, spells, factions, items, NPCs, races, magic effects, plugins, globals, message boxes
- Read, write, and semantically search NPC memories
- Manage world knowledge entries, packs, and NPC groups
- Check action eligibility for any actor
- Render any prompt template with full context
- Render items to images for vision models
- Execute Skyrim console commands on the game thread
- Validate trigger, action, and item-customization YAML before saving
- Reload prompts, triggers, and actions live

## Major community plugins

SkyrimNet's modder API has a growing ecosystem of plugins built on top of it. A couple of major ones to know about:

- **[SeverActions](https://github.com/Severause/SeverActions)** — A native AI-first follower framework with rapport, trust, loyalty, and mood tracked per companion, optional NFF/EFF integration, LLM-generated relationship assessments from recent events, and autonomous companion-on-companion banter. Additionally ships a large action pack — 71 actions spanning combat, gold and debt, crafting at forges and cooking pots and alchemy labs, and a full crime-and-arrest system. Includes its own native C++ SKSE plugin and an in-game PrismaUI configuration panel.
- **[IntelEngine](https://github.com/galanx/IntelEngine-GamePlugin)** — Gives NPCs the ability to physically act across wide spaces of the world, both on your command and on their own. NPCs accept scheduled meetings, fetches, and deliveries at natural future times ("at sunset", "tomorrow morning", "in three hours") and travel on foot to keep them — across cells, across holds. An LLM Dungeon Master then decides when NPCs should act unprompted: **dynamic quest creation** (bounty hunts, rescues, item retrieval, faction-war battles), ambushes from people you've wronged, gossip chains that propagate between NPCs, and faction politics with nine configurable factions, off-screen developments in wars that influence scenario/quest generation, and player-fought battles.

## 🚀 **Installation & Setup**

### ⚙️ **Quick Start**
1. **Download** from [GitHub Releases](https://github.com/MinLL/SkyrimNet-GamePlugin/releases)
   
   **Piper TTS Models (Optional)**: If you plan to use Piper TTS, download the required voice models from [Google Drive](https://drive.google.com/file/d/1zmBJCLlaGWKBW8Z87rw2MiaNE-8cdSlv/view) and install them as a separate mod in your mod manager (MO2, Vortex, etc.).

2. **Install** using your preferred mod manager
3. **Enable** SkyrimNet.esp in your load order
4. **Launch** via SKSE and visit [localhost:8080](http://localhost:8080)
5. **Complete** the guided setup wizard with your API keys
6. **Experience** the future of gaming AI!

*First launch automatically generates default configurations for your system.*

## 📋 **System Requirements**

### 🔧 **Essential Dependencies**
- [Skyrim Script Extender (SKSE)](https://skse.silverlock.org/)
- [Address Library for SKSE Plugins](https://www.nexusmods.com/skyrimspecialedition/mods/32444)
- [PowerOfThree's Papyrus Extender](https://www.nexusmods.com/skyrimspecialedition/mods/22854)
- [PapyrusUtil SE](https://www.nexusmods.com/skyrimspecialedition/mods/13048)
- [Latest Microsoft Visual C++ Redistributable](https://learn.microsoft.com/en-us/cpp/windows/latest-supported-vc-redist?view=msvc-170)
- [Native EditorID Fix](https://www.nexusmods.com/skyrimspecialedition/mods/85260) (or [VR version](https://github.com/naitro2010/NativeEditorIDFixNG/releases/))
- [Prisma UI](https://www.nexusmods.com/skyrimspecialedition/mods/148718)
- [Media Keys Fix SKSE](https://www.nexusmods.com/skyrimspecialedition/mods/92948) - Requirement of Prisma UI

### 📋 **Optional Dependencies**
- [UIExtensions](https://www.nexusmods.com/skyrimspecialedition/mods/17561) - Required for Input Wheel
- [Dragonborn Voice Over](https://www.nexusmods.com/skyrimspecialedition/mods/84329) - Download the 1.1.1 version, not the newer 2.0 versions. Required for several optional features: voicing player lines in Dialogue menus (DBVO but with real-time audio generation), TTS for mods with silent voices, and Universal Translator. To enable these features, install DBVO but disable or delete the DBVO.esp file (no voice pack is required).
- [CUDA Toolkit 12.x](https://developer.nvidia.com/cuda-12-9-1-download-archive) - If you have an NVIDIA GPU with CUDA support, CUDA toolkit 12.x (**not** the most recent 13.x versions) can be used to increase performance of local Whisper STT. Restart your PC after installing it.
You can confirm that CUDA is being used on the Test & Easy Setup page in the Speech-to-Text Test section:
  - <img width="600" height="122" alt="image" src="https://github.com/user-attachments/assets/68fdc4b5-70a3-402c-a258-ea33518d73a2" />


### 🎮 **Version-Specific Requirements**

**Skyrim SE (without ESL support):**
- [Backported Extended ESL Support (BEES)](https://www.nexusmods.com/skyrimspecialedition/mods/106441)

**Skyrim VR:**
- [Skyrim VR ESL Support](https://www.nexusmods.com/skyrimspecialedition/mods/106712) - Use instead of BEES
- [Skyrim VR Refocused](https://www.nexusmods.com/skyrimspecialedition/mods/32737), or a similar mod to make sure Skyrim keeps focus.
- [MFG Fix NG](https://www.nexusmods.com/skyrimspecialedition/mods/133568)
- [Dragonborn Voice Over - Skyrim VR Patch](https://www.nexusmods.com/skyrimspecialedition/mods/84329?tab=files), if using Dragonborn Voice Over


### 🌐 **External API Requirements**
- **LLM Provider**: OpenRouter API key (or compatible OpenAI API)
- **Cloud Processing**: VastAI account (optional, for cloud GPU access and automatic XTTS provisioning)

## Current Limitations
- **Vanilla dialogue trees.** SkyrimNet handles freeform conversation; vanilla quest dialogue trees still go through Skyrim's normal system. Integrating the two is on the roadmap.

## What's coming

A major focus right now is making SkyrimNet feel approachable for non-technical users. The end goal is for installing the mod to be all you have to do — download it, launch the game, and start talking to NPCs, with no API keys to configure, no models to pick, and no understanding of AI required.

## Credits
- The small community of developers who build SkyrimNet — contributions of code, design, testing, and ideas that keep the project moving.
- A special thanks to ArtFromTheMachine for letting us use his Piper voice models.
- Pre-written character bios are the work of the SkyrimNet community.


---

## 🛠️ **For Developers**

This repository contains the game plugin assets for SkyrimNet:
- **Spriggit serialized ESP plugin** (`plugins/SkyrimNet/`) - Text format for version control
- **Papyrus script sources** (`Source/Scripts/`) - Script source files
- **Papyrus headers** (`headers/`) - Vanilla Skyrim script headers for compilation
- **UI templates** (`interface/`) - MCM and UI configuration
- **SKSE prompts and assets** (`SKSE/Plugins/SkyrimNet/`) - Prompt templates and configuration

### Building from Source

Compiled files (`.esp` and `.pex`) are NOT stored in this repository. They are generated during the SkyrimNet build process.

### Manual Build Tools

**ESP Plugin:**
- Download [SpriggitCLI](https://github.com/Mutagen-Modding/Spriggit/releases/tag/0.40.0)
- Run: `Spriggit.CLI.exe convert-to-plugin -i plugins/SkyrimNet -o SkyrimNet.esp`

**Papyrus Scripts:**
- Download [papyrus-compiler](https://github.com/russo-2025/papyrus-compiler/releases/tag/2025.03.18)
- Run: `papyrus.exe -nocache -h headers -i Source/Scripts -output Scripts`

### Repository Structure

```
├── plugins/SkyrimNet/     # Spriggit serialized ESP (version controlled)
├── Source/Scripts/        # Papyrus source files (.psc)
├── Scripts/               # Compiled scripts output (not tracked)
├── headers/               # Vanilla Skyrim Papyrus headers
├── interface/             # MCM and UI templates
├── SKSE/Plugins/SkyrimNet/# Prompts, assets, documentation
└── docs/                  # In-game documentation
```
