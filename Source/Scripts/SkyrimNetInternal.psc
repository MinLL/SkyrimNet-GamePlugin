scriptname SkyrimNetInternal

; Functions from within this file are executed directly by the main DLL.
; Do not change or touch them, or you risk stability issues.

Bool Function ClearTimelineMessage() global
    skynet_MainController skynet = ((Game.GetFormFromFile(0x0802, "SkyrimNet.esp") as Quest) As skynet_MainController)
    if !skynet
        Debug.MessageBox("Fatal Error: AnimationGeneric failed to retrieve controller.")
        return False
    endif

    Int _i = skynet.libs.msgClearHistory.Show()
    if _i == 0
        ; Keep history
        return False
    Else
        ; Clear history
        return True
    EndIf
EndFunction

; -----------------------------------------------------------------------------
; --- Actor & Package Management ---
; -----------------------------------------------------------------------------

Function SetActorDialogueTarget(Actor akActor, Actor akTarget = None) global
    skynet_MainController skynet = ((Game.GetFormFromFile(0x0802, "SkyrimNet.esp") as Quest) As skynet_MainController)
    if !skynet
        Debug.MessageBox("Fatal Error: SetActorDialogueTarget failed to retrieve controller.")
        return
    endif
    skynet.SetActorDialogueTarget(akActor, akTarget)
EndFunction

; SetLookAt - Makes the actor look at the target without applying dialogue packages
; Used for actors that already have a follower package we don't want to override
Function SetLookAt(Actor akActor, Actor akTarget = None) global
    if !akActor
        Debug.Trace("[SkyrimNetInternal] SetLookAt: akActor is null")
        return
    endif
    
    if !akTarget
        akActor.ClearLookAt()
        Debug.Trace("[SkyrimNetInternal] SetLookAt: Cleared look at for " + akActor.GetDisplayName())
    else
        akActor.SetLookAt(akTarget)
        Debug.Trace("[SkyrimNetInternal] SetLookAt: " + akActor.GetDisplayName() + " now looking at " + akTarget.GetDisplayName())
    endif
EndFunction

Function AddPackageToActor(Actor akActor, string packageName, int priority, int flags) global
    Debug.Trace("[SkyrimNetInternal] AddPackageToActor called for " + akActor.GetDisplayName() + " with package " + packageName + " and priority " + priority + " and flags " + flags)
    skynet_MainController skynet = ((Game.GetFormFromFile(0x0802, "SkyrimNet.esp") as Quest) As skynet_MainController)
    if !skynet
        Debug.MessageBox("Fatal Error: AddPackageToActor failed to retrieve controller.")
        return
    endif
    skynet.libs.ApplyPackageOverrideToActor(akActor, packageName, priority, flags)
EndFunction

Function RemovePackageFromActor(Actor akActor, string packageName) global
    Debug.Trace("[SkyrimNetInternal] RemovePackageFromActor called for " + akActor.GetDisplayName() + " with package " + packageName)
    skynet_MainController skynet = ((Game.GetFormFromFile(0x0802, "SkyrimNet.esp") as Quest) As skynet_MainController)
    if !skynet
        Debug.MessageBox("Fatal Error: RemovePackageFromActor failed to retrieve controller.")
        return
    endif
    skynet.libs.RemovePackageOverrideFromActor(akActor, packageName)
EndFunction

; -----------------------------------------------------------------------------
; --- Player Input Handlers ---
; -----------------------------------------------------------------------------

string Function GetPlayerInput() global
    Debug.Trace("[SkyrimNetInternal] GetPlayerInput called")
    UIExtensions.OpenMenu("UITextEntryMenu")
    ; Don't do this if we're in VR
    if SkyrimNetApi.IsRunningVR()
        Debug.Trace("[SkyrimNetInternal] GetPlayerInput: Skipping input in VR")
        Debug.Notification("Text input is disabled in VR")
        return ""
    endif
    string messageText = UIExtensions.GetMenuResultString("UITextEntryMenu")
    Debug.Trace("[SkyrimNetInternal] GetPlayerInput returned: " + messageText)
    return messageText
