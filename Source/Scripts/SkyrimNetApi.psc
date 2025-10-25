Scriptname SkyrimNetApi


; -----------------------------------------------------------------------------
; --- Decorator Management ---
; -----------------------------------------------------------------------------

; Register a decorator to be used when resolving a variable in a prompt
; - decoratorID: Unique identifier for the decorator, e.g., "my_custom_decorator"
; - sourceScript: The script where the global decorator function is defined
; - functionName: The name of the function in the source script that implements the decorator logic
;                 
;   Functions with an Actor parameter can be called from the prompt template by passing a UUID 
;   `{{my_custom_decorator(player.UUID)}}` -> `Function DecoratorFunction(Actor akActor) Global`
int function RegisterDecorator(String decoratorID, String sourceScript, String functionName) Global Native

; -----------------------------------------------------------------------------
; --- Action Management ---
; -----------------------------------------------------------------------------

; Register an action to be performed by an NPC
;
; - actionName: Will be visible to the LLM. Take care when naming so the llm will call it in the right circumstances.
; - parameterSchemaJson: Describes expected parameters, e.g., {"target": "string", "duration": "number"}
; - categoryStr: Should be PAPYRUS unless the action should only be visible in a custom category which requires PAPYRUS_CUSTOM instead
; - customCategory: Should be the name of a custom sub-category if normal category is PAPYRUS_CUSTOM
int function RegisterAction(String actionName, String description, \
                           String eligibilityScriptName, String eligibilityFunctionName, \
                           String executionScriptName, String executionFunctionName, \
                           String triggeringEventTypesCsv, String categoryStr, \
                           int defaultPriority, String parameterSchemaJson, String customCategory="", String tags="") Global Native

; Register a sub-category which can contain other actions and categories
; - actionName: What the LLM uses to select a category.  Will be visible to the LLM. Take care when naming so the llm will call it in the right circumstances.
; - customParentCategory: leave blank unless the sub-category is inside another custom category
; - customCategory: The name of the new custom sub-category that can contain actions and other sub-categories.
; Register a custom sub-category for PAPYRUS_CUSTOM actions
int function RegisterSubCategory (String actionName, String description, \
                                String eligibilityScriptName, String eligibilityFunctionName, \
                                String triggeringEventTypesCsv, \
                                int defaultPriority,String customParentCategory, String customCategory) Global Native

; Register a tag with its associated eligibility function
int function RegisterTag(String tagName, String eligibilityScriptName, String eligibilityFunctionName) Global Native

; Check if an action is registered in the action library
; Returns true if the action exists, false otherwise
bool function IsActionRegistered(String actionName) Global Native

; Unregister an action from the action library
; Returns 0 on success, 1 on failure (action not found)
int function UnregisterAction(String actionName) Global Native

; Makes the specified actor run the specified action. Arguments can be supplied as a json string. Runs the action irrespective of cooldowns or eligibility.
int function ExecuteAction(string actionName, Actor akOriginator, string argsJson) global native

; Sets the cooldown for the specified action
int function SetActionCooldown(string actionName, int cooldownTimeSeconds) global native

; Gets the remaining cooldown time for the specified action in seconds. Returns -1 if no cooldown is set.
int function GetRemainingCooldown(string actionName) global native

; -----------------------------------------------------------------------------
; --- Event Management ---
; -----------------------------------------------------------------------------

; Register a short-lived event that appears in scene context and expires after TTL
; You can use this to have highly real-time events that don't blow up the context. For example, I use these to track the spells that actors have recently cast, like such: spell_cast_actor_id. Whenever an actor casts a spell, it updates this key. Therefore, only the last spell they cast shows up in the context.

; Returns 0 on success, 1 on failure
; - eventId is a unique key for your event. 


int function RegisterShortLivedEvent(String eventId, String eventType, String description, \
                                    String data, int ttlMs, Actor sourceActor, Actor targetActor) Global Native

; Register a persistent event for historical tracking and analysis
; Returns 0 on success, 1 on failure
int function RegisterEvent(String eventType, String content, Actor originatorActor, Actor targetActor) Global Native

; -----------------------------------------------------------------------------
; --- Dialogue Management ---
; -----------------------------------------------------------------------------

; Register dialogue from a speaker (general announcement, no specific listener)
; Returns 0 on success, 1 on failure
int function RegisterDialogue(Actor speaker, String dialogue) Global Native

; Register dialogue from a speaker to a specific listener
; Returns 0 on success, 1 on failure
int function RegisterDialogueToListener(Actor speaker, Actor listener, String dialogue) Global Native

