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
int optionHotkeySilentNarration

int useImage

; ============================================================================
; Developer Page - Category Navigation
; ============================================================================
int devCategoryMenu
int devCurrentCategory = 0
string[] devCategoryNames

; Category indices
int DEV_CAT_LLM = 0
int DEV_CAT_HOTKEYS = 1
int DEV_CAT_DIALOGUE = 2
int DEV_CAT_EVENTS = 3
int DEV_CAT_UTILITIES = 4
int DEV_CAT_SYSTEM = 5

; ============================================================================
; Developer Page - LLM Interaction
; ============================================================================
int optionLlmPromptName
int optionLlmVariant
int optionLlmContextJson
int optionLlmExecute
string devLlmPromptName = "dev/mcm_test"
string devLlmVariant = ""
string devLlmContextJson = "{\"test_variable\":\"Hello from MCM!\"}"

int optionNarrationContent
int optionNarrationExecute
string devNarrationContent = ""

int optionPersistentContent
int optionPersistentExecute
string devPersistentContent = ""

; ============================================================================
; Developer Page - Hotkey Triggers
; ============================================================================
int optionTriggerTextInput
int optionTriggerToggleGameMaster
int optionTriggerToggleContinuousMode
int optionTriggerToggleWorldEvents
int optionTriggerToggleWhisperMode
int optionTriggerToggleOpenMic
int optionTriggerTextThought
int optionTriggerTextDialogueTransform
int optionTriggerDirectInput
int optionTriggerContinueNarration
int optionTriggerPlayerThought
int optionTriggerPlayerDialogue
int optionTriggerGenerateDiaryBio
int optionTriggerInterruptDialogue

; ============================================================================
; Developer Page - Dialogue
; ============================================================================
int optionDialogueContent
int optionDialogueExecute
string devDialogueContent = ""

int optionPurgeDialogue

; ============================================================================
; Developer Page - Events
; ============================================================================
int optionEventType
int optionEventContent
int optionEventExecute
string devEventType = "custom_event"
string devEventContent = ""

int optionShortEventId
int optionShortEventType
int optionShortEventDesc
int optionShortEventTtl
int optionShortEventExecute
string devShortEventId = "test_event_1"
string devShortEventType = "test"
string devShortEventDesc = "Test event description"
int devShortEventTtl = 30000

; ============================================================================
; Developer Page - Utilities
; ============================================================================
int optionTemplateNameInput
int optionTemplateVarName
int optionTemplateVarValue
int optionRenderTemplate
string devTemplateName = "dev/mcm_test"
string devTemplateVarName = ""
string devTemplateVarValue = ""

int optionParseInput
int optionParseVarName
int optionParseVarValue
int optionParseExecute
string devParseInput = "Hello {{ data.name }}, welcome to {{ data.location }}!"
string devParseVarName = "data"
string devParseVarValue = "{\"name\":\"Dragonborn\",\"location\":\"Skyrim\"}"

int optionConfigName
int optionConfigPath
int optionConfigDefault
int optionGetConfigString
string devConfigName = "game"
string devConfigPath = "name"
string devConfigDefault = "Unknown"

; ============================================================================
; Developer Page - System
; ============================================================================
int optionOpenWebUI
int optionGetVersion
int optionGetBuildType
int optionIsRecording
int optionIsVR
int optionSpeechQueueSize
int optionTimeSinceAudio
int optionCppHotkeysToggle
int optionIsContinuousMode

; ============================================================================
; Package Debug Page
; ============================================================================
Actor pkgTargetActor
string pkgTargetDisplay = "(none)"

; Option IDs for Package Debug page
int pkgSelectCrosshair
int pkgRefresh
int pkgGamePackageDisplay
int pkgSkyrimNetDisplay
int pkgHasTalkToPlayer
int pkgHasTalkToNPC
int pkgHasFollowPlayer

int pkgAddMenu
int pkgAddPrioritySlider
int pkgAddViaSkyrimNet
int pkgAddViaDirect

int pkgRemoveMenu
int pkgRemoveViaSkyrimNet
int pkgRemoveViaDirect

int pkgClearAllSkyrimNet
int pkgClearAllGlobal
int pkgReinforce
int pkgCancelPending

; Package menu state
string[] pkgPackageNames
int pkgAddMenuSelection = 0
int pkgRemoveMenuSelection = 0
float pkgAddPriority = 70.0

; ============================================================================
; Last result tracking
; ============================================================================
string devLastResult = ""
int devLastSuccess = -1

event OnConfigOpen()
    
    ; Fetch the library from the quest
    library = ((Game.GetFormFromFile(0x0802, "SkyrimNet.esp") as Quest) as skynet_Library)
    
    Pages = new string[5]

    Pages[0] = "Overview"
    Pages[1] = "SkyrimNet Status"
    Pages[2] = "Hotkeys"
    Pages[3] = "Package Debug"
    Pages[4] = "Developer"

    ; Initialize package names for debug page
    pkgPackageNames = new string[3]
    pkgPackageNames[0] = "TalkToPlayer"
    pkgPackageNames[1] = "TalkToNPC"
    pkgPackageNames[2] = "FollowPlayer"

    ; Initialize developer category names
    devCategoryNames = new string[6]
    devCategoryNames[0] = "LLM Interaction"
    devCategoryNames[1] = "Hotkey Triggers"
    devCategoryNames[2] = "Dialogue"
    devCategoryNames[3] = "Events"
    devCategoryNames[4] = "Utilities"
    devCategoryNames[5] = "System"

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
    elseif page == "Package Debug"
        DisplayPackageDebug()
    elseif page == "Developer"
        DisplayDeveloper()
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
        optionHotkeySilentNarration = AddKeyMapOption("Silent Narration", library.hotkeySilentNarration)
    else
        AddTextOption("Enable in-game hotkeys to configure", "")
    endif

