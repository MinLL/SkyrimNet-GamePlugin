scriptName RealNamesReset extends activemagiceffect

FormList Property UniquesRename Auto
FormList Property NonUniqueNoRename Auto

Bool Function FormListHas(FormList akList, Form akForm)
	If akList == None || akForm == None
		Return False
	EndIf

	Return akList.Find(akForm) >= 0
EndFunction

Bool Function AddActorBaseToExclusionList(Actor akTarget)
	If akTarget == None || NonUniqueNoRename == None
		Return False
	EndIf

	ActorBase TargetBase = akTarget.GetActorBase()
	If TargetBase == None
		TargetBase = akTarget.GetLeveledActorBase()
	EndIf

	If TargetBase == None
		Return False
	EndIf

	If !FormListHas(NonUniqueNoRename, TargetBase)
		NonUniqueNoRename.AddForm(TargetBase)
		Debug.Trace("RealNamesExtended: Added " + TargetBase.GetName() + " to RealNamesNonUniqueNoRename.")
	EndIf

	Return True
EndFunction

Event OnEffectStart(Actor akTarget, Actor akCaster)
	If akTarget == None
		Return
	EndIf

	ActorBase TargetRef = akTarget.GetLeveledActorBase()
	If TargetRef != None && TargetRef.GetName() != ""
		String oldname = TargetRef.GetName()
		akTarget.SetDisplayName(oldname, False)
		StorageUtil.UnsetStringValue(akTarget, "RNE_Name")
	EndIf

	If AddActorBaseToExclusionList(akTarget)
		Debug.Notification("Real Names Extended: actor excluded from future renaming.")
	EndIf
EndEvent
