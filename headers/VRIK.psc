Scriptname VRIK Hidden

Function VrikSetSetting(String name, Float value) native global
Float Function VrikGetSetting(String name) native global
Function VrikSaveSettings() native global
Function VrikRestoreSettings() native global
Float Function VrikGetSettingDefault(String name) native global
Float Function VrikGetSettingMin(String name) native global
Float Function VrikGetSettingMax(String name) native global
Float Function VrikGetSettingInterval(String name) native global
Function VrikSetSlot(String name, Float value) native global
Float Function VrikGetSlot(String name) native global
Function VrikRevertSlotTransform(Int SlotNumber) native global
Function VrikSaveSlots() native global
Float Function VrikGetSlotDefault(String name) native global
Float Function VrikGetSlotMin(String name) native global
Float Function VrikGetSlotMax(String name) native global
Float Function VrikGetSlotInterval(String name) native global
Function VrikSetGesture(String name, Float value) native global
Function VrikSetGestureString(String name, String value) native global
Float Function VrikGetGesture(String name) native global
String Function VrikGetGestureString(String name) native global
Function VrikSaveGestures() native global
Float Function VrikGetGestureDefault(String name) native global
Float Function VrikGetGestureMin(String name) native global
Float Function VrikGetGestureMax(String name) native global
Float Function VrikGetGestureInterval(String name) native global
Function VrikGestureListSetForm(String name, Form form) native global
Function VrikGestureListAppendForm(String name, Form form) native global
Function VrikGestureListAppendNumber(String name, Int value) native global
Function VrikGestureListRemoveElement(String name, Int removeIndex) native global
Int Function VrikGestureListGetCount(String name) native global
Form Function VrikGestureListGetForm(String name, Int formIndex) native global
Int Function VrikGestureListGetNumber(String name, Int numberIndex) native global
Bool Function VrikGetSlotDisplayed(Int SlotNumber) native global
Function VrikSetSlotWeaponType(Int SlotNumber, Form weapon) native global
Function VrikSetSlotEquipped(Int SlotNumber, Int Hand) native global
Function VrikSetSlotForArt(Int slotNumber, Art ArtObject) native global
Function VrikAddGestureAction(String modEventName, String mcmEntryName) native global
Function VrikBeginGestureProfile() native global
Function VrikSetProfileAction(Int gestureNumber, String modEventName) native global
Function VrikEndGestureProfile() native global
Int Function VrikGetModActionCount() native global
String Function VrikGetModActionMenuName(Int index) native global
String[] Function AppendPlayerItems(String[] input, Form selectedForm, Bool addArmor, Bool addWeapons, Bool addSpells, Bool addPowers, Bool addShouts, Bool addConsumables) native global
Form Function GetPlayerItemForm(String name, Form selectedForm, Bool addArmor, Bool addWeapons, Bool addSpells, Bool addPowers, Bool addShouts, Bool addConsumables) native global
Int Function GetPlayerItemIndex(String[] input, String itemName, Int startIndex) native global
Float Function VrikGetFingerPos(Int fingerIndex) native global
Function VrikSetLeftFingerRange(Float min0, Float max0, Float min1, Float max1, Float min2, Float max2, Float min3, Float max3, Float min4, Float max4) native global
Function VrikSetRightFingerRange(Float min0, Float max0, Float min1, Float max1, Float min2, Float max2, Float min3, Float max3, Float min4, Float max4) native global
Function VrikRestoreFingers(Bool isLeft) native global
Int Function VrikGetBuildNumber() native global
Bool Function VrikIsWeaponDrawn() native global
Function VrikPlayerDrawSheathe(Bool weaponDrawn) native global
Int Function VrikGetSpellType(Spell spell) native global
Int Function VrikGetSpellCastType(Spell spell) native global
Bool Function VrikGetSpellAutoCalc(Spell spell) native global
Int Function VrikGetShoutCount(Actor actor) native global
Shout Function VrikGetNthShout(Actor actor, Int index) native global
Int Function VrikGetControllerType() native global
Float Function VrikGetAxisX(Bool onLeft) native global
Float Function VrikGetAxisY(Bool onLeft) native global
Bool Function VrikIsGripTouched(Bool onLeft) native global
Bool Function VrikIsTriggerTouched(Bool onLeft) native global
Bool Function VrikIsThumbstickTouched(Bool onLeft) native global
Bool Function VrikIsButtonATouched(Bool onLeft) native global
Bool Function VrikIsButtonBTouched(Bool onLeft) native global
Bool Function VrikIsTouchpadTouched(Bool onLeft) native global
Bool Function VrikIsAnyButtonTouched(Bool onLeft) native global
Int Function VrikGripTouchCount(Bool onLeft) native global
Int Function VrikTriggerTouchCount(Bool onLeft) native global
Int Function VrikThumbstickTouchCount(Bool onLeft) native global
Int Function VrikButtonATouchCount(Bool onLeft) native global
Int Function VrikButtonBTouchCount(Bool onLeft) native global
Int Function VrikTouchpadTouchCount(Bool onLeft) native global
float Function VrikGripTouchDuration(Bool onLeft) native global
float Function VrikTriggerTouchDuration(Bool onLeft) native global
float Function VrikThumbstickTouchDuration(Bool onLeft) native global
float Function VrikButtonATouchDuration(Bool onLeft) native global
float Function VrikButtonBTouchDuration(Bool onLeft) native global
float Function VrikTouchpadTouchDuration(Bool onLeft) native global
Bool Function VrikIsGripPressed(Bool onLeft) native global
Bool Function VrikIsTriggerPressed(Bool onLeft) native global
Bool Function VrikIsThumbstickPressed(Bool onLeft) native global
Bool Function VrikIsButtonAPressed(Bool onLeft) native global
Bool Function VrikIsButtonBPressed(Bool onLeft) native global
Bool Function VrikIsTouchpadPressed(Bool onLeft) native global
Int Function VrikGripPressCount(Bool onLeft) native global
Int Function VrikTriggerPressCount(Bool onLeft) native global
Int Function VrikThumbstickPressCount(Bool onLeft) native global
Int Function VrikButtonAPressCount(Bool onLeft) native global
Int Function VrikButtonBPressCount(Bool onLeft) native global
Int Function VrikTouchpadPressCount(Bool onLeft) native global
float Function VrikGripPressDuration(Bool onLeft) native global
float Function VrikTriggerPressDuration(Bool onLeft) native global
float Function VrikThumbstickPressDuration(Bool onLeft) native global
float Function VrikButtonAPressDuration(Bool onLeft) native global
float Function VrikButtonBPressDuration(Bool onLeft) native global
float Function VrikTouchpadPressDuration(Bool onLeft) native global
Float Function VrikGetHandX(Bool onLeft) native global
Float Function VrikGetHandY(Bool onLeft) native global
Float Function VrikGetHandZ(Bool onLeft) native global
Float Function VrikGetHmdX() native global
Float Function VrikGetHmdY() native global
Float Function VrikGetHmdZ() native global
Function VrikHapticPulse(Bool onLeftHand, Int frames, Int microsec) native global
Function VrikLog(String text) native global