EndFunction

; -----------------------------------------------------------------------------
; --- Example Papyrus Decorators ---
; -----------------------------------------------------------------------------

string Function ExampleDecorator(Actor akActor) global
    Debug.Trace("[SkyrimNet] (ExampleScript) ExampleDecorator called")
    return "Hello, world!"
EndFunction


string Function ExampleDecorator2(Actor akActor) global
    Debug.Trace("[SkyrimNet] (ExampleScript) ExampleDecorator2 called with " + akActor + " : " + akActor.GetDisplayName())
    return "Hello, world! You called me with " + akActor.GetDisplayName()
EndFunction

; -----------------------------------------------------------------------------
; --- Papyrus Actions ---
; -----------------------------------------------------------------------------

; Eligibility function for a "OpenTrade" action
bool Function OpenTrade_IsEligible(Actor akActor, string contextJson, string paramsJson) global
    Debug.Trace("[SkyrimNetInternal] OpenTrade_IsEligible called for " + akActor.GetDisplayName())
    Debug.Trace("[SkyrimNetInternal] ContextJSON: " + contextJson)
    Debug.Trace("[SkyrimNetInternal] ParamsJSON: " + paramsJson)
    
    ; we first check stuff that we can check from global scope for optimization
    if akActor.IsInCombat()
        return false
    endif

    ; we then reroute the request to only load from file one thing instead of potentially dozens
    skynet_MainController skynet = ((Game.GetFormFromFile(0x0802, "SkyrimNet.esp") as Quest) As skynet_MainController)
    if !skynet
        Debug.MessageBox("Fatal Error: OpenTrade_IsEligible failed to retrieve controller.")
        return false
    endif

    return skynet.libs.OpenTrade_IsEligible(akActor, contextJson, paramsJson)
EndFunction

; Execution function for a "OpenTrade" action
Function OpenTrade_Execute(Actor akActor, string contextJson, string paramsJson) global
    Debug.Trace("[SkyrimNetInternal] OpenTrade_Execute called for " + akActor.GetDisplayName())
    Debug.Trace("[SkyrimNetInternal] ContextJSON: " + contextJson)
    Debug.Trace("[SkyrimNetInternal] ParamsJSON: " + paramsJson)

    akActor.ShowBarterMenu()
EndFunction


; Eligibility function for an "Animation<type>" action
bool Function Animation_IsEligible(Actor akActor, string contextJson, string paramsJson) global
    Debug.Trace("[SkyrimNetInternal] Animation_IsEligible called for " + akActor.GetDisplayName())

    if akActor.IsInCombat()
        Debug.Trace("[SkyrimNetInternal] Animation_IsEligible: " + akActor.GetDisplayName() + " is in combat. Cannot animate.")
        return false
    endif

    if !akActor.GetRace().IsPlayable()
        Debug.Trace("[SkyrimNetInternal] Animation_IsEligible: " + akActor.GetDisplayName() + " is not a human. Cannot animate.")
        return false
    endif

    if akActor.GetSitState() > 0
        Debug.Trace("[SkyrimNetInternal] Animation_IsEligible: " + akActor.GetDisplayName() + " is using furniture. Cannot animate.")
        return false
    endif

    if SkyrimNetApi.HasPackage(akActor, "FollowPlayer")
        Debug.Trace("[SkyrimNetInternal] Animation_IsEligible: " + akActor.GetDisplayName() + " is following player. Cannot animate.")
        return false
    endif

    Debug.Trace("[SkyrimNetInternal] Animation_IsEligible: " + akActor.GetDisplayName() + " is eligible to animate.")
    return true
EndFunction

