Scriptname SKI_ConfigBase extends SKI_QuestBase

int Property OPTION_FLAG_NONE = 0x00 autoReadonly
int Property OPTION_FLAG_DISABLED = 0x01 autoReadonly
int Property OPTION_FLAG_HIDDEN = 0x02 autoReadonly
int Property OPTION_FLAG_WITH_UNMAP = 0x04 autoReadonly
int Property LEFT_TO_RIGHT = 1 autoReadonly
int Property TOP_TO_BOTTOM = 2 autoReadonly
string Property ModName auto
string[] Property Pages auto
string Property CurrentPage auto

string Function get() native
int Function GetVersion() native
string Function GetCustomControl(int a_keyCode) native
Function ForcePageReset() native
Function SetTitleText(string a_text) native
Function SetInfoText(string a_text) native
Function SetCursorPosition(int a_position) native
Function SetCursorFillMode(int a_fillMode) native
int Function AddEmptyOption() native
int Function AddHeaderOption(string a_text, int a_flags = 0) native
int Function AddTextOption(string a_text, string a_value, int a_flags = 0) native
int Function AddToggleOption(string a_text, bool a_checked, int a_flags = 0) native
int Function AddSliderOption(string a_text, float a_value, string a_formatString = "{0}", int a_flags = 0) native
int Function AddMenuOption(string a_text, string a_value, int a_flags = 0) native
int Function AddColorOption(string a_text, int a_color, int a_flags = 0) native
int Function AddKeyMapOption(string a_text, int a_keyCode, int a_flags = 0) native
int Function AddInputOption(string a_text, string a_value, int a_flags = 0) native
Function AddTextOptionST(string a_stateName, string a_text, string a_value, int a_flags = 0) native
Function AddToggleOptionST(string a_stateName, string a_text, bool a_checked, int a_flags = 0) native
Function AddSliderOptionST(string a_stateName, string a_text, float a_value, string a_formatString = "{0}", int a_flags = 0) native
Function AddMenuOptionST(string a_stateName, string a_text, string a_value, int a_flags = 0) native
Function AddColorOptionST(string a_stateName, string a_text, int a_color, int a_flags = 0) native
Function AddKeyMapOptionST(string a_stateName, string a_text, int a_keyCode, int a_flags = 0) native
Function AddInputOptionST(string a_stateName, string a_text, string a_value, int a_flags = 0) native
Function LoadCustomContent(string a_source, float a_x = 0.0, float a_y = 0.0) native
Function UnloadCustomContent() native
Function SetOptionFlags(int a_option, int a_flags, bool a_noUpdate = false) native
Function SetTextOptionValue(int a_option, string a_value, bool a_noUpdate = false) native
Function SetToggleOptionValue(int a_option, bool a_checked, bool a_noUpdate = false) native
Function SetSliderOptionValue(int a_option, float a_value, string a_formatString = "{0}", bool a_noUpdate = false) native
Function SetMenuOptionValue(int a_option, string a_value, bool a_noUpdate = false) native
Function SetColorOptionValue(int a_option, int a_color, bool a_noUpdate = false) native
Function SetKeyMapOptionValue(int a_option, int a_keyCode, bool a_noUpdate = false) native
Function SetInputOptionValue(int a_option, string a_value, bool a_noUpdate = false) native
Function SetOptionFlagsST(int a_flags, bool a_noUpdate = false, string a_stateName = "") native
Function SetTextOptionValueST(string a_value, bool a_noUpdate = false, string a_stateName = "") native
Function SetToggleOptionValueST(bool a_checked, bool a_noUpdate = false, string a_stateName = "") native
Function SetSliderOptionValueST(float a_value, string a_formatString = "{0}", bool a_noUpdate = false, string a_stateName = "") native
Function SetMenuOptionValueST(string a_value, bool a_noUpdate = false, string a_stateName = "") native
Function SetColorOptionValueST(int a_color, bool a_noUpdate = false, string a_stateName = "") native
Function SetKeyMapOptionValueST(int a_keyCode, bool a_noUpdate = false, string a_stateName = "") native
Function SetInputOptionValueST(string a_value, bool a_noUpdate = false, string a_stateName = "") native
Function SetSliderDialogStartValue(float a_value) native
Function SetSliderDialogDefaultValue(float a_value) native
Function SetSliderDialogRange(float a_minValue, float a_maxValue) native
Function SetSliderDialogInterval(float a_value) native
Function SetMenuDialogStartIndex(int a_value) native
Function SetMenuDialogDefaultIndex(int a_value) native
Function SetMenuDialogOptions(string[] a_options) native
Function SetColorDialogStartColor(int a_color) native
Function SetColorDialogDefaultColor(int a_color) native
Function SetInputDialogStartText(string a_text) native
bool Function ShowMessage(string a_message, bool a_withCancel = true, string a_acceptLabel = "$Accept", string a_cancelLabel = "$Cancel") native
Function Guard() native
