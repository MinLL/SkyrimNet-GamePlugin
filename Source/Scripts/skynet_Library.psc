Scriptname skynet_Library extends Quest  

skynet_MainController Property skynet Auto Hidden
skynet_MinAIBridge Property minAIBridge Auto Hidden

; -----------------------------------------------------------------------------
; --- The Library Part of the Library ---
; -----------------------------------------------------------------------------
Faction Property factionMerchants Auto
Faction Property factionInnkeepers Auto
Faction Property factionStewards Auto
Faction Property factionPlayerFollowers Auto

Faction Property factionRentRoom Auto

Quest Property questDialogueGeneric Auto
Quest Property questBountyBandits Auto

GlobalVariable Property globalRentRoomPrice Auto

Keyword Property keywordDialogueTarget Auto
Keyword Property keywordFollowTarget Auto

Package Property packageDialoguePlayer Auto
Package Property packageDialogueNPC Auto
Package Property packageFollowPlayer Auto

Idle Property IdleApplaud2 Auto
Idle Property IdleApplaud3 Auto
Idle Property IdleApplaud4 Auto
Idle Property IdleApplaud5 Auto
Idle Property IdleApplaudSarcastic Auto
Idle Property IdleBook_Reading Auto
Idle Property IdleDrink Auto
Idle Property IdleDrinkPotion Auto
Idle Property IdleEatSoup Auto
Idle Property IdleExamine Auto
Idle Property IdleForceDefaultState Auto
Idle Property IdleLaugh Auto
Idle Property IdleNervous Auto
Idle Property IdleNoteRead Auto
Idle Property IdlePointClose Auto
Idle Property IdlePray Auto
Idle Property IdleSalute Auto
Idle Property IdleSnapToAttention Auto
Idle Property IdleStudy Auto
Idle Property IdleWave Auto
Idle Property IdleWipeBrow Auto

MiscObject Property miscGold Auto

Message Property msgClearHistory Auto
Message Property msgDiaryScope Auto

; -----------------------------------------------------------------------------
; --- Test Data for Template Decorator Testing ---
; -----------------------------------------------------------------------------
Int Property testInt = 42 Auto
Float Property testFloat = 3.14159 Auto
Bool Property testBool = true Auto
String Property testString = "Hello from SkyrimNet!" Auto
Int[] Property testIntArray Auto
String[] Property testStringArray Auto

; -----------------------------------------------------------------------------
; --- Version & Maintenance ---
; -----------------------------------------------------------------------------

Function Maintenance(skynet_MainController _skynet)
    skynet = _skynet
    RegisterActions()
    InitVRIntegrations()
    InitDBVOIntegration()
    InitMinAIBridge()
    ResetHotkeyStates()
    InitializeInGameHotkeys()
    InitTestData()
    skynet.Info("Library initialized")
EndFunction

Function InitTestData()
    ; Initialize test arrays for template decorator testing
    testIntArray = new Int[5]
    testIntArray[0] = 10
    testIntArray[1] = 20
    testIntArray[2] = 30
    testIntArray[3] = 40
    testIntArray[4] = 50
    
    testStringArray = new String[3]
    testStringArray[0] = "First"
    testStringArray[1] = "Second"
    testStringArray[2] = "Third"
EndFunction

Function RegisterActions()
    if !RegisterTags()
        skynet.Fatal("Tags failed to register.")
        return
    endif

    if !RegisterBasicActions()
        skynet.Fatal("Basic actions failed to register.")
        return
    endif

    if !RegisterAnimationActions()
        skynet.Fatal("Animation actions failed to register.")
        return
    endif

    if !RegisterCompanionActions()
        skynet.Fatal("Companion actions failed to register.")
        return
    endif

    if !RegisterTavernActions()
        skynet.Fatal("Tavern actions failed to register.")
        return
    endif

    ; DEBUG ONLY
    ; debug.notification("Actions registered.")
EndFunction

; -----------------------------------------------------------------------------
; --- Skynet Papyrus Actions ---
; -----------------------------------------------------------------------------

Bool Function RegisterBasicActions()
    SkyrimNetApi.RegisterAction("OpenTrade", "Use ONLY if {{ player.name }} asks to trade and you agree to trade. Otherwise, you MUST NOT use this action.", \
                                "SkyrimNetInternal", "OpenTrade_IsEligible", \
                                "SkyrimNetInternal", "OpenTrade_Execute", \
                                "", "PAPYRUS", \
                                1, "")

    SkyrimNetApi.RegisterAction("AccompanyTarget", "Start accompanying {{ player.name }}. Only use this when you are sure that you want to stop what you're doing and follow {{ player.name }} to another location, and {{ player.name }} has specifically requested it.", \
                                "SkyrimNetInternal", "StartFollow_IsEligible", \
                                "SkyrimNetInternal", "StartFollow_Execute", \
                                "", "PAPYRUS", \
                                1, "")

    SkyrimNetApi.RegisterAction("StopAccompanying", "Stop accompanying {{ player.name }}. Use this when you are done accompanying them, or want to go home.", \
                                "SkyrimNetInternal", "StopFollow_IsEligible", \
                                "SkyrimNetInternal", "StopFollow_Execute", \
                                "", "PAPYRUS", \
                                1, "")

    SkyrimNetApi.RegisterAction("WaitHere", "Wait for {{ player.name }} at the current location temporarily. Only use this when {{ player.name }} has specifically requested it.", \
                                "SkyrimNetInternal", "PauseFollow_IsEligible", \
                                "SkyrimNetInternal", "PauseFollow_Execute", \
                                "", "PAPYRUS", \
                                1, "")
    return true
EndFunction

; we reoute stuff here if it has properties we can use so we're not in the global anymore
Bool Function OpenTrade_IsEligible(Actor akActor, string contextJson, string paramsJson)
    if akActor.GetFactionRank(factionMerchants) == -2
        return false
    endif
    return true
EndFunction

Bool Function RegisterTavernActions()
    SkyrimNetApi.RegisterAction("RentRoom", "Rent a room out to {{ player.name }} for an amount of gold, but only if they agreed to the price beforehand", \
                                "SkyrimNetInternal", "RentRoom_IsEligible", \
                                "SkyrimNetInternal", "RentRoom_Execute", \
                                "", "PAPYRUS", \
                                1, "{\"price\": \"Int\"}")

    ; SkyrimNetApi.RegisterAction("GiveBanditBounty", "Hand {{ player.name }} a bounty poster for a bounty on a bandit leader by the local jarl", \
    ;                             "SkyrimNetInternal", "GiveBanditBounty_IsEligible", \
    ;                             "SkyrimNetInternal", "GiveBanditBounty_Execute", \
    ;                             "", "PAPYRUS", \
    ;                             1, "")

    return True
EndFunction

Bool Function RentRoom_IsEligible(Actor akActor)
    if !akActor.IsInFaction(factionRentRoom) || akActor.GetActorValue("Variable09") > 0
        return false
    EndIf

    if !(akActor as RentRoomScript)
        return false
    endif

    return true
EndFunction

Function RentRoom_Execute(Actor akActor, string paramsJson)
    DialogueGenericScript _dqs = (questDialogueGeneric as DialogueGenericScript)

    if (!(akActor as RentRoomScript)) || (!_dqs)
        return
    endif

    Int price = SkyrimNetApi.GetJsonInt(paramsJson, "price", Math.Floor(globalRentRoomPrice.GetValue()))
    if skynet.playerRef.GetItemCount(miscGold) < price
        SkyrimNetApi.DirectNarration("*" + akActor.GetDisplayName() + " complains to " + Game.GetPlayer().GetDisplayName() + " about not having enough gold for the room*", akActor, Game.GetPlayer())
        return
    EndIf

    skynet.playerRef.RemoveItem(miscGold, price)
    (akActor as RentRoomScript).RentRoom(_dqs)
    return