; -----------------------------------------------------------------------------
; --- Package Management ---
; -----------------------------------------------------------------------------

; Register a package to be applied to an actor
; This registers the package internally in SkyrimNet so that its lifecycle is tracked and managed, 
; and then calls RegisterPackage on the SkyrimNetInternal script.
int function RegisterPackage(Actor akActor, String packageName, int priority, int flags, bool isPersistent) Global Native

; Remove a package from an actor
int function UnregisterPackage(Actor akActor, String packageName) Global Native

; Schedule a delayed package removal
int function ScheduleDelayedPackageRemoval(Actor akActor, String packageName, int delaySeconds) Global Native

; Clear all packages applied to an actor
int function ClearAllPackages(Actor akActor) Global Native

; Clear all packages that SkyrimNet is managing
int function ClearAllPackagesGlobally() Global Native

; Cancel any pending package removal tasks for an actor
int function CancelPendingPackageTasks(Actor akActor) Global Native

; Check if an actor currently has a specific skyrimnet package applied
int function HasPackage(Actor akActor, String packageName) Global Native

; -----------------------------------------------------------------------------
; --- LLM Interaction ---
; -----------------------------------------------------------------------------

; Send a custom prompt to the LLM and receive a callback when it responds
; Returns a request ID (positive integer) on success, or a negative error code on failure
; The callback function should have the signature: Function OnLLMResponse(String response) on the specified script
int function SendCustomPromptToLLM(String promptName, float temperature, int maxTokens, \
                                  String callbackScriptName, String callbackFunctionName) Global Native

; Register a direct narration event that forces the LLM to respond to a factual event
; This function creates an event that NPCs will respond to as established fact, such as:
; - "A tree fell over in the forest"
; - "The guard glares angrily at the traveler" 
; - "Lightning strikes the tower"
; - "A merchant drops their coin purse"
; 
; If originatorActor is specified, that actor will be the one to speak/respond to the event
; If originatorActor is not specified, the system will select an appropriate speaker
; 
; If targetActor is specified, the speaker will address that specific target
; If targetActor is not specified, the speaker will address everyone nearby (general announcement)
; 
; Special behavior: If content is empty (""), the event will be registered as a short-lived (ephemeral) event
; that appears in scene context but does not persist to the database. This is useful for triggering
; immediate responses without cluttering event history.
; 
; Examples:
; DirectNarration("A wolf howls in the distance") ; System selects speaker, addresses all
; DirectNarration("The shopkeeper drops a bottle", shopkeeperRef) ; Shopkeeper speaks to all
; DirectNarration("The guard thinks that the player looks tired", guardRef, Game.GetPlayer()) ; Guard speaks to player
; DirectNarration("", someActor) ; Trigger immediate response without persistent event
; 
; Returns 0 on success, 1 on failure
int function DirectNarration(String content, Actor originatorActor = None, Actor targetActor = None) Global Native

; -----------------------------------------------------------------------------
; --- Utility Functions ---
; -----------------------------------------------------------------------------

; Utility functions to extract values from a JSON string
String function GetJsonString(String jsonString, String key, String defaultValue) Global Native
int function GetJsonInt(String jsonString, String key, int defaultValue) Global Native
bool function GetJsonBool(String jsonString, String key, bool defaultValue) Global Native
float function GetJsonFloat(String jsonString, String key, float defaultValue) Global Native
Actor function GetJsonActor(String jsonString, String key, Actor defaultValue) Global Native

; Utility functions to access configuration values
String function GetConfigString(String configName, String path, String defaultValue) Global Native
int function GetConfigInt(String configName, String path, int defaultValue) Global Native
bool function GetConfigBool(String configName, String path, bool defaultValue) Global Native
float function GetConfigFloat(String configName, String path, float defaultValue) Global Native

; Utility functions to set configuration values
; - name: The name of the configuration section to modify. Options:
;       game, OpenRouter, XTTS, Zonos, Piper, STT, ActorFilter, Phonetic, Hotkey, furniture, PlayerDialogue, VirtualEntities, Entity, Memory, ItemCustomization, Actions, DynamicBio, Events, VastAI, WebServer, VoiceSamples, SpellCustomization
; - jsonPath: The partial json, of the values to apply to the config
bool function PatchConfig(String name, String jsonPatch) Global Native

; Utility functions to get build information
; Returns the SkyrimNet version string (e.g., "0.0.1.0")
String function GetBuildVersion() Global Native
; Returns the build configuration type (e.g., "Debug", "Release", etc.)
String function GetBuildType() Global Native

