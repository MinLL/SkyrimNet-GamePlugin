Scriptname skynet_TelepathyListenIn extends ActiveMagicEffect
{Drives the timed Telepathy: Listen In spell. Enables Telepathy eavesdropping on cast and forces it OFF when the duration expires. If the player had eavesdropping ON via the debug Lesser Power before casting, expiry of this effect will turn it off — that's documented in the MCM tooltip for the debug power.}

Event OnEffectStart(Actor akTarget, Actor akCaster)

    SkyrimNetApi.SetTelepathyEavesdroppingEnabled(true)
    Debug.Notification("Telepathy: Listen In ON (60s)")

EndEvent

Event OnEffectFinish(Actor akTarget, Actor akCaster)

    SkyrimNetApi.SetTelepathyEavesdroppingEnabled(false)
    Debug.Notification("Telepathy: Listen In expired")

EndEvent
