Scriptname Utility Hidden

string Function GameTimeToString(float afGameTime) native global
float Function GetCurrentGameTime() native global
float Function GetCurrentRealTime() native global
bool Function IsInMenuMode() native global
int Function RandomInt(int aiMin = 0, int aiMax = 100) native global
float Function RandomFloat(float afMin = 0.0, float afMax = 1.0) native global
Function SetINIFloat(string ini, float value) native global
Function SetINIInt(string ini, int value) native global
Function SetINIBool(string ini, bool value) native global
Function SetINIString(string ini, string value) native global
Function Wait(float afSeconds) native global
Function WaitGameTime(float afHours) native global
Function WaitMenuMode(float afSeconds) native global
string Function CaptureFrameRate(int numFrames) native global
Function StartFrameRateCapture() native global
Function EndFrameRateCapture() native global
float Function GetAverageFrameRate() native global
float Function GetMinFrameRate() native global
float Function GetMaxFrameRate() native global
int Function GetCurrentMemory() native global
int Function GetBudgetCount() native global
int Function GetCurrentBudget(int aiBudgetNumber) native global
bool Function OverBudget(int aiBudgetNumber) native global
string Function GetBudgetName(int aiBudgetNumber) native global
float Function GetINIFloat(string ini) global native
int Function GetINIInt(string ini) global native
bool Function GetINIBool(string ini) global native
string Function GetINIString(string ini) global native
float[] Function CreateFloatArray(int size, float fill = 0.0) global native
int[] Function CreateIntArray(int size, int fill = 0) global native
bool[] Function CreateBoolArray(int size, bool fill = false) global native
string[] Function CreateStringArray(int size, string fill = "") global native
Form[] Function CreateFormArray(int size, Form fill = None) global native
Alias[] Function CreateAliasArray(int size, Alias fill = None) global native
float[] Function ResizeFloatArray(float[] source, int size, float fill = 0.0) global native
int[] Function ResizeIntArray(int[] source, int size, int fill = 0) global native
bool[] Function ResizeBoolArray(bool[] source, int size, bool fill = false) global native
string[] Function ResizeStringArray(string[] source, int size, string fill = "") global native
Form[] Function ResizeFormArray(Form[] source, int size, Form fill = None) global native
Alias[] Function ResizeAliasArray(Alias[] source, int size, Alias fill = None) global native