EndFunction

; Bool Function GiveBanditBounty_IsEligible(Actor akActor)
;     if (!akActor.IsInFaction(factionInnkeepers) && !akActor.IsInFaction(factionStewards)) || questBountyBandits.GetStageDone(10)
;         return false
;     EndIf

;     return true
; EndFunction

; Function GiveBanditBounty_Execute(Actor akActor)
;     questBountyBandits.SetStage(10)
;     return
; EndFunction


Bool Function RegisterAnimationActions()
    SkyrimNetApi.RegisterAction("Gesture", "Perform a gesture to emphasize your words.", \
                                "SkyrimNetInternal", "Animation_IsEligible", \
                                "SkyrimNetInternal", "AnimationGeneric", \
                                "", "PAPYRUS", \
                                1, "{ \"anim\": \"applaud|applaud_sarcastic|drink|drink_potion|eat|laugh|nervous|read_note|pray|salute|study|wave|wipe_brow\" }")

    return True
EndFunction

; ag12: I hate this. Why didn't Bethesda give us Lua instead of Papyrus? Fuck you, Todd.
Function PlayGenericAnimation(Actor akActor, String anim)
    Idle _idle
    Debug.Trace("Playing animation: " + anim + " for " + akActor.GetDisplayName())
    If anim == "applaud"
        int rnd = Utility.RandomInt(0,3)
        if rnd == 0
            _idle = IdleApplaud2
        elseif rnd == 1
            _idle = IdleApplaud3
        elseif rnd == 2
            _idle = IdleApplaud4
        elseif rnd == 3
            _idle = IdleApplaud5
        EndIf
    ElseIf anim == "applaud_sarcastic"
        _idle = IdleApplaudSarcastic
    Elseif anim == "read_book"
        _idle = IdleBook_Reading
    Elseif anim == "drink"
        _idle = IdleDrink
    Elseif anim == "drink_potion"
        _idle = IdleDrinkPotion
    Elseif anim == "eat"
        _idle = IdleEatSoup
    Elseif anim == "laugh"
        _idle = IdleLaugh
    Elseif anim == "nervous"
        _idle = IdleNervous
    Elseif anim == "read_note"
        _idle = IdleNoteRead
    Elseif anim == "pray"
        _idle = IdlePray
    Elseif anim == "salute"
        _idle = IdleSalute
    Elseif anim == "study"
        _idle = IdleStudy
    Elseif anim == "wave"
        _idle = IdleWave
    Elseif anim == "wipe_brow"
        _idle = IdleWipeBrow
    endif

    if !_idle
        skynet.Error("Could not parse animation string for generic animation: " + anim)
        Return
    endif

    akActor.PlayIdle(IdleForceDefaultState)
    utility.wait(2)
    ; debug.notification("Playing animation: " + anim + " for " + akActor.GetDisplayName())
    akActor.PlayIdle(_idle)
EndFunction

Bool Function RegisterCompanionActions()
    SkyrimNetApi.RegisterAction("CompanionFollow", "Start following {{ player.name }}.", \
                                "SkyrimNetInternal", "CompanionFollow_IsEligible", \
                                "SkyrimNetInternal", "CompanionFollow", \
                                "", "PAPYRUS", \
                                1, "", "", "follower")

    SkyrimNetApi.RegisterAction("CompanionWait", "Wait at this location", \
                                "SkyrimNetInternal", "CompanionWait_IsEligible", \
                                "SkyrimNetInternal", "CompanionWait", \
                                "", "PAPYRUS", \
                                1, "", "", "follower")

    SkyrimNetApi.RegisterAction("CompanionInventory", "Give {{ player.name }} access to your inventory", \
                                "SkyrimNetInternal", "Companion_IsEligible", \
                                "SkyrimNetInternal", "CompanionInventory", \
                                "", "PAPYRUS", \
                                1, "", "", "follower")

    SkyrimNetApi.RegisterAction("CompanionGiveTask", "Let {{ player.name }} designate a task for you", \
                                "SkyrimNetInternal", "CompanionGiveTask_IsEligible", \
                                "SkyrimNetInternal", "CompanionGiveTask", \
                                "", "PAPYRUS", \
                                1, "", "", "follower")

    return true
EndFunction

Bool Function StartFollow_IsEligible(Actor akActor)
    if SkyrimNetApi.HasPackage(akActor, "FollowPlayer") && akActor.GetAV("WaitingForPlayer") == 0
        return false
    endif

    Faction factionCompanion = Game.GetFormFromFile(0x084D1B, "Skyrim.esm") as Faction
    if (!factionCompanion)
        Debug.Trace("[SkyrimNetInternal] StartFollow_IsEligible: factionCompanion is null")
        return true
    endif

    if akActor.IsInFaction(factionCompanion)
        Debug.Trace("[SkyrimNetInternal] StartFollow_IsEligible: " + akActor.GetDisplayName() + " is in the companion faction.")
        return false
    endif
    return true

EndFunction

Bool Function StopFollow_IsEligible(Actor akActor)
    if akActor.IsInFaction(factionPlayerFollowers)
        return false
    endif

    if !SkyrimNetApi.HasPackage(akActor, "FollowPlayer")
        return false
    endif

    return true
EndFunction

Bool Function PauseFollow_IsEligible(Actor akActor)
    if akActor.IsInFaction(factionPlayerFollowers)
        return false
    endif

    if !SkyrimNetApi.HasPackage(akActor, "FollowPlayer")
        return false
    endif

    if akActor.GetAV("WaitingForPlayer") > 0
        return false
    endif

    return true
EndFunction

Function StartFollow_Execute(Actor akActor)
    debug.notification(akActor.GetDisplayName() + " is now accompanying you.")

    akActor.SetAV("WaitingForPlayer", 0)

    SkyrimNetApi.RegisterPackage(akActor, "FollowPlayer", 10, 0, true)

    akActor.EvaluatePackage()
EndFunction

Function StopFollow_Execute(Actor akActor)    
    debug.notification(akActor.GetDisplayName() + " is no longer accompanying you.")

    SkyrimNetApi.UnregisterPackage(akActor, "FollowPlayer")

    akActor.EvaluatePackage()
EndFunction

Function PauseFollow_Execute(Actor akActor)
    debug.notification(akActor.GetDisplayName() + " is waiting for you here.")

    akActor.SetAV("WaitingForPlayer", 1)

    akActor.EvaluatePackage()
EndFunction

; -----------------------------------------------------------------------------
; --- Cast Spell Action Functions ---
; -----------------------------------------------------------------------------

Function CastSpell_Execute(Actor akSource, Actor akTarget, String sFormID)
    ; Support both hex (0x0004D3F2) and decimal (316402) format
    Int iFormID = PO3_SKSEFunctions.StringToInt(sFormID)

    If (iFormID == -1)
        Debug.Trace("CastSpell_Execute: Invalid form ID string provided: " + sFormID)
        Return
    EndIf

    Form foundForm = Game.GetForm(iFormID)

    If (foundForm == None)
        Debug.Trace("CastSpell_Execute: GetForm failed for ID " + sFormID + ". Attempting GetFormEx...")

        foundForm = Game.GetFormEx(iFormID)

        If (foundForm == None)
            Debug.Trace("CastSpell_Execute: GetFormEx also failed. Form ID " + sFormID + " is invalid.")
            Return
        EndIf
    EndIf

    Spell spellToCast = foundForm as Spell

    If (spellToCast == None)
        Debug.Trace("CastSpell_Execute: Form ID " + sFormID + " exists but is NOT a Spell.")
        Return
    EndIf

    If (akSource == None || akTarget == None)
        Debug.Trace("CastSpell_Execute: Invalid Actor passed. Source: " + akSource + ", Target: " + akTarget)
        Return
    EndIf

    Debug.Trace("CastSpell_Execute: Casting " + spellToCast + " from " + akSource + " to " + akTarget + ".")
    spellToCast.Cast(akSource, akTarget)