endfunction

; ============================================================================
; Package Debug Page
; ============================================================================
function DisplayPackageDebug()

    AddHeaderOption("Target Selection")
    AddHeaderOption("")

    pkgSelectCrosshair = AddTextOption("Select from Crosshair", "[Select]")
    AddTextOption("Selected:", pkgTargetDisplay)

    AddHeaderOption("Package Status")
    AddHeaderOption("")

    if pkgTargetActor
        string gamePkg = SkyrimNetApi.GetCurrentGamePackageName(pkgTargetActor)
        string skyrimnetPkgs = SkyrimNetApi.GetSkyrimNetPackagesString(pkgTargetActor)
        pkgGamePackageDisplay = AddTextOption("Game Package:", gamePkg)
        pkgSkyrimNetDisplay = AddTextOption("SkyrimNet Tracked:", TruncateDisplay(skyrimnetPkgs, "(none)"))
        pkgHasTalkToPlayer = AddTextOption("Has TalkToPlayer:", BoolToYesNo(SkyrimNetApi.HasPackage(pkgTargetActor, "TalkToPlayer")))
        pkgHasTalkToNPC = AddTextOption("Has TalkToNPC:", BoolToYesNo(SkyrimNetApi.HasPackage(pkgTargetActor, "TalkToNPC")))
        pkgHasFollowPlayer = AddTextOption("Has FollowPlayer:", BoolToYesNo(SkyrimNetApi.HasPackage(pkgTargetActor, "FollowPlayer")))
        pkgRefresh = AddTextOption("Refresh Status", "[Refresh]")
    else
        AddTextOption("Game Package:", "(no target)")
        AddTextOption("SkyrimNet Tracked:", "(no target)")
        AddTextOption("Select a target actor first", "")
        AddEmptyOption()
        AddEmptyOption()
        pkgRefresh = -1
    endif

    AddHeaderOption("Add Package")
    AddHeaderOption("")

    pkgAddMenu = AddMenuOption("Package:", pkgPackageNames[pkgAddMenuSelection])
    pkgAddPrioritySlider = AddSliderOption("Priority:", pkgAddPriority, "{0}")
    pkgAddViaSkyrimNet = AddTextOption("Add via SkyrimNet", "[Add]")
    pkgAddViaDirect = AddTextOption("Add via PapyrusUtil Direct", "[Add]")

    AddHeaderOption("Remove Package")
    AddHeaderOption("")

    pkgRemoveMenu = AddMenuOption("Package:", pkgPackageNames[pkgRemoveMenuSelection])
    AddEmptyOption()
    pkgRemoveViaSkyrimNet = AddTextOption("Remove via SkyrimNet", "[Remove]")
    pkgRemoveViaDirect = AddTextOption("Remove via PapyrusUtil Direct", "[Remove]")

    AddHeaderOption("Bulk Operations")
    AddHeaderOption("")

    pkgClearAllSkyrimNet = AddTextOption("Clear All (SkyrimNet)", "[Clear]")
    pkgClearAllGlobal = AddTextOption("Clear All (Global)", "[Clear]")
    pkgReinforce = AddTextOption("Reinforce Packages", "[Reinforce]")
    pkgCancelPending = AddTextOption("Cancel Pending Tasks", "[Cancel]")

endfunction

string function BoolToYesNo(int value)
    if value
        return "Yes"
    endif
    return "No"
endfunction

