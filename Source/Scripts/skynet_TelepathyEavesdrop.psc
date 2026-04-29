Scriptname skynet_TelepathyEavesdrop extends ActiveMagicEffect

Event OnEffectStart(Actor akTarget, Actor akCaster)

    bool newState = SkyrimNetApi.ToggleTelepathyEavesdropping()
    if newState
        Debug.Notification("Telepathy eavesdropping ON")
    else
        Debug.Notification("Telepathy eavesdropping OFF")
    endif

EndEvent
