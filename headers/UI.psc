Scriptname UI Hidden

bool Function IsMenuOpen(string menuName) global native
Function SetBool(string menuName, string target, bool value) global native
Function SetInt(string menuName, string target, int value) global native
Function SetFloat(string menuName, string target, float value) global native
Function SetString(string menuName, string target, string value) global native
Function SetNumber(string menuName, string target, float value) global native
bool Function GetBool(string menuName, string target) global native
int Function GetInt(string menuName, string target) global native
float Function GetFloat(string menuName, string target) global native
string Function GetString(string menuName, string target) global native
float Function GetNumber(string menuName, string target) global native
Function Invoke(string menuName, string target) global native
Function InvokeBool(string menuName, string target, bool arg) global native
Function InvokeInt(string menuName, string target, int arg) global native
Function InvokeFloat(string menuName, string target, float arg) global native
Function InvokeString(string menuName, string target, string arg) global native
Function InvokeNumber(string menuName, string target, float arg) global native
Function InvokeBoolA(string menuName, string target, bool[] args) global native
Function InvokeIntA(string menuName, string target, int[] args) global native
Function InvokeFloatA(string menuName, string target, float[] args) global native
Function InvokeStringA(string menuName, string target, string[] args) global native
Function InvokeNumberA(string menuName, string target, float[] args) global native
Function InvokeForm(string menuName, string target, Form arg) global native
bool Function IsTextInputEnabled() global native
Function OpenCustomMenu(string swfPath, int flags = 0) global native
Function CloseCustomMenu() global native
