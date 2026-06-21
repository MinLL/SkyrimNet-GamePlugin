Scriptname skynet_WheelMenu extends ActiveMagicEffect  

Event OnEffectStart(Actor akTarget, Actor akCaster)
	
    skynet_WheelMenu.DisplayWheel()

EndEvent

;NOTE - this is the function to call from the DLL
; Text input modes (Think, Transform, Direct, Silent) are handled via prefixes in the PrismaUI chat
Function DisplayWheel() global

    ; Build with explicit slot indices (UIWheelMenu has 8 fixed wedges, 0-7).
    ; Slots 0-4 keep the original layout so existing muscle memory holds; slot 5
    ; is left as a gap and Open Dashboard sits at slot 6 (past Utilities) so the
    ; new entry doesn't shove the original cluster around.
    UIMenuBase wheelMenu = uiextensions.GetMenu("UIWheelMenu")
    wheelMenu = skynet_WheelMenu.SetWheelEntry(wheelMenu, 0, "Text Input", "Text Input")
    wheelMenu = skynet_WheelMenu.SetWheelEntry(wheelMenu, 1, "Think to Self", "Think to Self")
    wheelMenu = skynet_WheelMenu.SetWheelEntry(wheelMenu, 2, "Auto Roleplay", "Auto Roleplay")
    wheelMenu = skynet_WheelMenu.SetWheelEntry(wheelMenu, 3, "Toggle Whisper Mode", "Toggle Whisper Mode")
    wheelMenu = skynet_WheelMenu.SetWheelEntry(wheelMenu, 4, "Utilities", "Utilities Menu")
    wheelMenu = skynet_WheelMenu.SetWheelEntry(wheelMenu, 5, "", "", false)
    wheelMenu = skynet_WheelMenu.SetWheelEntry(wheelMenu, 6, "Open Dashboard", "Open Dashboard")
    wheelMenu = skynet_WheelMenu.SetWheelEntry(wheelMenu, 7, "", "", false)

    int result = wheelMenu.OpenMenu()

    if result == 0
        ; Text input — use prefixes for modes: % Think, ' Transform, ! Direct, /silent Silent
        SkyrimNetApi.TriggerTextInput()
    elseif result == 1
        ; Direct player thought processing
        SkyrimNetApi.TriggerPlayerThought()
    elseif result == 2
        ; Direct player dialogue processing
        SkyrimNetApi.TriggerPlayerDialogue()
    elseif result == 3
        ; Toggle whisper mode
        SkyrimNetApi.TriggerToggleWhisperMode()
    elseif result == 4
        ; Utilities submenu
        skynet_WheelMenu.DisplayUtilities()
    elseif result == 6
        ; Toggle the in-game dashboard. Note: UIExtensions menus generally don't
        ; render in VR, so the bindable "Open Dashboard" Papyrus hotkey is the
        ; real VR path — this wheel entry is the convenience path for flatrim.
        SkyrimNetApi.TriggerToggleDashboard()
    endif

EndFunction

Function DisplayUtilities() global

    string labels = "Go Back,Toggle GameMaster,Toggle NPC Reactions,Toggle Actions,Continue Narration,Toggle Continuous Mode,Interrupt Dialogue"
    string options = "Go Back,Toggle GameMaster,Toggle NPC Reactions,Toggle Actions,Continue Narration,Toggle Continuous Mode,Interrupt Dialogue"

    ; Option 7: White/Blacklist management only if there's a target under the crosshair
    Actor akTarget = GetTargetFromCrosshair()
    If akTarget
        labels += ",White/Blacklist Mgmt"
        options += ",White/Blacklist Mgmt"
    EndIf

    int result = skynet_WheelMenu.MenuWheel(StringUtil.Split(options, ","), StringUtil.Split(labels, ","))

    if result == 0
        skynet_WheelMenu.DisplayWheel()
    elseif result == 1
        ; Toggle GameMaster
        SkyrimNetApi.TriggerToggleGameMaster()
    elseif result == 2
        ; Toggle NPC reactions to world events
        SkyrimNetApi.TriggerToggleWorldEventReactions()
    elseif result == 3
        ; Toggle runtime master switch for NPC actions (embedded + separate-call flows)
        SkyrimNetApi.TriggerToggleActions()
    elseif result == 4
        ; Continue narration
        SkyrimNetApi.TriggerContinueNarration()
    elseif result == 5
        ; Toggle continuous mode
        SkyrimNetApi.TriggerToggleContinuousMode()
    elseif result == 6
        ; Interrupt all ongoing dialogue
        SkyrimNetApi.TriggerInterruptDialogue()
    elseif result == 7
        ; White/Blacklist management submenu
        ; This option only appears if there's a target under the crosshair
        skynet_WheelMenu.DisplayFactionManagement(akTarget)
    endif
EndFunction

