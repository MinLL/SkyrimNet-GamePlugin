# Prompts in Skyrimnet

In SkyrimNet, all prompts are defined in their respective prompt files in the content store (shipped defaults under `store/skyrimnet.base/prompts`, your edits under `overlay/prompts`). This does not only apply to the prompt for getting the npc to speak, but also things like Generating Memories, Prompts for choosing the appropriate action to call as well as prompts added through mods.

Likely, the most relevant prompt sub-folders for you to add your files in are `prompts/submodules/character_bio/` and `prompts/submodules/system_head/`

## Character Bio

All prompt files in the `character_bio` folder get combined into each characters bio. 

They are combined in the order they appear in the folder, so having your prompt start appropriate number, you can choose at which point in the bio you would like your custom entry to be rendered (eg. `0001_myMod.prompt` would render before anything else)

Since you character bios are always evaluated for a specific npc, you have the npc for which it is evaluate available in the `npc` variable

```
{{ decnpc(npc.UUID).name }} has been magically turned into a mudcrab
```

## System Head

TBA

## Decorators

Decorators are functions callable from within your prompt, that return some value.

There are several native decorators supplied, an overview of which can be found in the SkyrimNet dashboard.

## Creating Custom Decorators

You can register your own custom decorators using papyrus, to get your mods data into the prompts.

In your papyrus code, register a decorator with SkyrimNet
```
Function Init()
    SkyrimNetApi.RegisterDecorator(\
            "get_npc_mudcrab_status",\  ; Decorator name
            "MudcrabMod_Decorators",\ ; Script name that contains the function
            "GetMudcrabStatus") ; function name
EndFunction
```

Then implement the registered function to return all the data you need as json
```
String Function GetMudcrabStatus(Actor akActor)
    return "{\"isMudcrab\": \"true\", \"mudcrabName\": \"Crabby Mc'" + akActor.GetDisplayName() + "\"}"
EndFunction
```

In any prompt, you can then call the decorator
```
{{ get_npc_mudcrab_status(npc.UUID).mudcrabName }}
```


> [!CAUTION]
> Trying to evaluate a mod-added decorator on an npc, that is neither speaker nor target will result in a 'decorator function not found' error. 
> This can, for example, happen as a result of looping over nearby npcs and calling your custom decorator on them 
> 
> This will not work:
> ```
> {% for npc in get_nearby_npc_list(player.UUID) %}
>     {{ get_npc_mudcrab_status(npc.UUID) }}  
> {% endfor %}
> ```

