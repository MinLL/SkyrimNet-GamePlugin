---
title: Papyrus API
audience: modder
covers: ["papyrus:SkyrimNetApi.*"]
---

# Papyrus API

Other mods talk to SkyrimNet through the native functions of the
`SkyrimNetApi` script. Every function is `Global Native`, so you call it on
the script itself, for example
`SkyrimNetApi.RegisterDecorator("my_decorator", "MyModScript", "MyDecorator")`.
To compile against it, put `SkyrimNetApi.psc` from SkyrimNet's
[`Source/Scripts`](https://github.com/MinLL/SkyrimNet-GamePlugin/tree/main/Source/Scripts)
on your Papyrus import path.

This page is generated from that script's own comments, so it always matches
the release it was built from. To register an action from Papyrus, start with
:papyrus[SkyrimNetApi.RegisterAction]; for a decorator, with
:papyrus[SkyrimNetApi.RegisterDecorator].

::papyrus{script="SkyrimNetApi"}
