Scriptname ActiveMagicEffect Hidden

Function AddInventoryEventFilter(Form akFilter) native
Function Dispel() native
MagicEffect Function GetBaseObject() native
Actor Function GetCasterActor() native
Actor Function GetTargetActor() native
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
Function RemoveAllInventoryEventFilters() native
Function RemoveInventoryEventFilter(Form akFilter) native
Function StartObjectProfiling() native
Function StopObjectProfiling() native
Function UnregisterForLOS(Actor akViewer, ObjectReference akTarget) native
Function UnregisterForAnimationEvent(ObjectReference akSender, string asEventName) native
Function UnregisterForSleep() native
Function UnregisterForTrackedStatsEvent() native
Function UnregisterForUpdate() native
Function UnregisterForUpdateGameTime() native
float Function GetDuration() native
float Function GetTimeElapsed() native
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
float Function GetMagnitude() native
