Scriptname Armor extends Form Hidden

int Property kSlotMask30 = 0x00000001 AutoReadOnly
int Property kSlotMask31 = 0x00000002 AutoReadOnly
int Property kSlotMask32 = 0x00000004 AutoReadOnly
int Property kSlotMask33 = 0x00000008 AutoReadOnly
int Property kSlotMask34 = 0x00000010 AutoReadOnly
int Property kSlotMask35 = 0x00000020 AutoReadOnly
int Property kSlotMask36 = 0x00000040 AutoReadOnly
int Property kSlotMask37 = 0x00000080 AutoReadOnly
int Property kSlotMask38 = 0x00000100 AutoReadOnly
int Property kSlotMask39 = 0x00000200 AutoReadOnly
int Property kSlotMask40 = 0x00000400 AutoReadOnly
int Property kSlotMask41 = 0x00000800 AutoReadOnly
int Property kSlotMask42 = 0x00001000 AutoReadOnly
int Property kSlotMask43 = 0x00002000 AutoReadOnly
int Property kSlotMask44 = 0x00004000 AutoReadOnly
int Property kSlotMask45 = 0x00008000 AutoReadOnly
int Property kSlotMask46 = 0x00010000 AutoReadOnly
int Property kSlotMask47 = 0x00020000 AutoReadOnly
int Property kSlotMask48 = 0x00040000 AutoReadOnly
int Property kSlotMask49 = 0x00080000 AutoReadOnly
int Property kSlotMask50 = 0x00100000 AutoReadOnly
int Property kSlotMask51 = 0x00200000 AutoReadOnly
int Property kSlotMask52 = 0x00400000 AutoReadOnly
int Property kSlotMask53 = 0x00800000 AutoReadOnly
int Property kSlotMask54 = 0x01000000 AutoReadOnly
int Property kSlotMask55 = 0x02000000 AutoReadOnly
int Property kSlotMask56 = 0x04000000 AutoReadOnly
int Property kSlotMask57 = 0x08000000 AutoReadOnly
int Property kSlotMask58 = 0x10000000 AutoReadOnly
int Property kSlotMask59 = 0x20000000 AutoReadOnly
int Property kSlotMask60 = 0x40000000 AutoReadOnly
int Property kSlotMask61 = 0x80000000 AutoReadOnly

float Function GetWarmthRating() native
int Function GetArmorRating() native
int Function GetAR() native
Function SetArmorRating(int armorRating) native
Function SetAR(int armorRating) native
Function ModArmorRating(int modBy) native
Function ModAR(int modBy) native
string Function GetModelPath(bool bFemalePath) native
Function SetModelPath(string path, bool bFemalePath) native
string Function GetIconPath(bool bFemalePath) native
Function SetIconPath(string path, bool bFemalePath) native
string Function GetMessageIconPath(bool bFemalePath) native
Function SetMessageIconPath(string path, bool bFemalePath) native
int Function GetWeightClass() native
Function SetWeightClass(int weightClass) native
Enchantment Function GetEnchantment() native
Function SetEnchantment(Enchantment e) native
bool Function IsLightArmor() native
bool Function IsHeavyArmor() native
bool Function IsClothing() native
bool Function IsBoots() native
bool Function IsCuirass() native
bool Function IsGauntlets() native
bool Function IsHelmet() native
bool Function IsShield() native
bool Function IsJewelry() native
bool Function IsClothingHead() native
bool Function IsClothingBody() native
bool Function IsClothingFeet() native
bool Function IsClothingHands() native
bool Function IsClothingRing() native
bool Function IsClothingRich() native
bool Function IsClothingPoor() native
int Function GetSlotMask() native
Function SetSlotMask(int slotMask) native
int Function AddSlotToMask(int slotMask) native
int Function RemoveSlotFromMask(int slotMask) native
int Function GetMaskForSlot(int slot) global native
int Function GetNumArmorAddons() native
ArmorAddon Function GetNthArmorAddon(int n) native