Function AnimationGeneric(Actor akOriginator, string contextJson, string paramsJson) global
    if (!akOriginator)
        Debug.Trace("[SkyrimNetInternal] AnimationGeneric: akOriginator is null")
        return
    endif

    String _anim = SkyrimNetApi.GetJsonString(paramsJson, "anim", "none")

    If _anim == "none"
        Debug.Trace("[SkyrimNetInternal] AnimationGeneric: _anim is none")
        return
    endif

    skynet_MainController skynet = ((Game.GetFormFromFile(0x0802, "SkyrimNet.esp") as Quest) As skynet_MainController)
    if !skynet
        Debug.MessageBox("Fatal Error: AnimationGeneric failed to retrieve controller.")
        return
    endif

    Debug.Trace("[SkyrimNetInternal] AnimationGeneric: Playing: " + _anim)
    skynet.libs.PlayGenericAnimation(akOriginator, _anim)
EndFunction

Function AnimationSlapActor(Actor akOriginator, string contextJson, string paramsJson) global
    actor akTarget = SkyrimNetApi.GetJsonActor(paramsJson, "target", Game.GetPlayer())
    sound slapSound = Game.GetFormFromFile(0x0E98, "SkyrimNet.esp") as Sound
    if (!akOriginator || !akTarget)
        Debug.Trace("[SkyrimNetInternal] AnimationSlapActor: akOriginator or akTarget is null")
        return
    endif
    Debug.Trace("[SkyrimNetInternal] AnimationSlapActor: Slapping " + akTarget.GetDisplayName() + " with " + akOriginator.GetDisplayName())
    akTarget.SetDontMove()
    akOriginator.MoveTo(akTarget, 40.0 * Math.Sin(akTarget.GetAngleZ()), 40.0 * Math.Cos(akTarget.GetAngleZ()))
    akOriginator.SetAngle(0.0, 0.0, akTarget.GetAngleZ()+180.0)
    debug.sendanimationevent(akOriginator, "SMplayerslaps")
    slapSound.play(akTarget)
    utility.wait(0.8)
    akOriginator.pushactoraway(akTarget,1)
    akTarget.SetDontMove(false)
EndFunction

Function AnimationPrayer(Actor akOriginator, string contextJson, string paramsJson) global
    GlobalVariable prayAnimationGlobal = Game.GetFormFromFile(0x0E99, "SkyrimNet.esp") as GlobalVariable
    if (!akOriginator)
        Debug.Trace("[SkyrimNetInternal] AnimationPrayer: akOriginator is null")
        return
    endif
    Debug.Trace("[SkyrimNetInternal] AnimationPrayer: Praying with " + akOriginator.GetDisplayName())
    PrayAnimationGlobal.SetValue(10)
    Utility.wait(5)
    PrayAnimationGlobal.SetValue(0)
EndFunction

; Companion stuff
bool Function Companion_IsEligible(Actor akActor, string contextJson, string paramsJson) global
    Debug.Trace("[SkyrimNetInternal] Companion_IsEligible called for " + akActor.GetDisplayName())
    Debug.Trace("[SkyrimNetInternal] Companion_IsEligible: " + akActor.GetDisplayName() + " is eligible (faction check handled by follower tag).")
    return true
EndFunction

Function CompanionInventory(Actor akActor, string contextJson, string paramsJson) global
    Debug.Trace("[SkyrimNetInternal] CompanionInventory called for " + akActor.GetDisplayName())
    Debug.Trace("[SkyrimNetInternal] ContextJSON: " + contextJson)
    Debug.Trace("[SkyrimNetInternal] ParamsJSON: " + paramsJson)

    akActor.OpenInventory()
EndFunction

bool Function CompanionFollow_IsEligible(Actor akActor, string contextJson, string paramsJson) global
    Debug.Trace("[SkyrimNetInternal] CompanionFollow_IsEligible called for " + akActor.GetDisplayName())

    if akActor.GetActorValue("WaitingForPlayer") == 0
        Debug.Trace("[SkyrimNetInternal] CompanionFollow_IsEligible: " + akActor.GetDisplayName() + " is already following.")
        return false
    endif

    Debug.Trace("[SkyrimNetInternal] CompanionFollow_IsEligible: " + akActor.GetDisplayName() + " is eligible (faction check handled by follower tag).")
    return true
EndFunction

