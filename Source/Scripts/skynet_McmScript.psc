Scriptname skynet_McmScript extends SKI_ConfigBase

skynet_Library library

int toggleShowWebUi
int toggleInGameHotkeys

; Hotkey options
int optionHotkeyRecordSpeech
int optionHotkeyTextInput
int optionHotkeyToggleGameMaster
int optionHotkeyTextThought
int optionHotkeyVoiceThought
int optionHotkeyTextDialogueTransform
int optionHotkeyVoiceDialogueTransform
int optionHotkeyToggleContinuousMode
int optionHotkeyToggleWorldEventReactions
int optionHotkeyDirectInput
int optionHotkeyVoiceDirectInput
int optionHotkeyContinueNarration
int optionHotkeyToggleWhisperMode
int optionHotkeyToggleOpenMic
int optionHotkeyCaptureCrosshair
int optionHotkeyGenerateDiaryBio
int optionHotkeyInterruptDialogue

int useImage

event OnConfigOpen()
    
    ; Fetch the library from the quest
    library = ((Game.GetFormFromFile(0x0802, "SkyrimNet.esp") as Quest) as skynet_Library)
    
    Pages = new string[3]

    Pages[0] = "Overview"
    Pages[1] = "SkyrimNet Status"
    Pages[2] = "Hotkeys"

endevent

event OnPageReset(string page)

    SetCursorFillMode(LEFT_TO_RIGHT)
    SetCursorPosition(0)

    if page == ""
        DisplaySplashScreen()
    else
        UnloadCustomContent()
    endif
    
    if page == "Overview"
        DisplayOverview()
    elseif page == "SkyrimNet Status"
        DisplayStatus()
    elseif page == "Hotkeys"
        DisplayHotkeys()
    else
        ; Default to Overview page
        DisplayOverview()
    endif

endevent

function DisplaySplashScreen()

    if useImage == 0
        LoadCustomContent("SkyrimNet/Skyrimnet1.dds")
        useImage = 1
    else
        LoadCustomContent("SkyrimNet/Skyrimnet2.dds")
        useImage = 0
    endif

endfunction

function DisplayOverview()

    AddHeaderOption("Overview")
    AddHeaderOption("")

    toggleShowWebUi = AddTextOption("Click here to view Web UI", "")
    AddTextOption("UI can be found at http://localhost:8080 if the above link does not work on your system", "")

endfunction

function DisplayStatus()

    AddHeaderOption("SkyrimNet Status")
    AddHeaderOption("")
    
    ; Display build information
    string version = SkyrimNetApi.GetBuildVersion()
    string buildType = SkyrimNetApi.GetBuildType()
    
    AddTextOption("Version:", version)
    AddTextOption("Build Type:", buildType)
    
    ; Add more status information here as needed
    ; For example: uptime, connected status, etc.

endfunction

