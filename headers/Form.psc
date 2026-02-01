Scriptname Form Hidden

Int Function GetFormID() native
int Function GetGoldValue() native
bool Function HasKeyword(Keyword akKeyword) native
bool Function PlayerKnows() native
bool Function RegisterForAnimationEvent(ObjectReference akSender, string asEventName) native
Function RegisterForLOS(Actor akViewer, ObjectReference akTarget) native
Function RegisterForSingleLOSGain(Actor akViewer, ObjectReference akTarget) native
Function RegisterForSingleLOSLost(Actor akViewer, ObjectReference akTarget) native
Function RegisterForSingleUpdate(float afInterval) native
Function RegisterForSleep() native
Function RegisterForTrackedStatsEvent() native
Function RegisterForUpdate(float afInterval) native
Function RegisterForUpdateGameTime(float afInterval) native
Function RegisterForSingleUpdateGameTime(float afInterval) native
Function StartObjectProfiling() native
Function StopObjectProfiling() native
Function UnregisterForAnimationEvent(ObjectReference akSender, string asEventName) native
Function UnregisterForLOS(Actor akViewer, ObjectReference akTarget) native
Function UnregisterForSleep() native
Function UnregisterForTrackedStatsEvent() native
Function UnregisterForUpdate() native
Function UnregisterForUpdateGameTime() native
Int Function GetType() native
string Function GetName() native
Function SetName(string name) native
float Function GetWeight() native
Function SetWeight(float weight) native
Function SetGoldValue(int value) native
int Function GetNumKeywords() native
Keyword Function GetNthKeyword(int index) native
Keyword[] Function GetKeywords() native
bool Function HasKeywordString(string s) native
Function SetPlayerKnows(bool knows) native
Function RegisterForKey(int keyCode) native
Function UnregisterForKey(int keyCode) native
Function UnregisterForAllKeys() native
Function RegisterForControl(string control) native
Function UnregisterForControl(string control) native
Function UnregisterForAllControls() native
Function RegisterForMenu(string menuName) native
Function UnregisterForMenu(string menuName) native
Function UnregisterForAllMenus() native
Function RegisterForModEvent(string eventName, string callbackName) native
Function UnregisterForModEvent(string eventName) native
Function UnregisterForAllModEvents() native
Function SendModEvent(string eventName, string strArg = "", float numArg = 0.0) native
Function RegisterForCameraState() native
Function UnregisterForCameraState() native
Function RegisterForCrosshairRef() native
Function UnregisterForCrosshairRef() native
Function RegisterForActorAction(int actionType) native
Function UnregisterForActorAction(int actionType) native
Function RegisterForNiNodeUpdate() native
Function UnregisterForNiNodeUpdate() native
Form Function TempClone() native
bool Function HasWorldModel() native
string Function GetWorldModelPath() native
Function SetWorldModelPath(string path) native
int Function GetWorldModelNumTextureSets() native
TextureSet Function GetWorldModelNthTextureSet(int n) native
Function SetWorldModelNthTextureSet(TextureSet nSet, int n) native
bool Function IsPlayable() native
