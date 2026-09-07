Scriptname skynet_Harness
{Harness-only probes the SkyrimNet DLL dispatches through its decorator path.
Nothing in the game calls this script; it is not registered as a decorator.}

; DLL -> Papyrus -> SkyrimNetApi natives -> Papyrus -> DLL.
; The engine sweep (Core: /harness?api=engine-sweep, ai_docs/ENGINE_SWEEP.md) dispatches this like a
; decorator and checks for the "ok|" prefix; any other value names the first native that failed.
String Function RoundTrip(Actor akActor) global
    If akActor == None
        Return "fail|no actor"
    EndIf
    String uuid = SkyrimNetApi.GetEntityUUID(akActor)
    If uuid == ""
        Return "fail|GetEntityUUID"
    EndIf
    Actor back = SkyrimNetApi.GetActorByUUID(uuid)
    If back != akActor
        Return "fail|GetActorByUUID"
    EndIf
    String build = SkyrimNetApi.GetBuildVersion()
    If build == ""
        Return "fail|GetBuildVersion"
    EndIf
    If !SkyrimNetApi.IsActionRegistered("OpenTrade")
        Return "fail|IsActionRegistered"
    EndIf
    Int queue = SkyrimNetApi.GetSpeechQueueSize()
    If queue < 0
        Return "fail|GetSpeechQueueSize"
    EndIf
    String result = "ok|" + uuid + "|" + build + "|" + akActor.GetDisplayName() + "|vr=" + (SkyrimNetApi.IsRunningVR() as Int) + "|queue=" + queue
    Debug.Trace("[SkyrimNet] harness RoundTrip: " + result)
    Return result
EndFunction
