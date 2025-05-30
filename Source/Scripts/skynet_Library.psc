Scriptname skynet_Library extends Quest  

skynet_MainController Property skynet Auto Hidden

; -----------------------------------------------------------------------------
; --- The Library Part of the Library ---
; -----------------------------------------------------------------------------
Faction Property factionMerchants Auto
Faction Property factionPlayerFollowers Auto

Keyword Property keywordDialogueTarget Auto
Keyword Property keywordFollowTarget Auto

Package Property packageDialoguePlayer Auto
Package Property packageDialogueNPC Auto


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

; -----------------------------------------------------------------------------
; --- Version & Maintenance ---
; -----------------------------------------------------------------------------

Function Maintenance(skynet_MainController _skynet)
    skynet = _skynet
    RegisterActions()
    skynet.Info("Library initialized")
EndFunction

Function RegisterActions()
    if !RegisterOpenTradeAction()
        skynet.Fatal("OpenTrade failed to register.")
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

    ; DEBUG ONLY
    debug.notification("Actions registered.")
EndFunction

; -----------------------------------------------------------------------------
; --- Skynet Package Parsing ---
; -----------------------------------------------------------------------------

Package Function GetPackageFromString(String asPackage)
    if asPackage == "TalkToPlayer"
        return packageDialoguePlayer
    elseif asPackage == "TalkToNPC"
        return packageDialogueNPC
    endif
    return None
EndFunction

Function ApplyPackageOverrideToActor(Actor akActor, String asString, Int priority = 1, Int flags = 0)
    Package _pck = GetPackageFromString(asString)
    if !_pck
        skynet.Error("Could not retrieve package for: " + asString)
        return
    endif
    ActorUtil.AddPackageOverride(akActor, _pck, priority, flags)
    akActor.EvaluatePackage()
EndFunction

Function RemovePackageOverrideFromActor(Actor akActor, String asString)
    Package _pck = GetPackageFromString(asString)
    if !_pck
        skynet.Error("Could not retrieve package for: " + asString)
        return
    endif
    ActorUtil.RemovePackageOverride(akActor, _pck)
    akActor.EvaluatePackage()
EndFunction

; -----------------------------------------------------------------------------
; --- Skynet Papyrus Actions ---
; -----------------------------------------------------------------------------

Bool Function RegisterCompanionActions()
    SkyrimNetApi.RegisterAction("CompanionFollow", "Start following {{ player.name }}.", \
                                "SkyrimNetInternal", "CompanionFollow_IsEligible", \
                                "SkyrimNetInternal", "CompanionFollow", \
                                "", "PAPYRUS", \
                                1, "")

    SkyrimNetApi.RegisterAction("CompanionWait", "Wait at this location", \
                                "SkyrimNetInternal", "CompanionWait_IsEligible", \
                                "SkyrimNetInternal", "CompanionWait", \
                                "", "PAPYRUS", \
                                1, "")

    SkyrimNetApi.RegisterAction("CompanionInventory", "Give {{ player.name }} access to your inventory", \
                                "SkyrimNetInternal", "Companion_IsEligible", \
                                "SkyrimNetInternal", "CompanionInventory", \
                                "", "PAPYRUS", \
                                1, "")

    SkyrimNetApi.RegisterAction("CompanionGiveTask", "Let {{ player.name }} designate a task for you", \
                                "SkyrimNetInternal", "CompanionGiveTask_IsEligible", \
                                "SkyrimNetInternal", "CompanionGiveTask", \
                                "", "PAPYRUS", \
                                1, "")

    return true
EndFunction

Bool Function RegisterOpenTradeAction()
  string actionName = "OpenTrade"
  string description = "Use ONLY if {{ player.name }} asks to trade and you agree to trade. Otherwise, do not use this action."
  string eligibilityScriptName = "SkyrimNetInternal"
  string eligibilityFunctionName = "OpenTrade_IsEligible"
  string executionScriptName = "SkyrimNetInternal"
  string executionFunctionName = "OpenTrade_Execute"
  string triggeringEventTypesCsv = ""
  string categoryStr = "PAPYRUS" 
  int defaultPriority = 1
  
  string parameterSchemaJson = "{}"

  int registrationResult = SkyrimNetApi.RegisterAction(actionName, description, \
                                eligibilityScriptName, eligibilityFunctionName, \
                                executionScriptName, executionFunctionName, \
                                triggeringEventTypesCsv, categoryStr, \
                                defaultPriority, parameterSchemaJson)
  
  if registrationResult == 0
    skynet.Info("Papyrus action '" + actionName + "' registered successfully.")
    return true
  else
    skynet.Error("Failed to register Papyrus action '" + actionName + "'. Error code: " + registrationResult)
    return false
  endif
EndFunction

; we reoute stuff here if it has properties we can use so we're not in the global anymore
Bool Function OpenTrade_IsEligible(Actor akActor, string contextJson, string paramsJson)
    if akActor.GetFactionRank(factionMerchants) == -2
        return false
    endif
    return true
EndFunction

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