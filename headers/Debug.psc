Scriptname Debug Hidden

Function CenterOnCell(string asCellname) native global
float Function CenterOnCellAndWait(string asCellname) native global
float Function PlayerMoveToAndWait(string asDestRef) native global
Function CloseUserLog(string asLogName) native global
Function DebugChannelNotify(string channel, string message) native global
Function DumpAliasData(Quest akQuest) native global
string Function GetConfigName() native global
string Function GetPlatformName() native global
string Function GetVersionNumber() native global
Function MessageBox(string asMessageBoxText) native global
Function Notification(string asNotificationText) native global
bool Function OpenUserLog(string asLogName) native global
Function QuitGame() native global
Function SetFootIK(bool abFootIK) native global
Function SetGodMode(bool abGodMode) native global
Function SendAnimationEvent(ObjectReference arRef, string asEventName) native global
Function StartScriptProfiling(string asScriptName) native global
Function StartStackProfiling() native global
Function StopScriptProfiling(string asScriptName) native global
Function StopStackProfiling() native global
Function TakeScreenshot(string asFilename) native global
Function ToggleAI() native global
Function ToggleCollisions() native global
Function ToggleMenus() native global
Function Trace(string asTextToPrint, int aiSeverity = 0) native global
Function TraceStack(string asTextToPrint = "Tracing stack on request", int aiSeverity = 0) native global
bool Function TraceUser(string asUserLog, string asTextToPrint, int aiSeverity = 0) native global
Function TraceConditional(string TextToPrint, bool ShowTrace) Global native
Function TraceAndBox(string asTextToPrint, int aiSeverity = 0) global native
Function ShowRefPosition(ObjectReference arRef) native global
Function DBSendPlayerPosition() native global