Function CompanionFollow(Actor akActor, string contextJson, string paramsJson) global
    Debug.Trace("[SkyrimNetInternal] CompanionFollow called for " + akActor.GetDisplayName())
    Debug.Trace("[SkyrimNetInternal] ContextJSON: " + contextJson)
    Debug.Trace("[SkyrimNetInternal] ParamsJSON: " + paramsJson)

    akActor.SetActorValue("WaitingForPlayer", 0)
    akActor.EvaluatePackage()
EndFunction

bool Function CompanionWait_IsEligible(Actor akActor, string contextJson, string paramsJson) global
    Debug.Trace("[SkyrimNetInternal] CompanionWait_IsEligible called for " + akActor.GetDisplayName())

    if akActor.GetActorValue("WaitingForPlayer") == 1
        Debug.Trace("[SkyrimNetInternal] CompanionWait_IsEligible: " + akActor.GetDisplayName() + " is already waiting.")
        return false
    endif

    Debug.Trace("[SkyrimNetInternal] CompanionWait_IsEligible: " + akActor.GetDisplayName() + " is eligible (faction check handled by follower tag).")
    return true
EndFunction

Function CompanionWait(Actor akActor, string contextJson, string paramsJson) global
    Debug.Trace("[SkyrimNetInternal] CompanionWait called for " + akActor.GetDisplayName())
    Debug.Trace("[SkyrimNetInternal] ContextJSON: " + contextJson)
    Debug.Trace("[SkyrimNetInternal] ParamsJSON: " + paramsJson)

    akActor.SetActorValue("WaitingForPlayer", 1)
    akActor.EvaluatePackage()
EndFunction

bool Function CompanionGiveTask_IsEligible(Actor akActor, string contextJson, string paramsJson) global
    Debug.Trace("[SkyrimNetInternal] CompanionGiveTask_IsEligible called for " + akActor.GetDisplayName())

    if akActor.IsDoingFavor()
        Debug.Trace("[SkyrimNetInternal] CompanionGiveTask_IsEligible: " + akActor.GetDisplayName() + " is already doing a favor.")
        return false
    endif

    Debug.Trace("[SkyrimNetInternal] CompanionGiveTask_IsEligible: " + akActor.GetDisplayName() + " is eligible (faction check handled by follower tag).")
    return true
EndFunction

Function CompanionGiveTask(Actor akActor, string contextJson, string paramsJson) global
    Debug.Trace("[SkyrimNetInternal] CompanionGiveTask called for " + akActor.GetDisplayName())
    Debug.Trace("[SkyrimNetInternal] ContextJSON: " + contextJson)
    Debug.Trace("[SkyrimNetInternal] ParamsJSON: " + paramsJson)

    akActor.SetDoingFavor(true)
EndFunction

; Basic Follow

bool Function StartFollow_IsEligible(Actor akActor, string contextJson, string paramsJson) global
    Debug.Trace("[SkyrimNetInternal] StartFollow_IsEligible called for " + akActor.GetDisplayName())

    skynet_MainController skynet = ((Game.GetFormFromFile(0x0802, "SkyrimNet.esp") as Quest) As skynet_MainController)
    if !skynet
        Debug.MessageBox("Fatal Error: StartFollow_IsEligible failed to retrieve controller.")
        return false
    endif

    return skynet.libs.StartFollow_IsEligible(akActor)
EndFunction

Function StartFollow_Execute(Actor akActor, string contextJson, string paramsJson) global
    Debug.Trace("[SkyrimNetInternal] StartFollow_Execute called for " + akActor.GetDisplayName())
    Debug.Trace("[SkyrimNetInternal] ContextJSON: " + contextJson)
    Debug.Trace("[SkyrimNetInternal] ParamsJSON: " + paramsJson)

    skynet_MainController skynet = ((Game.GetFormFromFile(0x0802, "SkyrimNet.esp") as Quest) As skynet_MainController)
    if !skynet
        Debug.MessageBox("Fatal Error: StartFollow_Execute failed to retrieve controller.")
        return
    endif

    Debug.Trace("[SkyrimNetInternal] StartFollow_Execute: Starting follow on " + akActor.GetDisplayName())
    skynet.libs.StartFollow_Execute(akActor)
