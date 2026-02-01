Scriptname Quest extends Form Hidden

bool Function ModObjectiveGlobal(float afModValue, GlobalVariable aModGlobal, int aiObjectiveID = -1, float afTargetValue = -1.0, bool abCountingUp = true, bool abCompleteObjective = true, bool abRedisplayObjective = true) native
Function CompleteAllObjectives() native
Function CompleteQuest() native
Function FailAllObjectives() native
Alias Function GetAlias(int aiAliasID) native
int Function GetCurrentStageID() native
int Function GetStage() native
bool Function GetStageDone(int aiStage) native
bool Function IsActive() native
bool Function IsCompleted() native
bool Function IsObjectiveCompleted(int aiObjective) native
bool Function IsObjectiveDisplayed(int aiObjective) native
bool Function IsObjectiveFailed(int aiObjective) native
bool Function IsRunning() native
bool Function IsStageDone(int aiStage) native
bool Function IsStarting() native
bool Function IsStopping() native
bool Function IsStopped() native
Function Reset() native
Function SetActive(bool abActive = true) native
bool Function SetCurrentStageID(int aiStageID) native
Function SetObjectiveCompleted(int aiObjective, bool abCompleted = true) native
Function SetObjectiveDisplayed(int aiObjective, bool abDisplayed = true, bool abForce = false) native
Function SetObjectiveFailed(int aiObjective, bool abFailed = true) native
bool Function SetStage(int aiStage) native
bool Function Start() native
Function Stop() native
bool Function UpdateCurrentInstanceGlobal(GlobalVariable aUpdateGlobal) native
Quest Function GetQuest(string editorId) global native
string Function GetID() native
int Function GetPriority() native
int Function GetNumAliases() native
Alias Function GetNthAlias(int index) native
Alias Function GetAliasByName(string name) native
Alias Function GetAliasById(int aliasId) native
Alias[] Function GetAliases() native
