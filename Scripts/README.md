# Compiled Scripts

This folder contains compiled Papyrus scripts (`.pex` files).

**Note:** Compiled scripts are NOT stored in this repository. They are generated during the SkyrimNet build process.

## How to compile

Compiled scripts are automatically generated when building SkyrimNet:
1. Clone the [SkyrimNet](https://github.com/MinLL/SkyrimNet) repository
2. Set `$gamePluginPath` in `Build_Config_Local.ps1` to point to this repository
3. Run `.\BuildRelease.ps1`

The build will:
- Compile Papyrus scripts from `Source/Scripts/` using the papyrus-compiler
- Copy compiled `.pex` files to the output folder

## Manual compilation

To compile manually without SkyrimNet:
1. Download the [papyrus-compiler](https://github.com/russo-2025/papyrus-compiler/releases/tag/2025.03.18)
2. Run: `papyrus.exe -nocache -h headers -i Source/Scripts -output Scripts`

## Source files

Source `.psc` files are located in `Source/Scripts/`.
