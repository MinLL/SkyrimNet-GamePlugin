Scriptname Actor extends ObjectReference Hidden

int Property CritStage_None = 0 AutoReadOnly
int Property CritStage_GooStart = 1 AutoReadOnly
int Property CritStage_GooEnd = 2 AutoReadOnly
int Property CritStage_DisintegrateStart = 3 AutoReadOnly
int Property CritStage_DisintegrateEnd = 4 AutoReadOnly
int Property EquipSlot_Default = 0 AutoReadOnly
int Property EquipSlot_RightHand = 1 AutoReadOnly
int Property EquipSlot_LeftHand = 2 AutoReadOnly

Function ModFavorPoints(int iFavorPoints = 1) native
Function ModFavorPointsWithGlobal(GlobalVariable FavorPointsGlobal) native
Function MakePlayerFriend() native
Function AddPerk(Perk akPerk) native
bool Function AddShout(Shout akShout) native
bool Function AddSpell(Spell akSpell, bool abVerbose=true) native
Function AllowBleedoutDialogue(bool abCanTalk) native
Function AllowPCDialogue(bool abTalk) native
Function AttachAshPile(Form akAshPileBase = None) native
bool Function CanFlyHere() native
Function ClearArrested() native
Function ClearExpressionOverride() native
Function ClearExtraArrows() native
Function ClearForcedLandingMarker() native
Function ClearKeepOffsetFromActor() native
Function ClearLookAt() native
Function DamageActorValue(string asValueName, float afDamage) native
Function DamageAV(string asValueName, float afDamage) native
bool Function Dismount() native
Function DispelAllSpells() native
bool Function DispelSpell(Spell akSpell) native
Function DoCombatSpellApply(Spell akSpell, ObjectReference akTarget) native
Function EnableAI(bool abEnable = true) native
Function EndDeferredKill() native
Function EquipItem(Form akItem, bool abPreventRemoval = false, bool abSilent = false) native
Function EquipShout(Shout akShout) native
Function EquipSpell(Spell akSpell, int aiSource) native
Function EvaluatePackage() native
Function ForceActorValue(string asValueName, float afNewValue) native
Function ForceAV(string asValueName, float afNewValue) native
ActorBase Function GetActorBase() native
float Function GetActorValue(string asValueName) native
float Function GetActorValueMax(string asValueName) native
float Function GetActorValuePercentage(string asValueName) native
float Function GetAV(string asValueName) native
float Function GetAVMax(string asValueName) native
float Function GetAVPercentage(string asValueName) native
float Function GetBaseActorValue(string asValueName) native
float Function GetBaseAV(string asValueName) native
int Function GetBribeAmount() native
Faction Function GetCrimeFaction() native
int Function GetCombatState() native
Actor Function GetCombatTarget() native
Package Function GetCurrentPackage() native
Actor Function GetDialogueTarget() native
Armor Function GetEquippedArmorInSlot(int aiSlot) native
int Function GetEquippedItemType(int aiHand) native
Shout Function GetEquippedShout() native
Weapon Function GetEquippedWeapon(bool abLeftHand = false) native
Armor Function GetEquippedShield() native
Spell Function GetEquippedSpell(int aiSource) native
int Function GetFactionRank(Faction akFaction) native
int Function GetFactionReaction(Actor akOther) native
int Function GetFlyingState() native
ObjectReference Function GetForcedLandingMarker() native
int Function GetGoldAmount() native
int Function GetHighestRelationshipRank() native
Actor Function GetKiller() native
int Function GetLevel() native
float Function GetLightLevel() native
int Function GetLowestRelationshipRank() native
ActorBase Function GetLeveledActorBase() native
bool Function GetNoBleedoutRecovery() native
bool Function GetPlayerControls() native
Race Function GetRace() native
int Function GetRelationshipRank(Actor akOther) native
int Function GetSitState() native
int Function GetSleepState() native
float Function GetVoiceRecoveryTime() native
float Function GetWarmthRating() native
bool Function HasAssociation(AssociationType akAssociation, Actor akOther = None) native
bool Function HasFamilyRelationship(Actor akOther = None) native
bool Function HasLOS(ObjectReference akOther) native
bool Function HasMagicEffect(MagicEffect akEffect) native
bool Function HasMagicEffectWithKeyword(Keyword akKeyword) native
bool Function HasParentRelationship(Actor akOther) native
bool Function HasPerk(Perk akPerk) native
bool Function HasSpell(Form akForm) native
bool Function IsAlarmed() native
bool Function IsAlerted() native
bool Function IsAllowedToFly() native
bool Function IsArrested() native
bool Function IsArrestingTarget() native
bool Function IsBeingRidden() native
bool Function IsBleedingOut() native
bool Function IsBribed() native
bool Function IsChild() native
bool Function IsCommandedActor() native
bool Function IsDead() native
bool Function IsDetectedBy(Actor akOther) native
bool Function IsDoingFavor() native
bool Function IsEquipped(Form akItem) native
bool Function IsEssential() native
bool Function IsFlying() native
bool Function IsGuard() native
bool Function IsGhost() native
bool Function IsHostileToActor(Actor akActor) native
bool Function IsInCombat() native
bool Function IsInFaction(Faction akFaction) native
bool Function IsInKillMove() native
bool Function IsIntimidated() native
bool Function IsOnMount() native
bool Function IsOverEncumbered() native
bool Function IsPlayersLastRiddenHorse() native
bool Function IsPlayerTeammate() native
bool Function IsRunning() native
bool Function IsSneaking() native
bool Function IsSprinting() native
bool Function IsTrespassing() native
bool Function IsUnconscious() native
bool Function IsWeaponDrawn() native
Function KeepOffsetFromActor(Actor arTarget, float afOffsetX, float afOffsetY, float afOffsetZ, float afOffsetAngleX = 0.0, float afOffsetAngleY = 0.0, float afOffsetAngleZ = 0.0, float afCatchUpRadius = 20.0, float afFollowRadius = 5.0) native
Function Kill(Actor akKiller = None) native
Function KillEssential(Actor akKiller = None) native
Function KillSilent(Actor akKiller = None) native
Function ModActorValue(string asValueName, float afAmount) native
Function ModAV(string asValueName, float afAmount) native
Function ModFactionRank(Faction akFaction, int aiMod) native
Function MoveToPackageLocation() native
Function OpenInventory(bool abForceOpen = false) native
bool Function PathToReference(ObjectReference aTarget, float afWalkRunPercent) native
bool Function PlayIdle(Idle akIdle) native
bool Function PlayIdleWithTarget(Idle akIdle, ObjectReference akTarget) native
Function PlaySubGraphAnimation(string asEventName) native
Function RemoveFromFaction(Faction akFaction) native
Function RemoveFromAllFactions() native
Function RemovePerk(Perk akPerk) native
bool Function RemoveShout(Shout akShout) native
bool Function RemoveSpell(Spell akSpell) native
Function ResetHealthAndLimbs() native
Function RestoreActorValue(string asValueName, float afAmount) native
Function Resurrect() native
Function RestoreAV(string asValueName, float afAmount) native
Function SendAssaultAlarm() native
Function SendLycanthropyStateChanged(bool abIsWerewolf) native
Function SendTrespassAlarm(Actor akCriminal) native
Function SendVampirismStateChanged(bool abIsVampire) native
Function SetActorValue(string asValueName, float afValue) native
Function SetAlert(bool abAlerted = true) native
Function SetAllowFlying(bool abAllowed = true) native
Function SetAllowFlyingEx(bool abAllowed = true, bool abAllowCrash = true, bool abAllowSearch = false) native
Function SetAlpha(float afTargetAlpha, bool abFade = false) native
Function SetAttackActorOnSight(bool abAttackOnSight = true) native
Function SetAV(string asValueName, float afValue) native
Function SetBribed(bool abBribe = true) native
Function SetCrimeFaction(Faction akFaction) native
Function SetCriticalStage(int aiStage) native
Function SetDoingFavor(bool abDoingFavor = true) native
Function SetDontMove(bool abDontMove = true) native
Function SetExpressionOverride(int aiMood, int aiStrength = 100) native
Function SetEyeTexture(TextureSet akNewTexture) native
Function SetFactionRank(Faction akFaction, int aiRank) native
Function SetForcedLandingMarker(ObjectReference aMarker) native
Function SetGhost(bool abIsGhost = true) native
Function AddToFaction(Faction akFaction) native
Function SetHeadTracking(bool abEnable = true) native
Function SetIntimidated(bool abIntimidate = true) native
Function SetLookAt(ObjectReference akTarget, bool abPathingLookAt = false) native
Function SetNoBleedoutRecovery(bool abAllowed) native
Function SetNotShowOnStealthMeter(bool abNotShow) native
Function SetOutfit(Outfit akOutfit, bool abSleepOutfit = false) native
Function SetPlayerControls(bool abControls) native
Function SetPlayerResistingArrest() native
Function SetPlayerTeammate(bool abTeammate = true, bool abCanDoFavor=true) native
Function SetRace(Race akRace = None) native
Function SetRelationshipRank(Actor akOther, int aiRank) native
Function SetRestrained(bool abRestrained = true) native
Function SetSubGraphFloatVariable(string asVariableName, float afValue) native
Function SetUnconscious(bool abUnconscious = true) native
Function SetVehicle(ObjectReference akVehicle) native
Function SetVoiceRecoveryTime(float afTime) native
Function ShowBarterMenu() native
int Function ShowGiftMenu(bool abGivingGift, FormList apFilterList = None, bool abShowStolenItems = false, bool abUseFavorPoints = true) native
Function StartCannibal(Actor akTarget) native
Function StartCombat(Actor akTarget) native
Function StartDeferredKill() native
Function StartVampireFeed(Actor akTarget) native
Function StopCombat() native
Function StopCombatAlarm() native
bool Function TrapSoul(Actor akTarget) native
Function UnequipAll() native
Function UnequipItem(Form akItem, bool abPreventEquip = false, bool abSilent = false) native
Function UnequipItemSlot(int aiSlot) native
Function UnequipShout(Shout akShout) native
Function UnequipSpell(Spell akSpell, int aiSource) native
Function UnLockOwnedDoorsInCell() native
bool Function WillIntimidateSucceed() native
bool Function WornHasKeyword(Keyword akKeyword) native
Function StartSneaking() native
Function DrawWeapon() native
Function ForceMovementDirection(float afXAngle = 0.0, float afYAngle = 0.0, float afZAngle = 0.0) native
Function ForceMovementSpeed(float afSpeedMult) native
Function ForceMovementRotationSpeed(float afXMult = 0.0, float afYMult = 0.0, float afZMult = 0.0) native
Function ForceMovementDirectionRamp(float afXAngle = 0.0, float afYAngle = 0.0, float afZAngle = 0.0, float afRampTime = 0.1) native
Function ForceMovementSpeedRamp(float afSpeedMult, float afRampTime = 0.1) native
Function ForceMovementRotationSpeedRamp(float afXMult = 0.0, float afYMult = 0.0, float afZMult = 0.0, float afRampTime = 0.1) native
Function ForceTargetDirection(float afXAngle = 0.0, float afYAngle = 0.0, float afZAngle = 0.0) native
Function ForceTargetSpeed(float afSpeed) native
Function ForceTargetAngle(float afXAngle = 0.0, float afYAngle = 0.0, float afZAngle = 0.0) native
Function ClearForcedMovement() native
Form Function GetWornForm(int slotMask) native
int Function GetWornItemId(int slotMask) native
Form Function GetEquippedObject(int location) native
int Function GetEquippedItemId(int location) native
Int Function GetSpellCount() native
Spell Function GetNthSpell(int n) native
Function QueueNiNodeUpdate() native
Function RegenerateHead() native
Function EquipItemEx(Form item, int equipSlot = 0, bool preventUnequip = false, bool equipSound = true) native
Function EquipItemById(Form item, int itemId, int equipSlot = 0, bool preventUnequip = false, bool equipSound = true) native
Function UnequipItemEx(Form item, int equipSlot = 0, bool preventEquip = false) native
Function ChangeHeadPart(HeadPart hPart) native
Function ReplaceHeadPart(HeadPart oPart, HeadPart newPart) native
Function UpdateWeight(float neckDelta) native
bool Function IsAIEnabled() native
Function ResetAI() native
bool Function IsSwimming() native
Function SheatheWeapon() native
ObjectReference Function GetFurnitureReference() native
Function SetExpressionPhoneme(int index, float value) native
Function SetExpressionModifier(int index, float value) native
Function ResetExpressionOverrides() native
Faction[] Function GetFactions(int minRank, int maxRank) native
