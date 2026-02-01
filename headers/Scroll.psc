Scriptname Scroll extends Form Hidden

Function Cast(ObjectReference akSource, ObjectReference akTarget=NONE) native
float Function GetCastTime() native
Perk Function GetPerk() native
int Function GetNumEffects() native
float Function GetNthEffectMagnitude(int index) native
int Function GetNthEffectArea(int index) native
int Function GetNthEffectDuration(int index) native
MagicEffect Function GetNthEffectMagicEffect(int index) native
int Function GetCostliestEffectIndex() native
Function SetNthEffectMagnitude(int index, float value) native
Function SetNthEffectArea(int index, int value) native
Function SetNthEffectDuration(int index, int value) native
EquipSlot Function GetEquipType() native
Function SetEquipType(EquipSlot type) native
float[] Function GetEffectMagnitudes() native
int[] Function GetEffectAreas() native
int[] Function GetEffectDurations() native
MagicEffect[] Function GetMagicEffects() native
