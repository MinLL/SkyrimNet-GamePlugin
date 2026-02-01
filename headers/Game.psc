Scriptname Game Hidden

Function AddAchievement(int aiAchievementID) native global
Function AddPerkPoints(int aiPerkPoints) native global
Function AdvanceSkill(string asSkillName, float afMagnitude) native global
bool Function AddHavokBallAndSocketConstraint(ObjectReference arRefA, string arRefANode, ObjectReference arRefB, string arRefBNode, float afRefALocalOffsetX = 0.0, float afRefALocalOffsetY = 0.0, float afRefALocalOffsetZ = 0.0, float afRefBLocalOffsetX = 0.0, float afRefBLocalOffsetY = 0.0, float afRefBLocalOffsetZ = 0.0) native global
bool Function RemoveHavokConstraints(ObjectReference arFirstRef, string arFirstRefNodeName, ObjectReference arSecondRef, string arSecondRefNodeName) native global
int Function CalculateFavorCost(int aiFavorPrice) native global
Function ClearPrison() native global
Function ClearTempEffects() native global
Function DisablePlayerControls(bool abMovement = true, bool abFighting = true, bool abCamSwitch = false, bool abLooking = false, bool abSneaking = false, bool abMenu = true, bool abActivate = true, bool abJournalTabs = false, int aiDisablePOVType = 0) native global
Function EnablePlayerControls(bool abMovement = true, bool abFighting = true, bool abCamSwitch = true, bool abLooking = true, bool abSneaking = true, bool abMenu = true, bool abActivate = true, bool abJournalTabs = true, int aiDisablePOVType = 0) native global
Function EnableFastTravel(bool abEnable = true) native global
Function FadeOutGame(bool abFadingOut, bool abBlackFade, float afSecsBeforeFade, float afFadeDuration) native global
Function FastTravel(ObjectReference akDestination) native global
ObjectReference Function FindClosestReferenceOfType(Form arBaseObject, float afX, float afY, float afZ, float afRadius) native global
ObjectReference Function FindRandomReferenceOfType(Form arBaseObject, float afX, float afY, float afZ, float afRadius) native global
ObjectReference Function FindClosestReferenceOfAnyTypeInList(FormList arBaseObjects, float afX, float afY, float afZ, float afRadius) native global
ObjectReference Function FindRandomReferenceOfAnyTypeInList(FormList arBaseObjects, float afX, float afY, float afZ, float afRadius) native global
ObjectReference Function FindClosestReferenceOfTypeFromRef(Form arBaseObject, ObjectReference arCenter, float afRadius) global native
ObjectReference Function FindRandomReferenceOfTypeFromRef(Form arBaseObject, ObjectReference arCenter, float afRadius) global native
ObjectReference Function FindClosestReferenceOfAnyTypeInListFromRef(FormList arBaseObjects, ObjectReference arCenter, float afRadius) global native
ObjectReference Function FindRandomReferenceOfAnyTypeInListFromRef(FormList arBaseObjects, ObjectReference arCenter, float afRadius) global native
Actor Function FindClosestActor(float afX, float afY, float afZ, float afRadius) native global
Actor Function FindRandomActor(float afX, float afY, float afZ, float afRadius) native global
Actor Function FindClosestActorFromRef(ObjectReference arCenter, float afRadius) global native
Actor Function FindRandomActorFromRef(ObjectReference arCenter, float afRadius) global native
Function ForceThirdPerson() native global
Function ForceFirstPerson() native global
Function ShowFirstPersonGeometry(bool abShow = true) native global
Form Function GetForm(int aiFormID) native global
Form Function GetFormFromFile(int aiFormID, string asFilename) native global
float Function GetGameSettingFloat(string asGameSetting) native global
int Function GetGameSettingInt(string asGameSetting) native global
string Function GetGameSettingString(string asGameSetting) native global
Actor Function GetPlayer() native global
ObjectReference Function GetPlayerGrabbedRef() native global
Actor Function GetPlayersLastRiddenHorse() native global
float Function GetSunPositionX() native global
float Function GetSunPositionY() native global
float Function GetSunPositionZ() native global
float Function GetRealHoursPassed() native global
Function IncrementSkill(string asSkillName) native global
Function IncrementSkillBy(string asSkillName, int aiCount) native global
Function IncrementStat(string asStatName, int aiModAmount = 1) native global
bool Function IsActivateControlsEnabled() native global
bool Function IsCamSwitchControlsEnabled() native global
bool Function IsFastTravelControlsEnabled() native global
bool Function IsFastTravelEnabled() native global
bool Function IsFightingControlsEnabled() native global
bool Function IsJournalControlsEnabled() native global
bool Function IsLookingControlsEnabled() native global
bool Function IsMenuControlsEnabled() native global
bool Function IsMovementControlsEnabled() native global
bool Function IsPlayerSungazing() native global
bool Function IsSneakingControlsEnabled() native global
bool Function IsWordUnlocked(WordOfPower akWord) native global
Function PlayBink(string asFileName, bool abInterruptible = false, bool abMuteAudio = true, bool abMuteMusic = true, bool abLetterbox = true) native global
Function PrecacheCharGen() native global
Function PrecacheCharGenClear() native global
int Function QueryStat(string asStat) native global
Function QuitToMainMenu() native global
Function RequestAutoSave() native global
Function RequestModel(string asModelName) native global
Function RequestSave() native global
Function ServeTime() native global
Function SendWereWolfTransformation() native global
Function SetBeastForm(bool abEntering) native global
Function SetCameraTarget(Actor arTarget) native global
Function SetHudCartMode(bool abSetCartMode = true) native global
Function SetInChargen(bool abDisableSaving, bool abDisableWaiting, bool abShowControlsDisabledMessage) native global
Function SetPlayerAIDriven(bool abAIDriven = true) native global
Function SetPlayerReportCrime(bool abReportCrime = true) native global
Function SetSittingRotation(float afValue) native global
Function ShakeCamera(ObjectReference akSource = None, float afStrength = 0.5, float afDuration = 0.0) native global
Function ShakeController(float afSmallMotorStrength, float afBigMotorStreangth, float afDuration) native global
Function ShowRaceMenu() native global
Function ShowLimitedRaceMenu() native global
Function ShowTitleSequenceMenu() native global
Function HideTitleSequenceMenu() native global
Function StartTitleSequence(string asSequenceName) native global
Function SetAllowFlyingMountLandingRequests(bool abAllow) native global
Function SetSunGazeImageSpaceModifier(ImageSpaceModifier apImod = NONE) native global
Function ShowTrainingMenu(Actor aTrainer) native global
Function TeachWord(WordOfPower akWord) native global
Function TriggerScreenBlood(int aiValue) native global
Function UnlockWord(WordOfPower akWord) native global
bool Function UsingGamepad() native global
int Function GetPerkPoints() global native
Function SetPerkPoints(int perkPoints) global native
Function ModPerkPoints(int perkPoints) global native
int Function GetModCount() native global
int Function GetModByName(string name) native global
string Function GetModName(int modIndex) native global
string Function GetModAuthor(int modIndex) native global
string Function GetModDescription(int modIndex) native global
int Function GetModDependencyCount(int modIndex) native global
bool Function IsPluginInstalled(string name) native global
int Function GetLightModCount() native global
int Function GetLightModByName(string name) native global
string Function GetLightModName(int idx) native global
string Function GetLightModAuthor(int idx) native global
string Function GetLightModDescription(int idx) native global
int Function GetLightModDependencyCount(int idx) native global
int Function GetNthLightModDependency(int modIdx, int idx) native global
Function SetGameSettingFloat(string setting, float value) global native
Function SetGameSettingInt(string setting, int value) global native
Function SetGameSettingBool(string setting, bool value) global native
Function SetGameSettingString(string setting, string value) global native
Function SaveGame(string name) native global
Function LoadGame(string name) native global
int Function GetNumTintMasks() native global
int Function GetNthTintMaskColor(int n) native global
int Function GetNthTintMaskType(int n) native global
Function SetNthTintMaskColor(int n, int color) native global
string Function GetNthTintMaskTexturePath(int n) native global
Function SetNthTintMaskTexturePath(string path, int n) native global
int Function GetNumTintsByType(int type) native global
int Function GetTintMaskColor(int type, int index) global native
Function SetTintMaskColor(int color, int type, int index) global native
string Function GetTintMaskTexturePath(int type, int index) global native
Function SetTintMaskTexturePath(string path, int type, int index) global native
Function UpdateTintMaskColors() global native
Function UpdateHairColor() global native
int Function GetCameraState() global native
Function SetMiscStat(string name, int value) global native
Function SetPlayersLastRiddenHorse(Actor horse) global native
int Function GetSkillLegendaryLevel(string actorValue) global native
Function SetSkillLegendaryLevel(string actorValue, int level) global native
float Function GetPlayerExperience() global native
Function SetPlayerExperience(float exp) global native
float Function GetExperienceForLevel(int currentLevel) global native
bool Function GetPlayerMovementMode() global native
Function UpdateThirdPerson() global native
Function UnbindObjectHotkey(int hotkey) global native
Form Function GetHotkeyBoundObject(int hotkey) global native
bool Function IsObjectFavorited(Form form) global native
Form Function GetFormEx(int formId) global native
ObjectReference Function GetDialogueTarget() global native
ObjectReference Function GetCurrentCrosshairRef() global native
ObjectReference Function GetCurrentConsoleRef() global native
Function SetPlayerLevel(int level) global native