EndFunction

; -----------------------------------------------------------------------------
; --- Skynet Tag Registration ---
; -----------------------------------------------------------------------------

Bool Function RegisterTags()
    SkyrimNetApi.RegisterTag("follower", "SkyrimNetInternal", "Follower_IsEligible")
    return true
EndFunction


; -----------------------------------------------------------------------------
; ---- VRIK Integration ----
; -----------------------------------------------------------------------------
  
Function InitVRIntegrations()
    if !SkyrimNetApi.IsRunningVR()
        skynet.Info("Not running VR, disabling VR Integrations")
        return
    endif
    if Game.GetModByName("vrik.esp") == 255
        skynet.Info("VRIK not installed, disabling VRIK Integrations")
        return
    endif
    skynet.Info("Using VRIK Integrations")

  
    RegisterForModEvent("skynet_vrik_continue_narration", "OnVrikContinueNarration")
    VRIK.VrikAddGestureAction("skynet_vrik_continue_narration", "SkyrimNet: Continue Narration")
  
    RegisterForModEvent("skynet_vrik_toggle_gamemaster", "OnVrikToggleGameMaster")
    VRIK.VrikAddGestureAction("skynet_vrik_toggle_gamemaster", "SkyrimNet: Toggle GameMaster")
  
    RegisterForModEvent("skynet_vrik_trigger_voice_input", "OnVrikTriggerVoiceInput")
    VRIK.VrikAddGestureAction("skynet_vrik_trigger_voice_input", "SkyrimNet: Start Voice Input")

    RegisterForModEvent("skynet_vrik_toggle_open_mic", "OnVrikToggleOpenMic")
    VRIK.VrikAddGestureAction("skynet_vrik_toggle_open_mic", "SkyrimNet: Toggle Open Mic")
  
    RegisterForModEvent("skynet_vrik_trigger_voice_release", "OnVrikTriggerVoiceRelease")
    VRIK.VrikAddGestureAction("skynet_vrik_trigger_voice_release", "SkyrimNet: Stop Voice Input")
  
    RegisterForModEvent("skynet_vrik_trigger_direct_input", "OnVrikTriggerDirectInput")
    VRIK.VrikAddGestureAction("skynet_vrik_trigger_direct_input", "SkyrimNet: Start Direct Input")
  
    RegisterForModEvent("skynet_vrik_trigger_direct_release", "OnVrikTriggerDirectRelease")
    VRIK.VrikAddGestureAction("skynet_vrik_trigger_direct_release", "SkyrimNet: Stop Direct Input")
  
    RegisterForModEvent("skynet_vrik_trigger_player_thought", "OnVrikTriggerPlayerThought")
    VRIK.VrikAddGestureAction("skynet_vrik_trigger_player_thought", "SkyrimNet: Trigger Player Thought")
  
    RegisterForModEvent("skynet_vrik_trigger_player_dialogue", "OnVrikTriggerPlayerDialogue")
    VRIK.VrikAddGestureAction("skynet_vrik_trigger_player_dialogue", "SkyrimNet: Trigger Player Dialogue")

    RegisterForModEvent("skynet_vrik_trigger_dialogue_transform", "OnVrikTriggerDialogueTransform")
    VRIK.VrikAddGestureAction("skynet_vrik_trigger_dialogue_transform", "SkyrimNet: Start Dialogue Transform Input")

    RegisterForModEvent("skynet_vrik_trigger_dialogue_transform_release", "OnVrikTriggerDialogueTransformRelease")
    VRIK.VrikAddGestureAction("skynet_vrik_trigger_dialogue_transform_release", "SkyrimNet: Stop Dialogue Transform Input")

    RegisterForModEvent("skynet_vrik_interrupt_dialogue", "OnVrikInterruptDialogue")
    VRIK.VrikAddGestureAction("skynet_vrik_interrupt_dialogue", "SkyrimNet: Interrupt Dialogue")
EndFunction
  
Event OnVrikTriggerDialogueTransform(string eventName, string strArg, float numArg, Form sender)
    SkyrimNetApi.TriggerVoiceDialogueTransformPressed()
EndEvent

Event OnVrikTriggerDialogueTransformRelease(string eventName, string strArg, float numArg, Form sender)
    SkyrimNetApi.TriggerVoiceDialogueTransformReleased(1.0)
EndEvent

Event OnVrikContinueNarration(string eventName, string strArg, float numArg, Form sender)
    SkyrimNetApi.TriggerContinueNarration()
EndEvent  
  
Event OnVrikToggleGameMaster(string eventName, string strArg, float numArg, Form sender)
    SkyrimNetApi.TriggerToggleGameMaster()
EndEvent
  
Event OnVrikTriggerVoiceInput(string eventName, string strArg, float numArg, Form sender)
    SkyrimNetApi.TriggerRecordSpeechPressed()
EndEvent
  
Event OnVrikToggleOpenMic(string eventName, string strArg, float numArg, Form sender)
    SkyrimNetApi.TriggerToggleOpenMic()
EndEvent
  
Event OnVrikTriggerVoiceRelease(string eventName, string strArg, float numArg, Form sender)
    SkyrimNetApi.TriggerRecordSpeechReleased(2.0)
EndEvent
  
Event OnVrikTriggerDirectInput(string eventName, string strArg, float numArg, Form sender)
    SkyrimNetApi.TriggerVoiceDirectInputPressed()
EndEvent
  
Event OnVrikTriggerDirectRelease(string eventName, string strArg, float numArg, Form sender)
    SkyrimNetApi.TriggerVoiceDirectInputReleased(2.0)
EndEvent
  
Event OnVrikTriggerPlayerThought(string eventName, string strArg, float numArg, Form sender)
    SkyrimNetApi.TriggerPlayerThought()
EndEvent
  
Event OnVrikTriggerPlayerDialogue(string eventName, string strArg, float numArg, Form sender)
    SkyrimNetApi.TriggerPlayerDialogue()
EndEvent

Event OnVrikInterruptDialogue(string eventName, string strArg, float numArg, Form sender)
    SkyrimNetApi.TriggerInterruptDialogue()
EndEvent

; -----------------------------------------------------------------------------
; ---- DBVO Integration ----
; -----------------------------------------------------------------------------
  
Function InitDBVOIntegration()
    if Game.GetModByName("DBVO.esp") != 255
        skynet.Info("DBVO.esp is active, so disabling custom DBVO integration")
        return
    endif

    skynet.Info("Using DBVO integration")
    RegisterForModEvent("PlayDBVOTopic", "OnPlayDBVOTopic")
EndFunction

; -----------------------------------------------------------------------------
; ---- MinAI Bridge Integration ----
; Bridges MinAI-style mod events to SkyrimNet's native API
; This allows mods that integrate with MinAI to also work with SkyrimNet,
; even if MinAI is not installed.
; -----------------------------------------------------------------------------

Function InitMinAIBridge()
    ; Get the bridge script instance from the same quest
    minAIBridge = (Self as Quest) as skynet_MinAIBridge
    
    if !minAIBridge
        skynet.Warn("MinAI Bridge script not found on quest - MinAI event bridging disabled")
        return
    endif
    
    minAIBridge.Maintenance(skynet)
    skynet.Info("MinAI Bridge initialized")
EndFunction
  
