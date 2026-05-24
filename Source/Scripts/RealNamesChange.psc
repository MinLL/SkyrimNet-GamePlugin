scriptName RealNamesChange extends Quest

GlobalVariable Property RNBandit Auto
GlobalVariable Property RNForsworn Auto
GlobalVariable Property RNGuard Auto
GlobalVariable Property RNStendarr Auto
GlobalVariable Property RNThalmor Auto
GlobalVariable Property RNVampire Auto
GlobalVariable Property RNDragon Auto
GlobalVariable Property RNDragonPriest Auto
GlobalVariable Property RNDaedra Auto
GlobalVariable Property RNCreature Auto
GlobalVariable Property RNOther Auto

GlobalVariable Property RNDoLastNames Auto

GlobalVariable Property RNQuestName Auto

Faction Property FacBandit Auto
Faction Property FacForsworn Auto
Faction Property FacHagraven Auto
Faction Property FacGuard Auto
Faction Property FacStendarr Auto
Faction Property FacThalmor Auto
Faction Property FacVampire Auto
Faction Property FacVampireThrall Auto
Faction Property FacDragon Auto
Faction Property FacDragonPriest Auto
Faction Property FacDaedra Auto
Faction Property FacCreature Auto

FormList Property UniquesRename Auto
FormList Property NonUniqueNoRename Auto

Bool Function FormListHas(FormList akList, Form akForm)
	If akList == None || akForm == None
		Return False
	EndIf

	Return akList.Find(akForm) >= 0
EndFunction

Bool Function ShouldRenameActor(Actor akTarget)
	If akTarget == None
		Return False
	EndIf

	ActorBase TargetRef = akTarget.GetLeveledActorBase()
	ActorBase TargetBase = akTarget.GetActorBase()

	Bool ForceRename = FormListHas(UniquesRename, TargetRef) || FormListHas(UniquesRename, TargetBase)
	Bool BlockRename = FormListHas(NonUniqueNoRename, TargetRef) || FormListHas(NonUniqueNoRename, TargetBase)
	Bool TargetIsUnique = False

	If TargetRef != None && TargetRef.IsUnique()
		TargetIsUnique = True
	EndIf

	If TargetBase != None && TargetBase.IsUnique()
		TargetIsUnique = True
	EndIf

	Debug.Trace("RealNamesExtended: ForceRename = " + ForceRename)
	Debug.Trace("RealNamesExtended: BlockRename = " + BlockRename)
	Debug.Trace("RealNamesExtended: TargetIsUnique = " + TargetIsUnique)

	If BlockRename
		; Explicit exclusions win even if an actor is also present in RealNamesUniqueRename.
		Return False
	EndIf

	If TargetIsUnique && !ForceRename
		Return False
	EndIf

	Return True
EndFunction

Function ChangeName(Actor akTarget, String newFirstName, String newLastName)

	If !ShouldRenameActor(akTarget)
		; Debug.Notification("Target is a unique NPC. You cannot change its name!")
		Return
	EndIf

	If RNQuestName.GetValue() as int == 0
		QuestNameFalse(akTarget, newFirstName, newLastName)
	Else
		QuestNameTrue(akTarget, newFirstName, newLastName)
	EndIf

EndFunction



