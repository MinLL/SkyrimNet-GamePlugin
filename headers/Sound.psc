Scriptname Sound extends Form Hidden

int Function Play(ObjectReference akSource) native
bool Function PlayAndWait(ObjectReference akSource) native
Function StopInstance(int aiPlaybackInstance) native global
Function SetInstanceVolume(int aiPlaybackInstance, float afVolume) native global
SoundDescriptor Function GetDescriptor() native
