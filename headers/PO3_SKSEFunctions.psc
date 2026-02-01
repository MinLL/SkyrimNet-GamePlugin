Scriptname PO3_SKSEFunctions Hidden

string[] Function GetScriptsAttachedToActiveEffect(ActiveMagicEffect akActiveEffect) global native
Bool Function IsScriptAttachedToActiveEffect(ActiveMagicEffect akActiveEffect, string asScriptName) global native
Form Function GetActiveEffectSpell(ActiveMagicEffect akActiveEffect) global native
MagicEffect[] Function GetActiveEffects(Actor akActor, bool abShowInactive = false) global native
float Function GetActorAlpha(Actor akActor) global native
int Function GetActorKnockState(Actor akActor) global native
float Function GetActorRefraction(Actor akActor) global native
int Function GetActorState(Actor akActor) global native
int Function GetActorSoulSize(Actor akActor) global native
float Function GetActorValueModifier(Actor akActor, int aiModifier, string asActorValue) global native
Spell[] Function GetAllActorPlayableSpells(Actor akActor) global native
int Function GetCriticalStage(Actor akActor) global native
Actor[] Function GetCombatAllies(Actor akActor) global native
Actor[] Function GetCombatTargets(Actor akActor) global native
Actor[] Function GetCommandedActors(Actor akActor) global native
Actor Function GetCommandingActor(Actor akActor) global native
float Function GetEditorLocationX(Actor akActor) global native
float Function GetEditorLocationY(Actor akActor) global native
float Function GetEditorLocationZ(Actor akActor) global native
float Function GetEditorLocationAngle(Actor akActor) global native
Ammo Function GetEquippedAmmo(Actor akActor) global native
Enchantment Function GetEquippedAmmoEnchantment(Actor akActor) global native
Bool Function GetEquippedWeaponIsPoisoned(Actor akActor, bool abLeftHand) global native
Potion Function GetEquippedWeaponPoison(Actor akActor, bool abLeftHand) global native
int Function GetEquippedWeaponPoisonCount(Actor akActor, bool abLeftHand) global native
float Function GetEquippedWeight(Actor akActor) global native
ColorForm Function GetHairColor(Actor akActor) global native
int[] Function GetHairRGB(Actor akActor) global native
TextureSet Function GetHeadPartTextureSet(Actor akActor, int aiType) global native
float Function GetLocalGravityActor(Actor akActor) global native
Actor Function GetMount(Actor akActor) global native
ObjectReference Function GetObjectUnderFeet(Actor akActor) global native
Bool Function GetOffersServices(Actor akActor) global native
Actor Function GetRider(Actor akActor) global native
Package Function GetRunningPackage(Actor akActor) global native
ColorForm Function GetSkinColor(Actor akActor) global native
int[] Function GetSkinRGB(Actor akActor) global native
float Function GetTimeDead(Actor akActor) global native
float Function GetTimeOfDeath(Actor akActor) global native
Faction Function GetVendorFaction(Actor akActor) global native
Bool Function HasActiveMagicEffect(Actor akActor, MagicEffect akEffect) global native
Bool Function HasActiveSpell(Actor akActor, Spell akSpell) global native
Bool Function HasDeferredKill(Actor akActor) global native
Bool Function HasMagicEffectWithArchetype(Actor akActor, string asArchetype) global native
Bool Function HasSkin(Actor akActor, Armor akArmorToCheck) global native
Bool Function IsActorInWater(Actor akActor) global native
Bool Function IsActorUnderwater(Actor akActor) global native
Bool Function IsLimbGone(Actor akActor, int aiLimb) global native
Bool Function IsPowerAttacking(Actor akActor) global native
Bool Function IsQuadruped(Actor akActor) global native
Bool Function IsSoulTrapped(Actor akActor) global native
Bool Function ApplyPoisonToEquippedWeapon(Actor akActor, Potion akPoison, int aiCount, bool abLeftHand) global native
Form[] Function AddAllEquippedItemsToArray(Actor akActor) global native
Form[] Function AddAllEquippedItemsBySlotToArray(Actor akActor, int[] aiSlots) global native
Bool Function AddBasePerk(Actor akActor, Perk akPerk) global native
Bool Function AddBaseSpell(Actor akActor, Spell akSpell) global native
Function BlendColorWithSkinTone(Actor akActor, ColorForm akColor, int aiBlendMode, bool abAutoLuminance, float afOpacity) global native
Bool Function DamageActorHealth(Actor akActor, float afHealthDamage, Actor akSource) global native
Function DecapitateActor(Actor akActor) global native
Function FreezeActor(Actor akActor, int type, bool abFreeze) global native
Function KillNoWait(Actor akActor) global native
Function LaunchArrow(Actor akActor, Ammo akAmmo, Weapon akWeapon, string asNodeName = "", int aiSource = -1, ObjectReference akTarget = None, Potion akPoison = None) global native
Function LaunchSpell(Actor akActor, Spell akSpell, int aiSource) global native
Function MixColorWithSkinTone(Actor akActor, ColorForm akColor, bool abManualMode, float afPercentage) global native
Function RemoveAddedSpells(Actor akActor, string modName, Keyword[] keywords, bool abMatchAll) global native
Function RemoveArmorOfType(Actor akActor, int afArmorType, int[] aiSlotsToSkip, bool abEquippedOnly) global native
Bool Function RemoveBasePerk(Actor akActor, Perk akPerk) global native
Bool Function RemoveBaseSpell(Actor akActor, Spell akSpell) global native
Function ReplaceArmorTextureSet(Actor akActor, Armor akArmor, TextureSet akSourceTXST, TextureSet akTargetTXST, int aiTextureType = -1) global native
Function ReplaceFaceTextureSet(Actor akActor, TextureSet akMaleTXST, TextureSet akFemaleTXST, int aiTextureType = -1) global native
Function ReplaceSkinTextureSet(Actor akActor, TextureSet akMaleTXST, TextureSet akFemaleTXST, int aiSlotMask, int aiTextureType = -1) global native
Bool Function ResetActor3D(Actor akActor, string asFolderName) global native
Function SetActorRefraction(Actor akActor, float afRefraction) global native
Bool Function SetEquippedWeaponPoison(Actor akActor, Potion akPoison, bool abLeftHand) global native
Bool Function SetEquippedWeaponPoisonCount(Actor akActor, int aiCount, bool abLeftHand) global native
Function SetHairColor(Actor akActor, ColorForm akColor) global native
Function SetHeadPartAlpha(Actor akActor, int aiPartType, float afAlpha) global native
Function SetHeadPartTextureSet(Actor akActor, TextureSet headpartTXST, int aiType) global native
Function SetLinearVelocity(Actor akActor, float afX, float afY, float afZ) global native
Function SetLocalGravityActor(Actor akActor, float afValue, bool abDisableGravityOnGround) global native
Function SetSkinAlpha(Actor akActor, float afAlpha) global native
Function SetSkinColor(Actor akActor, ColorForm akColor) global native
Function SetSoulTrapped(Actor akActor, bool abTrapped) global native
Function ToggleHairWigs(Actor akActor, bool abDisable) global native
Function UnequipAllOfType(Actor akActor, int afArmorType, int[] aiSlotsToSkip) global native
AssociationType Function GetAssociationType(Actorbase akBase1, Actorbase akBase2) global native
LeveledItem Function GetDeathItem(Actorbase akBase) global native
Perk Function GetNthPerk(Actorbase akBase, int aiIndex) global native
int Function GetPerkCount(Actorbase akBase) global native
Actorbase[] Function GetRelationships(Actorbase akBase, AssociationType akAssocType) global native
Function SetDeathItem(Actorbase akBase, LeveledItem akLeveledItem) global native
Enchantment Function GetBaseAmmoEnchantment(Ammo akAmmo) global native
string[] Function GetScriptsAttachedToAlias(Alias akAlias) global native
Bool Function IsScriptAttachedToAlias(Alias akAlias, string asScriptName) global native
FootstepSet Function GetFootstepSet(ArmorAddon akArma) global native
Function SetFootstepSet(ArmorAddon akArma, FootstepSet akFootstepSet) global native
string[] Function GetSortedActorNames(Keyword akKeyword, string asPlural = "(s)", bool abInvertKeyword) global native
string[] Function GetSortedNPCNames(ActorBase[] aiActorBases, string asPlural = "(s)") global native
Bool Function AddActorToArray(Actor akActor, Actor[] actorArray) global native
Bool Function AddStringToArray(string asString, string[] asStrings) global native
int Function ArrayStringCount(string asString, string[] asStrings) global native
string[] Function SortArrayString(string[] asStrings) global native
Function ClearBookCantBeTakenFlag(Book akBook) global native
Function ClearReadFlag(Book akBook) global native
Function SetBookCantBeTakenFlag(Book akBook) global native
Function SetReadFlag(Book akBook) global native
float Function GetCellNorthRotation(Cell akCell) global native
LightingTemplate Function GetLightingTemplate(Cell akCell) global native
Function SetLightingTemplate(Cell akCell, LightingTemplate akLightingTemplate) global native
Function SetCellNorthRotation(Cell akCell, float afAngle) global native
Function GivePlayerSpellBook() global native
Function DumpAnimationVariables(Actor akActor, string asAnimationVarPrefix) global native
int Function CanActorBeDetected(Actor akActor) global native
int Function CanActorDetect(Actor akActor) global native
Bool Function IsDetectedByAnyone(Actor akActor) global native
Function ForceActorDetection(Actor akActor) global native
Function ForceActorDetecting(Actor akActor) global native
Function PreventActorDetection(Actor akActor) global native
Function PreventActorDetecting(Actor akActor) global native
Function ResetActorDetection(Actor akActor) global native
Function ResetActorDetecting(Actor akActor) global native
Debris Function GetAddonModels(EffectShader akEffectShader) global native
int Function GetEffectShaderTotalCount(EffectShader akEffectShader, bool abActive) global native
Bool Function IsEffectShaderFlagSet(EffectShader akEffectShader, int aiFlag) global native
string Function GetMembraneFillTexture(EffectShader akEffectShader) global native
string Function GetMembraneHolesTexture(EffectShader akEffectShader) global native
string Function GetMembranePaletteTexture(EffectShader akEffectShader) global native
float Function GetParticleFullCount(EffectShader akEffectShader) global native
string Function GetParticlePaletteTexture(EffectShader akEffectShader) global native
string Function GetParticleShaderTexture(EffectShader akEffectShader) global native
float Function GetParticlePersistentCount(EffectShader akEffectShader) global native
Function ClearEffectShaderFlag(EffectShader akEffectShader, int aiFlag) global native
Function SetAddonModels(EffectShader akEffectShader, Debris akDebris) global native
Function SetEffectShaderFlag(EffectShader akEffectShader, int aiFlag) global native
Function SetMembraneColorKeyData(EffectShader akEffectShader, int aiColorKey, int[] aiRGB, float afAlpha, float afTime) global native
Function SetMembraneFillTexture(EffectShader akEffectShader, string asTextureName) global native
Function SetMembraneHolesTexture(EffectShader akEffectShader, string asTextureName) global native
Function SetMembranePaletteTexture(EffectShader akEffectShader, string asTextureName) global native
Function SetParticleColorKeyData(EffectShader akEffectShader, int aiColorKey, int[] aiRGB, float afAlpha, float afTime) global native
Function SetParticleFullCount(EffectShader akEffectShader, float afParticleCount) global native
Function SetParticlePaletteTexture(EffectShader akEffectShader, string asTextureName) global native
Function SetParticlePersistentCount(EffectShader akEffectShader, float afParticleCount) global native
Function SetParticleShaderTexture(EffectShader akEffectShader, string asTextureName) global native
int Function GetEnchantmentType(Enchantment akEnchantment) global native
Function AddMagicEffectToEnchantment(Enchantment akEnchantment, MagicEffect akMagicEffect, float afMagnitude, int aiArea, int aiDuration, float afCost = 0.0, string[] asConditionList) global native
Function AddEffectItemToEnchantment(Enchantment akEnchantment, Enchantment akEnchantmentToCopyFrom, int aiIndex, float afCost = -1.0) global native
Function RemoveMagicEffectFromEnchantment(Enchantment akEnchantment, MagicEffect akMagicEffect, float afMagnitude, int aiArea, int aiDuration, float afCost = 0.0) global native
Function RemoveEffectItemFromEnchantment(Enchantment akEnchantment, Enchantment akEnchantmentToMatchFrom, int aiIndex) global native
Function SetEnchantmentMagicEffect(Enchantment akEnchantment, MagicEffect akMagicEffect, int aiIndex) global native
ObjectReference Function GetVendorFactionContainer(Faction akVendorFaction) global native
Actor[] Function GetAllActorsInFaction(Faction akFaction) global native
Bool Function SetFastTravelDisabled(bool abDisable) global native
Bool Function SetFastTravelTargetFormID(int aiDestinationFormID) global native
Bool Function SetFastTravelTargetRef(ObjectReference akDestination) global native
Bool Function SetFastTravelTargetString(string asDestination) global native
float Function SetFastTravelWaitTimeout(float afTimeout) global native
Bool Function EvaluateConditionList(Form akForm, ObjectReference akActionRef, ObjectReference akTargetRef) global native
Function ClearRecordFlag(Form akForm, int aiFlag) global native
string[] Function GetConditionList(Form akForm, int aiIndex = 0) global native
string Function GetDescription(Form akForm) global native
string Function GetFormEditorID(Form akForm) global native
string Function GetFormModName(Form akForm, bool abLastModified) global native
string[] Function GetScriptsAttachedToForm(Form akForm) global native
Bool Function IsFormInMod(Form akForm, string asModName) global native
Bool Function IsGeneratedForm(Form akForm) global native
Bool Function IsRecordFlagSet(Form akForm, int aiFlag) global native
Bool Function IsScriptAttachedToForm(Form akForm, string asScriptName) global native
Function SetRecordFlag(Form akForm, int aiFlag) global native
Function AddKeywordToForm(Form akForm, Keyword akKeyword) global native
Function MarkItemAsFavorite(Form akForm) global native
Function RemoveConditionList(Form akForm, int aiIndex, string[] asConditionList) global native
Function ReplaceKeywordOnForm(Form akForm, Keyword akKeywordAdd, Keyword akKeywordRemove) global native
Bool Function RemoveKeywordOnForm(Form akForm, Keyword akKeyword) global native
Function SetConditionList(Form akForm, int aiIndex, string[] asConditionList) global native
Function UnmarkItemAsFavorite(Form akForm) global native
int Function GetFurnitureType(Furniture akFurniture) global native
Enchantment[] Function GetAllEnchantments(Keyword[] akKeywords = None) global native
Form[] Function GetAllForms(int aiFormType, Keyword[] akKeywords = None) global native
Race[] Function GetAllRaces(Keyword[] akKeywords = None) global native
Spell[] Function GetAllSpells(Keyword[] akKeywords = None, bool abIsPlayable = false) global native
Actor[] Function GetActorsByProcessingLevel(int aiLevel) global native
Form[] Function GetAllFormsInMod(string asModName, int aiFormType, Keyword[] akKeywords = None) global native
Enchantment[] Function GetAllEnchantmentsInMod(string asModName, Keyword[] akKeywords = None) global native
Race[] Function GetAllRacesInMod(string asModName, Keyword[] akKeywords = None) global native
Spell[] Function GetAllSpellsInMod(string asModName, Keyword[] akKeywords = None, bool abIsPlayable = false) global native
Cell[] Function GetAttachedCells() global native
Form Function GetFormFromEditorID(string asEditorID) global native
int Function GetGameSettingBool(string asGameSetting) global native
Bool Function GetGodMode() global native
float Function GetLandHeight(float afPosX, float afPosY, float afPosZ) global native
string Function GetLandMaterialType(float afPosX, float afPosY, float afPosZ) global native
float[] Function GetLocalGravity() global native
int Function GetNumActorsInHigh() global native
Actor[] Function GetPlayerFollowers() global native
string Function GetSurfaceMaterialType(float afX, float afY, float afZ) global native
Bool Function IsPluginFound(string akName) global native
Bool Function IsSurvivalModeActive() global native
Function ClearCachedFactionFightReactions() global native
Function SetLocalGravity(float afXAxis, float afYAxis, float afZAxis) global native
Function UpdateCrosshairs() global native
string Function GetHazardArt(Hazard akHazard) global native
ImageSpaceModifier Function GetHazardIMOD(Hazard akHazard) global native
float Function GetHazardIMODRadius(Hazard akHazard) global native
ImpactDataSet Function GetHazardIPDS(Hazard akHazard) global native
float Function GetHazardLifetime(Hazard akHazard) global native
Light Function GetHazardLight(Hazard akHazard) global native
int Function GetHazardLimit(Hazard akHazard) global native
float Function GetHazardRadius(Hazard akHazard) global native
SoundDescriptor Function GetHazardSound(Hazard akHazard) global native
Spell Function GetHazardSpell(Hazard akHazard) global native
float Function GetHazardTargetInterval(Hazard akHazard) global native
Bool Function IsHazardFlagSet(Hazard akHazard, int aiFlag) global native
Function ClearHazardFlag(Hazard akHazard, int aiFlag) global native
Function SetHazardArt(Hazard akHazard, string asPath) global native
Function SetHazardFlag(Hazard akHazard, int aiFlag) global native
Function SetHazardIMOD(Hazard akHazard, ImageSpaceModifier akIMOD) global native
Function SetHazardIMODRadius(Hazard akHazard, float afRadius) global native
Function SetHazardIPDS(Hazard akHazard, ImpactDataSet akIPDS) global native
Function SetHazardLifetime(Hazard akHazard, float afLifetime) global native
Function SetHazardLight(Hazard akHazard, Light akLight) global native
Function SetHazardLimit(Hazard akHazard, int aiLimit) global native
Function SetHazardRadius(Hazard akHazard, float afRadius) global native
Function SetHazardSound(Hazard akHazard, SoundDescriptor akSound) global native
Function SetHazardSpell(Hazard akHazard, Spell akspell) global native
Function SetHazardTargetInterval(Hazard akHazard, float afInterval) global native
string Function GetAnimationEventName(Idle akIdle) global native
string Function GetAnimationFileName(Idle akIdle) global native
ColorForm Function GetLightColor(Light akLight) global native
float Function GetLightFade(Light akLight) global native
float Function GetLightFOV(Light akLight) global native
float Function GetLightRadius(Light akLight) global native
int[] Function GetLightRGB(Light akLight) global native
float Function GetLightShadowDepthBias(ObjectReference akLightObject) global native
int Function GetLightType(Light akLight) global native
Function SetLightColor(Light akLight, ColorForm akColorform) global native
Function SetLightFade(Light akLight, float afRange) global native
Function SetLightFOV(Light akLight, float afFOV) global native
Function SetLightRadius(Light akLight, float afRadius) global native
Function SetLightRGB(Light akLight, int[] aiRGB) global native
Function SetLightShadowDepthBias(ObjectReference akLightObject, float afDepthBias) global native
Function SetLightType(Light akLight, int aiLightType) global native
Form[] Function GetContentFromLeveledItem(LeveledItem akLeveledItem, ObjectReference akRef) global native
Form[] Function GetContentFromLeveledActor(LeveledActor akLeveledActor, ObjectReference akRef) global native
Form[] Function GetContentFromLeveledSpell(LeveledSpell akLeveledSpell, ObjectReference akRef) global native
Location Function GetParentLocation(Location akLoc) global native
Function SetParentLocation(Location akLoc, Location akNewLoc) global native
Form Function GetAssociatedForm(MagicEffect akMagicEffect) global native
int Function GetEffectArchetypeAsInt(MagicEffect akMagicEffect) global native
string Function GetEffectArchetypeAsString(MagicEffect akMagicEffect) global native
string Function GetPrimaryActorValue(MagicEffect akMagicEffect) global native
string Function GetSecondaryActorValue(MagicEffect akMagicEffect) global native
SoundDescriptor Function GetMagicEffectSound(MagicEffect akMagicEffect, int aiType) global native
Function SetAssociatedForm(MagicEffect akMagicEffect, Form akForm) global native
Function SetMagicEffectSound(MagicEffect akMagicEffect, SoundDescriptor akSoundDescriptor, int aiType) global native
Bool Function ActorInRangeHasEffect(ObjectReference akRef, float afRadius, MagicEffect akEffect, bool abIgnorePlayer) global native
Form[] Function AddAllItemsToArray(ObjectReference akRef, bool abNoEquipped = true, bool abNoFavorited = false, bool abNoQuestItem = false) global native
Function AddAllItemsToList(ObjectReference akRef, Formlist akList, bool abNoEquipped = true, bool abNoFavorited = false, bool abNoQuestItem = false) global native
Form[] Function AddItemsOfTypeToArray(ObjectReference akRef, int aiFormType, bool abNoEquipped = true, bool abNoFavorited = false, bool abNoQuestItem = false) global native
Function AddItemsOfTypeToList(ObjectReference akRef, Formlist akList, int aiFormType, bool abNoEquipped = true, bool abNoFavorited = false, bool abNoQuestItem = false) global native
Form[] Function AddItemsWithKeywordToArray(ObjectReference akRef, Keyword akKeyword, bool abNoEquipped = true, bool abNoFavorited = false, bool abNoQuestItem = false) global native
Function AddItemsWithKeywordToList(ObjectReference akRef, Formlist akList, Keyword akKeyword, bool abNoEquipped = true, bool abNoFavorited = false, bool abNoQuestItem = false) global native
Form[] Function AddItemsWithKeywordStringToArray(ObjectReference akRef, String asKeywordString, bool abNoEquipped = true, bool abNoFavorited = false, bool abNoQuestItem = false) global native
Function AddItemsWithKeywordStringToList(ObjectReference akRef, Formlist akList, String asKeywordString, bool abNoEquipped = true, bool abNoFavorited = false, bool abNoQuestItem = false) global native
ObjectReference[] Function FindAllReferencesOfFormType(ObjectReference akRef, int formType, float afRadius) global native
ObjectReference[] Function FindAllReferencesWithKeyword(ObjectReference akRef, Form keywordOrList, float afRadius, bool abMatchAll) global native
ObjectReference[] Function FindAllReferencesOfType(ObjectReference akRef, Form akFormOrList, float afRadius) global native
Form Function FindFirstItemInList(ObjectReference akRef, FormList akList) global native
Quest[] Function GetActiveAssociatedQuests(ObjectReference akRef, Bool abAllowEmptyStages = True) global native
ObjectReference[] Function GetActivateChildren(ObjectReference akRef) global native
string Function GetActiveGamebryoAnimation(ObjectReference akRef) global native
ActiveMagicEffect[] Function GetActiveMagicEffects(ObjectReference akRef, MagicEffect akMagicEffect) global native
Quest[] Function GetAllAssociatedQuests(ObjectReference akRef, Bool abAllowEmptyStages = True) global native
Actor Function GetActorCause(ObjectReference akRef) global native
Art[] Function GetAllArtObjects(ObjectReference akRef) global native
EffectShader[] Function GetAllEffectShaders(ObjectReference akRef) global native
Actor Function GetClosestActorFromRef(ObjectReference akRef, bool abIgnorePlayer) global native
float Function GetEffectShaderDuration(ObjectReference akRef, EffectShader akShader) global native
ObjectReference Function GetDoorDestination(ObjectReference akRef) global native
ObjectReference[] Function GetLinkedChildren(ObjectReference akRef, Keyword akKeyword) global native
Form[] Function GetMagicEffectSource(ObjectReference akRef, MagicEffect akEffect) global native
string[] Function GetMaterialType(ObjectReference akRef, string asNodeName = "") global native
int Function GetMotionType(ObjectReference akRef) global native
int Function GetNumActorsWithEffectInRange(ObjectReference akRef, float afRadius, MagicEffect akEffect, bool abignorePlayer) global native
Actor Function GetRandomActorFromRef(ObjectReference akRef, float afRadius, bool abIgnorePlayer) global native
Form[] Function GetQuestItems(ObjectReference akRef, bool abNoEquipped = false, bool abNoFavorited = false) global native
Alias[] Function GetRefAliases(ObjectReference akRef) global native
int Function GetRefCount(ObjectReference akRef) global native
int Function GetStoredSoulSize(ObjectReference akRef) global native
int Function HasArtObject(ObjectReference akRef, Art akArtObject, bool abActive = false) global native
int Function HasEffectShader(ObjectReference akRef, EffectShader akShader, bool abActive = false) global native
Bool Function HasNiExtraData(ObjectReference akRef, string asName) global native
Bool Function IsCasting(ObjectReference akRef, Form akMagicItem) global native
Bool Function IsLoadDoor(ObjectReference akRef) global native
Bool Function IsQuestItem(ObjectReference akRef) global native
Bool Function IsRefInWater(ObjectReference akRef) global native
Bool Function IsRefNodeInWater(ObjectReference akRef, String asNodeName) global native
Bool Function IsRefUnderwater(ObjectReference akRef) global native
Bool Function IsVIP(ObjectReference akRef) global native
Function ApplyMaterialShader(ObjectReference akRef, MaterialObject akMatObject, float directionalThresholdAngle) global native
Function AddKeywordToRef(ObjectReference akRef, Keyword akKeyword) global native
Function CastEx(ObjectReference akRef, Form akSpell, ObjectReference akTarget, Actor akBlameActor, int aiSource) global native
Function MoveToNearestNavmeshLocation(ObjectReference akRef) global native
Function RemoveAllModItems(ObjectReference akRef, string asModName, bool abOnlyUnequip = false) global native
Function RemoveListFromContainer(ObjectReference akRef, FormList akList, bool abNoEquipped = false, bool abNoFavorited = false, bool abNoQuestItem = false, ObjectReference akDestination = None) global native
Bool Function RemoveKeywordFromRef(ObjectReference akRef, Keyword akKeyword) global native
Function ReplaceKeywordOnRef(ObjectReference akRef, Keyword akKeywordAdd, Keyword akKeywordRemove) global native
Function PlayDebugShader(ObjectReference akRef, float[] afRGBA) global native
Function ScaleObject3D(ObjectReference akRef, string asNodeName, float afScale) global native
Function SetBaseObject(ObjectReference akRef, Form akBaseObject) global native
Function SetCollisionLayer(ObjectReference akRef, string asNodeName, int aiCollisionLayer) global native
Bool Function SetDoorDestination(ObjectReference akRef, ObjectReference akDoor) global native
Function SetEffectShaderDuration(ObjectReference akRef, EffectShader akShader, float afTime, bool abAbsolute) global native
Function SetKey(ObjectReference akRef, Key akKey) global native
Function SetLinkedRef(ObjectReference akRef, ObjectReference akTargetRef, Keyword akKeyword = None) global native
Function SetMaterialType(ObjectReference akRef, string asNewMaterial, string asOldMaterial = "", string asNodeName = "") global native
Function SetupBodyPartGeometry(ObjectReference akRef, actor akActor) global native
Function SetShaderType(ObjectReference akRef, ObjectReference akTemplate, string asDiffusePath, int aiShaderType, int aiTextureType, bool abNoWeapons, bool abNoAlphaProperty) global native
Function StopAllShaders(ObjectReference akRef) global native
Function StopArtObject(ObjectReference akRef, Art akArt) global native
Function ToggleChildNode(ObjectReference akRef, string asNodeName, bool abDisable) global native
Function UpdateHitEffectArtNode(ObjectReference akRef, Art akArt, string asNewNode, float[] afTranslate, float[] afRotate, float afRelativeScale = 1.0) global native
int Function GetPackageType(Package akPackage) global native
Idle[] Function GetPackageIdles(Package akPackage) global native
Function AddPackageIdle(Package akPackage, Idle akIdle) global native
Function RemovePackageIdle(Package akPackage, Idle akIdle) global native
int[] Function GetPapyrusExtenderVersion() global native
Function AddMagicEffectToPotion(Potion akPotion, MagicEffect akMagicEffect, float afMagnitude, int aiArea, int aiDuration, float afCost = 0.0, string[] asConditionList) global native
Function AddEffectItemToPotion(Potion akPotion, Potion akPotionToCopyFrom, int aiIndex, float afCost = -1.0) global native
Function RemoveMagicEffectFromPotion(Potion akPotion, MagicEffect akMagicEffect, float afMagnitude, int aiArea, int aiDuration, float afCost = 0.0) global native
Function RemoveEffectItemFromPotion(Potion akPotion, Potion akPotionToMatchFrom, int aiIndex) global native
Function SetPotionMagicEffect(Potion akPotion, MagicEffect akMagicEffect, int aiIndex) global native
float Function GetProjectileGravity(Projectile akProjectile) global native
float Function GetProjectileImpactForce(Projectile akProjectile) global native
float Function GetProjectileRange(Projectile akProjectile) global native
float Function GetProjectileSpeed(Projectile akProjectile) global native
int Function GetProjectileType(Projectile akProjectile) global native
Function SetProjectileGravity(Projectile akProjectile, float afGravity) global native
Function SetProjectileImpactForce(Projectile akProjectile, float afImpactForce) global native
Function SetProjectileRange(Projectile akProjectile, float afRange) global native
Function SetProjectileSpeed(Projectile akProjectile, float afSpeed) global native
int[] Function GetAllQuestObjectives(Quest akQuest) global native
int[] Function GetAllQuestStages(Quest akQuest) global native
Function SetObjectiveText(Quest akQuest, string asText, int aiIndex) global native
Actor[] Function GetActorsInScene(Scene akScene) global native
bool Function IsActorInScene(Scene akScene, Actor akActor) global native
Function AddMagicEffectToScroll(Scroll akScroll, MagicEffect akMagicEffect, float afMagnitude, int aiArea, int aiDuration, float afCost = 0.0, string[] asConditionList) global native
Function AddEffectItemToScroll(Scroll akScroll, Scroll akScrollToCopyFrom, int aiIndex, float afCost = -1.0) global native
Function RemoveMagicEffectFromScroll(Scroll akScroll, MagicEffect akMagicEffect, float afMagnitude, int aiArea, int aiDuration, float afCost = 0.0) global native
Function RemoveEffectItemFromScroll(Scroll akScroll, Scroll akScrollToMatchFrom, int aiIndex) global native
Function SetScrollMagicEffect(Scroll akScroll, MagicEffect akMagicEffect, int aiIndex) global native
Function SetSoundDescriptor(Sound akSound, SoundDescriptor akSoundDescriptor) global native
int Function GetSpellType(Spell akSpell) global native
Function AddMagicEffectToSpell(Spell akSpell, MagicEffect akMagicEffect, float afMagnitude, int aiArea, int aiDuration, float afCost = 0.0, string[] asConditionList) global native
Function AddEffectItemToSpell(Spell akSpell, Spell akSpellToCopyFrom, int aiIndex, float afCost = -1.0) global native
Function RemoveMagicEffectFromSpell(Spell akSpell, MagicEffect akMagicEffect, float afMagnitude, int aiArea, int aiDuration, float afCost = 0.0) global native
Function RemoveEffectItemFromSpell(Spell akSpell, Spell akSpellToMatchFrom, int aiIndex) global native
Function SetSpellCastingType(Spell akSpell, int aiType) global native
Function SetSpellDeliveryType(Spell akSpell, int aiType) global native
Function SetSpellType(Spell akSpell, int aiType) global native
Function SetSpellMagicEffect(Spell akSpell, MagicEffect akMagicEffect, int aiIndex) global native
string Function IntToString(int aiValue, bool abHex) global native
int Function StringToInt(string asString) global native
ObjectReference Function GetMenuContainer() global native
Function HideMenu(string asMenuName) global native
Bool Function IsShowingMenus() global native
Function ShowBookMenu(Book akBook) global native
Function ShowMenu(string asMenuName) global native
Function ToggleOpenSleepWaitMenu(bool abOpenSleepMenu) global native
float Function GenerateRandomFloat(float afMin, float afMax) global native
int Function GenerateRandomInt(int afMin, int afMax) global native
int[] Function GetSystemTime() global native
Art Function GetArtObject(VisualEffect akEffect) global native
int Function GetArtObjectTotalCount(VisualEffect akEffect, bool abActive) global native
Function SetArtObject(VisualEffect akEffect, Art akArt) global native
float Function GetWindSpeedAsFloat(Weather akWeather) global native
int Function GetWindSpeedAsInt(Weather akWeather) global native
int Function GetWeatherType(Weather akWeather = None) global native