Function DisplayFactionManagement(Actor akTarget) global
    Faction ActorWhitelistFaction = Game.GetFormFromFile(0x12DA, "SkyrimNet.esp") as Faction
    Faction ActorBlacklistFaction = Game.GetFormFromFile(0x12DB, "SkyrimNet.esp") as Faction

    UIMenuBase wheelMenu = uiextensions.GetMenu("UIWheelMenu")
    If akTarget.IsInFaction(ActorWhitelistFaction)
        wheelMenu = skynet_WheelMenu.SetWheelEntry(wheelMenu, 0, "Actor: Clear", "Remove from Whitelist")
        wheelMenu = skynet_WheelMenu.SetWheelEntry(wheelMenu, 1, "Actor: Blacklist", akTarget.GetDisplayName() + " -> Blacklist")
    ElseIf akTarget.IsInFaction(ActorBlacklistFaction)
        wheelMenu = skynet_WheelMenu.SetWheelEntry(wheelMenu, 0, "Actor: Clear", "Remove from Blacklist")
        wheelMenu = skynet_WheelMenu.SetWheelEntry(wheelMenu, 1, "Actor: Whitelist", akTarget.GetDisplayName() + " -> Whitelist")
    Else
        wheelMenu = skynet_WheelMenu.SetWheelEntry(wheelMenu, 0, "Actor: Whitelist", akTarget.GetDisplayName() + " -> Whitelist")
        wheelMenu = skynet_WheelMenu.SetWheelEntry(wheelMenu, 1, "Actor: Blacklist", akTarget.GetDisplayName() + " -> Blacklist")
    EndIf

    ;/
    If akTarget.IsInFaction(MemoryWhitelistFaction)
        wheelMenu = skynet_WheelMenu.SetWheelEntry(wheelMenu, 4, "Memory: Clear", "Remove from Whitelist")
        wheelMenu = skynet_WheelMenu.SetWheelEntry(wheelMenu, 5, "Memory: Blacklist", akTarget.GetDisplayName() + " -> Blacklist")
    ElseIf akTarget.IsInFaction(MemoryBlacklistFaction)
        wheelMenu = skynet_WheelMenu.SetWheelEntry(wheelMenu, 4, "Memory: Clear", "Remove from Blacklist")
        wheelMenu = skynet_WheelMenu.SetWheelEntry(wheelMenu, 5, "Memory: Whitelist", akTarget.GetDisplayName() + " -> Whitelist")
    Else
        wheelMenu = skynet_WheelMenu.SetWheelEntry(wheelMenu, 4, "Memory: Whitelist", akTarget.GetDisplayName() + " -> Whitelist")
        wheelMenu = skynet_WheelMenu.SetWheelEntry(wheelMenu, 5, "Memory: Blacklist", akTarget.GetDisplayName() + " -> Blacklist")
    EndIf
    /;

    int result = wheelMenu.OpenMenu()
    If akTarget.IsInFaction(ActorWhitelistFaction)
        ; Actor is whitelisted
        If result == 0
            akTarget.RemoveFromFaction(ActorWhitelistFaction)
        ElseIf result == 1
            akTarget.RemoveFromFaction(ActorWhitelistFaction)
            akTarget.AddToFaction(ActorBlacklistFaction)
        EndIf
    ElseIf akTarget.IsInFaction(ActorBlacklistFaction)
        ; Actor is blacklisted
        If result == 0
            akTarget.RemoveFromFaction(ActorBlacklistFaction)
        ElseIf result == 1
            akTarget.RemoveFromFaction(ActorBlacklistFaction)
            akTarget.AddToFaction(ActorWhitelistFaction)
        EndIf
    Else
        ; Actor is neither whitelisted nor blacklisted
        If result == 0
            akTarget.AddToFaction(ActorWhitelistFaction)
        ElseIf result == 1
            akTarget.AddToFaction(ActorBlacklistFaction)
        EndIf
    EndIf
EndFunction

int Function MenuWheel(String[] options, string[] labels) global
    UIMenuBase wheelMenu = uiextensions.GetMenu("UIWheelMenu")
    int i = 0
    int count = options.length 
    while i < count 
        wheelMenu.SetPropertyIndexString(PropertyName = "optionText", index = i, value = options[i])
        wheelMenu.SetPropertyIndexString(PropertyName = "optionLabelText", index = i, value = labels[i])
        wheelMenu.SetPropertyIndexBool("optionEnabled", i, true)
        i += 1
    endwhile 
    return wheelMenu.OpenMenu()
EndFunction

UIMenuBase Function SetWheelEntry(UIMenuBase menu, int menuIndex, string label, string text, bool enabled = true) global
    if(menuIndex > 7)
        ; Menu index out of bounds
        return menu
    endif
    menu.SetPropertyIndexbool(PropertyName = "optionEnabled", index = menuIndex, value = enabled)
    menu.SetPropertyIndexString(PropertyName = "optionText", index = menuIndex, value = text)
    menu.SetPropertyIndexString(PropertyName = "optionLabelText", index = menuIndex, value = label)
    return menu
EndFunction

Actor Function GetTargetFromCrosshair() global
    Actor targetRef = (Game.GetCurrentCrosshairRef() as Actor)
    If targetRef
		Return targetRef
    Else
        Return None
	EndIf
EndFunction