; Event to intercept DBVO dialogue
Event OnPlayDBVOTopic(string eventName, string strArg, float numArg, Form sender)
    ; If DBVO.esp is active, don't interfere with it
    if Game.GetModByName("DBVO.esp") != 255
        return
    endif

    ; Check which features are enabled
    Bool _playerTTSEnabled = SkyrimNetApi.GetConfigBool("game", "dbvo.enabled", true)
    Bool _voiceSilentNPCs = SkyrimNetApi.GetConfigBool("game", "dbvo.voiceSilentNPCs", true)

    ; If both features are disabled, proceed with vanilla behavior
    if !_playerTTSEnabled && !_voiceSilentNPCs
        UI.InvokeString("Dialogue Menu", "_root.DialogueMenu_mc.startTopicClickedTimer", "off")
        return
    endif

    ; Kick off player TTS asynchronously if enabled
    if _playerTTSEnabled
        SkyrimNetApi.TriggerPlayerTTS(strArg)
    endif

    ; Pre-generate TTS for silent NPC responses if enabled
    if _voiceSilentNPCs
        SkyrimNetApi.PrepareNPCDialogue(strArg)
    endif

    ; Poll until player audio finishes playing
    if _playerTTSEnabled
        Float _timeout = 60.0 ; safety cap (seconds)
        Float _elapsed = 0.0
        Float _interval = 0.1 ; 100ms polling
        Bool _isReady = false

        while _elapsed < _timeout && !_isReady
            if SkyrimNetApi.IsPlayerTTSFinished()
                ; Audio has finished playing - proceed immediately
                _isReady = true
            else
                Utility.WaitMenuMode(_interval)
                _elapsed += _interval
            endif
        endwhile

        ; Check if we timed out
        if !_isReady
            Debug.Notification("Warning: Player TTS timed out after " + _timeout + " seconds")
            skynet.Warn("Player TTS timed out after " + _timeout + " seconds")
        endif
    endif

    ; Poll until NPC dialogue (vanilla or TTS-generated) is ready to play
    if _voiceSilentNPCs
        ; We block here to ensure TTS is ready before starting subtitles and lip sync
        Float _npc_dialogue_timeout = 30.0 ; timeout for TTS generation (seconds)
        Float _npc_dialogue_elapsed = 0.0
        Float _npc_dialogue_interval = 0.1 ; 100ms polling
        Bool _npc_dialogue_ready = false

        while _npc_dialogue_elapsed < _npc_dialogue_timeout && !_npc_dialogue_ready
            if SkyrimNetApi.IsNPCDialogueReady()
                _npc_dialogue_ready = true
            else
                Utility.WaitMenuMode(_npc_dialogue_interval)
                _npc_dialogue_elapsed += _npc_dialogue_interval
            endif
        endwhile

        ; Check if we timed out waiting for NPC dialogue TTS generation
        if !_npc_dialogue_ready
            skynet.Warn("NPC dialogue TTS generation timed out after " + _npc_dialogue_timeout + " seconds")
        endif
    endif

    ; Wait to give a natural pause between player and NPC speech
    if _playerTTSEnabled
        Float _speech_break = 0.3
        Utility.WaitMenuMode(_speech_break)
    endif

    ; Proceed with DBVO callback
    UI.InvokeString("Dialogue Menu", "_root.DialogueMenu_mc.startTopicClickedTimer", "off")
EndEvent

; -----------------------------------------------------------------------------
; --- In-Game Hotkey System ---
; -----------------------------------------------------------------------------

; Hotkey properties - stores key codes for each hotkey
Int Property hotkeyRecordSpeech = -1 Auto Hidden
Int Property hotkeyTextInput = -1 Auto Hidden
Int Property hotkeyToggleGameMaster = -1 Auto Hidden
Int Property hotkeyTextThought = -1 Auto Hidden
Int Property hotkeyVoiceThought = -1 Auto Hidden
Int Property hotkeyTextDialogueTransform = -1 Auto Hidden
Int Property hotkeyVoiceDialogueTransform = -1 Auto Hidden
Int Property hotkeyToggleContinuousMode = -1 Auto Hidden
Int Property hotkeyToggleWorldEventReactions = -1 Auto Hidden
Int Property hotkeyDirectInput = -1 Auto Hidden
Int Property hotkeyVoiceDirectInput = -1 Auto Hidden
Int Property hotkeyContinueNarration = -1 Auto Hidden
Int Property hotkeyToggleWhisperMode = -1 Auto Hidden
Int Property hotkeyToggleOpenMic = -1 Auto Hidden
Int Property hotkeyCaptureCrosshair = -1 Auto Hidden
Int Property hotkeyGenerateDiaryBio = -1 Auto Hidden
Int Property hotkeyInterruptDialogue = -1 Auto Hidden
Int Property hotkeySilentNarration = -1 Auto Hidden
Int Property hotkeyDebugFollowTarget = -1 Auto Hidden
Int Property hotkeyDebugPackageTest = -1 Auto Hidden
Int Property hotkeyDebugPackageInfo = -1 Auto Hidden

Bool Property inGameHotkeysEnabled = false Auto Hidden

; Track which keys are currently pressed to detect press/release
; Using individual bools instead of arrays to support keycodes > 127
Bool pressedRecordSpeech = false
Bool pressedVoiceThought = false
Bool pressedVoiceDialogueTransform = false
Bool pressedVoiceDirectInput = false
Bool pressedCaptureCrosshair = false

; Track press times for hold detection
Float timestampRecordSpeech = 0.0
Float timestampVoiceThought = 0.0
Float timestampVoiceDialogueTransform = 0.0
Float timestampVoiceDirectInput = 0.0
Float timestampCaptureCrosshair = 0.0

Function ResetHotkeyStates()
    ; Reset all press tracking states to prevent stuck keys
    pressedRecordSpeech = false
    pressedVoiceThought = false
    pressedVoiceDialogueTransform = false
    pressedVoiceDirectInput = false
    pressedCaptureCrosshair = false
    
    timestampRecordSpeech = 0.0
    timestampVoiceThought = 0.0
    timestampVoiceDialogueTransform = 0.0
    timestampVoiceDirectInput = 0.0
    timestampCaptureCrosshair = 0.0
EndFunction

Function InitializeInGameHotkeys()
    ; Apply the saved hotkey setting
    If inGameHotkeysEnabled
        ; If in-game hotkeys are enabled, disable native hotkeys and register for key events
        SkyrimNetApi.SetCppHotkeysEnabled(false)
        RegisterConfiguredHotkeys()
        skynet.Info("In-game hotkeys enabled on load")
    Else
        ; If in-game hotkeys are disabled, ensure native hotkeys are enabled
        SkyrimNetApi.SetCppHotkeysEnabled(true)
        skynet.Info("Native hotkeys enabled on load")
    EndIf
EndFunction

