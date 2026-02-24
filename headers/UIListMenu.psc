Scriptname UIListMenu extends UIMenuBase

string Property ROOT_MENU = "CustomMenu" autoReadonly
string Property MENU_ROOT = "_root.listMenu." autoReadonly

int Function GetResultInt() native
float Function GetResultFloat() native
string Function GetResultString() native
Function SetPropertyInt(string propertyName, int value) native
Function SetPropertyBool(string propertyName, bool value) native
Function SetPropertyStringA(string propertyName, string[] value) native
int Function AddEntryItem(string entryName, int entryParent = -1, int entryCallback = -1, bool entryHasChildren = false) native
Function SetPropertyIndexInt(string propertyName, int index, int value) native
Function SetPropertyIndexBool(string propertyName, int index, bool value) native
Function SetPropertyIndexString(string propertyName, int index, string value) native
int Function GetPropertyInt(string propertyName) native
Function OnInit() native
Function ResetMenu() native
int Function OpenMenu(Form aForm = None, Form aReceiver = None) native
string Function GetMenuName() native
