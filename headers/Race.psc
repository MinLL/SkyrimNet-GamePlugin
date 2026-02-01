Scriptname Race extends Form Hidden

int Property kRace_Playable = 0x00000001 AutoReadOnly
int Property kRace_FaceGenHead = 0x00000002 AutoReadOnly
int Property kRace_Child = 0x00000004 AutoReadOnly
int Property kRace_TiltFrontBack = 0x00000008 AutoReadOnly
int Property kRace_TiltLeftRight = 0x00000010 AutoReadOnly
int Property kRace_NoShadow = 0x00000020 AutoReadOnly
int Property kRace_Swims = 0x00000040 AutoReadOnly
int Property kRace_Flies = 0x00000080 AutoReadOnly
int Property kRace_Walks = 0x00000100 AutoReadOnly
int Property kRace_Immobile = 0x00000200 AutoReadOnly
int Property kRace_NotPushable = 0x00000400 AutoReadOnly
int Property kRace_NoCombatInWater = 0x00000800 AutoReadOnly
int Property kRace_NoRotatingToHeadTrack = 0x00001000 AutoReadOnly
int Property kRace_UseHeadTrackAnim = 0x00008000 AutoReadOnly
int Property kRace_SpellsAlignWithMagicNode = 0x00010000 AutoReadOnly
int Property kRace_UseWorldRaycasts = 0x00020000 AutoReadOnly
int Property kRace_AllowRagdollCollision = 0x00040000 AutoReadOnly
int Property kRace_CantOpenDoors = 0x00100000 AutoReadOnly
int Property kRace_AllowPCDialogue = 0x00200000 AutoReadOnly
int Property kRace_NoKnockdowns = 0x00400000 AutoReadOnly
int Property kRace_AllowPickpocket = 0x00800000 AutoReadOnly
int Property kRace_AlwaysUseProxyController = 0x01000000 AutoReadOnly
int Property kRace_AllowMultipleMembraneShaders = 0x20000000 AutoReadOnly
int Property kRace_AvoidsRoads = 0x80000000 AutoReadOnly

int Function GetSpellCount() native
Spell Function GetNthSpell(int n) native
bool Function IsRaceFlagSet(int n) native
Function SetRaceFlag(int n) native
Function ClearRaceFlag(int n) native
VoiceType Function GetDefaultVoiceType(bool female) native
Function SetDefaultVoiceType(bool female, VoiceType voice) native
Armor Function GetSkin() native
Function SetSkin(Armor skin) native
int Function GetNumPlayableRaces() native global
Race Function GetNthPlayableRace(int n) native global
Race Function GetRace(string editorId) native global
bool Function IsPlayable() native
Function MakePlayable() native
Function MakeUnplayable() native
bool Function IsChildRace() native
Function MakeChildRace() native
Function MakeNonChildRace() native
bool Function CanFly() native
Function MakeCanFly() native
Function MakeNonFlying() native
bool Function CanSwim() native
Function MakeCanSwim() native
Function MakeNonSwimming() native
bool Function CanWalk() native
Function MakeCanWalk() native
Function MakeNonWalking() native
bool Function IsImmobile() native
Function MakeImmobile() native
Function MakeMobile() native
bool Function IsNotPushable() native
Function MakeNotPushable() native
Function MakePushable() native
bool Function NoKnockdowns() native
Function MakeNoKnockdowns() native
Function ClearNoKNockdowns() native
bool Function NoCombatInWater() native
Function SetNoCombatInWater() native
Function ClearNoCombatInWater() native
bool Function AvoidsRoads() native
Function SetAvoidsRoads() native
Function ClearAvoidsRoads() native
bool Function AllowPickpocket() native
Function SetAllowPickpocket() native
Function ClearAllowPickpocket() native
bool Function AllowPCDialogue() native
Function SetAllowPCDialogue() native
Function ClearAllowPCDialogue() native
bool Function CantOpenDoors() native
Function SetCantOpenDoors() native
Function ClearCantOpenDoors() native
bool Function NoShadow() native
Function SetNoShadow() native
Function ClearNoShadow() native