; Check if currently recording voice input
; Returns true if voice recording is active, false otherwise
bool function IsRecordingInput() Global Native

; Check if the game is running in VR mode
; Returns true if running in VR, false otherwise
bool function IsRunningVR() Global Native

; Get the current number of tasks in the speech generation queue
; Returns the number of speech tasks currently queued for processing
int function GetSpeechQueueSize() Global Native

; Get the time in milliseconds since the last audio finished playing
; Returns the number of milliseconds since the last audio ended, or 0 if no audio has played yet
int function GetTimeSinceLastAudioEnded() Global Native

; Render a prompt template with a custom variable
; - templateName: The name of the template file to render (e.g., "my_custom_template")
; - variableName: The name of the variable to set (can be empty to render without custom variables)
; - variableValue: The value to assign to the variable (ignored if variableName is empty)
; Returns the rendered template as a string, or an error message if rendering fails
String function RenderTemplate(String templateName, String variableName, String variableValue) Global Native

; Parse a string with variable substitution using the PromptEngine
; - inputStr: The string to parse, containing variable placeholders (e.g., "Hello {{mydata.name}}, welcome to {{mydata.location}}!")
; - variableName: The name of the variable to set (can be empty to parse without custom variables) (e.g "mydata" or "MyData" - will be converted to lowercase)
; - variableValue: The value to assign to the variable (ignored if variableName is empty) (e.g "{\"name\":"Bill\", "location\":\"our home\"}")
; Returns the parsed string with variables substituted, or an error message if parsing fails (e.g "Hello Bill, welcome to our home")
; Note: The variable name will be automatically converted to lowercase for consistency
String function ParseString(String inputStr, String variableName, String variableValue) Global Native

; Update the dynamic biography for an actor using the DynamicBioManager
; - actor: The actor whose dynamic bio should be updated
; Returns a summary of changes made to the actor's bio, or an empty string if the update failed
String function UpdateActorDynamicBio(Actor actor) Global Native

; -----------------------------------------------------------------------------
; --- Event Schema Registry Functions ---
; -----------------------------------------------------------------------------

; Register a custom event schema for structured event data
; - eventType: Unique identifier for the event type (e.g., "custom_spell_learn", "merchant_interaction")
; - displayName: Human-readable name for the event type
; - description: Description of what this event represents
; - fieldsJson: JSON array defining the schema fields. Each field object should contain:
;   - "name": Field name (string)
;   - "type": Field type (0=String, 1=Integer, 2=Boolean, 3=Double, 4=Object, 5=Array)
;   - "required": Whether the field is required (boolean)
;   - "description": Field description (string)
;   - "defaultValue": Optional default value (type must match field type)
;   Example: [{"name":"actor","type":0,"required":true,"description":"Actor name"},{"name":"spell_level","type":1,"required":false,"description":"Spell level","defaultValue":1}]
; - formatTemplatesJson: JSON object defining format templates for different modes:
;   - "recent_events": Template for recent events display (usually includes time_desc) - Used for scene context, most commonly used formatting mode
;   - "raw": Template for raw data access - Used for event history
;   - "compact": Template for compact display - Used for memories
;   - "verbose": Template for detailed display - Used for diagnostics
;   Example: {"recent_events":"**{{actor}}** learned {{spell_name}} ({{time_desc}})","raw":"{{actor}} learned {{spell_name}}","compact":"{{actor}} learned {{spell_name}}","verbose":"{{actor}} learned the {{spell_level}} level spell {{spell_name}}"}
; - isEphemeral: Whether events of this type should be automatically cleaned up (true) or persist (false)
; - defaultTTLMs: Default time-to-live in milliseconds for ephemeral events (ignored if isEphemeral is false)
; Returns 0 on success, 1 on failure
int function RegisterEventSchema(String eventType, String displayName, String description, \
                                String fieldsJson, String formatTemplatesJson, bool isEphemeral, int defaultTTLMs) Global Native

; Validate event data against a registered schema
; - eventType: The event type to validate against
; - dataJson: JSON string containing the event data to validate
; Returns true if the data is valid for the schema, false otherwise
bool function ValidateEventData(String eventType, String dataJson) Global Native

; Format an event using its registered schema
; - eventJson: Complete event JSON string (must include "type" field and event data)
; - mode: Format mode to use ("recent_events", "raw", "compact", "verbose")
; Returns formatted string according to the schema's template for the specified mode
String function FormatEvent(String eventJson, String mode) Global Native

