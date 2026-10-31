# Contributing to SkyrimNet

Thanks for helping. Pull requests are welcome: prompts, scripts, plugin records, presets and docs.

## How to contribute

1. Open an issue first for anything larger than a fix, so we can agree on the approach.
2. Branch from `main` and open a pull request against it. Fill in the template: what changed, what
   you tested in game, and a release note in `changelog.d/` if a player would notice the change
   (see [changelog.d/README.md](changelog.d/README.md)).
3. Plugin (ESP) changes go through the Spriggit source in `spriggit/`, not the binary
   `SkyrimNet.esp` alone.
4. Keep each pull request to one change. A reviewer and the review bot will comment; answer every
   comment, with a fix or a reply.

## What's in this repository

This repository holds SkyrimNet's game plugin assets. The SkyrimNet DLL itself is built elsewhere.

```
├── spriggit/SkyrimNet/      # Spriggit serialized ESP (version controlled)
├── plugins/skyrimnet/base/  # skyrimnet.base Content Library plugin: prompts, translations, vanilla/DLC/CC bios
├── Source/Scripts/          # Papyrus source files (.psc)
├── Scripts/                 # Compiled scripts output (not tracked)
├── headers/                 # Vanilla Skyrim Papyrus headers
├── interface/               # MCM and UI templates
├── SKSE/Plugins/SkyrimNet/  # Runtime assets and configuration
├── CppAPI/                  # Public C++ API for other SKSE plugins
└── docs/                    # Feature tour and modding guides
```

Bios for third-party mods are not in base; they ship as `skyrimnet.bios-{mod}` packs on the plugin hub.

## Building

Compiled files (`.esp` and `.pex`) are not stored in this repository. The SkyrimNet build generates
them. To build them by hand:

- **ESP plugin:** download [SpriggitCLI](https://github.com/Mutagen-Modding/Spriggit/releases/tag/0.40.0)
  and run `Spriggit.CLI.exe convert-to-plugin -i spriggit/SkyrimNet -o SkyrimNet.esp`
- **Papyrus scripts:** download [papyrus-compiler](https://github.com/russo-2025/papyrus-compiler/releases/tag/2025.03.18)
  and run `papyrus.exe -nocache -h headers -i Source/Scripts -output Scripts`

## Licensing your contribution

SkyrimNet is not open source; see [LICENSE](LICENSE). By opening a pull request, or by submitting
content (text, prompts, code) in an issue, comment or review, you agree that:

1. The contribution is your own work, or you have the right to submit it under these terms.
2. You keep the copyright in your contribution, and you grant Fateless.Ai a perpetual, worldwide,
   non-exclusive, royalty-free, irrevocable license to use, copy, modify, distribute and sublicense
   it, under any terms, as part of SkyrimNet or any other Fateless.Ai product.
3. Fateless.Ai may decide not to use your contribution, and owes you nothing for using it.

If your contribution includes someone else's work (a script from another mod, a borrowed prompt),
say so in the pull request and name its license. Its license must allow the grant in point 2.

The pull request template asks you to confirm this with a checkbox.
