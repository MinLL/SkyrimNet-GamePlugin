Scriptname ObjectReference extends Form Hidden

int Property Motion_Dynamic = 1 AutoReadOnly
int Property Motion_SphereIntertia = 2 AutoReadOnly
int Property Motion_BoxIntertia = 3 AutoReadOnly
int Property Motion_Keyframed = 4 AutoReadOnly
int Property Motion_Fixed = 5 AutoReadOnly
int Property Motion_ThinBoxIntertia = 6 AutoReadOnly
int Property Motion_Character = 7 AutoReadOnly
float Property X auto
float Property Y auto
float Property Z auto

bool Function rampRumble(float power = 0.5, float duration = 0.25, float falloff = 1600.0) native
bool Function IsNearPlayer() native
bool Function IsInInterior() native
bool Function MoveToIfUnloaded(ObjectReference akTarget, float afXOffset = 0.0, float afYOffset = 0.0, float afZOffset = 0.0) native
Function MoveToWhenUnloaded(ObjectReference akTarget, float afXOffset = 0.0, float afYOffset = 0.0, float afZOffset = 0.0) native
Function DeleteWhenAble() native
Function AddKeyIfNeeded(ObjectReference ObjectWithNeededKey) native
float Function get() native
float Function get() native
float Function get() native
bool Function Activate(ObjectReference akActivator, bool abDefaultProcessingOnly = false) native
bool Function AddDependentAnimatedObjectReference(ObjectReference akDependent) native
Function AddInventoryEventFilter(Form akFilter) native
Function AddItem(Form akItemToAdd, int aiCount = 1, bool abSilent = false) native
Function AddToMap(bool abAllowFastTravel = false) native
Function ApplyHavokImpulse(float afX, float afY, float afZ, float afMagnitude) native
Function BlockActivation(bool abBlocked = true) native
int Function CalculateEncounterLevel(int aiDifficulty = 4) native
bool Function CanFastTravelToMarker() native
Function ClearDestruction() native
Function CreateDetectionEvent(Actor akOwner, int aiSoundLevel = 0) native
Function DamageObject(float afDamage) native
Function Delete() native
Function Disable(bool abFadeOut = false) native
Function DisableNoWait(bool abFadeOut = false) native
ObjectReference Function DropObject(Form akObject, int aiCount = 1) native
Function Enable(bool abFadeIn = false) native
Function EnableFastTravel(bool abEnable = true) native
Function EnableNoWait(bool abFadeIn = false) native
Function ForceAddRagdollToWorld() native
Function ForceRemoveRagdollFromWorld() native
ActorBase Function GetActorOwner() native
float Function GetAngleX() native
float Function GetAngleY() native
float Function GetAngleZ() native
bool Function GetAnimationVariableBool(string arVariableName) native
int Function GetAnimationVariableInt(string arVariableName) native
float Function GetAnimationVariableFloat(string arVariableName) native
Form Function GetBaseObject() native
int Function GetCurrentDestructionStage() native
Location Function GetCurrentLocation() native
Scene Function GetCurrentScene() native
float Function GetDistance(ObjectReference akOther) native
Location Function GetEditorLocation() native
Faction Function GetFactionOwner() native
float Function GetHeadingAngle(ObjectReference akOther) native
float Function GetHeight() native
int Function GetItemCount(Form akItem) native
float Function GetItemHealthPercent() native
Key Function GetKey() native
float Function GetLength() native
ObjectReference Function GetLinkedRef(Keyword apKeyword = NONE) native
int Function GetLockLevel() native
int Function countLinkedRefChain(keyword apKeyword = None, int maxExpectedLinkedRefs = 100) native
ObjectReference Function GetNthLinkedRef(int aiLinkedRef) native
Function EnableLinkChain(Keyword apKeyword = None) native
Function DisableLinkChain(Keyword apKeyword = None, bool abFadeOut = false) native
float Function GetMass() native
int Function GetOpenState() native
Cell Function GetParentCell() native
float Function GetPositionX() native
float Function GetPositionY() native
float Function GetPositionZ() native
float Function GetScale() native
int Function GetTriggerObjectCount() native
VoiceType Function GetVoiceType() native
float Function GetWidth() native
WorldSpace Function GetWorldSpace() native
actor Function GetSelfAsActor() native
bool Function HasEffectKeyword(Keyword akKeyword) native
bool Function HasNode(string asNodeName) native
bool Function HasRefType(LocationRefType akRefType) native
Function IgnoreFriendlyHits(bool abIgnore = true) native
Function InterruptCast() native
bool Function IsActivateChild(ObjectReference akChild) native
bool Function IsActivationBlocked() native
bool Function Is3DLoaded() native
bool Function IsDeleted() native
bool Function IsDisabled() native
bool Function IsEnabled() native
bool Function IsFurnitureInUse(bool abIgnoreReserved = false) native
bool Function IsFurnitureMarkerInUse(int aiMarker, bool abIgnoreReserved = false) native
bool Function IsIgnoringFriendlyHits() native
bool Function IsInDialogueWithPlayer() native
bool Function IsLockBroken() native
bool Function IsLocked() native
bool Function IsMapMarkerVisible() native
Function KnockAreaEffect(float afMagnitude, float afRadius) native
Function Lock(bool abLock = true, bool abAsOwner = false) native
Function MoveTo(ObjectReference akTarget, float afXOffset = 0.0, float afYOffset = 0.0, float afZOffset = 0.0, bool abMatchRotation = true) native
Function MoveToInteractionLocation(ObjectReference akTarget) native
Function MoveToMyEditorLocation() native
Function MoveToNode(ObjectReference akTarget, string asNodeName) native
ObjectReference Function PlaceAtMe(Form akFormToPlace, int aiCount = 1, bool abForcePersist = false, bool abInitiallyDisabled = false) native
Actor Function PlaceActorAtMe(ActorBase akActorToPlace, int aiLevelMod = 4, EncounterZone akZone = None) native
bool Function PlayAnimation(string asAnimation) native
bool Function PlayAnimationAndWait(string asAnimation, string asEventName) native
bool Function PlayGamebryoAnimation(string asAnimation, bool abStartOver = false, float afEaseInTime = 0.0) native
bool Function PlayImpactEffect(ImpactDataSet akImpactEffect, string asNodeName = "", float afPickDirX = 0.0, float afPickDirY = 0.0, float afPickDirZ = -1.0, float afPickLength = 512.0, bool abApplyNodeRotation = false, bool abUseNodeLocalRotation = false) native
bool Function PlaySyncedAnimationSS(string asAnimation1, ObjectReference akObj2, string asAnimation2) native
bool Function PlaySyncedAnimationAndWaitSS(string asAnimation1, string asEvent1, ObjectReference akObj2, string asAnimation2, string asEvent2) native
Function PlayTerrainEffect(string asEffectModelName, string asAttachBoneName) native
Function ProcessTrapHit(ObjectReference akTrap, float afDamage, float afPushback, float afXVel, float afYVel, float afZVel, float afXPos, float afYPos, float afZPos, int aeMaterial, float afStagger) native
Function PushActorAway(Actor akActorToPush, float aiKnockbackForce) native
Function RemoveAllInventoryEventFilters() native
Function RemoveAllItems(ObjectReference akTransferTo = None, bool abKeepOwnership = false, bool abRemoveQuestItems = false) native
Function RemoveInventoryEventFilter(Form akFilter) native
Function RemoveItem(Form akItemToRemove, int aiCount = 1, bool abSilent = false, ObjectReference akOtherContainer = None) native
bool Function RemoveDependentAnimatedObjectReference(ObjectReference akDependent) native
Function Reset(ObjectReference akTarget = None) native
Function Say(Topic akTopicToSay, Actor akActorToSpeakAs = None, bool abSpeakInPlayersHead = false) native
Function SendStealAlarm(Actor akThief) native
Function SetActorCause(Actor akActor) native
Function SetActorOwner(ActorBase akActorBase) native
Function SetAngle(float afXAngle, float afYAngle, float afZAngle) native
Function SetAnimationVariableBool(string arVariableName, bool abNewValue) native
Function SetAnimationVariableInt(string arVariableName, int aiNewValue) native
Function SetAnimationVariableFloat(string arVariableName, float afNewValue) native
Function SetDestroyed(bool abDestroyed = true) native
Function SetFactionOwner(Faction akFaction) native
Function SetLockLevel(int aiLockLevel) native
Function SetMotionType(int aeMotionType, bool abAllowActivate = true) native
Function SetNoFavorAllowed(bool abNoFavor = true) native
Function SetOpen(bool abOpen = true) native
Function SetPosition(float afX, float afY, float afZ) native
Function SetScale(float afScale) native
Function TranslateTo(float afX, float afY, float afZ, float afXAngle, float afYAngle, float afZAngle, float afSpeed, float afMaxRotationSpeed = 0.0) native
Function SplineTranslateTo(float afX, float afY, float afZ, float afXAngle, float afYAngle, float afZAngle, float afTangentMagnitude, float afSpeed, float afMaxRotationSpeed = 0.0) native
Function SplineTranslateToRefNode(ObjectReference arTarget, string arNodeName, float afTangentMagnitude, float afSpeed, float afMaxRotationSpeed = 0.0) native
Function StopTranslation() native
Function TranslateToRef(ObjectReference arTarget, float afSpeed, float afMaxRotationSpeed = 0.0) native
Function SplineTranslateToRef(ObjectReference arTarget, float afTangentMagnitude, float afSpeed, float afMaxRotationSpeed = 0.0) native
Function TetherToHorse(ObjectReference akHorse) native
bool Function WaitForAnimationEvent(string asEventName) native
bool Function IsInLocation(Location akLocation) native
Bool Function IsContainerEmpty() Native
Function RemoveAllStolenItems(ObjectReference akTransferTo) Native
Function SetContainerAllowStolenItems(Bool setAllowStolenItems) Native
Int Function GetAllItemsCount() Native
int Function GetNumItems() native
Form Function GetNthForm(int index) native
float Function GetTotalItemWeight() native
float Function GetTotalArmorWeight() native
bool Function IsHarvested() native
Function SetHarvested(bool harvested) native
Function SetItemHealthPercent(float health) native
Function SetItemMaxCharge(float maxCharge) native
float Function GetItemMaxCharge() native
float Function GetItemCharge() native
Function SetItemCharge(float charge) native
Function ResetInventory() native
bool Function IsOffLimits() native
string Function GetDisplayName() native
bool Function SetDisplayName(string name, bool force = false) native
ObjectReference Function GetEnableParent() native
Enchantment Function GetEnchantment() native
Function SetEnchantment(Enchantment source, float maxCharge) native
Function CreateEnchantment(float maxCharge, MagicEffect[] effects, float[] magnitudes, int[] areas, int[] durations) native
int Function GetNumReferenceAliases() native
ReferenceAlias Function GetNthReferenceAlias(int n) native
Potion Function GetPoison() native
Function GetAllForms(FormList toFill) native
Form[] Function GetContainerForms() native
ReferenceAlias[] Function GetReferenceAliases() native