function HandlePackageDebugSelect(int option)

    if option == pkgSelectCrosshair
        Actor crosshairRef = Game.GetCurrentCrosshairRef() as Actor
        if crosshairRef
            pkgTargetActor = crosshairRef
            pkgTargetDisplay = pkgTargetActor.GetDisplayName()
            ForcePageReset()
        else
            Debug.MessageBox("No actor under crosshair")
        endif

    elseif option == pkgRefresh
        ForcePageReset()

    elseif option == pkgAddViaSkyrimNet
        if !pkgTargetActor
            Debug.MessageBox("No target actor selected")
            return
        endif
        string pkgName = pkgPackageNames[pkgAddMenuSelection]
        int result = SkyrimNetApi.RegisterPackage(pkgTargetActor, pkgName, pkgAddPriority as int, 0, false)
        ShowResultInt("RegisterPackage(" + pkgName + ")", result)
        ForcePageReset()

    elseif option == pkgAddViaDirect
        if !pkgTargetActor
            Debug.MessageBox("No target actor selected")
            return
        endif
        string pkgName = pkgPackageNames[pkgAddMenuSelection]
        int result = SkyrimNetApi.AddDirectPackageOverride(pkgTargetActor, pkgName, pkgAddPriority as int, 0)
        ShowResultInt("AddDirectPackageOverride(" + pkgName + ")", result)
        ForcePageReset()

    elseif option == pkgRemoveViaSkyrimNet
        if !pkgTargetActor
            Debug.MessageBox("No target actor selected")
            return
        endif
        string pkgName = pkgPackageNames[pkgRemoveMenuSelection]
        int result = SkyrimNetApi.UnregisterPackage(pkgTargetActor, pkgName)
        ShowResultInt("UnregisterPackage(" + pkgName + ")", result)
        ForcePageReset()

    elseif option == pkgRemoveViaDirect
        if !pkgTargetActor
            Debug.MessageBox("No target actor selected")
            return
        endif
        string pkgName = pkgPackageNames[pkgRemoveMenuSelection]
        int result = SkyrimNetApi.RemoveDirectPackageOverride(pkgTargetActor, pkgName)
        ShowResultInt("RemoveDirectPackageOverride(" + pkgName + ")", result)
        ForcePageReset()

    elseif option == pkgClearAllSkyrimNet
        if !pkgTargetActor
            Debug.MessageBox("No target actor selected")
            return
        endif
        int result = SkyrimNetApi.ClearAllPackages(pkgTargetActor)
        ShowResultInt("ClearAllPackages", result)
        ForcePageReset()

    elseif option == pkgClearAllGlobal
        int result = SkyrimNetApi.ClearAllPackagesGlobally()
        ShowResultInt("ClearAllPackagesGlobally", result)
        ForcePageReset()

    elseif option == pkgReinforce
        if !pkgTargetActor
            Debug.MessageBox("No target actor selected")
            return
        endif
        int result = SkyrimNetApi.ReinforcePackages(pkgTargetActor)
        ShowResultInt("ReinforcePackages", result)
        ForcePageReset()

    elseif option == pkgCancelPending
        if !pkgTargetActor
            Debug.MessageBox("No target actor selected")
            return
        endif
        int result = SkyrimNetApi.CancelPendingPackageTasks(pkgTargetActor)
        ShowResultInt("CancelPendingPackageTasks", result)
        ForcePageReset()
    endif

endfunction

; ============================================================================
; Developer Page - Main Display with Category Navigation
; ============================================================================
function DisplayDeveloper()
    
    ; Reset all developer option IDs to prevent cross-category conflicts
    ResetDevOptionIds()
    
    AddHeaderOption("Developer API Testing")
    AddHeaderOption("")
    
    AddTextOption("Test SkyrimNet's exposed Papyrus API", "")
    AddTextOption("functions directly from this panel.", "")
    
    ; Category selector menu
    devCategoryMenu = AddMenuOption("Category:", devCategoryNames[devCurrentCategory])
    AddEmptyOption()
    
    ; Display the selected category
    if devCurrentCategory == DEV_CAT_LLM
        DisplayDevLLM()
    elseif devCurrentCategory == DEV_CAT_HOTKEYS
        DisplayDevHotkeys()
    elseif devCurrentCategory == DEV_CAT_DIALOGUE
        DisplayDevDialogue()
    elseif devCurrentCategory == DEV_CAT_EVENTS
        DisplayDevEvents()
    elseif devCurrentCategory == DEV_CAT_UTILITIES
        DisplayDevUtilities()
    elseif devCurrentCategory == DEV_CAT_SYSTEM
        DisplayDevSystem()
    endif
    
endfunction

; Reset all developer option IDs to -1 to prevent cross-category ID conflicts
function ResetDevOptionIds()
    ; LLM options
    optionLlmPromptName = -1
    optionLlmVariant = -1
    optionLlmContextJson = -1
    optionLlmExecute = -1
    optionNarrationContent = -1
    optionNarrationExecute = -1
    optionPersistentContent = -1
    optionPersistentExecute = -1
    
    ; Hotkey trigger options
    optionTriggerTextInput = -1
    optionTriggerToggleGameMaster = -1
    optionTriggerToggleContinuousMode = -1
    optionTriggerToggleWorldEvents = -1
    optionTriggerToggleWhisperMode = -1
    optionTriggerToggleOpenMic = -1
    optionTriggerTextThought = -1
    optionTriggerTextDialogueTransform = -1
    optionTriggerDirectInput = -1
    optionTriggerContinueNarration = -1
    optionTriggerPlayerThought = -1
    optionTriggerPlayerDialogue = -1
    optionTriggerGenerateDiaryBio = -1
    optionTriggerInterruptDialogue = -1
    
    ; Dialogue options
    optionDialogueContent = -1
    optionDialogueExecute = -1
    optionPurgeDialogue = -1
    
    ; Events options
    optionEventType = -1
    optionEventContent = -1
    optionEventExecute = -1
    optionShortEventId = -1
    optionShortEventType = -1
    optionShortEventDesc = -1
    optionShortEventTtl = -1
    optionShortEventExecute = -1
    
    ; Utilities options
    optionTemplateNameInput = -1
    optionTemplateVarName = -1
    optionTemplateVarValue = -1
    optionRenderTemplate = -1
    optionParseInput = -1
    optionParseVarName = -1
    optionParseVarValue = -1
    optionParseExecute = -1
    optionConfigName = -1
    optionConfigPath = -1
    optionConfigDefault = -1
    optionGetConfigString = -1
    
    ; System options
    optionOpenWebUI = -1
    optionGetVersion = -1
    optionGetBuildType = -1
    optionIsRecording = -1
    optionIsVR = -1
    optionSpeechQueueSize = -1
    optionTimeSinceAudio = -1
    optionCppHotkeysToggle = -1
    optionIsContinuousMode = -1
endfunction

