Scriptname Faction extends Form Hidden

int Property kFaction_HiddenFromNPC = 0x00000001 AutoReadOnly
int Property kFaction_SpecialCombat = 0x00000002 AutoReadOnly
int Property kFaction_TrackCrime = 0x00000010 AutoReadOnly
int Property kFaction_IgnoreMurder = 0x00000020 AutoReadOnly
int Property kFaction_IgnoreAssault = 0x00000040 AutoReadOnly
int Property kFaction_IgnoreStealing = 0x00000080 AutoReadOnly
int Property kFaction_IgnoreTrespass = 0x00000100 AutoReadOnly
int Property kFaction_NoReportCrime = 0x00000200 AutoReadOnly
int Property kFaction_CrimeGoldDefaults = 0x00000400 AutoReadOnly
int Property kFaction_IgnorePickpocket = 0x00000800 AutoReadOnly
int Property kFaction_Vendor = 0x00001000 AutoReadOnly
int Property kFaction_CanBeOwner = 0x00002000 AutoReadOnly
int Property kFaction_IgnoreWerewolf = 0x00004000 AutoReadOnly

bool Function CanPayCrimeGold() native
int Function GetCrimeGold() native
int Function GetCrimeGoldNonViolent() native
int Function GetCrimeGoldViolent() native
int Function GetInfamy() native
int Function GetInfamyNonViolent() native
int Function GetInfamyViolent() native
int Function GetReaction(Faction akOther) native
int Function GetStolenItemValueCrime() native
int Function GetStolenItemValueNoCrime() native
bool Function IsFactionInCrimeGroup(Faction akOther) native
bool Function IsPlayerExpelled() native
Function ModCrimeGold(int aiAmount, bool abViolent = false) native
Function ModReaction(Faction akOther, int aiAmount) native
Function PlayerPayCrimeGold(bool abRemoveStolenItems = true, bool abGoToJail = true) native
Function SendAssaultAlarm() native
Function SendPlayerToJail(bool abRemoveInventory = true, bool abRealJail = true) native
Function SetAlly(Faction akOther, bool abSelfIsFriendToOther = false, bool abOtherIsFriendToSelf = false) native
Function SetCrimeGold(int aiGold) native
Function SetCrimeGoldViolent(int aiGold) native
Function SetEnemy(Faction akOther, bool abSelfIsNeutralToOther = false, bool abOtherIsNeutralToSelf = false) native
Function SetPlayerEnemy(bool abIsEnemy = true) native
Function SetPlayerExpelled(bool abIsExpelled = true) native
Function SetReaction(Faction akOther, int aiNewValue) native
Function MakeVendor() native
bool Function IsVendor() native
Function ClearVendor() native
bool Function IsFactionFlagSet(int flag) native
Function SetFactionFlag(int flag) native
Function ClearFactionFlag(int flag) native
bool Function OnlyBuysStolenItems() native
Function SetOnlyBuysStolenItems(bool onlyStolen) native
int Function GetVendorStartHour() native
Function SetVendorStartHour(int hour) native
int Function GetVendorEndHour() native
Function SetVendorEndHour(int hour) native
int Function GetVendorRadius() native
Function SetVendorRadius(int radius) native
ObjectReference Function GetMerchantContainer() native
Function SetMerchantContainer(ObjectReference akContainer) native
bool Function IsNotSellBuy() native
Function SetNotSellBuy(bool notSellBuy) native
FormList Function GetBuySellList() native
Function SetBuySellList(FormList akList) native