; Get schema information for a specific event type
; - eventType: The event type to get information for
; Returns JSON string containing schema details (fields, templates, etc.) or "{}" if not found
String function GetSchemaInfo(String eventType) Global Native

; Get all registered event types
; Returns JSON array of strings containing all registered event type names
String function GetAllEventTypes() Global Native

; Check if a specific event type has a registered schema
; - eventType: The event type to check
; Returns true if the event type is registered, false otherwise
bool function IsEventTypeRegistered(String eventType) Global Native

; Get information about all registered schemas
; Returns JSON object where keys are event types and values are schema information objects
String function GetAllSchemasInfo() Global Native

; -----------------------------------------------------------------------------
; --- Web Interface ---
; -----------------------------------------------------------------------------

; Open the default web browser to the SkyrimNet web interface
; Returns 0 on success, 1 on failure
int function OpenSkyrimNetUI() Global Native

; -----------------------------------------------------------------------------
; --- Hotkey Trigger Functions ---
; -----------------------------------------------------------------------------

; These functions trigger hotkey actions programmatically from Papyrus.
; They function identically as if the player had pressed the corresponding physical key.
; All functions return 0 on success, 1 on failure.

; --- Voice Recording Functions ---

; Simulates pressing the voice recording hotkey
; - Plays input start sound effect or shows notification
; - Prepares search query cache for player input
; - Starts voice recording with 200-second timeout
; - Resets GameMaster action cooldown
; Functions identically to pressing the configured voice recording key
int function TriggerRecordSpeechPressed() Global Native

; Simulates releasing the voice recording hotkey
; - Plays input end sound effect or shows notification
; - Stops voice recording and processes the recorded audio
; - Duration parameter simulates how long the key was held (in seconds)
; Functions identically to releasing the configured voice recording key
int function TriggerRecordSpeechReleased(float duration) Global Native

; Simulates pressing the open mic toggle hotkey
; - Shows notification
; - Toggles open mic mode
; Functions identically to pressing the configured open mic toggle key
int function TriggerToggleOpenMic() Global Native

; --- Text Input Functions ---

; Simulates pressing the text input hotkey
; - Prepares search query cache for player input
; - Opens text input dialog for the player to type their message
; - Resets GameMaster action cooldown
; Functions identically to pressing the configured text input key
int function TriggerTextInput() Global Native

; --- GameMaster Control Functions ---

; Simulates pressing the GameMaster toggle hotkey
; - Toggles the GameMaster agent on/off
; - Updates configuration and shows notification to player
; - Logs the state change
; Functions identically to pressing the configured GameMaster toggle key
int function TriggerToggleGameMaster() Global Native

; Simulates pressing the continuous mode toggle hotkey
; - Toggles continuous scene mode on/off (requires GameMaster to be enabled)
; - Shows notification with current state and cooldown time
; - Only works if GameMaster agent is already enabled
; Functions identically to pressing the configured continuous mode toggle key
int function TriggerToggleContinuousMode() Global Native

; Simulates pressing the world event reactions toggle hotkey
; - Toggles whether NPCs react to world events (dialogue (Including AI dialogue), combat, death, quest stages, etc.)
; - This effectively disables NPCs from reacting to other NPCs dialogue. No interjections, no interruptions.
; - Shows notification with current state (NPC Reactions: ON/OFF)
; - When disabled, NPCs will not autonomously react to world events
; Functions identically to pressing the configured world event reactions toggle key
int function TriggerToggleWorldEventReactions() Global Native

; --- Interaction Control Functions ---

; Simulates pressing the whisper mode toggle hotkey
; - Toggles interaction.maxDistance between interaction.whisperMaxDistance and interaction.normalMaxDistance
; - Shows notification with current state (Whisper mode: ON/OFF)
; Functions identically to pressing the configured whisper toggle key
int function TriggerToggleWhisperMode() Global Native

; --- Thought System Functions ---

; Simulates pressing the text thought hotkey
; - Shows "Enter your thought..." notification
; - Prepares search query cache for player input
; - Opens text input dialog for thought input
; - Resets GameMaster action cooldown
; Functions identically to pressing the configured text thought key
int function TriggerTextThought() Global Native

; Simulates pressing the voice thought recording hotkey
; - Plays input start sound effect or shows notification
; - Prepares search query cache for player input
; - Starts voice recording with 90-second timeout for thought input
; - Resets GameMaster action cooldown
; Functions identically to pressing the configured voice thought key
int function TriggerVoiceThoughtPressed() Global Native

