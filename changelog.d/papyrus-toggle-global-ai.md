---
title: Papyrus can flip the SkyrimNet master switch
area: For Mod Authors
kind: change
---
`SkyrimNetApi.TriggerToggleGlobalAI()` turns all of SkyrimNet on or off, exactly like pressing the master toggle hotkey. The DLL has offered it for a while, but the script never declared it, so the game refused to bind it and logged an error on every load.