; ============================================================================
; Developer Category: LLM Interaction
; ============================================================================
function DisplayDevLLM()
    
    AddHeaderOption("SendCustomPromptToLLM")
    AddHeaderOption("")
    
    optionLlmPromptName = AddInputOption("Prompt Name:", devLlmPromptName)
    optionLlmVariant = AddInputOption("Variant:", TruncateDisplay(devLlmVariant, "(default)"))
    optionLlmContextJson = AddInputOption("Context JSON:", TruncateDisplay(devLlmContextJson, "(none)"))
    optionLlmExecute = AddTextOption("Execute", "[Send to LLM]")
    
    AddEmptyOption()
    AddEmptyOption()
    
    AddHeaderOption("DirectNarration")
    AddHeaderOption("")
    
    optionNarrationContent = AddInputOption("Narration:", TruncateDisplay(devNarrationContent, "(enter text)"))
    optionNarrationExecute = AddTextOption("Execute", "[Narrate]")
    
    AddEmptyOption()
    AddEmptyOption()
    
    AddHeaderOption("RegisterPersistentEvent")
    AddHeaderOption("")
    
    optionPersistentContent = AddInputOption("Event Content:", TruncateDisplay(devPersistentContent, "(enter text)"))
    optionPersistentExecute = AddTextOption("Execute", "[Register]")
    
endfunction

; ============================================================================
; Developer Category: Hotkey Triggers
; ============================================================================
function DisplayDevHotkeys()
    
    AddTextOption("Note: Text input triggers won't show", "")
    AddTextOption("dialogs while in this menu.", "")
    
    AddHeaderOption("Input Triggers")
    AddHeaderOption("")
    
    optionTriggerTextInput = AddTextOption("TriggerTextInput", "[Execute]")
    optionTriggerTextThought = AddTextOption("TriggerTextThought", "[Execute]")
    optionTriggerTextDialogueTransform = AddTextOption("TriggerTextDialogueTransform", "[Execute]")
    optionTriggerDirectInput = AddTextOption("TriggerDirectInput", "[Execute]")
    
    AddHeaderOption("Toggle Triggers")
    AddHeaderOption("")
    
    optionTriggerToggleGameMaster = AddTextOption("TriggerToggleGameMaster", "[Execute]")
    optionTriggerToggleContinuousMode = AddTextOption("TriggerToggleContinuousMode", "[Execute]")
    optionTriggerToggleWorldEvents = AddTextOption("TriggerToggleWorldEventReactions", "[Execute]")
    optionTriggerToggleWhisperMode = AddTextOption("TriggerToggleWhisperMode", "[Execute]")
    optionTriggerToggleOpenMic = AddTextOption("TriggerToggleOpenMic", "[Execute]")
    
    AddHeaderOption("Action Triggers")
    AddHeaderOption("")
    
    optionTriggerContinueNarration = AddTextOption("TriggerContinueNarration", "[Execute]")
    optionTriggerPlayerThought = AddTextOption("TriggerPlayerThought", "[Execute]")
    optionTriggerPlayerDialogue = AddTextOption("TriggerPlayerDialogue", "[Execute]")
    optionTriggerGenerateDiaryBio = AddTextOption("TriggerGenerateDiaryBio", "[Execute]")
    optionTriggerInterruptDialogue = AddTextOption("TriggerInterruptDialogue", "[Execute]")
    
endfunction

; ============================================================================
; Developer Category: Dialogue
; ============================================================================
function DisplayDevDialogue()
    
    AddHeaderOption("RegisterDialogue")
    AddHeaderOption("")
    
    AddTextOption("Speaker: Player", "")
    optionDialogueContent = AddInputOption("Dialogue:", TruncateDisplay(devDialogueContent, "(enter text)"))
    optionDialogueExecute = AddTextOption("Execute", "[Register]")
    
    AddEmptyOption()
    AddEmptyOption()
    
    AddHeaderOption("PurgeDialogue")
    AddHeaderOption("")
    
    AddTextOption("Immediately stop all NPC dialogue", "")
    optionPurgeDialogue = AddTextOption("Execute", "[Purge]")
    
endfunction

; ============================================================================
; Developer Category: Events
; ============================================================================
function DisplayDevEvents()
    
    AddHeaderOption("RegisterEvent")
    AddHeaderOption("")
    
    optionEventType = AddInputOption("Event Type:", devEventType)
    optionEventContent = AddInputOption("Content:", TruncateDisplay(devEventContent, "(enter text)"))
    optionEventExecute = AddTextOption("Execute", "[Register]")
    
    AddEmptyOption()
    AddEmptyOption()
    
    AddHeaderOption("RegisterShortLivedEvent")
    AddHeaderOption("")
    
    optionShortEventId = AddInputOption("Event ID:", devShortEventId)
    optionShortEventType = AddInputOption("Event Type:", devShortEventType)
    optionShortEventDesc = AddInputOption("Description:", TruncateDisplay(devShortEventDesc, "(enter)"))
    optionShortEventTtl = AddSliderOption("TTL (ms):", devShortEventTtl as float, "{0}")
    optionShortEventExecute = AddTextOption("Execute", "[Register]")
    
endfunction

