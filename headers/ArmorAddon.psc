Scriptname ArmorAddon extends Form Hidden

string Function GetModelPath(bool firstPerson, bool female) native
Function SetModelPath(string path, bool firstPerson, bool female) native
int Function GetModelNumTextureSets(bool first, bool female) native
TextureSet Function GetModelNthTextureSet(int n, bool first, bool female) native
Function SetModelNthTextureSet(TextureSet texture, int n, bool first, bool female) native
int Function GetNumAdditionalRaces() native
Race Function GetNthAdditionalRace(int n) native
int Function GetSlotMask() native
Function SetSlotMask(int slotMask) native
int Function AddSlotToMask(int slotMask) native
int Function RemoveSlotFromMask(int slotMask) native
int Function GetMaskForSlot(int slot) global native
