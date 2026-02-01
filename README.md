# SkyrimNet

## Overview

SkyrimNet is a cutting-edge AI integration platform for games, beginning with Skyrim. Unlike other AI projects that take an external server approach, SkyrimNet uses an **in-process design as a DLL** without requiring WSL or external servers. This architectural difference offers faster response times, lower system load, and a streamlined setup process.

**The most advanced AI platform for gaming - transforming every NPC into a living, breathing character with their own memories, goals, and personalities.**

[![ko-fi](https://ko-fi.com/img/githubbutton_sm.svg)](https://ko-fi.com/S6S51B7MJA) 

[![Discord](https://img.shields.io/badge/Chat-on%20Discord-7289DA?logo=discord&logoColor=white)](https://discord.gg/gHHS7HpJS9)


## 🏗️ Revolutionary Architecture

### ⚡ **In-Process AI Stack**
- **In-Process Design**: Everything runs within the game's DLL - no external server or WSL required
- **High Performance**: Fast response times and efficient system resource usage
- **Direct Memory Access**: Reads game state directly from memory instead of syncing to external systems
- **Simplified Setup**: Straightforward installation without server configuration
- **Real-time Responsiveness**: Improved freshness of data and responsive AI behavior


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

### 📋 **Optional Dependencies**
- [UIExtensions](https://www.nexusmods.com/skyrimspecialedition/mods/17561) - Required for text input and Input Wheel
- [Dragonborn Voice Over](https://www.nexusmods.com/skyrimspecialedition/mods/84329) - Required for several optional features: voicing player lines in Dialogue menus (DBVO but with real-time audio generation), TTS for mods with silent voices, and Universal Translator. To enable these features, install DBVO but disable or delete the DBVO.esp file (no voice pack is required).
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


*⚠️ Important: CUDA Toolkit is required for the CUDA build to load properly*

### 🌐 **External API Requirements**
- **LLM Provider**: OpenRouter API key (or compatible OpenAI API)
- **Cloud Processing**: VastAI account (optional, for cloud GPU access and automatic XTTS provisioning)

## 🎪 Key Features

### 🧠 **AI Capabilities**
- **Dynamic NPC Interactions**: NPCs can react to player actions, world events, and conversations in real-time
- **Contextual Awareness**: The system maintains knowledge of recent events and uses this to inform AI responses
- **Smart NPC Selection**: Uses targeted fast LLM prompts to determine which NPC should react to events
- **Streaming Responses**: Supports streaming LLM responses for much faster responses and more natural conversation flow
- **Multi-Modal Processing**: Use the best LLM for the job. Different usecases are split out to different LLM's, allowing you to use a wider range of LLM's that were previously unsuitable
- **Semantic Understanding**: Advanced embedding models for natural conversation flow

### 🎭 **Living Character System**
- **3,000+ Unique Personalities**: Every vanilla NPC plus popular mod characters with detailed backstories
- **Dynamic Relationships**: Characters remember interactions, form opinions, and develop connections
- **Goal-Oriented Behavior**: NPCs pursue personal objectives, react to successes/failures
- **Emergent Conversations**: Characters naturally discuss events, gossip, and share knowledge

### 🧠 **Advanced Memory Architecture**
- **Per-Character Memories**: Memories are created from a first-person, per-character perspective. Every character remembers events differently based upon their personality and perspective.
- **Vector-Based Recall**: Semantic similarity matching for contextually relevant memories
- **Importance Weighting**: Critical events are remembered longer and influence behavior more
- **Temporal Decay**: Natural forgetting patterns that mirror human memory
- **Memory Consolidation**: Background processing creates long-term behavioral patterns

### 👁️ **Intelligent Awareness System**
- **Realistic Perception**: NPCs only know what they can see, hear, or reasonably infer. People from "downstairs" will not hear or react to your conversations.
- **Spatial Intelligence**: Distance, obstacles, and environmental factors affect interactions
- **Combat Awareness**: Dynamic reactions to threats, allies, and changing battle conditions
- **Social Context**: Understanding of relationships, hierarchies, and appropriate responses
- **Privacy Respect**: Private conversations stay private unless realistically overheard

### 🎙️ **Multi-Modal Communication**
- **Voice Recognition**: Natural speech input with streaming transcription
- **Text Interface**: Typical text input via UIExtensions
- **Facial Animation**: Synchronized expressions with speech
- **Multiple TTS Engines**: XTTS, Zonos, and Piper support for diverse voice options

### ⚙️ **Customization & Flexibility**
- **Customizable Prompt Templates**: Uses Inja templating system for highly configurable AI behavior
- **Situation-Specific Models**: Support for different LLM configurations based on context and needs
- **Profile-Based Overrides**: Ability to override settings on a per-profile basis (Not exposed via the UI in the initial Beta release, coming soon)
- **Extensive Configuration**: Fine-tune every aspect of the AI system, from dialogue detection distance to facial animation intensity

### 🌐 **Cloud-Native Features**
- **One-Click VastAI**: Automated cloud GPU provisioning with preconfigured environments. One click setup for XTTS
- **Smart Instance Management**: Manage and monitor your instances, with automatic TTS endpoint configuration
- **Cost Optimization**: Dynamic resource allocation. Automatically identifies and provisions the cheapest pod based upon your GPU requirements.
- **Zero-Config Setup**: One click "Smart Create" button to provision a preconfigured pod.

## 🌐 **Professional-Grade Web Interface**

### 📊 **Live Operations Dashboard**
- **Real-Time System Monitoring**: Server status, uptime, version info, and GameMaster state
- **Live Game Data**: View nearby NPCs, recent events, active short-lived events in real-time
- **Performance Analytics**: ThreadPool statistics, task duration analysis, error tracking
- **API Request Monitoring**: View recent LLM requests, response times, and token usage
- **Pinned Characters**: Quick access to frequently used characters with teleportation controls

### 🎨 **Character Management Studio**  
- **Dual Bio System**: Switch between static character bios and dynamic event-driven bios
- **Real-Time Actor Data**: Live health, stats, location, factions, and package information
- **AI-Powered Generation**: Create character profiles from nearby actors using LLM assistance
- **Character Creation**: Scan nearby actors and generate comprehensive bios automatically
- **Bio Update System**: Request AI updates to character personalities with diff preview
- **Split View Editor**: Edit bios while monitoring live actor data simultaneously
- **Backup Management**: Automatic backup system with restore capabilities

### 🧠 **Memory System Interface**
- **Vector Search Testing**: Test memory recall with semantic similarity matching
- **Memory Analytics**: Statistics on memory types, importance scores, and actor distribution  
- **Memory Generation**: Automatically generate memories from recent events and conversations
- **Advanced Filtering**: Search by actor, type, importance, content, and creation time
- **Memory Management**: Create, edit, delete, and organize character memories

### ⚙️ **Configuration Management**
- **Live Config Editing**: Real-time configuration changes with immediate validation
- **Hotkey Configuration**: Visual hotkey capture with Windows VK code mapping
- **Variant Support**: Separate configs for CUDA vs non-CUDA builds
- **Config Search**: Find specific settings across all configuration files
- **Schema Validation**: Built-in validation prevents configuration errors

### ☁️ **VastAI Cloud Integration**
- **Instance Management**: Create, monitor, and manage cloud GPU instances
- **Smart Provisioning**: One-click setup with automatic cost optimization
- **Live Instance Monitoring**: Real-time status, logs, and resource usage
- **Automatic TTS Setup**: Seamless XTTS endpoint configuration for running instances
- **Cost Tracking**: Monitor usage and automatically find cheapest available pods

## 🔧 **Built for Innovation**

### 🎯 **Modder-Friendly Architecture**
- **Extensible API**: Powerful Papyrus API for creating custom behaviors and actions. Creating new mods generally follows normal Skyrim modding paradigms.
- **Hot-Reloading**: Modify prompts, configs, and see changes instantly
- **Template Engine**: Powerful Inja-based prompt system with advanced features
- **Event Hooks**: React to any game event with custom AI behaviors

## ⚠️ **Current Limitations**

- **Available Actions**: The default list of actions that is exposed is rather limited at the moment. This will be expanded substantively in the future.
- **VR Keybinds**: At present, VR users cannot bind their controller buttons directly to hotkeys. VR users can use [this](https://github.com/BOLL7708/OpenVR2Key) as a workaround for the time being.

## 🚀 **Future Plans**

- **Expanded Actions**: More actions for NPC's to use.
- **Dynamic Quests**: Start and progress (some) quests automatically. Construct meaningful story arcs via automatic quest assignment. Handle things like "Meet me at the tavern later" via this system.
- **Dialogue Tree Analysis and Integration**: Analyze and Integrate with the existing normal "dialogue trees" to expose selection through natural dialogue, and improve profile generation.
- **Improve VR Support**: Fix the VR Keybind thing, and make VR a first class citizen. It already works quite well in VR aside from the hotkeys, for which there is a workaround.
- **Image to Text**: Add a sophisticated ITT pipeline that introduces meaningful context for the LLM.
- **Much, much more**

## Credits
- A special thanks to ArtFromTheMachine for letting us use his Piper models!

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