EndFunction

bool Function StopFollow_IsEligible(Actor akActor, string contextJson, string paramsJson) global
    Debug.Trace("[SkyrimNetInternal] StopFollow_IsEligible called for " + akActor.GetDisplayName())

    skynet_MainController skynet = ((Game.GetFormFromFile(0x0802, "SkyrimNet.esp") as Quest) As skynet_MainController)
    if !skynet
        Debug.MessageBox("Fatal Error: StopFollow_IsEligible failed to retrieve controller.")
        return false
    endif

    return skynet.libs.StopFollow_IsEligible(akActor)
EndFunction

Function StopFollow_Execute(Actor akActor, string contextJson, string paramsJson) global
    Debug.Trace("[SkyrimNetInternal] StopFollow_Execute called for " + akActor.GetDisplayName())
    Debug.Trace("[SkyrimNetInternal] ContextJSON: " + contextJson)
    Debug.Trace("[SkyrimNetInternal] ParamsJSON: " + paramsJson)

    skynet_MainController skynet = ((Game.GetFormFromFile(0x0802, "SkyrimNet.esp") as Quest) As skynet_MainController)
    if !skynet
        Debug.MessageBox("Fatal Error: StopFollow_Execute failed to retrieve controller.")
        return
    endif

    Debug.Trace("[SkyrimNetInternal] StopFollow_Execute: Starting follow on " + akActor.GetDisplayName())
    skynet.libs.StopFollow_Execute(akActor)
EndFunction

bool Function PauseFollow_IsEligible(Actor akActor, string contextJson, string paramsJson) global
    Debug.Trace("[SkyrimNetInternal] PauseFollow_IsEligible called for " + akActor.GetDisplayName())

    skynet_MainController skynet = ((Game.GetFormFromFile(0x0802, "SkyrimNet.esp") as Quest) As skynet_MainController)
    if !skynet
        Debug.MessageBox("Fatal Error: PauseFollow_IsEligible failed to retrieve controller.")
        return false
    endif

    return skynet.libs.PauseFollow_IsEligible(akActor)
EndFunction

Function PauseFollow_Execute(Actor akActor, string contextJson, string paramsJson) global
    Debug.Trace("[SkyrimNetInternal] PauseFollow_Execute called for " + akActor.GetDisplayName())
    Debug.Trace("[SkyrimNetInternal] ContextJSON: " + contextJson)
    Debug.Trace("[SkyrimNetInternal] ParamsJSON: " + paramsJson)

    skynet_MainController skynet = ((Game.GetFormFromFile(0x0802, "SkyrimNet.esp") as Quest) As skynet_MainController)
    if !skynet
        Debug.MessageBox("Fatal Error: PauseFollow_Execute failed to retrieve controller.")
        return
    endif

    Debug.Trace("[SkyrimNetInternal] PauseFollow_Execute: Starting follow on " + akActor.GetDisplayName())
    skynet.libs.PauseFollow_Execute(akActor)
EndFunction

; Tavern actions
bool Function RentRoom_IsEligible(Actor akActor, string contextJson, string paramsJson) global
    Debug.Trace("[SkyrimNetInternal] RentRoom_IsEligible called for " + akActor.GetDisplayName())

    skynet_MainController skynet = ((Game.GetFormFromFile(0x0802, "SkyrimNet.esp") as Quest) As skynet_MainController)
    if !skynet
        Debug.MessageBox("Fatal Error: RentRoom_IsEligible failed to retrieve controller.")
        return false
    endif

    return skynet.libs.RentRoom_IsEligible(akActor)
EndFunction