Function RegisterConfiguredHotkeys()
    ; Register for each configured hotkey
    If hotkeyRecordSpeech != -1
        RegisterForKey(hotkeyRecordSpeech)
    EndIf
    If hotkeyTextInput != -1
        RegisterForKey(hotkeyTextInput)
    EndIf
    If hotkeyToggleGameMaster != -1
        RegisterForKey(hotkeyToggleGameMaster)
    EndIf
    If hotkeyTextThought != -1
        RegisterForKey(hotkeyTextThought)
    EndIf
    If hotkeyVoiceThought != -1
        RegisterForKey(hotkeyVoiceThought)
    EndIf
    If hotkeyTextDialogueTransform != -1
        RegisterForKey(hotkeyTextDialogueTransform)
    EndIf
    If hotkeyVoiceDialogueTransform != -1
        RegisterForKey(hotkeyVoiceDialogueTransform)
    EndIf
    If hotkeyToggleContinuousMode != -1
        RegisterForKey(hotkeyToggleContinuousMode)
    EndIf
    If hotkeyToggleWorldEventReactions != -1
        RegisterForKey(hotkeyToggleWorldEventReactions)
    EndIf
    If hotkeyDirectInput != -1
        RegisterForKey(hotkeyDirectInput)
    EndIf
    If hotkeyVoiceDirectInput != -1
        RegisterForKey(hotkeyVoiceDirectInput)
    EndIf
    If hotkeyContinueNarration != -1
        RegisterForKey(hotkeyContinueNarration)
    EndIf
    If hotkeyToggleWhisperMode != -1
        RegisterForKey(hotkeyToggleWhisperMode)
    EndIf
    If hotkeyToggleOpenMic != -1
        RegisterForKey(hotkeyToggleOpenMic)
    EndIf
    If hotkeyCaptureCrosshair != -1
        RegisterForKey(hotkeyCaptureCrosshair)
    EndIf
    If hotkeyGenerateDiaryBio != -1
        RegisterForKey(hotkeyGenerateDiaryBio)
    EndIf
    If hotkeyInterruptDialogue != -1
        RegisterForKey(hotkeyInterruptDialogue)
    EndIf
    If hotkeySilentNarration != -1
        RegisterForKey(hotkeySilentNarration)
    EndIf
    If hotkeyDebugFollowTarget != -1
        RegisterForKey(hotkeyDebugFollowTarget)
    EndIf
    If hotkeyDebugPackageTest != -1
        RegisterForKey(hotkeyDebugPackageTest)
    EndIf
    If hotkeyDebugPackageInfo != -1
        RegisterForKey(hotkeyDebugPackageInfo)
    EndIf
EndFunction

Function UnregisterAllHotkeys()
    ; Unregister each configured hotkey individually
    If hotkeyRecordSpeech != -1
        UnregisterForKey(hotkeyRecordSpeech)
    EndIf
    If hotkeyTextInput != -1
        UnregisterForKey(hotkeyTextInput)
    EndIf
    If hotkeyToggleGameMaster != -1
        UnregisterForKey(hotkeyToggleGameMaster)
    EndIf
    If hotkeyTextThought != -1
        UnregisterForKey(hotkeyTextThought)
    EndIf
    If hotkeyVoiceThought != -1
        UnregisterForKey(hotkeyVoiceThought)
    EndIf
    If hotkeyTextDialogueTransform != -1
        UnregisterForKey(hotkeyTextDialogueTransform)
    EndIf
    If hotkeyVoiceDialogueTransform != -1
        UnregisterForKey(hotkeyVoiceDialogueTransform)
    EndIf
    If hotkeyToggleContinuousMode != -1
        UnregisterForKey(hotkeyToggleContinuousMode)
    EndIf
    If hotkeyToggleWorldEventReactions != -1
        UnregisterForKey(hotkeyToggleWorldEventReactions)
    EndIf
    If hotkeyDirectInput != -1
        UnregisterForKey(hotkeyDirectInput)
    EndIf
    If hotkeyVoiceDirectInput != -1
        UnregisterForKey(hotkeyVoiceDirectInput)
    EndIf
    If hotkeyContinueNarration != -1
        UnregisterForKey(hotkeyContinueNarration)
    EndIf
    If hotkeyToggleWhisperMode != -1
        UnregisterForKey(hotkeyToggleWhisperMode)
    EndIf
    If hotkeyToggleOpenMic != -1
        UnregisterForKey(hotkeyToggleOpenMic)
    EndIf
    If hotkeyCaptureCrosshair != -1
        UnregisterForKey(hotkeyCaptureCrosshair)
    EndIf
    If hotkeyGenerateDiaryBio != -1
        UnregisterForKey(hotkeyGenerateDiaryBio)
    EndIf
    If hotkeyInterruptDialogue != -1
        UnregisterForKey(hotkeyInterruptDialogue)
    EndIf
    If hotkeySilentNarration != -1
        UnregisterForKey(hotkeySilentNarration)
    EndIf
    If hotkeyDebugFollowTarget != -1
        UnregisterForKey(hotkeyDebugFollowTarget)
    EndIf
    If hotkeyDebugPackageTest != -1
        UnregisterForKey(hotkeyDebugPackageTest)
    EndIf
    If hotkeyDebugPackageInfo != -1
        UnregisterForKey(hotkeyDebugPackageInfo)
    EndIf
EndFunction

Function EnableInGameHotkeys()
    If inGameHotkeysEnabled
        return ; Already enabled
    EndIf
    
    skynet.Info("Enabling in-game hotkeys")
    
    ; Disable native hotkeys
    SkyrimNetApi.SetCppHotkeysEnabled(false)
    
    ; Reset all key states to prevent stuck keys
    ResetHotkeyStates()
    
    ; Enable in-game hotkeys
    inGameHotkeysEnabled = true
    RegisterConfiguredHotkeys()
    
    Debug.Notification("In-game hotkeys enabled")
EndFunction

Function DisableInGameHotkeys()
    If !inGameHotkeysEnabled
        return ; Already disabled
    EndIf
    
    skynet.Info("Disabling in-game hotkeys")
    
    ; Disable in-game hotkeys
    inGameHotkeysEnabled = false
    UnregisterAllHotkeys()
    
    ; Reset all key states to prevent stuck keys
    ResetHotkeyStates()
    
    ; Re-enable native hotkeys
    SkyrimNetApi.SetCppHotkeysEnabled(true)
    
    Debug.Notification("In-game hotkeys disabled")
EndFunction

Event OnKeyDown(Int keyCode)
    If !inGameHotkeysEnabled || keyCode < 0
        return
    EndIf
    
    ; Track key press for keys that need press/release handling
    Bool alreadyPressed = false
    
    If keyCode == hotkeyRecordSpeech && hotkeyRecordSpeech != -1
        alreadyPressed = pressedRecordSpeech
        pressedRecordSpeech = true
        timestampRecordSpeech = Utility.GetCurrentRealTime()
    ElseIf keyCode == hotkeyVoiceThought && hotkeyVoiceThought != -1
        alreadyPressed = pressedVoiceThought
        pressedVoiceThought = true
        timestampVoiceThought = Utility.GetCurrentRealTime()
    ElseIf keyCode == hotkeyVoiceDialogueTransform && hotkeyVoiceDialogueTransform != -1
        alreadyPressed = pressedVoiceDialogueTransform
        pressedVoiceDialogueTransform = true
        timestampVoiceDialogueTransform = Utility.GetCurrentRealTime()
    ElseIf keyCode == hotkeyVoiceDirectInput && hotkeyVoiceDirectInput != -1
        alreadyPressed = pressedVoiceDirectInput
        pressedVoiceDirectInput = true
        timestampVoiceDirectInput = Utility.GetCurrentRealTime()
    ElseIf keyCode == hotkeyCaptureCrosshair && hotkeyCaptureCrosshair != -1
        alreadyPressed = pressedCaptureCrosshair
        pressedCaptureCrosshair = true
        timestampCaptureCrosshair = Utility.GetCurrentRealTime()
    EndIf
    
    ; Only handle press if this is a new press (not held)
    If !alreadyPressed
        HandleHotkeyPress(keyCode)
    EndIf
EndEvent

Event OnKeyUp(Int keyCode, Float holdTime)
    If !inGameHotkeysEnabled || keyCode < 0
        return
    EndIf
    
    ; Check if this key was being tracked and clear its pressed state
    Bool wasPressed = false
    
    If keyCode == hotkeyRecordSpeech && hotkeyRecordSpeech != -1
        wasPressed = pressedRecordSpeech
        pressedRecordSpeech = false
    ElseIf keyCode == hotkeyVoiceThought && hotkeyVoiceThought != -1
        wasPressed = pressedVoiceThought
        pressedVoiceThought = false
    ElseIf keyCode == hotkeyVoiceDialogueTransform && hotkeyVoiceDialogueTransform != -1
        wasPressed = pressedVoiceDialogueTransform
        pressedVoiceDialogueTransform = false
    ElseIf keyCode == hotkeyVoiceDirectInput && hotkeyVoiceDirectInput != -1
        wasPressed = pressedVoiceDirectInput
        pressedVoiceDirectInput = false
    ElseIf keyCode == hotkeyCaptureCrosshair && hotkeyCaptureCrosshair != -1
        wasPressed = pressedCaptureCrosshair
        pressedCaptureCrosshair = false
    EndIf
    
    ; Only handle release if the key was actually pressed
    If wasPressed
        HandleHotkeyRelease(keyCode, holdTime)
    EndIf