function DisplayHotkeys()
    
    AddHeaderOption("Hotkey Configuration")
    AddHeaderOption("")
    
    ; Toggle between native and in-game hotkeys
    if library.inGameHotkeysEnabled
        toggleInGameHotkeys = AddToggleOption("Use In-Game Hotkeys", true)
    else
        toggleInGameHotkeys = AddToggleOption("Use In-Game Hotkeys (Default: Native)", false)
    endif
    
    AddEmptyOption()
    
    ; Only show hotkey mappings if in-game hotkeys are enabled
    if library.inGameHotkeysEnabled
        AddHeaderOption("Voice Input Hotkeys")
        AddHeaderOption("")
        
        optionHotkeyRecordSpeech = AddKeyMapOption("Voice Recording", library.hotkeyRecordSpeech)
        optionHotkeyVoiceThought = AddKeyMapOption("Voice Thought", library.hotkeyVoiceThought)
        optionHotkeyVoiceDialogueTransform = AddKeyMapOption("Voice Dialogue Transform", library.hotkeyVoiceDialogueTransform)
        optionHotkeyVoiceDirectInput = AddKeyMapOption("Voice Direct Input", library.hotkeyVoiceDirectInput)
        
        AddHeaderOption("Text Input Hotkeys")
        AddHeaderOption("")
        
        optionHotkeyTextInput = AddKeyMapOption("Text Input", library.hotkeyTextInput)
        optionHotkeyTextThought = AddKeyMapOption("Text Thought", library.hotkeyTextThought)
        optionHotkeyTextDialogueTransform = AddKeyMapOption("Text Dialogue Transform", library.hotkeyTextDialogueTransform)
        optionHotkeyDirectInput = AddKeyMapOption("Direct Input", library.hotkeyDirectInput)
        
        AddHeaderOption("System Hotkeys")
        AddHeaderOption("")
        
        optionHotkeyToggleGameMaster = AddKeyMapOption("Toggle GameMaster", library.hotkeyToggleGameMaster)
        optionHotkeyToggleContinuousMode = AddKeyMapOption("Toggle Continuous Mode", library.hotkeyToggleContinuousMode)
        optionHotkeyToggleWorldEventReactions = AddKeyMapOption("Toggle World Events", library.hotkeyToggleWorldEventReactions)
        optionHotkeyToggleWhisperMode = AddKeyMapOption("Toggle Whisper Mode", library.hotkeyToggleWhisperMode)
        optionHotkeyToggleOpenMic = AddKeyMapOption("Toggle Open Mic", library.hotkeyToggleOpenMic)
        
        AddHeaderOption("Other Hotkeys")
        AddHeaderOption("")
        
        optionHotkeyContinueNarration = AddKeyMapOption("Continue Narration", library.hotkeyContinueNarration)
        optionHotkeyCaptureCrosshair = AddKeyMapOption("Capture Target (Hold: Player)", library.hotkeyCaptureCrosshair)
        optionHotkeyGenerateDiaryBio = AddKeyMapOption("Generate Diary & Bio", library.hotkeyGenerateDiaryBio)
        optionHotkeyInterruptDialogue = AddKeyMapOption("Interrupt Dialogue", library.hotkeyInterruptDialogue)
    else
        AddTextOption("Enable in-game hotkeys to configure", "")
    endif

endfunction

event OnOptionSelect(int option)

    if option == toggleShowWebUi
        int result = SkyrimNetApi.OpenSkyrimNetUI()
        Debug.Trace("[SkyrimNetInternal] OpenSkyrimNetUI result: " + result)
    elseif option == toggleInGameHotkeys
        ; Toggle in-game hotkeys
        if library.inGameHotkeysEnabled
            library.DisableInGameHotkeys()
            SetToggleOptionValue(toggleInGameHotkeys, false)
        else
            library.EnableInGameHotkeys()
            SetToggleOptionValue(toggleInGameHotkeys, true)
        endif
        ForcePageReset() ; Refresh page to show/hide hotkey options
    endif

endevent

event OnOptionKeyMapChange(int option, int keyCode, string conflictControl, string conflictName)
    
    ; keyCode == 0 means the user wants to clear/unmap the binding
    ; In this case, we set the hotkey to -1 (not bound)
    int finalKeyCode = keyCode
    if keyCode == 0
        finalKeyCode = -1
    endif
    
    ; Handle hotkey mapping changes
    if option == optionHotkeyRecordSpeech
        library.hotkeyRecordSpeech = finalKeyCode
        SetKeyMapOptionValue(option, keyCode)
    elseif option == optionHotkeyTextInput
        library.hotkeyTextInput = finalKeyCode
        SetKeyMapOptionValue(option, keyCode)
    elseif option == optionHotkeyToggleGameMaster
        library.hotkeyToggleGameMaster = finalKeyCode
        SetKeyMapOptionValue(option, keyCode)
    elseif option == optionHotkeyTextThought
        library.hotkeyTextThought = finalKeyCode
        SetKeyMapOptionValue(option, keyCode)
    elseif option == optionHotkeyVoiceThought
        library.hotkeyVoiceThought = finalKeyCode
        SetKeyMapOptionValue(option, keyCode)
    elseif option == optionHotkeyTextDialogueTransform
        library.hotkeyTextDialogueTransform = finalKeyCode
        SetKeyMapOptionValue(option, keyCode)
    elseif option == optionHotkeyVoiceDialogueTransform
        library.hotkeyVoiceDialogueTransform = finalKeyCode
        SetKeyMapOptionValue(option, keyCode)
    elseif option == optionHotkeyToggleContinuousMode
        library.hotkeyToggleContinuousMode = finalKeyCode
        SetKeyMapOptionValue(option, keyCode)
    elseif option == optionHotkeyToggleWorldEventReactions
        library.hotkeyToggleWorldEventReactions = finalKeyCode
        SetKeyMapOptionValue(option, keyCode)
    elseif option == optionHotkeyDirectInput
        library.hotkeyDirectInput = finalKeyCode
        SetKeyMapOptionValue(option, keyCode)
    elseif option == optionHotkeyVoiceDirectInput
        library.hotkeyVoiceDirectInput = finalKeyCode
        SetKeyMapOptionValue(option, keyCode)
    elseif option == optionHotkeyContinueNarration
        library.hotkeyContinueNarration = finalKeyCode
        SetKeyMapOptionValue(option, keyCode)
    elseif option == optionHotkeyToggleWhisperMode
        library.hotkeyToggleWhisperMode = finalKeyCode
        SetKeyMapOptionValue(option, keyCode)
    elseif option == optionHotkeyToggleOpenMic
        library.hotkeyToggleOpenMic = finalKeyCode
        SetKeyMapOptionValue(option, keyCode)
    elseif option == optionHotkeyCaptureCrosshair
        library.hotkeyCaptureCrosshair = finalKeyCode
        SetKeyMapOptionValue(option, keyCode)
    elseif option == optionHotkeyGenerateDiaryBio
        library.hotkeyGenerateDiaryBio = finalKeyCode
        SetKeyMapOptionValue(option, keyCode)
    elseif option == optionHotkeyInterruptDialogue
        library.hotkeyInterruptDialogue = finalKeyCode
        SetKeyMapOptionValue(option, keyCode)
    endif
    
    ; Re-register hotkeys to pick up the change immediately
    if library.inGameHotkeysEnabled
        library.UnregisterAllHotkeys()
        library.RegisterConfiguredHotkeys()
    endif
    