Function RentRoom_Execute(Actor akActor, string contextJson, string paramsJson) global
    Debug.Trace("[SkyrimNetInternal] RentRoom_Execute called for " + akActor.GetDisplayName())
    Debug.Trace("[SkyrimNetInternal] ContextJSON: " + contextJson)
    Debug.Trace("[SkyrimNetInternal] ParamsJSON: " + paramsJson)

    skynet_MainController skynet = ((Game.GetFormFromFile(0x0802, "SkyrimNet.esp") as Quest) As skynet_MainController)
    if !skynet
        Debug.MessageBox("Fatal Error: RentRoom_Execute failed to retrieve controller.")
        return
    endif

    Debug.Trace("[SkyrimNetInternal] RentRoom_Execute: Starting follow on " + akActor.GetDisplayName())
    skynet.libs.RentRoom_Execute(akActor, paramsJson)
EndFunction

Function ResetFacialAnimations(Actor akActor) global
    if (akActor.IsOnMount())
        akActor.RegenerateHead()
    else
        akActor.QueueNiNodeUpdate()
    endif
    Int handle = ModEvent.Create("SynthEBD_HeadPartsReloaded")
    if (handle)
        ModEvent.Send(handle)
    endIf
EndFunction

; bool Function GiveBanditBounty_IsEligible(Actor akActor, string contextJson, string paramsJson) global
;     Debug.Trace("[SkyrimNetInternal] GiveBanditBounty_IsEligible called for " + akActor.GetDisplayName())

;     skynet_MainController skynet = ((Game.GetFormFromFile(0x0802, "SkyrimNet.esp") as Quest) As skynet_MainController)
;     if !skynet
;         Debug.MessageBox("Fatal Error: GiveBanditBounty_IsEligible failed to retrieve controller.")
;         return false
;     endif

;     return skynet.libs.GiveBanditBounty_IsEligible(akActor)
; EndFunction

; Function GiveBanditBounty_Execute(Actor akActor, string contextJson, string paramsJson) global
;     Debug.Trace("[SkyrimNetInternal] GiveBanditBounty_Execute called for " + akActor.GetDisplayName())
;     Debug.Trace("[SkyrimNetInternal] ContextJSON: " + contextJson)
;     Debug.Trace("[SkyrimNetInternal] ParamsJSON: " + paramsJson)

;     skynet_MainController skynet = ((Game.GetFormFromFile(0x0802, "SkyrimNet.esp") as Quest) As skynet_MainController)
;     if !skynet
;         Debug.MessageBox("Fatal Error: GiveBanditBounty_Execute failed to retrieve controller.")
;         return
;     endif

;     Debug.Trace("[SkyrimNetInternal] GiveBanditBounty_Execute: Starting follow on " + akActor.GetDisplayName())
;     skynet.libs.GiveBanditBounty_Execute(akActor)
; EndFunction

; -----------------------------------------------------------------------------
; --- General Eligibility Functions ---
; -----------------------------------------------------------------------------

; Always returns true - for actions that only need tag-based eligibility checks
bool Function AlwaysEligible(Actor akActor, string contextJson, string paramsJson) global
    Debug.Trace("[SkyrimNetInternal] AlwaysEligible called for " + akActor.GetDisplayName())
    return true
EndFunction

; -----------------------------------------------------------------------------
; --- Tag Eligibility Functions ---
; -----------------------------------------------------------------------------

; Follower tag eligibility - checks if actor is in companion faction
bool Function Follower_IsEligible(Actor akActor, string contextJson, string paramsJson) global
    Debug.Trace("[SkyrimNetInternal] Follower_IsEligible called for " + akActor.GetDisplayName())
    Faction factionCompanion = Game.GetFormFromFile(0x084D1B, "Skyrim.esm") as Faction
    if (!factionCompanion)
        Debug.Trace("[SkyrimNetInternal] Follower_IsEligible: factionCompanion is null")
        return false
    endif

    if !akActor.IsInFaction(factionCompanion)
        Debug.Trace("[SkyrimNetInternal] Follower_IsEligible: " + akActor.GetDisplayName() + " is not in the companion faction.")
        return false
    endif

    Debug.Trace("[SkyrimNetInternal] Follower_IsEligible: " + akActor.GetDisplayName() + " is eligible as active companion.")
    return true
EndFunction