EndEvent

Function HandleHotkeyPress(Int keyCode)
    ; Voice recording hotkeys (with press/release)
    If keyCode == hotkeyRecordSpeech && hotkeyRecordSpeech != -1
        SkyrimNetApi.TriggerRecordSpeechPressed()
    ElseIf keyCode == hotkeyVoiceThought && hotkeyVoiceThought != -1
        SkyrimNetApi.TriggerVoiceThoughtPressed()
    ElseIf keyCode == hotkeyVoiceDialogueTransform && hotkeyVoiceDialogueTransform != -1
        SkyrimNetApi.TriggerVoiceDialogueTransformPressed()
    ElseIf keyCode == hotkeyVoiceDirectInput && hotkeyVoiceDirectInput != -1
        SkyrimNetApi.TriggerVoiceDirectInputPressed()
    ElseIf keyCode == hotkeyCaptureCrosshair && hotkeyCaptureCrosshair != -1
        SkyrimNetApi.TriggerCaptureCrosshairPressed()
    
    ; Single-press hotkeys (no release handler)
    ElseIf keyCode == hotkeyTextInput && hotkeyTextInput != -1
        SkyrimNetApi.TriggerTextInput()
    ElseIf keyCode == hotkeyToggleGameMaster && hotkeyToggleGameMaster != -1
        SkyrimNetApi.TriggerToggleGameMaster()
    ElseIf keyCode == hotkeyTextThought && hotkeyTextThought != -1
        SkyrimNetApi.TriggerTextThought()
    ElseIf keyCode == hotkeyTextDialogueTransform && hotkeyTextDialogueTransform != -1
        SkyrimNetApi.TriggerTextDialogueTransform()
    ElseIf keyCode == hotkeyToggleContinuousMode && hotkeyToggleContinuousMode != -1
        SkyrimNetApi.TriggerToggleContinuousMode()
    ElseIf keyCode == hotkeyToggleWorldEventReactions && hotkeyToggleWorldEventReactions != -1
        SkyrimNetApi.TriggerToggleWorldEventReactions()
    ElseIf keyCode == hotkeyDirectInput && hotkeyDirectInput != -1
        SkyrimNetApi.TriggerDirectInput()
    ElseIf keyCode == hotkeyContinueNarration && hotkeyContinueNarration != -1
        SkyrimNetApi.TriggerContinueNarration()
    ElseIf keyCode == hotkeyToggleWhisperMode && hotkeyToggleWhisperMode != -1
        SkyrimNetApi.TriggerToggleWhisperMode()
    ElseIf keyCode == hotkeyToggleOpenMic && hotkeyToggleOpenMic != -1
        SkyrimNetApi.TriggerToggleOpenMic()
    ElseIf keyCode == hotkeyGenerateDiaryBio && hotkeyGenerateDiaryBio != -1
        SkyrimNetApi.TriggerGenerateDiaryBio()
    ElseIf keyCode == hotkeyInterruptDialogue && hotkeyInterruptDialogue != -1
        SkyrimNetApi.TriggerInterruptDialogue()
    ElseIf keyCode == hotkeySilentNarration && hotkeySilentNarration != -1
        SkyrimNetApi.TriggerSilentNarration()
    ElseIf keyCode == hotkeyDebugFollowTarget && hotkeyDebugFollowTarget != -1
        DebugFollowCrosshairTarget()
    ElseIf keyCode == hotkeyDebugPackageTest && hotkeyDebugPackageTest != -1
        DebugPackagePreemptionTest()
    ElseIf keyCode == hotkeyDebugPackageInfo && hotkeyDebugPackageInfo != -1
        DebugPackageInfo()
    EndIf
EndFunction

Function HandleHotkeyRelease(Int keyCode, Float holdTime)
    ; Voice recording hotkeys that need release handling
    If keyCode == hotkeyRecordSpeech && hotkeyRecordSpeech != -1
        SkyrimNetApi.TriggerRecordSpeechReleased(holdTime)
    ElseIf keyCode == hotkeyVoiceThought && hotkeyVoiceThought != -1
        SkyrimNetApi.TriggerVoiceThoughtReleased(holdTime)
    ElseIf keyCode == hotkeyVoiceDialogueTransform && hotkeyVoiceDialogueTransform != -1
        SkyrimNetApi.TriggerVoiceDialogueTransformReleased(holdTime)
    ElseIf keyCode == hotkeyVoiceDirectInput && hotkeyVoiceDirectInput != -1
        SkyrimNetApi.TriggerVoiceDirectInputReleased(holdTime)
    ElseIf keyCode == hotkeyCaptureCrosshair && hotkeyCaptureCrosshair != -1
        ; Crosshair capture with hold detection
        ; Quick press (< 1.0s) = capture crosshair target (actor/furniture)
        ; Long press (>= 1.0s) = capture player
        SkyrimNetApi.TriggerCaptureCrosshairReleased(holdTime)
    EndIf
EndFunction

; -----------------------------------------------------------------------------
; --- Debug Utilities ---
; -----------------------------------------------------------------------------

Function DebugFollowCrosshairTarget()
    Actor target = Game.GetCurrentCrosshairRef() as Actor
    If !target
        Debug.Notification("[SkyrimNet Debug] No actor under crosshair")
        return
    EndIf

    If ActorUtil.RemovePackageOverride(target, packageFollowPlayer)
        ; Had the override, removed it (toggle off)
        Debug.Notification("[SkyrimNet Debug] " + target.GetDisplayName() + " stopped following")
        target.EvaluatePackage()
    Else
        ; Didn't have it, add it (toggle on)
        Debug.Notification("[SkyrimNet Debug] " + target.GetDisplayName() + " now following")
        ActorUtil.AddPackageOverride(target, packageFollowPlayer, 10, 0)
        target.EvaluatePackage()
    EndIf
EndFunction