; ============================================================================
; Developer Category: Utilities
; ============================================================================
function DisplayDevUtilities()
    
    AddHeaderOption("RenderTemplate")
    AddHeaderOption("")
    
    optionTemplateNameInput = AddInputOption("Template:", devTemplateName)
    optionTemplateVarName = AddInputOption("Var Name:", TruncateDisplay(devTemplateVarName, "(optional)"))
    optionTemplateVarValue = AddInputOption("Var Value:", TruncateDisplay(devTemplateVarValue, "(optional)"))
    optionRenderTemplate = AddTextOption("Execute", "[Render]")
    
    AddEmptyOption()
    AddEmptyOption()
    
    AddHeaderOption("ParseString")
    AddHeaderOption("")
    
    optionParseInput = AddInputOption("Input String:", TruncateDisplay(devParseInput, "(enter)"))
    optionParseVarName = AddInputOption("Var Name:", devParseVarName)
    optionParseVarValue = AddInputOption("Var Value (JSON):", TruncateDisplay(devParseVarValue, "(enter)"))
    optionParseExecute = AddTextOption("Execute", "[Parse]")
    
    AddEmptyOption()
    AddEmptyOption()
    
    AddHeaderOption("GetConfigString")
    AddHeaderOption("")
    
    optionConfigName = AddInputOption("Config Name:", devConfigName)
    optionConfigPath = AddInputOption("Path:", devConfigPath)
    optionConfigDefault = AddInputOption("Default:", TruncateDisplay(devConfigDefault, "(empty)"))
    optionGetConfigString = AddTextOption("Execute", "[Get]")
    
endfunction

; ============================================================================
; Developer Category: System
; ============================================================================
function DisplayDevSystem()
    
    AddHeaderOption("Web Interface")
    AddHeaderOption("")
    
    optionOpenWebUI = AddTextOption("OpenSkyrimNetUI", "[Open]")
    AddEmptyOption()
    
    AddHeaderOption("Build Info")
    AddHeaderOption("")
    
    optionGetVersion = AddTextOption("GetBuildVersion", "[Get]")
    optionGetBuildType = AddTextOption("GetBuildType", "[Get]")
    
    AddHeaderOption("Status Queries")
    AddHeaderOption("")
    
    optionIsRecording = AddTextOption("IsRecordingInput", "[Check]")
    optionIsVR = AddTextOption("IsRunningVR", "[Check]")
    optionSpeechQueueSize = AddTextOption("GetSpeechQueueSize", "[Get]")
    optionTimeSinceAudio = AddTextOption("GetTimeSinceLastAudioEnded", "[Get]")
    
    AddHeaderOption("C++ Hotkey Control")
    AddHeaderOption("")
    
    bool cppEnabled = SkyrimNetApi.IsCppHotkeysEnabled()
    optionCppHotkeysToggle = AddToggleOption("C++ Hotkeys Enabled", cppEnabled)
    
    AddHeaderOption("GameMaster State")
    AddHeaderOption("")
    
    optionIsContinuousMode = AddTextOption("IsContinuousModeEnabled", "[Check]")
    
endfunction

; ============================================================================
; Helper Functions
; ============================================================================
string function TruncateDisplay(string value, string defaultText)
    if value == ""
        return defaultText
    endif
    if StringUtil.GetLength(value) > 20
        return StringUtil.Substring(value, 0, 17) + "..."
    endif
    return value
endfunction

function ShowResult(string title, string result)
    Debug.Trace("[SkyrimNet MCM] " + title + ": " + result)
    Debug.MessageBox(title + "\n\n" + result)
endfunction

function ShowResultInt(string title, int result)
    ShowResult(title, result as string)
endfunction

; ============================================================================
; Event Handlers
; ============================================================================
event OnOptionSelect(int option)

    ; === Overview Page ===
    if option == toggleShowWebUi
        int result = SkyrimNetApi.OpenSkyrimNetUI()
        Debug.Trace("[SkyrimNetInternal] OpenSkyrimNetUI result: " + result)
        
    ; === Hotkeys Page ===
    elseif option == toggleInGameHotkeys
        if library.inGameHotkeysEnabled
            library.DisableInGameHotkeys()
            SetToggleOptionValue(toggleInGameHotkeys, false)
        else
            library.EnableInGameHotkeys()
            SetToggleOptionValue(toggleInGameHotkeys, true)
        endif
        ForcePageReset()
        
    ; === Package Debug Page ===
    elseif CurrentPage == "Package Debug"
        HandlePackageDebugSelect(option)

    ; === Developer Page Options ===
    ; Check CurrentPage to ensure we're on the Developer page before handling developer options
    ; This prevents cross-category conflicts when option IDs overlap
    elseif CurrentPage == "Developer"
        HandleDeveloperOptionSelect(option)
    endif

endevent

