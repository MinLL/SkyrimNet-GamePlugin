Scriptname StorageUtil Hidden

int Function SetIntValue(Form ObjKey, string KeyName, int value) global native
float Function SetFloatValue(Form ObjKey, string KeyName, float value) global native
string Function SetStringValue(Form ObjKey, string KeyName, string value) global native
Form Function SetFormValue(Form ObjKey, string KeyName, Form value) global native
bool Function UnsetIntValue(Form ObjKey, string KeyName) global native
bool Function UnsetFloatValue(Form ObjKey, string KeyName) global native
bool Function UnsetStringValue(Form ObjKey, string KeyName) global native
bool Function UnsetFormValue(Form ObjKey, string KeyName) global native
bool Function HasIntValue(Form ObjKey, string KeyName) global native
bool Function HasFloatValue(Form ObjKey, string KeyName) global native
bool Function HasStringValue(Form ObjKey, string KeyName) global native
bool Function HasFormValue(Form ObjKey, string KeyName) global native
int Function GetIntValue(Form ObjKey, string KeyName, int missing = 0) global native
float Function GetFloatValue(Form ObjKey, string KeyName, float missing = 0.0) global native
string Function GetStringValue(Form ObjKey, string KeyName, string missing = "") global native
Form Function GetFormValue(Form ObjKey, string KeyName, Form missing = none) global native
int Function PluckIntValue(Form ObjKey, string KeyName, int missing = 0) global native
float Function PluckFloatValue(Form ObjKey, string KeyName, float missing = 0.0) global native
string Function PluckStringValue(Form ObjKey, string KeyName, string missing = "") global native
Form Function PluckFormValue(Form ObjKey, string KeyName, Form missing = none) global native
int Function AdjustIntValue(Form ObjKey, string KeyName, int amount) global native
float Function AdjustFloatValue(Form ObjKey, string KeyName, float amount) global native
int Function IntListAdd(Form ObjKey, string KeyName, int value, bool allowDuplicate = true) global native
int Function FloatListAdd(Form ObjKey, string KeyName, float value, bool allowDuplicate = true) global native
int Function StringListAdd(Form ObjKey, string KeyName, string value, bool allowDuplicate = true) global native
int Function FormListAdd(Form ObjKey, string KeyName, Form value, bool allowDuplicate = true) global native
int Function IntListGet(Form ObjKey, string KeyName, int index) global native
float Function FloatListGet(Form ObjKey, string KeyName, int index) global native
string Function StringListGet(Form ObjKey, string KeyName, int index) global native
Form Function FormListGet(Form ObjKey, string KeyName, int index) global native
int Function IntListSet(Form ObjKey, string KeyName, int index, int value) global native
float Function FloatListSet(Form ObjKey, string KeyName, int index, float value) global native
string Function StringListSet(Form ObjKey, string KeyName, int index, string value) global native
Form Function FormListSet(Form ObjKey, string KeyName, int index, Form value) global native
int Function IntListPluck(Form ObjKey, string KeyName, int index, int missing) global native
float Function FloatListPluck(Form ObjKey, string KeyName, int index, float missing) global native
string Function StringListPluck(Form ObjKey, string KeyName, int index, string missing) global native
Form Function FormListPluck(Form ObjKey, string KeyName, int index, Form missing) global native
int Function IntListShift(Form ObjKey, string KeyName) global native
float Function FloatListShift(Form ObjKey, string KeyName) global native
string Function StringListShift(Form ObjKey, string KeyName) global native
Form Function FormListShift(Form ObjKey, string KeyName) global native
int Function IntListPop(Form ObjKey, string KeyName) global native
float Function FloatListPop(Form ObjKey, string KeyName) global native
string Function StringListPop(Form ObjKey, string KeyName) global native
Form Function FormListPop(Form ObjKey, string KeyName) global native
int Function IntListAdjust(Form ObjKey, string KeyName, int index, int amount) global native
float Function FloatListAdjust(Form ObjKey, string KeyName, int index, float amount) global native
bool Function IntListInsert(Form ObjKey, string KeyName, int index, int value) global native
bool Function FloatListInsert(Form ObjKey, string KeyName, int index, float value) global native
bool Function StringListInsert(Form ObjKey, string KeyName, int index, string value) global native
bool Function FormListInsert(Form ObjKey, string KeyName, int index, Form value) global native
int Function IntListRemove(Form ObjKey, string KeyName, int value, bool allInstances = false) global native
int Function FloatListRemove(Form ObjKey, string KeyName, float value, bool allInstances = false) global native
int Function StringListRemove(Form ObjKey, string KeyName, string value, bool allInstances = false) global native
int Function FormListRemove(Form ObjKey, string KeyName, Form value, bool allInstances = false) global native
int Function IntListClear(Form ObjKey, string KeyName) global native
int Function FloatListClear(Form ObjKey, string KeyName) global native
int Function StringListClear(Form ObjKey, string KeyName) global native
int Function FormListClear(Form ObjKey, string KeyName) global native
bool Function IntListRemoveAt(Form ObjKey, string KeyName, int index) global native
bool Function FloatListRemoveAt(Form ObjKey, string KeyName, int index) global native
bool Function StringListRemoveAt(Form ObjKey, string KeyName, int index) global native
bool Function FormListRemoveAt(Form ObjKey, string KeyName, int index) global native
int Function IntListCount(Form ObjKey, string KeyName) global native
int Function FloatListCount(Form ObjKey, string KeyName) global native
int Function StringListCount(Form ObjKey, string KeyName) global native
int Function FormListCount(Form ObjKey, string KeyName) global native
int Function IntListCountValue(Form ObjKey, string KeyName, int value, bool exclude = false) global native
int Function FloatListCountValue(Form ObjKey, string KeyName, float value, bool exclude = false) global native
int Function StringListCountValue(Form ObjKey, string KeyName, string value, bool exclude = false) global native
int Function FormListCountValue(Form ObjKey, string KeyName, Form value, bool exclude = false) global native
int Function IntListFind(Form ObjKey, string KeyName, int value) global native
int Function FloatListFind(Form ObjKey, string KeyName, float value) global native
int Function StringListFind(Form ObjKey, string KeyName, string value) global native
int Function FormListFind(Form ObjKey, string KeyName, Form value) global native
bool Function IntListHas(Form ObjKey, string KeyName, int value) global native
bool Function FloatListHas(Form ObjKey, string KeyName, float value) global native
bool Function StringListHas(Form ObjKey, string KeyName, string value) global native
bool Function FormListHas(Form ObjKey, string KeyName, Form value) global native
Function IntListSort(Form ObjKey, string KeyName) global native
Function FloatListSort(Form ObjKey, string KeyName) global native
Function StringListSort(Form ObjKey, string KeyName) global native
Function FormListSort(Form ObjKey, string KeyName) global native
Function IntListSlice(Form ObjKey, string KeyName, int[] slice, int startIndex = 0) global native
Function FloatListSlice(Form ObjKey, string KeyName, float[] slice, int startIndex = 0) global native
Function StringListSlice(Form ObjKey, string KeyName, string[] slice, int startIndex = 0) global native
Function FormListSlice(Form ObjKey, string KeyName, Form[] slice, int startIndex = 0) global native
int Function IntListResize(Form ObjKey, string KeyName, int toLength, int filler = 0) global native
int Function FloatListResize(Form ObjKey, string KeyName, int toLength, float filler = 0.0) global native
int Function StringListResize(Form ObjKey, string KeyName, int toLength, string filler = "") global native
int Function FormListResize(Form ObjKey, string KeyName, int toLength, Form filler = none) global native
bool Function IntListCopy(Form ObjKey, string KeyName, int[] copy) global native
bool Function FloatListCopy(Form ObjKey, string KeyName, float[] copy) global native
bool Function StringListCopy(Form ObjKey, string KeyName, string[] copy) global native
bool Function FormListCopy(Form ObjKey, string KeyName, Form[] copy) global native
int[] Function IntListToArray(Form ObjKey, string KeyName) global native
float[] Function FloatListToArray(Form ObjKey, string KeyName) global native
string[] Function StringListToArray(Form ObjKey, string KeyName) global native
Form[] Function FormListToArray(Form ObjKey, string KeyName) global native
int Function IntListRandom(Form ObjKey, string KeyName) global native
float Function FloatListRandom(Form ObjKey, string KeyName) global native
string Function StringListRandom(Form ObjKey, string KeyName) global native
Form Function FormListRandom(Form ObjKey, string KeyName) global native
Form[] Function FormListFilterByTypes(Form ObjKey, string KeyName, int[] FormTypeIDs, bool ReturnMatching = true) global native
Form[] Function FormListFilterByType(Form ObjKey, string KeyName, int FormTypeID, bool ReturnMatching = true) global native
int Function CountIntValuePrefix(string PrefixKey) global native
int Function CountFloatValuePrefix(string PrefixKey) global native
int Function CountStringValuePrefix(string PrefixKey) global native
int Function CountFormValuePrefix(string PrefixKey) global native
int Function CountIntListPrefix(string PrefixKey) global native
int Function CountFloatListPrefix(string PrefixKey) global native
int Function CountStringListPrefix(string PrefixKey) global native
int Function CountFormListPrefix(string PrefixKey) global native
int Function CountAllPrefix(string PrefixKey) global native
int Function CountObjIntValuePrefix(Form ObjKey, string PrefixKey) global native
int Function CountObjFloatValuePrefix(Form ObjKey, string PrefixKey) global native
int Function CountObjStringValuePrefix(Form ObjKey, string PrefixKey) global native
int Function CountObjFormValuePrefix(Form ObjKey, string PrefixKey) global native
int Function CountObjIntListPrefix(Form ObjKey, string PrefixKey) global native
int Function CountObjFloatListPrefix(Form ObjKey, string PrefixKey) global native
int Function CountObjStringListPrefix(Form ObjKey, string PrefixKey) global native
int Function CountObjFormListPrefix(Form ObjKey, string PrefixKey) global native
int Function CountAllObjPrefix(Form ObjKey, string PrefixKey) global native
int Function ClearIntValuePrefix(string PrefixKey) global native
int Function ClearFloatValuePrefix(string PrefixKey) global native
int Function ClearStringValuePrefix(string PrefixKey) global native
int Function ClearFormValuePrefix(string PrefixKey) global native
int Function ClearIntListPrefix(string PrefixKey) global native
int Function ClearFloatListPrefix(string PrefixKey) global native
int Function ClearStringListPrefix(string PrefixKey) global native
int Function ClearFormListPrefix(string PrefixKey) global native
int Function ClearAllPrefix(string PrefixKey) global native
int Function ClearObjIntValuePrefix(Form ObjKey, string PrefixKey) global native
int Function ClearObjFloatValuePrefix(Form ObjKey, string PrefixKey) global native
int Function ClearObjStringValuePrefix(Form ObjKey, string PrefixKey) global native
int Function ClearObjFormValuePrefix(Form ObjKey, string PrefixKey) global native
int Function ClearObjIntListPrefix(Form ObjKey, string PrefixKey) global native
int Function ClearObjFloatListPrefix(Form ObjKey, string PrefixKey) global native
int Function ClearObjStringListPrefix(Form ObjKey, string PrefixKey) global native
int Function ClearObjFormListPrefix(Form ObjKey, string PrefixKey) global native
int Function ClearAllObjPrefix(Form ObjKey, string PrefixKey) global native
Function debug_DeleteValues(Form ObjKey) global native
Function debug_DeleteAllValues() global native
int Function debug_Cleanup() global native
Form[] Function debug_AllIntObjs() global native
Form[] Function debug_AllFloatObjs() global native
Form[] Function debug_AllStringObjs() global native
Form[] Function debug_AllFormObjs() global native
Form[] Function debug_AllIntListObjs() global native
Form[] Function debug_AllFloatListObjs() global native
Form[] Function debug_AllStringListObjs() global native
Form[] Function debug_AllFormListObjs() global native
string[] Function debug_AllObjIntKeys(Form ObjKey) global native
string[] Function debug_AllObjFloatKeys(Form ObjKey) global native
string[] Function debug_AllObjStringKeys(Form ObjKey) global native
string[] Function debug_AllObjFormKeys(Form ObjKey) global native
string[] Function debug_AllObjIntListKeys(Form ObjKey) global native
string[] Function debug_AllObjFloatListKeys(Form ObjKey) global native
string[] Function debug_AllObjStringListKeys(Form ObjKey) global native
string[] Function debug_AllObjFormListKeys(Form ObjKey) global native
int Function debug_GetIntObjectCount() global native
int Function debug_GetFloatObjectCount() global native
int Function debug_GetStringObjectCount() global native
int Function debug_GetFormObjectCount() global native
int Function debug_GetIntListObjectCount() global native
int Function debug_GetFloatListObjectCount() global native
int Function debug_GetStringListObjectCount() global native
int Function debug_GetFormListObjectCount() global native
Form Function debug_GetIntObject(int index) global native
Form Function debug_GetFloatObject(int index) global native
Form Function debug_GetStringObject(int index) global native
Form Function debug_GetFormObject(int index) global native
Form Function debug_GetIntListObject(int index) global native
Form Function debug_GetFloatListObject(int index) global native
Form Function debug_GetStringListObject(int index) global native
Form Function debug_GetFormListObject(int index) global native
int Function debug_GetIntKeysCount(Form ObjKey) global native
int Function debug_GetFloatKeysCount(Form ObjKey) global native
int Function debug_GetStringKeysCount(Form ObjKey) global native
int Function debug_GetFormKeysCount(Form ObjKey) global native
int Function debug_GetIntListKeysCount(Form ObjKey) global native
int Function debug_GetFloatListKeysCount(Form ObjKey) global native
int Function debug_GetStringListKeysCount(Form ObjKey) global native
int Function debug_GetFormListKeysCount(Form ObjKey) global native
string Function debug_GetIntKey(Form ObjKey, int index) global native
string Function debug_GetFloatKey(Form ObjKey, int index) global native
string Function debug_GetStringKey(Form ObjKey, int index) global native
string Function debug_GetFormKey(Form ObjKey, int index) global native
string Function debug_GetIntListKey(Form ObjKey, int index) global native
string Function debug_GetFloatListKey(Form ObjKey, int index) global native
string Function debug_GetStringListKey(Form ObjKey, int index) global native
string Function debug_GetFormListKey(Form ObjKey, int index) global native
int Function FileSetIntValue(string KeyName, int value) global native
float Function FileSetFloatValue(string KeyName, float value) global native
string Function FileSetStringValue(string KeyName, string value) global native
form Function FileSetFormValue(string KeyName, Form value) global native
int Function FileAdjustIntValue(string KeyName, int amount) global native
float Function FileAdjustFloatValue(string KeyName, float amount) global native
bool Function FileUnsetIntValue(string KeyName) global native
bool Function FileUnsetFloatValue(string KeyName) global native
bool Function FileUnsetStringValue(string KeyName) global native
bool Function FileUnsetFormValue(string KeyName) global native
bool Function FileHasIntValue(string KeyName) global native
bool Function FileHasFloatValue(string KeyName) global native
bool Function FileHasStringValue(string KeyName) global native
bool Function FileHasFormValue(string KeyName) global native
int Function FileGetIntValue(string KeyName, int missing = 0) global native
float Function FileGetFloatValue(string KeyName, float missing = 0.0) global native
string Function FileGetStringValue(string KeyName, string missing = "") global native
Form Function FileGetFormValue(string KeyName, Form missing = none) global native
int Function FileIntListAdd(string KeyName, int value, bool allowDuplicate = true) global native
int Function FileFloatListAdd(string KeyName, float value, bool allowDuplicate = true) global native
int Function FileStringListAdd(string KeyName, string value, bool allowDuplicate = true) global native
int Function FileFormListAdd(string KeyName, Form value, bool allowDuplicate = true) global native
int Function FileIntListAdjust(string KeyName, int index, int amount) global native
float Function FileFloatListAdjust(string KeyName, int index, float amount) global native
int Function FileIntListRemove(string KeyName, int value, bool allInstances = false) global native
int Function FileFloatListRemove(string KeyName, float value, bool allInstances = false) global native
int Function FileStringListRemove(string KeyName, string value, bool allInstances = false) global native
int Function FileFormListRemove(string KeyName, Form value, bool allInstances = false) global native
int Function FileIntListGet(string KeyName, int index) global native
float Function FileFloatListGet(string KeyName, int index) global native
string Function FileStringListGet(string KeyName, int index) global native
Form Function FileFormListGet(string KeyName, int index) global native
int Function FileIntListSet(string KeyName, int index, int value) global native
float Function FileFloatListSet(string KeyName, int index, float value) global native
string Function FileStringListSet(string KeyName, int index, string value) global native
Form Function FileFormListSet(string KeyName, int index, Form value) global native
int Function FileIntListClear(string KeyName) global native
int Function FileFloatListClear(string KeyName) global native
int Function FileStringListClear(string KeyName) global native
int Function FileFormListClear(string KeyName) global native
bool Function FileIntListRemoveAt(string KeyName, int index) global native
bool Function FileFloatListRemoveAt(string KeyName, int index) global native
bool Function FileStringListRemoveAt(string KeyName, int index) global native
bool Function FileFormListRemoveAt(string KeyName, int index) global native
bool Function FileIntListInsert(string KeyName, int index, int value) global native
bool Function FileFloatListInsert(string KeyName, int index, float value) global native
bool Function FileStringListInsert(string KeyName, int index, string value) global native
bool Function FileFormListInsert(string KeyName, int index, Form value) global native
int Function FileIntListCount(string KeyName) global native
int Function FileFloatListCount(string KeyName) global native
int Function FileStringListCount(string KeyName) global native
int Function FileFormListCount(string KeyName) global native
int Function FileIntListFind(string KeyName, int value) global native
int Function FileFloatListFind(string KeyName, float value) global native
int Function FileStringListFind(string KeyName, string value) global native
int Function FileFormListFind(string KeyName, Form value) global native
bool Function FileIntListHas(string KeyName, int value) global native
bool Function FileFloatListHas(string KeyName, float value) global native
bool Function FileStringListHas(string KeyName, string value) global native
bool Function FileFormListHas(string KeyName, Form value) global native
Function FileIntListSlice(string KeyName, int[] slice, int startIndex = 0) global native
Function FileFloatListSlice(string KeyName, float[] slice, int startIndex = 0) global native
Function FileStringListSlice(string KeyName, string[] slice, int startIndex = 0) global native
Function FileFormListSlice(string KeyName, Form[] slice, int startIndex = 0) global native
int Function FileIntListResize(string KeyName, int toLength, int filler = 0) global native
int Function FileFloatListResize(string KeyName, int toLength, float filler = 0.0) global native
int Function FileStringListResize(string KeyName, int toLength, string filler = "") global native
int Function FileFormListResize(string KeyName, int toLength, Form filler = none) global native
bool Function FileIntListCopy(string KeyName, int[] copy) global native
bool Function FileFloatListCopy(string KeyName, float[] copy) global native
bool Function FileStringListCopy(string KeyName, string[] copy) global native
bool Function FileFormListCopy(string KeyName, Form[] copy) global native
Function debug_SaveFile() global native
int Function debug_FileGetIntKeysCount() global native
int Function debug_FileGetFloatKeysCount() global native
int Function debug_FileGetStringKeysCount() global native
int Function debug_FileGetIntListKeysCount() global native
int Function debug_FileGetFloatListKeysCount() global native
int Function debug_FileGetStringListKeysCount() global native
string Function debug_FileGetIntKey(int index) global native
string Function debug_FileGetFloatKey(int index) global native
string Function debug_FileGetStringKey(int index) global native
string Function debug_FileGetIntListKey(int index) global native
string Function debug_FileGetFloatListKey(int index) global native
string Function debug_FileGetStringListKey(int index) global native
Function debug_FileDeleteAllValues() global native
Function debug_SetDebugMode(bool enabled) global native
bool Function ImportFile(string fileName, string restrictKey = "", int restrictType = -1, Form restrictForm = none, bool restrictGlobal = false, bool keyContains = false) global native
bool Function ExportFile(string fileName, string restrictKey = "", int restrictType = -1, Form restrictForm = none, bool restrictGlobal = false, bool keyContains = false, bool append = true) global native
