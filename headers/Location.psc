Scriptname Location extends Form Hidden

float Function GetKeywordData(Keyword akKeyword) native
int Function GetRefTypeAliveCount(LocationRefType akRefType) native
int Function GetRefTypeDeadCount(LocationRefType akRefType) native
bool Function HasCommonParent(Location akOther, Keyword akFilter = None) native
bool Function HasRefType(LocationRefType akRefType) native
bool Function IsCleared() native
bool Function IsChild(Location akOther) native
bool Function IsLoaded() native
bool Function IsSameLocation(Location akOtherLocation, Keyword akKeyword = None) native
Function SetKeywordData(Keyword akKeyword, float afData) native
Function SetCleared(bool abCleared = true) native
Location Function GetParent() native
