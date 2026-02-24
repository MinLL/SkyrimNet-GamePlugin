Scriptname UIMenuBase extends Quest

bool Property isResetting = false Auto

Function Lock() native
bool Function WaitLock() native
Function Unlock() native
bool Function BlockUntilClosed() native
bool Function WaitForReset() native
int Function OpenMenu(Form akForm = None, Form akReceiver = None) native
string Function GetMenuName() native
Function ResetMenu() native
float Function GetResultFloat() native
int Function GetResultInt() native
string Function GetResultString() native
Form Function GetResultForm() native
int Function GetPropertyInt(string propertyName) native
bool Function GetPropertyBool(string propertyName) native
string Function GetPropertyString(string propertyName) native
float Function GetPropertyFloat(string propertyName) native
Form Function GetPropertyForm(string propertyName) native
Alias Function GetPropertyAlias(string propertyName) native
Function SetPropertyInt(string propertyName, int value) native
Function SetPropertyBool(string propertyName, bool value) native
Function SetPropertyString(string propertyName, string value) native
Function SetPropertyFloat(string propertyName, float value) native
Function SetPropertyForm(string propertyName, Form value) native
Function SetPropertyAlias(string propertyName, Alias value) native
Function SetPropertyIndexInt(string propertyName, int index, int value) native
Function SetPropertyIndexBool(string propertyName, int index, bool value) native
Function SetPropertyIndexString(string propertyName, int index, string value) native
Function SetPropertyIndexFloat(string propertyName, int index, float value) native
Function SetPropertyIndexForm(string propertyName, int index, Form value) native
Function SetPropertyIndexAlias(string propertyName, int index, Alias value) native
Function SetPropertyIntA(string propertyName, int[] value) native
Function SetPropertyBoolA(string propertyName, bool[] value) native
Function SetPropertyStringA(string propertyName, string[] value) native
Function SetPropertyFloatA(string propertyName, float[] value) native
Function SetPropertyFormA(string propertyName, Form[] value) native
Function SetPropertyAliasA(string propertyName, Alias[] value) native