endevent

event OnOptionDefault(int option)
    
    ; Handle default (unset) for all hotkeys
    ; When user right-clicks and selects "Set Default", we unset the key
    if option == optionHotkeyRecordSpeech
        library.hotkeyRecordSpeech = -1
        SetKeyMapOptionValue(option, -1)
    elseif option == optionHotkeyTextInput
        library.hotkeyTextInput = -1
        SetKeyMapOptionValue(option, -1)
    elseif option == optionHotkeyToggleGameMaster
        library.hotkeyToggleGameMaster = -1
        SetKeyMapOptionValue(option, -1)
    elseif option == optionHotkeyTextThought
        library.hotkeyTextThought = -1
        SetKeyMapOptionValue(option, -1)
    elseif option == optionHotkeyVoiceThought
        library.hotkeyVoiceThought = -1
        SetKeyMapOptionValue(option, -1)
    elseif option == optionHotkeyTextDialogueTransform
        library.hotkeyTextDialogueTransform = -1
        SetKeyMapOptionValue(option, -1)
    elseif option == optionHotkeyVoiceDialogueTransform
        library.hotkeyVoiceDialogueTransform = -1
        SetKeyMapOptionValue(option, -1)
    elseif option == optionHotkeyToggleContinuousMode
        library.hotkeyToggleContinuousMode = -1
        SetKeyMapOptionValue(option, -1)
    elseif option == optionHotkeyToggleWorldEventReactions
        library.hotkeyToggleWorldEventReactions = -1
        SetKeyMapOptionValue(option, -1)
    elseif option == optionHotkeyDirectInput
        library.hotkeyDirectInput = -1
        SetKeyMapOptionValue(option, -1)
    elseif option == optionHotkeyVoiceDirectInput
        library.hotkeyVoiceDirectInput = -1
        SetKeyMapOptionValue(option, -1)
    elseif option == optionHotkeyContinueNarration
        library.hotkeyContinueNarration = -1
        SetKeyMapOptionValue(option, -1)
    elseif option == optionHotkeyToggleWhisperMode
        library.hotkeyToggleWhisperMode = -1
        SetKeyMapOptionValue(option, -1)
    elseif option == optionHotkeyToggleOpenMic
        library.hotkeyToggleOpenMic = -1
        SetKeyMapOptionValue(option, -1)
    elseif option == optionHotkeyCaptureCrosshair
        library.hotkeyCaptureCrosshair = -1
        SetKeyMapOptionValue(option, -1)
    elseif option == optionHotkeyGenerateDiaryBio
        library.hotkeyGenerateDiaryBio = -1
        SetKeyMapOptionValue(option, -1)
    elseif option == optionHotkeyInterruptDialogue
        library.hotkeyInterruptDialogue = -1
        SetKeyMapOptionValue(option, -1)
    endif
    
    ; Re-register hotkeys to pick up the change immediately
    if library.inGameHotkeysEnabled
        library.UnregisterAllHotkeys()
        library.RegisterConfiguredHotkeys()
    endif
    
endevent