; Handle Developer page option selections
; Separated to use CurrentPage check as guard against cross-category ID conflicts
function HandleDeveloperOptionSelect(int option)
    
    ; === LLM Category ===
    if devCurrentCategory == DEV_CAT_LLM
        if option == optionLlmExecute
            ExecuteLlmPrompt()
        elseif option == optionNarrationExecute
            int result = SkyrimNetApi.DirectNarration(devNarrationContent)
            ShowResultInt("DirectNarration", result)
        elseif option == optionPersistentExecute
            int result = SkyrimNetApi.RegisterPersistentEvent(devPersistentContent)
            ShowResultInt("RegisterPersistentEvent", result)
        endif
        
    ; === Hotkey Triggers Category ===
    elseif devCurrentCategory == DEV_CAT_HOTKEYS
        if option == optionTriggerTextInput
            ShowResultInt("TriggerTextInput", SkyrimNetApi.TriggerTextInput())
        elseif option == optionTriggerTextThought
            ShowResultInt("TriggerTextThought", SkyrimNetApi.TriggerTextThought())
        elseif option == optionTriggerTextDialogueTransform
            ShowResultInt("TriggerTextDialogueTransform", SkyrimNetApi.TriggerTextDialogueTransform())
        elseif option == optionTriggerDirectInput
            ShowResultInt("TriggerDirectInput", SkyrimNetApi.TriggerDirectInput())
        elseif option == optionTriggerToggleGameMaster
            ShowResultInt("TriggerToggleGameMaster", SkyrimNetApi.TriggerToggleGameMaster())
        elseif option == optionTriggerToggleContinuousMode
            ShowResultInt("TriggerToggleContinuousMode", SkyrimNetApi.TriggerToggleContinuousMode())
        elseif option == optionTriggerToggleWorldEvents
            ShowResultInt("TriggerToggleWorldEventReactions", SkyrimNetApi.TriggerToggleWorldEventReactions())
        elseif option == optionTriggerToggleWhisperMode
            ShowResultInt("TriggerToggleWhisperMode", SkyrimNetApi.TriggerToggleWhisperMode())
        elseif option == optionTriggerToggleOpenMic
            ShowResultInt("TriggerToggleOpenMic", SkyrimNetApi.TriggerToggleOpenMic())
        elseif option == optionTriggerContinueNarration
            ShowResultInt("TriggerContinueNarration", SkyrimNetApi.TriggerContinueNarration())
        elseif option == optionTriggerPlayerThought
            ShowResultInt("TriggerPlayerThought", SkyrimNetApi.TriggerPlayerThought())
        elseif option == optionTriggerPlayerDialogue
            ShowResultInt("TriggerPlayerDialogue", SkyrimNetApi.TriggerPlayerDialogue())
        elseif option == optionTriggerGenerateDiaryBio
            ShowResultInt("TriggerGenerateDiaryBio", SkyrimNetApi.TriggerGenerateDiaryBio())
        elseif option == optionTriggerInterruptDialogue
            ShowResultInt("TriggerInterruptDialogue", SkyrimNetApi.TriggerInterruptDialogue())
        endif
        
    ; === Dialogue Category ===
    elseif devCurrentCategory == DEV_CAT_DIALOGUE
        if option == optionDialogueExecute
            int result = SkyrimNetApi.RegisterDialogue(Game.GetPlayer(), devDialogueContent)
            ShowResultInt("RegisterDialogue", result)
        elseif option == optionPurgeDialogue
            int result = SkyrimNetApi.PurgeDialogue()
            ShowResultInt("PurgeDialogue", result)
        endif
        
    ; === Events Category ===
    elseif devCurrentCategory == DEV_CAT_EVENTS
        if option == optionEventExecute
            int result = SkyrimNetApi.RegisterEvent(devEventType, devEventContent, Game.GetPlayer(), None)
            ShowResultInt("RegisterEvent", result)
        elseif option == optionShortEventExecute
            int result = SkyrimNetApi.RegisterShortLivedEvent(devShortEventId, devShortEventType, devShortEventDesc, "", devShortEventTtl, Game.GetPlayer(), None)
            ShowResultInt("RegisterShortLivedEvent", result)
        endif
        
    ; === Utilities Category ===
    elseif devCurrentCategory == DEV_CAT_UTILITIES
        if option == optionRenderTemplate
            string result = SkyrimNetApi.RenderTemplate(devTemplateName, devTemplateVarName, devTemplateVarValue)
            ShowResult("RenderTemplate", result)
        elseif option == optionParseExecute
            string result = SkyrimNetApi.ParseString(devParseInput, devParseVarName, devParseVarValue)
            ShowResult("ParseString", result)
        elseif option == optionGetConfigString
            string result = SkyrimNetApi.GetConfigString(devConfigName, devConfigPath, devConfigDefault)
            ShowResult("GetConfigString", result)
        endif
        
    ; === System Category ===
    elseif devCurrentCategory == DEV_CAT_SYSTEM
        if option == optionOpenWebUI
            ShowResultInt("OpenSkyrimNetUI", SkyrimNetApi.OpenSkyrimNetUI())
        elseif option == optionGetVersion
            ShowResult("GetBuildVersion", SkyrimNetApi.GetBuildVersion())
        elseif option == optionGetBuildType
            ShowResult("GetBuildType", SkyrimNetApi.GetBuildType())
        elseif option == optionIsRecording
            ShowResult("IsRecordingInput", SkyrimNetApi.IsRecordingInput() as string)
        elseif option == optionIsVR
            ShowResult("IsRunningVR", SkyrimNetApi.IsRunningVR() as string)
        elseif option == optionSpeechQueueSize
            ShowResultInt("GetSpeechQueueSize", SkyrimNetApi.GetSpeechQueueSize())
        elseif option == optionTimeSinceAudio
            ShowResultInt("GetTimeSinceLastAudioEnded", SkyrimNetApi.GetTimeSinceLastAudioEnded())
        elseif option == optionCppHotkeysToggle
            bool currentState = SkyrimNetApi.IsCppHotkeysEnabled()
            SkyrimNetApi.SetCppHotkeysEnabled(!currentState)
            SetToggleOptionValue(optionCppHotkeysToggle, !currentState)
        elseif option == optionIsContinuousMode
            ShowResult("IsContinuousModeEnabled", SkyrimNetApi.IsContinuousModeEnabled() as string)
        endif
    endif
    
endfunction