; Comprehensive PapyrusUtil API + SkyrimNet multi-priority package test.
; Exercises all 4 hooked PapyrusUtil functions and verifies SkyrimNet handles
; multiple packages with different priorities correctly.
;
; Phase A (steps 1-3): Multi-priority SkyrimNet test
;   Register two SkyrimNet packages at different priorities, verify priority
;   ordering, then unwind and verify correct fallback at each step.
;
; Phase B (steps 4-6): PU preemption survival test
;   PU.Add(FollowPlayer@10), SkyrimNet preempts with TalkToPlayer@30,
;   remove SkyrimNet override, verify PU package survived.
;   Exercises: PU.AddPackageOverride
;
; Phase C (steps 7-9): PU API coverage
;   Tests ClearPackageOverride(actor) and RemoveAllPackageOverride(package).
;   Exercises: PU.ClearPackageOverride, PU.RemoveAllPackageOverride,
;              PU.RemovePackageOverride (cleanup via ClearPackageOverride)
Function DebugPackagePreemptionTest()
    Actor target = Game.GetCurrentCrosshairRef() as Actor
    If !target
        Debug.Notification("[PkgTest] No actor under crosshair")
        return
    EndIf

    String name = target.GetDisplayName()
    int formID = target.GetFormID()
    Package currentPkg = None
    int puCount = 0
    int curPkgID = 0

    ; Capture the NPC's original package before we touch anything
    Package originalPkg = target.GetCurrentPackage()
    int originalPkgID = 0
    If originalPkg
        originalPkgID = originalPkg.GetFormID()
    EndIf
    Debug.Trace("[PkgTest] ========== COMPREHENSIVE PACKAGE TEST START ==========")
    Debug.Trace("[PkgTest] Target: " + name + " (FormID: " + formID + ")")
    Debug.Trace("[PkgTest] Original package: " + originalPkgID)
    Debug.Trace("[PkgTest] FollowPlayer pkg: " + packageFollowPlayer.GetFormID())
    Debug.Trace("[PkgTest] TalkToPlayer pkg: " + packageDialoguePlayer.GetFormID())
    Debug.Notification("[PkgTest] " + name + ": Starting comprehensive test...")

    ; =======================================================================
    ; Phase A: Multi-priority SkyrimNet test
    ; =======================================================================
    Debug.Trace("[PkgTest] --- Phase A: Multi-priority SkyrimNet test ---")

    ; --- Step 1: Register two SkyrimNet packages at different priorities ---
    Debug.Trace("[PkgTest] Step 1: Register TalkToPlayer@10 + FollowPlayer@20 via SkyrimNet")
    Debug.Notification("[PkgTest] Step 1/9: SkyrimNet TalkToPlayer@10 + FollowPlayer@20")
    SkyrimNetApi.RegisterPackage(target, "TalkToPlayer", 10, 0, false)
    SkyrimNetApi.RegisterPackage(target, "FollowPlayer", 20, 0, false)

    Utility.Wait(3.0)
    currentPkg = target.GetCurrentPackage()
    curPkgID = 0
    If currentPkg
        curPkgID = currentPkg.GetFormID()
    EndIf
    Debug.Trace("[PkgTest] Step 1 verify: pkg=" + curPkgID + " matchFollow=" + (currentPkg == packageFollowPlayer))
    If currentPkg == packageFollowPlayer
        Debug.Trace("[PkgTest] Step 1: SUCCESS - FollowPlayer@20 wins over TalkToPlayer@10")
        Debug.Notification("[PkgTest] Step 1 OK: FollowPlayer wins (pri 20>10)")
    Else
        Debug.Trace("[PkgTest] Step 1: FAIL - expected FollowPlayer, got " + curPkgID)
        Debug.Notification("[PkgTest] Step 1 FAIL: pkg=" + curPkgID)
    EndIf

    ; --- Step 2: Remove higher-priority FollowPlayer → TalkToPlayer should resume ---
    Utility.Wait(2.0)
    Debug.Trace("[PkgTest] Step 2: Unregister FollowPlayer → TalkToPlayer@10 should resume")
    Debug.Notification("[PkgTest] Step 2/9: Remove FollowPlayer, expect TalkToPlayer")
    SkyrimNetApi.UnregisterPackage(target, "FollowPlayer")
    target.EvaluatePackage()

    Utility.Wait(2.0)
    currentPkg = target.GetCurrentPackage()
    curPkgID = 0
    If currentPkg
        curPkgID = currentPkg.GetFormID()
    EndIf
    Debug.Trace("[PkgTest] Step 2 verify: pkg=" + curPkgID + " matchTalk=" + (currentPkg == packageDialoguePlayer))
    If currentPkg == packageDialoguePlayer
        Debug.Trace("[PkgTest] Step 2: SUCCESS - TalkToPlayer resumed")
        Debug.Notification("[PkgTest] Step 2 OK: TalkToPlayer resumed (pri=10)")
    Else
        Debug.Trace("[PkgTest] Step 2: FAIL - expected TalkToPlayer, got " + curPkgID)
        Debug.Notification("[PkgTest] Step 2 FAIL: pkg=" + curPkgID)
    EndIf

    ; --- Step 3: Remove TalkToPlayer → original should restore ---
    Utility.Wait(2.0)
    Debug.Trace("[PkgTest] Step 3: Unregister TalkToPlayer → original should restore")
    Debug.Notification("[PkgTest] Step 3/9: Remove TalkToPlayer, expect original")
    SkyrimNetApi.UnregisterPackage(target, "TalkToPlayer")
    target.EvaluatePackage()

    Utility.Wait(2.0)
    currentPkg = target.GetCurrentPackage()
    curPkgID = 0
    If currentPkg
        curPkgID = currentPkg.GetFormID()
    EndIf
    Debug.Trace("[PkgTest] Step 3 verify: pkg=" + curPkgID + " matchOrig=" + (currentPkg == originalPkg))
    If currentPkg == originalPkg
        Debug.Notification("[PkgTest] Step 3 OK: Original restored")
    Else
        Debug.Notification("[PkgTest] Step 3 INFO: pkg=" + curPkgID + " (orig=" + originalPkgID + ")")
    EndIf

    ; =======================================================================
    ; Phase B: PU preemption survival test
    ; =======================================================================
    Debug.Trace("[PkgTest] --- Phase B: PU preemption survival test ---")

    ; --- Step 4: Add FollowPlayer via PapyrusUtil [exercises PU.AddPackageOverride] ---
    Utility.Wait(2.0)
    Debug.Trace("[PkgTest] Step 4: PU.AddPackageOverride(FollowPlayer, pri=10)")
    Debug.Notification("[PkgTest] Step 4/9: PU Add FollowPlayer (pri=10)")
    ActorUtil.AddPackageOverride(target, packageFollowPlayer, 10, 0)
    target.EvaluatePackage()

    Utility.Wait(3.0)
    currentPkg = target.GetCurrentPackage()
    puCount = ActorUtil.CountPackageOverride(target)
    curPkgID = 0
    If currentPkg
        curPkgID = currentPkg.GetFormID()
    EndIf
    Debug.Trace("[PkgTest] Step 4 verify: pkg=" + curPkgID + " PU.Count=" + puCount + " matchFollow=" + (currentPkg == packageFollowPlayer))
    If currentPkg == packageFollowPlayer
        Debug.Notification("[PkgTest] Step 4 OK: FollowPlayer via PU (PU=" + puCount + ")")
    Else
        Debug.Notification("[PkgTest] Step 4 WARN: pkg=" + curPkgID + " (PU=" + puCount + ")")
    EndIf

    ; --- Step 5: SkyrimNet preempts with TalkToPlayer@30 ---
    Debug.Trace("[PkgTest] Step 5: SkyrimNet.Register(TalkToPlayer, pri=30) — preempts PU FollowPlayer")
    Debug.Notification("[PkgTest] Step 5/9: SkyrimNet TalkToPlayer@30 (preempts)")
    SkyrimNetApi.RegisterPackage(target, "TalkToPlayer", 30, 0, false)

    Utility.Wait(2.0)
    currentPkg = target.GetCurrentPackage()
    curPkgID = 0
    If currentPkg
        curPkgID = currentPkg.GetFormID()
    EndIf
    Debug.Trace("[PkgTest] Step 5 verify: pkg=" + curPkgID + " matchTalk=" + (currentPkg == packageDialoguePlayer))
    If currentPkg == packageDialoguePlayer
        Debug.Notification("[PkgTest] Step 5 OK: TalkToPlayer preempted")
    Else
        Debug.Notification("[PkgTest] Step 5 WARN: pkg=" + curPkgID + " not TalkToPlayer")
    EndIf

    ; --- Step 6: Remove SkyrimNet TalkToPlayer → PU FollowPlayer should survive ---
    Utility.Wait(3.0)
    puCount = ActorUtil.CountPackageOverride(target)
    Debug.Trace("[PkgTest] Step 6: Unregister TalkToPlayer. PU.Count=" + puCount + " (likely 0 — PU erased during preemption)")
    Debug.Notification("[PkgTest] Step 6/9: Remove TalkToPlayer (PU=" + puCount + ")")
    SkyrimNetApi.UnregisterPackage(target, "TalkToPlayer")
    target.EvaluatePackage()

    Utility.Wait(2.0)
    currentPkg = target.GetCurrentPackage()
    puCount = ActorUtil.CountPackageOverride(target)
    curPkgID = 0
    If currentPkg
        curPkgID = currentPkg.GetFormID()
    EndIf
    Debug.Trace("[PkgTest] Step 6 verify: pkg=" + curPkgID + " PU.Count=" + puCount + " matchFollow=" + (currentPkg == packageFollowPlayer))
    If currentPkg == packageFollowPlayer
        Debug.Trace("[PkgTest] Step 6: SUCCESS - PU FollowPlayer survived preemption!")
        Debug.Notification("[PkgTest] Step 6 SUCCESS: FollowPlayer survived! (PU=" + puCount + ")")
    ElseIf currentPkg
        Debug.Trace("[PkgTest] Step 6: FAIL - running pkg " + curPkgID + " instead of FollowPlayer")
        Debug.Notification("[PkgTest] Step 6 FAIL: pkg=" + curPkgID + " (PU=" + puCount + ")")
    Else
        Debug.Trace("[PkgTest] Step 6: FAIL - no package running")
        Debug.Notification("[PkgTest] Step 6 FAIL: no package (PU=" + puCount + ")")
    EndIf

    ; =======================================================================
    ; Phase C: PU API coverage — ClearPackageOverride + RemoveAllPackageOverride
    ; =======================================================================
    Debug.Trace("[PkgTest] --- Phase C: PU API coverage ---")

    ; --- Step 7: ClearPackageOverride(actor) [exercises hooked PU.ClearPackageOverride] ---
    ; FollowPlayer is still in our hook map from step 4. This should clear it.
    Utility.Wait(2.0)
    Debug.Trace("[PkgTest] Step 7: PU.ClearPackageOverride(actor) — clears all PU overrides for actor")
    Debug.Notification("[PkgTest] Step 7/9: PU ClearPackageOverride(actor)")
    ActorUtil.ClearPackageOverride(target)
    target.EvaluatePackage()

    Utility.Wait(2.0)
    currentPkg = target.GetCurrentPackage()
    puCount = ActorUtil.CountPackageOverride(target)
    curPkgID = 0
    If currentPkg
        curPkgID = currentPkg.GetFormID()
    EndIf
    Debug.Trace("[PkgTest] Step 7 verify: pkg=" + curPkgID + " PU.Count=" + puCount + " matchOrig=" + (currentPkg == originalPkg))
    If currentPkg == originalPkg
        Debug.Trace("[PkgTest] Step 7: SUCCESS - ClearPackageOverride restored original")
        Debug.Notification("[PkgTest] Step 7 OK: Cleared, original restored (PU=" + puCount + ")")
    Else
        Debug.Trace("[PkgTest] Step 7: INFO - pkg=" + curPkgID + " after clear (orig=" + originalPkgID + ")")
        Debug.Notification("[PkgTest] Step 7: pkg=" + curPkgID + " (PU=" + puCount + ")")
    EndIf

    ; --- Step 8: Re-add FollowPlayer via PU for RemoveAllPackageOverride test ---
    Utility.Wait(2.0)
    Debug.Trace("[PkgTest] Step 8: PU.AddPackageOverride(FollowPlayer, pri=10) — setup for RemoveAll")
    Debug.Notification("[PkgTest] Step 8/9: PU Add FollowPlayer (setup for RemoveAll)")
    ActorUtil.AddPackageOverride(target, packageFollowPlayer, 10, 0)
    target.EvaluatePackage()

    Utility.Wait(3.0)
    currentPkg = target.GetCurrentPackage()
    puCount = ActorUtil.CountPackageOverride(target)
    curPkgID = 0
    If currentPkg
        curPkgID = currentPkg.GetFormID()
    EndIf
    Debug.Trace("[PkgTest] Step 8 verify: pkg=" + curPkgID + " PU.Count=" + puCount)
    If currentPkg == packageFollowPlayer
        Debug.Notification("[PkgTest] Step 8 OK: FollowPlayer re-added (PU=" + puCount + ")")
    Else
        Debug.Notification("[PkgTest] Step 8 WARN: pkg=" + curPkgID + " (PU=" + puCount + ")")
    EndIf

    ; --- Step 9: RemoveAllPackageOverride [exercises hooked PU.RemoveAllPackageOverride] ---
    ; Removes the package form globally from all actors (not just this one).
    Debug.Trace("[PkgTest] Step 9: PU.RemoveAllPackageOverride(FollowPlayer) — removes from all actors")
    Debug.Notification("[PkgTest] Step 9/9: PU RemoveAllPackageOverride(FollowPlayer)")
    ActorUtil.RemoveAllPackageOverride(packageFollowPlayer)
    target.EvaluatePackage()

    Utility.Wait(2.0)
    currentPkg = target.GetCurrentPackage()
    puCount = ActorUtil.CountPackageOverride(target)
    curPkgID = 0
    If currentPkg
        curPkgID = currentPkg.GetFormID()
    EndIf
    Debug.Trace("[PkgTest] Step 9 verify: pkg=" + curPkgID + " PU.Count=" + puCount + " matchOrig=" + (currentPkg == originalPkg))
    If currentPkg == originalPkg
        Debug.Trace("[PkgTest] Step 9: SUCCESS - RemoveAllPackageOverride restored original")
        Debug.Notification("[PkgTest] Step 9 OK: RemoveAll done, original restored")
    Else
        Debug.Trace("[PkgTest] Step 9: INFO - pkg=" + curPkgID + " after RemoveAll (orig=" + originalPkgID + ")")
        Debug.Notification("[PkgTest] Step 9: pkg=" + curPkgID + " (PU=" + puCount + ")")
    EndIf

    Debug.Trace("[PkgTest] ========== COMPREHENSIVE PACKAGE TEST END ==========")
    Debug.Notification("[PkgTest] Test complete!")
