ScriptName skynet_MainController extends Quest

skynet_Library Property libs Auto
Actor property playerRef Auto Hidden
Spell property skynet_WheelMenuSpell auto
Spell property skynet_VoiceInputDirectSpell auto
Spell property skynet_VoiceInputNormalSpell auto
Spell property skynet_VoiceInputThoughtSpell auto
Spell property skynet_VoiceInputTransformSpell auto

; -----------------------------------------------------------------------------
; --- Version & Maintenance ---
; -----------------------------------------------------------------------------
Event OnInit()
  ; for right now we're okay to start it all right away.
  ; in the future, depending on what we do, we might want to have the user f5-f9 and only initialize on load game
  Maintenance()
EndEvent

Int Property versionCurrent = 0 Auto Hidden

Int Function GetVersion()
  return 1
EndFunction

Int Function GetVersionCutoff()
  return 0
EndFunction

; This runs every game load
Function Maintenance()
  RunUpdate()

  playerRef = Game.GetPlayer()
  libs.Maintenance(self as skynet_MainController)

  AddSpells()

  Info("SkyrimNet version " + versionCurrent + " ready.")
  ; Debug.Notification("SkyrimNet version " + versionCurrent + " ready.")
EndFunction

Function AddSpells()

	If !playerRef.HasSpell(skynet_WheelMenuSpell)
		playerRef.AddSpell(skynet_WheelMenuSpell, False)
	Endif

	; If !playerRef.HasSpell(skynet_VoiceInputDirectSpell)
	;	playerRef.AddSpell(skynet_VoiceInputDirectSpell, False)
	;Endif

	; If !playerRef.HasSpell(skynet_VoiceInputNormalSpell)
	;	playerRef.AddSpell(skynet_VoiceInputNormalSpell, False)
	;Endif

	; If !playerRef.HasSpell(skynet_VoiceInputThoughtSpell)
	;	playerRef.AddSpell(skynet_VoiceInputThoughtSpell, False)
	;Endif

	; If !playerRef.HasSpell(skynet_VoiceInputTransformSpell)
	;	playerRef.AddSpell(skynet_VoiceInputTransformSpell, False)
	;Endif

endfunction

Function RunUpdate()
  Int versionNumber = GetVersion()
  Int versionCutoff = GetVersionCutoff()

  If versionCurrent < versionCutoff
    Fatal("Version is too far out of date. New game required.")
    Debug.MessageBox("Your SkyrimNet plugin version is too far out of date. A new game is required.")
    Return
  EndIf

  If versionCurrent == 0
    ; first time install
    Info("First time install.")
  ElseIf versionCurrent < versionNumber
    Info("Updating to " + versionNumber)
  EndIf

  versionCurrent = versionNumber
EndFunction

; -----------------------------------------------------------------------------
; --- Skynet Conversation Management ---
; -----------------------------------------------------------------------------

; If you pass None as target, we clear the active dialogue target, else set it.
Function SetActorDialogueTarget(Actor akActor, Actor akTarget = None)
  If !akTarget
    ClearActorDialogueTarget(akActor)
    Return
  EndIf

  akActor.SetLookAt(akTarget)
  PO3_SKSEFunctions.SetLinkedRef(akActor, akTarget, libs.keywordDialogueTarget)
  If akTarget == playerRef
    SkyrimNetApi.RegisterPackage(akActor, "TalkToPlayer", 1, 0, False)
  Else
    SkyrimNetApi.RegisterPackage(akActor, "TalkToNPC", 1, 0, False)
  Endif
  akActor.EvaluatePackage()
EndFunction

Function ClearActorDialogueTarget(Actor akActor)
  PO3_SKSEFunctions.SetLinkedRef(akActor, None, libs.keywordDialogueTarget)
  SkyrimNetApi.UnregisterPackage(akActor, "TalkToPlayer")
  SkyrimNetApi.UnregisterPackage(akActor, "TalkToNPC")
  akActor.ClearLookAt()
  akActor.EvaluatePackage()
EndFunction

; -----------------------------------------------------------------------------
; --- Skynet Follower Management ---
; --- Follower: Any following actor.
; -----------------------------------------------------------------------------

Function SetActorFollowing(Actor akActor, Actor akTarget = None, Bool abCompanion = False)
  if akTarget == None
    ClearActorFollowing(akActor)
    return
  endif
  PO3_SKSEFunctions.SetLinkedRef(akActor, akTarget, libs.keywordFollowTarget)
EndFunction

Function ClearActorFollowing(Actor akActor)
  PO3_SKSEFunctions.SetLinkedRef(akActor, None, libs.keywordFollowTarget)
EndFunction

; -----------------------------------------------------------------------------
; --- Skynet Companion Management ---
; --- Companion: The classic followers that carry your burden
; -----------------------------------------------------------------------------



; -----------------------------------------------------------------------------
; --- Debug & Trace Functions ---
; -----------------------------------------------------------------------------
Function Fatal(String str)
  Debug.Trace("[SkyrimNet] (Fatal): " + str)
EndFunction

Function Error(String str)
  Debug.Trace("[SkyrimNet] (Error): " + str)
EndFunction

Function Warn(String str)
  Debug.Trace("[SkyrimNet] (Warn): " + str)
EndFunction

Function Info(String str)
  Debug.Trace("[SkyrimNet] (Info): " + str)
EndFunction

Function Debug(String str)
  Debug.Trace("[SkyrimNet] (Debug): " + str)
EndFunction
