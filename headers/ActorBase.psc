Scriptname ActorBase extends Form Hidden

Class Function GetClass() native
int Function GetDeadCount() native
FormList Function GetGiftFilter() native
Race Function GetRace() native
int Function GetSex() native
bool Function IsEssential() native
bool Function IsInvulnerable() native
bool Function IsProtected() native
bool Function IsUnique() native
Function SetEssential(bool abEssential = true) native
Function SetInvulnerable(bool abInvulnerable = true) native
Function SetProtected(bool abProtected = true) native
Function SetOutfit(Outfit akOutfit, bool abSleepOutfit = false) native
CombatStyle Function GetCombatStyle() native
Function SetCombatStyle(CombatStyle cs) native
Outfit Function GetOutfit(bool bSleepOutfit = false) native
Function SetClass(Class c) native
float Function GetHeight() native
Function SetHeight(float height) native
float Function GetWeight() native
Function SetWeight(float weight) native
int Function GetNumHeadParts() native
HeadPart Function GetNthHeadPart(int slotPart) native
Function SetNthHeadPart(HeadPart headPart, int slotPart) native
int Function GetIndexOfHeadPartByType(int type) native
int Function GetNumOverlayHeadParts() native
HeadPart Function GetNthOverlayHeadPart(int slotPart) native
int Function GetIndexOfOverlayHeadPartByType(int type) native
float Function GetFaceMorph(int index) native
Function SetFaceMorph(float value, int index) native
int Function GetFacePreset(int index) native
Function SetFacePreset(int value, int index) native
ColorForm Function GetHairColor() native
Function SetHairColor(ColorForm color) native
int Function GetSpellCount() native
Spell Function GetNthSpell(int n) native
TextureSet Function GetFaceTextureSet() native
Function SetFaceTextureSet(TextureSet textures) native
VoiceType Function GetVoiceType() native
Function SetVoiceType(VoiceType nVoice) native
Armor Function GetSkin() native
Function SetSkin(Armor skin) native
Armor Function GetSkinFar() native
Function SetSkinFar(Armor skin) native
ActorBase Function GetTemplate() native