event OnOptionMenuOpen(int option)
    if option == devCategoryMenu
        SetMenuDialogOptions(devCategoryNames)
        SetMenuDialogStartIndex(devCurrentCategory)
        SetMenuDialogDefaultIndex(0)
    elseif CurrentPage == "Package Debug"
        if option == pkgAddMenu
            SetMenuDialogOptions(pkgPackageNames)
            SetMenuDialogStartIndex(pkgAddMenuSelection)
            SetMenuDialogDefaultIndex(0)
        elseif option == pkgRemoveMenu
            SetMenuDialogOptions(pkgPackageNames)
            SetMenuDialogStartIndex(pkgRemoveMenuSelection)
            SetMenuDialogDefaultIndex(0)
        endif
    endif
endevent

event OnOptionMenuAccept(int option, int index)
    if option == devCategoryMenu
        devCurrentCategory = index
        SetMenuOptionValue(devCategoryMenu, devCategoryNames[devCurrentCategory])
        ForcePageReset()
    elseif CurrentPage == "Package Debug"
        if option == pkgAddMenu
            pkgAddMenuSelection = index
            SetMenuOptionValue(pkgAddMenu, pkgPackageNames[pkgAddMenuSelection])
        elseif option == pkgRemoveMenu
            pkgRemoveMenuSelection = index
            SetMenuOptionValue(pkgRemoveMenu, pkgPackageNames[pkgRemoveMenuSelection])
        endif
    endif
endevent

event OnOptionInputOpen(int option)
    ; Only handle inputs on Developer page
    if CurrentPage != "Developer"
        return
    endif

    ; LLM Category
    if devCurrentCategory == DEV_CAT_LLM
        if option == optionLlmPromptName
            SetInputDialogStartText(devLlmPromptName)
        elseif option == optionLlmVariant
            SetInputDialogStartText(devLlmVariant)
        elseif option == optionLlmContextJson
            SetInputDialogStartText(devLlmContextJson)
        elseif option == optionNarrationContent
            SetInputDialogStartText(devNarrationContent)
        elseif option == optionPersistentContent
            SetInputDialogStartText(devPersistentContent)
        endif
    ; Dialogue Category
    elseif devCurrentCategory == DEV_CAT_DIALOGUE
        if option == optionDialogueContent
            SetInputDialogStartText(devDialogueContent)
        endif
    ; Events Category
    elseif devCurrentCategory == DEV_CAT_EVENTS
        if option == optionEventType
            SetInputDialogStartText(devEventType)
        elseif option == optionEventContent
            SetInputDialogStartText(devEventContent)
        elseif option == optionShortEventId
            SetInputDialogStartText(devShortEventId)
        elseif option == optionShortEventType
            SetInputDialogStartText(devShortEventType)
        elseif option == optionShortEventDesc
            SetInputDialogStartText(devShortEventDesc)
        endif
    ; Utilities Category
    elseif devCurrentCategory == DEV_CAT_UTILITIES
        if option == optionTemplateNameInput
            SetInputDialogStartText(devTemplateName)
        elseif option == optionTemplateVarName
            SetInputDialogStartText(devTemplateVarName)
        elseif option == optionTemplateVarValue
            SetInputDialogStartText(devTemplateVarValue)
        elseif option == optionParseInput
            SetInputDialogStartText(devParseInput)
        elseif option == optionParseVarName
            SetInputDialogStartText(devParseVarName)
        elseif option == optionParseVarValue
            SetInputDialogStartText(devParseVarValue)
        elseif option == optionConfigName
            SetInputDialogStartText(devConfigName)
        elseif option == optionConfigPath
            SetInputDialogStartText(devConfigPath)
        elseif option == optionConfigDefault
            SetInputDialogStartText(devConfigDefault)
        endif
    endif
endevent