; Simulates releasing the voice thought recording hotkey
; - Stops voice recording and processes the recorded audio for thoughts
; - If duration < 0.3 seconds, prompts character to think with empty string
; - If duration >= 0.3 seconds, processes the recorded audio normally
; - Duration parameter simulates how long the key was held (in seconds)
; Functions identically to releasing the configured voice thought key
int function TriggerVoiceThoughtReleased(float duration) Global Native

; --- Dialogue Transformation Functions ---

; Simulates pressing the text dialogue transformation hotkey
; - Shows "Enter text to transform into dialogue..." notification
; - Prepares search query cache for player input
; - Opens text input dialog for dialogue transformation
; - Resets GameMaster action cooldown
; Functions identically to pressing the configured text dialogue transform key
int function TriggerTextDialogueTransform() Global Native

; Simulates pressing the voice dialogue transformation hotkey
; - Plays input start sound effect or shows notification
; - Prepares search query cache for player input
; - Starts voice recording with 90-second timeout for dialogue transformation
; - Resets GameMaster action cooldown
; Functions identically to pressing the configured voice dialogue transform key
int function TriggerVoiceDialogueTransformPressed() Global Native

; Simulates releasing the voice dialogue transformation hotkey
; - Stops voice recording and processes the recorded audio for dialogue transformation
; - If duration < 0.3 seconds, prompts character to speak with empty string
; - If duration >= 0.3 seconds, processes the recorded audio normally
; - Duration parameter simulates how long the key was held (in seconds)
; Functions identically to releasing the configured voice dialogue transform key
int function TriggerVoiceDialogueTransformReleased(float duration) Global Native

; --- Direct Input Functions ---

; Simulates pressing the direct input hotkey
; - Shows "Enter custom event text..." notification
; - Prepares search query cache for player input
; - Opens text input dialog for direct event input
; - Resets GameMaster action cooldown
; Functions identically to pressing the configured direct input key
int function TriggerDirectInput() Global Native

; Simulates pressing the voice direct input hotkey
; - Plays input start sound effect or shows notification
; - Prepares search query cache for player input
; - Starts voice direct input recording with 200-second timeout
; - Resets GameMaster action cooldown
; Functions identically to pressing the configured voice direct input key
int function TriggerVoiceDirectInputPressed() Global Native

; Simulates releasing the voice direct input hotkey
; - Plays input end sound effect or shows notification
; - Stops voice recording and processes the recorded audio for direct input
; - Duration parameter simulates how long the key was held (in seconds)
; Functions identically to releasing the configured voice direct input key
int function TriggerVoiceDirectInputReleased(float duration) Global Native

; --- Narration Control Functions ---

; Simulates pressing the continue narration hotkey
; - Shows "Continuing narration..." notification
; - Registers an ephemeral EVENT_CONTINUE_NARRATION event
; - Triggers callbacks for narration continuation without persisting the event
; Functions identically to pressing the configured continue narration key
int function TriggerContinueNarration() Global Native

; --- Player Dialogue and Thought Functions ---

; Triggers an autonomous thought from the player based on current circumstances and contex
; Returns 0 on success, 1 on failure
int function TriggerPlayerThought() Global Native

; Triggers an autonomous dialogue from the player based on current circumstances and context
; Returns 0 on success, 1 on failure
int function TriggerPlayerDialogue() Global Native

; Sends a line of player dialogue directly to TTS, without prompting the LLM or saving to context
int function TriggerPlayerTTS(String dialogue) Global Native

; Polling API for player TTS completion (for DBVO integration)
bool function IsPlayerTTSFinished() Global Native

; -----------------------------------------------------------------------------
; --- Events ---
; -----------------------------------------------------------------------------


; Package Added
; -------------
;
; Called when a package is added to an actor through SkyrimNet
; Example:
;
; RegisterForRegisterForModEvent("SkyrimNet_OnPackageAdded", "OnPackageAdded")
;
; Event OnPackageAdded(Actor akActor, Package akPackage) 
;     ; Your code to handle the package added event
; EndEvent
;
;
;
; Package Removed
; -------------
;
; Called when a package is reemoved from an actor through SkyrimNet
; Example:
;
; RegisterForRegisterForModEvent("SkyrimNet_OnPackageRemoved", "OnPackageRemoved")
;
; Event OnPackageRemoved(Actor akActor, Package akPackage) 
;     ; Your code to handle the package removed event
; EndEvent
;