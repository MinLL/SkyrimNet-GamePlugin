Scriptname skynet_Library extends Quest  

skynet_MainController Property skynet Auto Hidden

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

; -----------------------------------------------------------------------------
; --- Version & Maintenance ---
; -----------------------------------------------------------------------------

Function Maintenance(skynet_MainController _skynet)
    skynet = _skynet
    RegisterActions()
    InitVRIntegrations()
    InitDBVOIntegration()
    ResetHotkeyStates()
    InitializeInGameHotkeys()
    skynet.Info("Library initialized")
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
; --- Skynet Package Parsing ---
; -----------------------------------------------------------------------------

Package Function GetPackageFromString(String asPackage)
    if asPackage == "TalkToPlayer"
        return packageDialoguePlayer
    elseif asPackage == "TalkToNPC"
        return packageDialogueNPC
    elseif asPackage == "FollowPlayer"
        return packageFollowPlayer
    endif
    return None
EndFunction

Function ApplyPackageOverrideToActor(Actor akActor, String asString, Int priority = 1, Int flags = 0)
    Package _pck = GetPackageFromString(asString)
    if !_pck
        skynet.Error("Could not retrieve package for: " + asString)
        return
    endif
    skynet.Info("Applying package override " + asString + " to " + akActor.GetDisplayName())
    ActorUtil.AddPackageOverride(akActor, _pck, priority, flags)
    akActor.EvaluatePackage()
    DispatchPackageAddedEvent(akActor, _pck, asString)
    skynet.Info("Dispatched package remove event for " + akActor.GetDisplayName() + " with package " + asString)
EndFunction

Function RemovePackageOverrideFromActor(Actor akActor, String asString)
    Package _pck = GetPackageFromString(asString)
    if !_pck
        skynet.Error("Could not retrieve package for: " + asString)
        return
    endif
    skynet.Info("Removing package override " + asString + " from " + akActor.GetDisplayName())
    ActorUtil.RemovePackageOverride(akActor, _pck)
    akActor.EvaluatePackage()
    DispatchPackageRemovedEvent(akActor, _pck, asString)
    skynet.Info("Dispatched package remove event for " + akActor.GetDisplayName() + " with package " + asString)
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
    SkyrimNetApi.RegisterAction("SlapTarget", "Slap the target.", \
                                "SkyrimNetInternal", "Animation_IsEligible", \
                                "SkyrimNetInternal", "AnimationSlapActor", \
                                "", "PAPYRUS", \
                                1, "{\"target\": \"Actor\"}")

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
; --- Event Dispatchers
; -----------------------------------------------------------------------------

Function DispatchPackageAddedEvent(Actor akActor, Package pkg, String packageName)
 int handle = ModEvent.Create("SkyrimNet_OnPackageAdded")
  if handle
    modEvent.PushForm(handle,akActor)
    modEvent.PushForm(handle,pkg)
    modEvent.PushString(handle, packageName)
    modEvent.Send(handle)
endif
EndFunction

Function DispatchPackageRemovedEvent(Actor akActor, Package pkg, String packageName)
 int handle = ModEvent.Create("SkyrimNet_OnPackageRemoved")
  if handle
    modEvent.PushForm(handle,akActor)
    modEvent.PushForm(handle,pkg)
    modEvent.PushString(handle, packageName)
    modEvent.Send(handle)
endif
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