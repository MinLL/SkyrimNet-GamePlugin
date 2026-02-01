Scriptname Weather extends Form Hidden

Function ReleaseOverride() native global
Function ForceActive(bool abOverride=false) native
Function SetActive(bool abOverride=false, bool abAccelerate=false) native
Weather Function FindWeather(int auiType) native global
int Function GetClassification() native
Weather Function GetCurrentWeather() native global
Weather Function GetOutgoingWeather() native global
float Function GetCurrentWeatherTransition() native global
int Function GetSkyMode() native global
float Function GetSunGlare() native
float Function GetSunDamage() native
float Function GetWindDirection() native
float Function GetWindDirectionRange() native
float Function GetFogDistance(bool day, int type) native
