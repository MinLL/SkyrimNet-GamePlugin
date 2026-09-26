scriptname SkyrimNetInternal

; Functions from within this file are executed directly by the main DLL.
; Do not change or touch them, or you risk stability issues.

Bool Function ClearTimelineMessage() global
    skynet_MainController skynet = ((Game.GetFormFromFile(0x0802, "SkyrimNet.esp") as Quest) As skynet_MainController)
    if !skynet
        Debug.MessageBox("Fatal Error: ClearTimelineMessage failed to retrieve controller.")
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

; Returns: 0 = Player Only, 1 = Nearby Actors, 2 = Pinned Actors, 3 = Target in Crosshair, -1 = Cancelled/Error
Int Function GetDiaryScopeMessage() global
    Debug.Trace("[SkyrimNetInternal] GetDiaryScopeMessage called")
    skynet_MainController skynet = ((Game.GetFormFromFile(0x0802, "SkyrimNet.esp") as Quest) As skynet_MainController)
    if !skynet
        Debug.MessageBox("Fatal Error: GetDiaryScopeMessage failed to retrieve controller.")
        return -1
    endif

    Int _selection = skynet.libs.msgDiaryScope.Show()
    Debug.Trace("[SkyrimNetInternal] GetDiaryScopeMessage: User selected " + _selection)
    if _selection == 4
        Debug.Trace("[SkyrimNetInternal] GetDiaryScopeMessage: User cancelled")
        return -1
    endif
    return _selection
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

; -----------------------------------------------------------------------------
; --- Player Input Handlers ---
; -----------------------------------------------------------------------------

string Function GetPlayerInput() global
    Debug.Trace("[SkyrimNetInternal] GetPlayerInput: Papyrus text input removed, use PrismaUI")
    return ""
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

Function ResetFacialAnimations(Actor akActor) global
    if (akActor.IsOnMount())
        akActor.RegenerateHead()
    else
        akActor.QueueNiNodeUpdate()
    endif
EndFunction

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