EndFunction

; Show package override info for the crosshair target.
; Displays PapyrusUtil override count, SkyrimNet package status, and current package ID.
Function DebugPackageInfo()
    Actor target = Game.GetCurrentCrosshairRef() as Actor
    If !target
        Debug.Notification("[PkgInfo] No actor under crosshair")
        return
    EndIf

    String name = target.GetDisplayName()
    int puCount = ActorUtil.CountPackageOverride(target)
    bool hasTalkPlayer = SkyrimNetApi.HasPackage(target, "TalkToPlayer")
    bool hasTalkNPC = SkyrimNetApi.HasPackage(target, "TalkToNPC")
    bool hasFollow = SkyrimNetApi.HasPackage(target, "FollowPlayer")

    Package currentPkg = target.GetCurrentPackage()
    int curPkgID = 0
    If currentPkg
        curPkgID = currentPkg.GetFormID()
    EndIf

    Debug.Notification("[PkgInfo] " + name + ": pkg=" + curPkgID + " PU=" + puCount)

    String snetPkgs = ""
    If hasTalkPlayer
        snetPkgs = "TalkToPlayer "
    EndIf
    If hasTalkNPC
        snetPkgs = snetPkgs + "TalkToNPC "
    EndIf
    If hasFollow
        snetPkgs = snetPkgs + "FollowPlayer "
    EndIf

    If snetPkgs == ""
        snetPkgs = "(none)"
    EndIf
    Debug.Notification("[PkgInfo] SkyrimNet pkgs: " + snetPkgs)

    Debug.Trace("[PkgInfo] " + name + " (FormID:" + target.GetFormID() + "): currentPkg=" + curPkgID + " PU.Count=" + puCount + " SkyrimNet=[" + snetPkgs + "]")
EndFunction