event OnOptionInputAccept(int option, string value)
    ; Only handle inputs on Developer page
    if CurrentPage != "Developer"
        return
    endif

    ; LLM Category
    if devCurrentCategory == DEV_CAT_LLM
        if option == optionLlmPromptName
            devLlmPromptName = value
            SetInputOptionValue(optionLlmPromptName, value)
        elseif option == optionLlmVariant
            devLlmVariant = value
            SetInputOptionValue(optionLlmVariant, TruncateDisplay(value, "(default)"))
        elseif option == optionLlmContextJson
            devLlmContextJson = value
            SetInputOptionValue(optionLlmContextJson, TruncateDisplay(value, "(none)"))
        elseif option == optionNarrationContent
            devNarrationContent = value
            SetInputOptionValue(optionNarrationContent, TruncateDisplay(value, "(enter text)"))
        elseif option == optionPersistentContent
            devPersistentContent = value
            SetInputOptionValue(optionPersistentContent, TruncateDisplay(value, "(enter text)"))
        endif
    ; Dialogue Category
    elseif devCurrentCategory == DEV_CAT_DIALOGUE
        if option == optionDialogueContent
            devDialogueContent = value
            SetInputOptionValue(optionDialogueContent, TruncateDisplay(value, "(enter text)"))
        endif
    ; Events Category
    elseif devCurrentCategory == DEV_CAT_EVENTS
        if option == optionEventType
            devEventType = value
            SetInputOptionValue(optionEventType, value)
        elseif option == optionEventContent
            devEventContent = value
            SetInputOptionValue(optionEventContent, TruncateDisplay(value, "(enter text)"))
        elseif option == optionShortEventId
            devShortEventId = value
            SetInputOptionValue(optionShortEventId, value)
        elseif option == optionShortEventType
            devShortEventType = value
            SetInputOptionValue(optionShortEventType, value)
        elseif option == optionShortEventDesc
            devShortEventDesc = value
            SetInputOptionValue(optionShortEventDesc, TruncateDisplay(value, "(enter)"))
        endif
    ; Utilities Category
    elseif devCurrentCategory == DEV_CAT_UTILITIES
        if option == optionTemplateNameInput
            devTemplateName = value
            SetInputOptionValue(optionTemplateNameInput, value)
        elseif option == optionTemplateVarName
            devTemplateVarName = value
            SetInputOptionValue(optionTemplateVarName, TruncateDisplay(value, "(optional)"))
        elseif option == optionTemplateVarValue
            devTemplateVarValue = value
            SetInputOptionValue(optionTemplateVarValue, TruncateDisplay(value, "(optional)"))
        elseif option == optionParseInput
            devParseInput = value
            SetInputOptionValue(optionParseInput, TruncateDisplay(value, "(enter)"))
        elseif option == optionParseVarName
            devParseVarName = value
            SetInputOptionValue(optionParseVarName, value)
        elseif option == optionParseVarValue
            devParseVarValue = value
            SetInputOptionValue(optionParseVarValue, TruncateDisplay(value, "(enter)"))
        elseif option == optionConfigName
            devConfigName = value
            SetInputOptionValue(optionConfigName, value)
        elseif option == optionConfigPath
            devConfigPath = value
            SetInputOptionValue(optionConfigPath, value)
        elseif option == optionConfigDefault
            devConfigDefault = value
            SetInputOptionValue(optionConfigDefault, TruncateDisplay(value, "(empty)"))
        endif
    endif
endevent

event OnOptionSliderOpen(int option)
    ; Package Debug page
    if CurrentPage == "Package Debug"
        if option == pkgAddPrioritySlider
            SetSliderDialogStartValue(pkgAddPriority)
            SetSliderDialogDefaultValue(70.0)
            SetSliderDialogRange(0.0, 100.0)
            SetSliderDialogInterval(1.0)
        endif
        return
    endif

    ; Only handle sliders on Developer page, Events category
    if CurrentPage != "Developer" || devCurrentCategory != DEV_CAT_EVENTS
        return
    endif

    if option == optionShortEventTtl
        SetSliderDialogStartValue(devShortEventTtl as float)
        SetSliderDialogDefaultValue(30000.0)
        SetSliderDialogRange(1000.0, 300000.0)
        SetSliderDialogInterval(1000.0)
    endif
endevent

event OnOptionSliderAccept(int option, float value)
    ; Package Debug page
    if CurrentPage == "Package Debug"
        if option == pkgAddPrioritySlider
            pkgAddPriority = value
            SetSliderOptionValue(pkgAddPrioritySlider, value, "{0}")
        endif
        return
    endif

    ; Only handle sliders on Developer page, Events category
    if CurrentPage != "Developer" || devCurrentCategory != DEV_CAT_EVENTS
        return
    endif

    if option == optionShortEventTtl
        devShortEventTtl = value as int
        SetSliderOptionValue(optionShortEventTtl, value, "{0}")
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
    elseif option == optionHotkeySilentNarration
        library.hotkeySilentNarration = finalKeyCode
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
    elseif option == optionHotkeySilentNarration
        library.hotkeySilentNarration = -1
        SetKeyMapOptionValue(option, -1)
    endif

    ; Re-register hotkeys to pick up the change immediately
    if library.inGameHotkeysEnabled
        library.UnregisterAllHotkeys()
        library.RegisterConfiguredHotkeys()
    endif
    
endevent

; ============================================================================
; LLM Prompt Execution
; ============================================================================
function ExecuteLlmPrompt()
    Debug.Trace("[SkyrimNet MCM] Executing SendCustomPromptToLLM...")
    Debug.Trace("[SkyrimNet MCM]   Prompt: " + devLlmPromptName)
    Debug.Trace("[SkyrimNet MCM]   Variant: " + devLlmVariant)
    
    ; If using the default test prompt, add timestamp dynamically
    string contextToSend = devLlmContextJson
    if devLlmPromptName == "dev/mcm_test" && devLlmContextJson == "{\"test_variable\":\"Hello from MCM!\"}"
        contextToSend = "{\"test_variable\":\"Hello from MCM!\",\"timestamp\":\"" + Utility.GetCurrentGameTime() + "\"}"
    endif
    
    Debug.Trace("[SkyrimNet MCM]   Context: " + contextToSend)
    
    int result = SkyrimNetApi.SendCustomPromptToLLM(devLlmPromptName, devLlmVariant, contextToSend, Self as Quest, "skynet_McmScript", "OnLlmResponse")
    
    if result != 1
        ShowResult("SendCustomPromptToLLM", "Failed to queue request (code: " + result + ")")
    else
        Debug.Notification("LLM request queued...")
    endif
endfunction

; Callback for LLM response
Function OnLlmResponse(String response, int success)
    Debug.Trace("[SkyrimNet MCM] OnLlmResponse - Success: " + success)
    Debug.Trace("[SkyrimNet MCM] Response: " + response)
    
    if success == 1
        Debug.MessageBox("LLM Response:\n\n" + response)
    else
        Debug.MessageBox("LLM Request Failed:\n\n" + response)
    endif
EndFunction