Function QuestNameFalse(Actor akTarget, String newFirstName, String newLastName)

	ActorBase TargetRef = akTarget.GetLeveledActorBase()
	; ; Debug.Trace("RealNamesExtended: akTarget.IsInFaction(FacBandit) = " + akTarget.IsInFaction(FacBandit))
	IF akTarget.IsInFaction(FacBandit)
    String oldname = TargetRef.GetName()
		Int RNBanditGV = RNBandit.GetValue() as int
		If RNBanditGV == 0
			Return
		ElseIf RNBanditGV == 1
			string newName = newFirstName
			if (RNDoLastNames.GetValue() == 1 && newLastName != "")
				newName += " " + newLastName
			endif
			if (StorageUtil.HasStringValue(akTarget, "RNE_Name"))
				newName = StorageUtil.GetStringValue(akTarget, "RNE_Name")
			Else
				StorageUtil.SetStringValue(akTarget, "RNE_Name", newName)
			EndIf
			akTarget.SetDisplayName(newName + " ["+oldName+"]", False)
			Return
		ElseIf RNBanditGV == 2
			string newName = newFirstName
			if (RNDoLastNames.GetValue() == 1 && newLastName != "")
				newName += " " + newLastName
			endif
			if (StorageUtil.HasStringValue(akTarget, "RNE_Name"))
				newName = StorageUtil.GetStringValue(akTarget, "RNE_Name")
			Else
				StorageUtil.SetStringValue(akTarget, "RNE_Name", newName)
			EndIf
			akTarget.SetDisplayName(newName + " ["+oldName+"]", False)
			Return
		Endif	
	Endif
	; ; Debug.Trace("RealNamesExtended: akTarget.IsInFaction(FacForsworn) = " + akTarget.IsInFaction(FacForsworn))
	; ; Debug.Trace("RealNamesExtended: akTarget.IsInFaction(FacHagraven) = " + akTarget.IsInFaction(FacHagraven))
	IF akTarget.IsInFaction(FacForsworn) || akTarget.IsInFaction(FacHagraven)
    String oldname = TargetRef.GetName()
		Int RNForswornGV = RNForsworn.GetValue() as int
		If RNForswornGV == 0
			Return
		ElseIf RNForswornGV == 1
			string newName = newFirstName
			if (RNDoLastNames.GetValue() == 1 && newLastName != "")
				newName += " " + newLastName
			endif
			if (StorageUtil.HasStringValue(akTarget, "RNE_Name"))
				newName = StorageUtil.GetStringValue(akTarget, "RNE_Name")
			Else
				StorageUtil.SetStringValue(akTarget, "RNE_Name", newName)
			EndIf
			akTarget.SetDisplayName(newName + " ["+oldName+"]", False)
			Return
		ElseIf RNForswornGV == 2
			string newName = newFirstName
			if (RNDoLastNames.GetValue() == 1 && newLastName != "")
				newName += " " + newLastName
			endif
			if (StorageUtil.HasStringValue(akTarget, "RNE_Name"))
				newName = StorageUtil.GetStringValue(akTarget, "RNE_Name")
			Else
				StorageUtil.SetStringValue(akTarget, "RNE_Name", newName)
			EndIf
			akTarget.SetDisplayName(newName + " ["+oldName+"]", False)
			Return
		Endif	
	Endif
	; Debug.Trace("RealNamesExtended: akTarget.IsInFaction(FacGuard) = " + akTarget.IsInFaction(FacGuard))
	IF akTarget.IsInFaction(FacGuard)
    String oldname = TargetRef.GetName()
		Int RNGuardGV = RNGuard.GetValue() as int
		If RNGuardGV == 0
			Return
		ElseIf RNGuardGV == 1
			string newName = newFirstName
			if (RNDoLastNames.GetValue() == 1 && newLastName != "")
				newName += " " + newLastName
			endif
			if (StorageUtil.HasStringValue(akTarget, "RNE_Name"))
				newName = StorageUtil.GetStringValue(akTarget, "RNE_Name")
			Else
				StorageUtil.SetStringValue(akTarget, "RNE_Name", newName)
			EndIf
			akTarget.SetDisplayName(newName + " ["+oldName+"]", False)
			Return
		ElseIf RNGuardGV == 2
			string newName = newFirstName
			if (RNDoLastNames.GetValue() == 1 && newLastName != "")
				newName += " " + newLastName
			endif
			if (StorageUtil.HasStringValue(akTarget, "RNE_Name"))
				newName = StorageUtil.GetStringValue(akTarget, "RNE_Name")
			Else
				StorageUtil.SetStringValue(akTarget, "RNE_Name", newName)
			EndIf
			akTarget.SetDisplayName(newName + " ["+oldName+"]", False)
			Return
		Endif	
	Endif
	; Debug.Trace("RealNamesExtended: akTarget.IsInFaction(FacStendarr) = " + akTarget.IsInFaction(FacStendarr))
	IF akTarget.IsInFaction(FacStendarr)
    String oldname = TargetRef.GetName()
		Int RNStendarrGV = RNStendarr.GetValue() as int
		If RNStendarrGV == 0
			Return
		ElseIf RNStendarrGV == 1
			string newName = newFirstName
			if (RNDoLastNames.GetValue() == 1 && newLastName != "")
				newName += " " + newLastName
			endif
			if (StorageUtil.HasStringValue(akTarget, "RNE_Name"))
				newName = StorageUtil.GetStringValue(akTarget, "RNE_Name")
			Else
				StorageUtil.SetStringValue(akTarget, "RNE_Name", newName)
			EndIf
			akTarget.SetDisplayName(newName + " ["+oldName+"]", False)
			Return
		ElseIf RNStendarrGV == 2
			string newName = newFirstName
			if (RNDoLastNames.GetValue() == 1 && newLastName != "")
				newName += " " + newLastName
			endif
			if (StorageUtil.HasStringValue(akTarget, "RNE_Name"))
				newName = StorageUtil.GetStringValue(akTarget, "RNE_Name")
			Else
				StorageUtil.SetStringValue(akTarget, "RNE_Name", newName)
			EndIf
			akTarget.SetDisplayName(newName + " ["+oldName+"]", False)
			Return
		Endif	
	Endif
	; Debug.Trace("RealNamesExtended: akTarget.IsInFaction(FacThalmor) = " + akTarget.IsInFaction(FacThalmor))
	IF akTarget.IsInFaction(FacThalmor)
    String oldname = TargetRef.GetName()
		Int RNThalmorGV = RNThalmor.GetValue() as int
		If RNThalmorGV == 0
			Return
		ElseIf RNThalmorGV == 1
			string newName = newFirstName
			if (RNDoLastNames.GetValue() == 1 && newLastName != "")
				newName += " " + newLastName
			endif
			if (StorageUtil.HasStringValue(akTarget, "RNE_Name"))
				newName = StorageUtil.GetStringValue(akTarget, "RNE_Name")
			Else
				StorageUtil.SetStringValue(akTarget, "RNE_Name", newName)
			EndIf
			akTarget.SetDisplayName(newName + " ["+oldName+"]", False)
			Return
		ElseIf RNThalmorGV == 2
			string newName = newFirstName
			if (RNDoLastNames.GetValue() == 1 && newLastName != "")
				newName += " " + newLastName
			endif
			if (StorageUtil.HasStringValue(akTarget, "RNE_Name"))
				newName = StorageUtil.GetStringValue(akTarget, "RNE_Name")
			Else
				StorageUtil.SetStringValue(akTarget, "RNE_Name", newName)
			EndIf
			akTarget.SetDisplayName(newName + " ["+oldName+"]", False)
			Return
		Endif	
	Endif
	; Debug.Trace("RealNamesExtended: akTarget.IsInFaction(FacVampire) = " + akTarget.IsInFaction(FacVampire))
	; Debug.Trace("RealNamesExtended: akTarget.IsInFaction(FacVampireThrall) = " + akTarget.IsInFaction(FacVampireThrall))
	IF akTarget.IsInFaction(FacVampire) || akTarget.IsInFaction(FacVampireThrall)
    String oldname = TargetRef.GetName()
		Int RNVampireGV = RNVampire.GetValue() as int
		If RNVampireGV == 0
			Return
		ElseIf RNVampireGV == 1
			string newName = newFirstName
			if (RNDoLastNames.GetValue() == 1 && newLastName != "")
				newName += " " + newLastName
			endif
			if (StorageUtil.HasStringValue(akTarget, "RNE_Name"))
				newName = StorageUtil.GetStringValue(akTarget, "RNE_Name")
			Else
				StorageUtil.SetStringValue(akTarget, "RNE_Name", newName)
			EndIf
			akTarget.SetDisplayName(newName + " ["+oldName+"]", False)
			Return
		ElseIf RNVampireGV == 2
			string newName = newFirstName
			if (RNDoLastNames.GetValue() == 1 && newLastName != "")
				newName += " " + newLastName
			endif
			if (StorageUtil.HasStringValue(akTarget, "RNE_Name"))
				newName = StorageUtil.GetStringValue(akTarget, "RNE_Name")
			Else
				StorageUtil.SetStringValue(akTarget, "RNE_Name", newName)
			EndIf
			akTarget.SetDisplayName(newName + " ["+oldName+"]", False)
			Return
		Endif	
	Endif

	; Debug.Trace("RealNamesExtended: akTarget.IsInFaction(FacDragon) = " + akTarget.IsInFaction(FacDragon))
	IF akTarget.IsInFaction(FacDragon)
    String oldname = TargetRef.GetName()
		Int RNDragonGV = RNDragon.GetValue() as int
		; Debug.Trace("RNDragonGV = " + RNDragonGV)
		If RNDragonGV == 0
			Return
		ElseIf RNDragonGV == 1
			string newName = newFirstName
			if (RNDoLastNames.GetValue() == 1 && newLastName != "")
				newName += " " + newLastName
			endif
			if (StorageUtil.HasStringValue(akTarget, "RNE_Name"))
				newName = StorageUtil.GetStringValue(akTarget, "RNE_Name")
			Else
				StorageUtil.SetStringValue(akTarget, "RNE_Name", newName)
			EndIf
			akTarget.SetDisplayName(newName + " ["+oldName+"]", False)
			Return
		ElseIf RNDragonGV == 2
			string newName = newFirstName
			if (RNDoLastNames.GetValue() == 1 && newLastName != "")
				newName += " " + newLastName
			endif
			if (StorageUtil.HasStringValue(akTarget, "RNE_Name"))
				newName = StorageUtil.GetStringValue(akTarget, "RNE_Name")
			Else
				StorageUtil.SetStringValue(akTarget, "RNE_Name", newName)
			EndIf
			akTarget.SetDisplayName(newName + " ["+oldName+"]", False)
			Return
		Endif	
	Endif

	; Debug.Trace("RealNamesExtended: akTarget.IsInFaction(FacDragonPriest) = " + akTarget.IsInFaction(FacDragonPriest))
	IF akTarget.IsInFaction(FacDragonPriest)
    String oldname = TargetRef.GetName()
		Int RNDragonPriestGV = RNDragonPriest.GetValue() as int
		; Debug.Trace("RNDragonPriestGV = " + RNDragonPriestGV)
		If RNDragonPriestGV == 0
			Return
		ElseIf RNDragonPriestGV == 1
			string newName = newFirstName
			if (RNDoLastNames.GetValue() == 1 && newLastName != "")
				newName += " " + newLastName
			endif
			if (StorageUtil.HasStringValue(akTarget, "RNE_Name"))
				newName = StorageUtil.GetStringValue(akTarget, "RNE_Name")
			Else
				StorageUtil.SetStringValue(akTarget, "RNE_Name", newName)
			EndIf
			akTarget.SetDisplayName(newName + " ["+oldName+"]", False)
			Return
		ElseIf RNDragonPriestGV == 2
			string newName = newFirstName
			if (RNDoLastNames.GetValue() == 1 && newLastName != "")
				newName += " " + newLastName
			endif
			if (StorageUtil.HasStringValue(akTarget, "RNE_Name"))
				newName = StorageUtil.GetStringValue(akTarget, "RNE_Name")
			Else
				StorageUtil.SetStringValue(akTarget, "RNE_Name", newName)
			EndIf
			akTarget.SetDisplayName(newName + " ["+oldName+"]", False)
			Return
		Endif	
	Endif

	; Debug.Trace("RealNamesExtended: akTarget.IsInFaction(FacDaedra) = " + akTarget.IsInFaction(FacDaedra))
	IF akTarget.IsInFaction(FacDaedra)
    String oldname = TargetRef.GetName()
		Int RNDaedraGV = RNDaedra.GetValue() as int
		; Debug.Trace("RNDaedraGV = " + RNDaedraGV)
		If RNDaedraGV == 0
			Return
		ElseIf RNDaedraGV == 1
			string newName = newFirstName
			if (RNDoLastNames.GetValue() == 1 && newLastName != "")
				newName += " " + newLastName
			endif
			if (StorageUtil.HasStringValue(akTarget, "RNE_Name"))
				newName = StorageUtil.GetStringValue(akTarget, "RNE_Name")
			Else
				StorageUtil.SetStringValue(akTarget, "RNE_Name", newName)
			EndIf
			akTarget.SetDisplayName(newName + " ["+oldName+"]", False)
			Return
		ElseIf RNDaedraGV == 2
			string newName = newFirstName
			if (RNDoLastNames.GetValue() == 1 && newLastName != "")
				newName += " " + newLastName
			endif
			if (StorageUtil.HasStringValue(akTarget, "RNE_Name"))
				newName = StorageUtil.GetStringValue(akTarget, "RNE_Name")
			Else
				StorageUtil.SetStringValue(akTarget, "RNE_Name", newName)
			EndIf
			akTarget.SetDisplayName(newName + " ["+oldName+"]", False)
			Return
		Endif	
	Endif

	; Debug.Trace("RealNamesExtended: akTarget.IsInFaction(FacCreature) = " + akTarget.IsInFaction(FacCreature))
	IF akTarget.IsInFaction(FacCreature)
    String oldname = TargetRef.GetName()
		Int RNCreatureGV = RNCreature.GetValue() as int
		; Debug.Trace("RNCreatureGV = " + RNCreatureGV)
		If RNCreatureGV == 0
			Return
		ElseIf RNCreatureGV == 1
			string newName = newFirstName
			if (RNDoLastNames.GetValue() == 1 && newLastName != "")
				newName += " " + newLastName
			endif
			if (StorageUtil.HasStringValue(akTarget, "RNE_Name"))
				newName = StorageUtil.GetStringValue(akTarget, "RNE_Name")
			Else
				StorageUtil.SetStringValue(akTarget, "RNE_Name", newName)
			EndIf
			akTarget.SetDisplayName(newName + " ["+oldName+"]", False)
			Return
		ElseIf RNCreatureGV == 2
			string newName = newFirstName
			if (RNDoLastNames.GetValue() == 1 && newLastName != "")
				newName += " " + newLastName
			endif
			if (StorageUtil.HasStringValue(akTarget, "RNE_Name"))
				newName = StorageUtil.GetStringValue(akTarget, "RNE_Name")
			Else
				StorageUtil.SetStringValue(akTarget, "RNE_Name", newName)
			EndIf
			akTarget.SetDisplayName(newName + " ["+oldName+"]", False)
			Return
		Endif	
	Endif

	; Debug.Trace("RealNamesExtended: Target falls under 'Other'")
		Int RNOtherGV = RNOther.GetValue() as int
		If RNOtherGV == 0
			Return
		ElseIf RNOtherGV == 1
			string newName = newFirstName
			if (RNDoLastNames.GetValue() == 1 && newLastName != "")
				newName += " " + newLastName
			endif
			if (StorageUtil.HasStringValue(akTarget, "RNE_Name"))
				newName = StorageUtil.GetStringValue(akTarget, "RNE_Name")
			Else
				StorageUtil.SetStringValue(akTarget, "RNE_Name", newName)
			EndIf
      String oldname = TargetRef.GetName()
			akTarget.SetDisplayName(newName + " ["+oldName+"]", False)
			Return
		ElseIf RNOtherGV == 2
			string newName = newFirstName
			if (RNDoLastNames.GetValue() == 1 && newLastName != "")
				newName += " " + newLastName
			endif
			if (StorageUtil.HasStringValue(akTarget, "RNE_Name"))
				newName = StorageUtil.GetStringValue(akTarget, "RNE_Name")
			Else
				StorageUtil.SetStringValue(akTarget, "RNE_Name", newName)
			EndIf
      String oldname = TargetRef.GetName()
			akTarget.SetDisplayName(newName + " ["+oldName+"]", False)
			Return
		Endif	

