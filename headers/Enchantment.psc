Scriptname Enchantment extends Form Hidden

bool Function IsHostile() native
int Function GetNumEffects() native
float Function GetNthEffectMagnitude(int index) native
int Function GetNthEffectArea(int index) native
int Function GetNthEffectDuration(int index) native
MagicEffect Function GetNthEffectMagicEffect(int index) native
int Function GetCostliestEffectIndex() native
Function SetNthEffectMagnitude(int index, float value) native
Function SetNthEffectArea(int index, int value) native
Function SetNthEffectDuration(int index, int value) native
Enchantment Function GetBaseEnchantment() native
FormList Function GetKeywordRestrictions() native
Function SetKeywordRestrictions(FormList newKeywordList) native