EndFunction



Function QuestNameTrue(Actor akTarget, String newFirstName, String newLastName)

	ActorBase TargetRef = akTarget.GetLeveledActorBase()

	IF akTarget.IsInFaction(FacBandit)
    String oldname = TargetRef.GetName()
		Int RNBanditGV = RNBandit.GetValue() as int
		If RNBanditGV == 0
			Return
		ElseIf RNBanditGV == 1
			string newName = newFirstName
			if (RNDoLastNames.GetValue() == 1 && newLastName != "")
				newName += " " + newLastName
			endif
			if (StorageUtil.HasStringValue(akTarget, "RNE_Name"))
				newName = StorageUtil.GetStringValue(akTarget, "RNE_Name")
			Else
				StorageUtil.SetStringValue(akTarget, "RNE_Name", newName)
			EndIf
			akTarget.SetDisplayName(newName + " ["+oldName+"]", True)
			Return
		ElseIf RNBanditGV == 2
			string newName = newFirstName
			if (RNDoLastNames.GetValue() == 1 && newLastName != "")
				newName += " " + newLastName
			endif
			if (StorageUtil.HasStringValue(akTarget, "RNE_Name"))
				newName = StorageUtil.GetStringValue(akTarget, "RNE_Name")
			Else
				StorageUtil.SetStringValue(akTarget, "RNE_Name", newName)
			EndIf
			akTarget.SetDisplayName(newName + " ["+oldName+"]", True)
			Return
		Endif	
	Endif

	IF akTarget.IsInFaction(FacForsworn) || akTarget.IsInFaction(FacHagraven)
    String oldname = TargetRef.GetName()
		Int RNForswornGV = RNForsworn.GetValue() as int
		If RNForswornGV == 0
			Return
		ElseIf RNForswornGV == 1
			string newName = newFirstName
			if (RNDoLastNames.GetValue() == 1 && newLastName != "")
				newName += " " + newLastName
			endif
			if (StorageUtil.HasStringValue(akTarget, "RNE_Name"))
				newName = StorageUtil.GetStringValue(akTarget, "RNE_Name")
			Else
				StorageUtil.SetStringValue(akTarget, "RNE_Name", newName)
			EndIf
			akTarget.SetDisplayName(newName + " ["+oldName+"]", True)
			Return
		ElseIf RNForswornGV == 2
			string newName = newFirstName
			if (RNDoLastNames.GetValue() == 1 && newLastName != "")
				newName += " " + newLastName
			endif
			if (StorageUtil.HasStringValue(akTarget, "RNE_Name"))
				newName = StorageUtil.GetStringValue(akTarget, "RNE_Name")
			Else
				StorageUtil.SetStringValue(akTarget, "RNE_Name", newName)
			EndIf
			akTarget.SetDisplayName(newName + " ["+oldName+"]", True)
			Return
		Endif	
	Endif

	IF akTarget.IsInFaction(FacGuard)
    String oldname = TargetRef.GetName()
		Int RNGuardGV = RNGuard.GetValue() as int
		If RNGuardGV == 0
			Return
		ElseIf RNGuardGV == 1
			string newName = newFirstName
			if (RNDoLastNames.GetValue() == 1 && newLastName != "")
				newName += " " + newLastName
			endif
			if (StorageUtil.HasStringValue(akTarget, "RNE_Name"))
				newName = StorageUtil.GetStringValue(akTarget, "RNE_Name")
			Else
				StorageUtil.SetStringValue(akTarget, "RNE_Name", newName)
			EndIf
			akTarget.SetDisplayName(newName + " ["+oldName+"]", True)
			Return
		ElseIf RNGuardGV == 2
			string newName = newFirstName
			if (RNDoLastNames.GetValue() == 1 && newLastName != "")
				newName += " " + newLastName
			endif
			if (StorageUtil.HasStringValue(akTarget, "RNE_Name"))
				newName = StorageUtil.GetStringValue(akTarget, "RNE_Name")
			Else
				StorageUtil.SetStringValue(akTarget, "RNE_Name", newName)
			EndIf
			akTarget.SetDisplayName(newName + " ["+oldName+"]", True)
			Return
		Endif	
	Endif

	IF akTarget.IsInFaction(FacStendarr)
    String oldname = TargetRef.GetName()
		Int RNStendarrGV = RNStendarr.GetValue() as int
		If RNStendarrGV == 0
			Return
		ElseIf RNStendarrGV == 1
			string newName = newFirstName
			if (RNDoLastNames.GetValue() == 1 && newLastName != "")
				newName += " " + newLastName
			endif
			if (StorageUtil.HasStringValue(akTarget, "RNE_Name"))
				newName = StorageUtil.GetStringValue(akTarget, "RNE_Name")
			Else
				StorageUtil.SetStringValue(akTarget, "RNE_Name", newName)
			EndIf
			akTarget.SetDisplayName(newName + " ["+oldName+"]", True)
			Return
		ElseIf RNStendarrGV == 2
			string newName = newFirstName
			if (RNDoLastNames.GetValue() == 1 && newLastName != "")
				newName += " " + newLastName
			endif
			if (StorageUtil.HasStringValue(akTarget, "RNE_Name"))
				newName = StorageUtil.GetStringValue(akTarget, "RNE_Name")
			Else
				StorageUtil.SetStringValue(akTarget, "RNE_Name", newName)
			EndIf
			akTarget.SetDisplayName(newName + " ["+oldName+"]", True)
			Return
		Endif	
	Endif

	IF akTarget.IsInFaction(FacThalmor)
    String oldname = TargetRef.GetName()
		Int RNThalmorGV = RNThalmor.GetValue() as int
		If RNThalmorGV == 0
			Return
		ElseIf RNThalmorGV == 1
			string newName = newFirstName
			if (RNDoLastNames.GetValue() == 1 && newLastName != "")
				newName += " " + newLastName
			endif
			if (StorageUtil.HasStringValue(akTarget, "RNE_Name"))
				newName = StorageUtil.GetStringValue(akTarget, "RNE_Name")
			Else
				StorageUtil.SetStringValue(akTarget, "RNE_Name", newName)
			EndIf
			akTarget.SetDisplayName(newName + " ["+oldName+"]", True)
			Return
		ElseIf RNThalmorGV == 2
			string newName = newFirstName
			if (RNDoLastNames.GetValue() == 1 && newLastName != "")
				newName += " " + newLastName
			endif
			if (StorageUtil.HasStringValue(akTarget, "RNE_Name"))
				newName = StorageUtil.GetStringValue(akTarget, "RNE_Name")
			Else
				StorageUtil.SetStringValue(akTarget, "RNE_Name", newName)
			EndIf
			akTarget.SetDisplayName(newName + " ["+oldName+"]", True)
			Return
		Endif	
	Endif

	IF akTarget.IsInFaction(FacVampire) || akTarget.IsInFaction(FacVampireThrall)
    String oldname = TargetRef.GetName()
		Int RNVampireGV = RNVampire.GetValue() as int
		If RNVampireGV == 0
			Return
		ElseIf RNVampireGV == 1
			string newName = newFirstName
			if (RNDoLastNames.GetValue() == 1 && newLastName != "")
				newName += " " + newLastName
			endif
			if (StorageUtil.HasStringValue(akTarget, "RNE_Name"))
				newName = StorageUtil.GetStringValue(akTarget, "RNE_Name")
			Else
				StorageUtil.SetStringValue(akTarget, "RNE_Name", newName)
			EndIf
			akTarget.SetDisplayName(newName + " ["+oldName+"]", True)
			Return
		ElseIf RNVampireGV == 2
			string newName = newFirstName
			if (RNDoLastNames.GetValue() == 1 && newLastName != "")
				newName += " " + newLastName
			endif
			if (StorageUtil.HasStringValue(akTarget, "RNE_Name"))
				newName = StorageUtil.GetStringValue(akTarget, "RNE_Name")
			Else
				StorageUtil.SetStringValue(akTarget, "RNE_Name", newName)
			EndIf
			akTarget.SetDisplayName(newName + " ["+oldName+"]", True)
			Return
		Endif	
	Endif

	IF akTarget.IsInFaction(FacDragon)
    String oldname = TargetRef.GetName()
		Int RNDragonGV = RNDragon.GetValue() as int
		; Debug.Trace("RNDragonGV = " + RNDragonGV)
		If RNDragonGV == 0
			Return
		ElseIf RNDragonGV == 1
			string newName = newFirstName
			if (RNDoLastNames.GetValue() == 1 && newLastName != "")
				newName += " " + newLastName
			endif
			if (StorageUtil.HasStringValue(akTarget, "RNE_Name"))
				newName = StorageUtil.GetStringValue(akTarget, "RNE_Name")
			Else
				StorageUtil.SetStringValue(akTarget, "RNE_Name", newName)
			EndIf
			akTarget.SetDisplayName(newName + " ["+oldName+"]", True)
			Return
		ElseIf RNDragonGV == 2
			string newName = newFirstName
			if (RNDoLastNames.GetValue() == 1 && newLastName != "")
				newName += " " + newLastName
			endif
			if (StorageUtil.HasStringValue(akTarget, "RNE_Name"))
				newName = StorageUtil.GetStringValue(akTarget, "RNE_Name")
			Else
				StorageUtil.SetStringValue(akTarget, "RNE_Name", newName)
			EndIf
			akTarget.SetDisplayName(newName + " ["+oldName+"]", True)
			Return
		Endif	
	Endif

	IF akTarget.IsInFaction(FacDragonPriest)
    String oldname = TargetRef.GetName()
		Int RNDragonPriestGV = RNDragonPriest.GetValue() as int
		; Debug.Trace("RNDragonPriestGV = " + RNDragonPriestGV)
		If RNDragonPriestGV == 0
			Return
		ElseIf RNDragonPriestGV == 1
			string newName = newFirstName
			if (RNDoLastNames.GetValue() == 1 && newLastName != "")
				newName += " " + newLastName
			endif
			if (StorageUtil.HasStringValue(akTarget, "RNE_Name"))
				newName = StorageUtil.GetStringValue(akTarget, "RNE_Name")
			Else
				StorageUtil.SetStringValue(akTarget, "RNE_Name", newName)
			EndIf
			akTarget.SetDisplayName(newName + " ["+oldName+"]", True)
			Return
		ElseIf RNDragonPriestGV == 2
			string newName = newFirstName
			if (RNDoLastNames.GetValue() == 1 && newLastName != "")
				newName += " " + newLastName
			endif
			if (StorageUtil.HasStringValue(akTarget, "RNE_Name"))
				newName = StorageUtil.GetStringValue(akTarget, "RNE_Name")
			Else
				StorageUtil.SetStringValue(akTarget, "RNE_Name", newName)
			EndIf
			akTarget.SetDisplayName(newName + " ["+oldName+"]", True)
			Return
		Endif	
	Endif

	IF akTarget.IsInFaction(FacDaedra)
    String oldname = TargetRef.GetName()
		Int RNDaedraGV = RNDaedra.GetValue() as int
		; Debug.Trace("RNDaedraGV = " + RNDaedraGV)
		If RNDaedraGV == 0
			Return
		ElseIf RNDaedraGV == 1
			string newName = newFirstName
			if (RNDoLastNames.GetValue() == 1 && newLastName != "")
				newName += " " + newLastName
			endif
			if (StorageUtil.HasStringValue(akTarget, "RNE_Name"))
				newName = StorageUtil.GetStringValue(akTarget, "RNE_Name")
			Else
				StorageUtil.SetStringValue(akTarget, "RNE_Name", newName)
			EndIf
			akTarget.SetDisplayName(newName + " ["+oldName+"]", True)
			Return
		ElseIf RNDaedraGV == 2
			string newName = newFirstName
			if (RNDoLastNames.GetValue() == 1 && newLastName != "")
				newName += " " + newLastName
			endif
			if (StorageUtil.HasStringValue(akTarget, "RNE_Name"))
				newName = StorageUtil.GetStringValue(akTarget, "RNE_Name")
			Else
				StorageUtil.SetStringValue(akTarget, "RNE_Name", newName)
			EndIf
			akTarget.SetDisplayName(newName + " ["+oldName+"]", True)
			Return
		Endif	
	Endif

	IF akTarget.IsInFaction(FacCreature)
    String oldname = TargetRef.GetName()
		Int RNCreatureGV = RNCreature.GetValue() as int
		; Debug.Trace("RNCreatureGV = " + RNCreatureGV)
		If RNCreatureGV == 0
			Return
		ElseIf RNCreatureGV == 1
			string newName = newFirstName
			if (RNDoLastNames.GetValue() == 1 && newLastName != "")
				newName += " " + newLastName
			endif
			if (StorageUtil.HasStringValue(akTarget, "RNE_Name"))
				newName = StorageUtil.GetStringValue(akTarget, "RNE_Name")
			Else
				StorageUtil.SetStringValue(akTarget, "RNE_Name", newName)
			EndIf
			akTarget.SetDisplayName(newName + " ["+oldName+"]", True)
			Return
		ElseIf RNCreatureGV == 2
			string newName = newFirstName
			if (RNDoLastNames.GetValue() == 1 && newLastName != "")
				newName += " " + newLastName
			endif
			if (StorageUtil.HasStringValue(akTarget, "RNE_Name"))
				newName = StorageUtil.GetStringValue(akTarget, "RNE_Name")
			Else
				StorageUtil.SetStringValue(akTarget, "RNE_Name", newName)
			EndIf
			akTarget.SetDisplayName(newName + " ["+oldName+"]", True)
			Return
		Endif	
	Endif

		Int RNOtherGV = RNOther.GetValue() as int
		If RNOtherGV == 0
			Return
		ElseIf RNOtherGV == 1
			string newName = newFirstName
			if (RNDoLastNames.GetValue() == 1 && newLastName != "")
				newName += " " + newLastName
			endif
			if (StorageUtil.HasStringValue(akTarget, "RNE_Name"))
				newName = StorageUtil.GetStringValue(akTarget, "RNE_Name")
			Else
				StorageUtil.SetStringValue(akTarget, "RNE_Name", newName)
			EndIf
      String oldname = TargetRef.GetName()
			akTarget.SetDisplayName(newName + " ["+oldName+"]", True)
			Return
		ElseIf RNOtherGV == 2
			string newName = newFirstName
			if (RNDoLastNames.GetValue() == 1 && newLastName != "")
				newName += " " + newLastName
			endif
			if (StorageUtil.HasStringValue(akTarget, "RNE_Name"))
				newName = StorageUtil.GetStringValue(akTarget, "RNE_Name")
			Else
				StorageUtil.SetStringValue(akTarget, "RNE_Name", newName)
			EndIf
      String oldname = TargetRef.GetName()
			akTarget.SetDisplayName(newName + " ["+oldName+"]", True)
			Return
		Endif	

EndFunction
