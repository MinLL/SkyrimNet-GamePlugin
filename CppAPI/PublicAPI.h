#pragma once
#include <string>
#include <windows.h>
#include <functional>

/**
 * SkyrimNet Public API — loaded at runtime via LoadLibraryA + GetProcAddress.
 *
 * Drop this header into your SKSE plugin project. Call FindFunctions() once
 * during initialization (e.g., SKSE kDataLoaded message). If it returns true,
 * the function pointers below are ready to use.
 *
 * ## Initialization timing
 *
 * Call FindFunctions() during kDataLoaded. After it returns true:
 *   - Action registration works immediately.
 *   - Data query functions are safe to call but return empty results until
 *     the database initializes — which happens when a save is loaded (or a
 *     new game starts). Use PublicIsMemorySystemReady() to check.
 *
 * Quick start:
 * @code
 *   // In your SKSE kDataLoaded handler — resolve function pointers.
 *   void OnDataLoaded() {
 *       if (!FindFunctions()) {
 *           logger::warn("SkyrimNet not found");
 *           return;
 *       }
 *       logger::info("SkyrimNet API v{}", PublicGetVersion());
 *
 *       // Register actions here — they're available before a save loads.
 *       PublicRegisterCPPAction("MyMod_Wave", "Wave at someone",
 *           [](RE::Actor* a) { return a != nullptr; },
 *           [](RE::Actor* a, std::string params) { return true; },
 *           "dialogue", "Social", 50, "{}", "", "", "");
 *   }
 *
 *   // Query data later, after a save is loaded.
 *   void SomeGameplayFunction(uint32_t formId) {
 *       if (!PublicIsMemorySystemReady || !PublicIsMemorySystemReady()) return;
 *       std::string memories = PublicGetMemoriesForActor(formId, 10, "");
 *       std::string events   = PublicGetRecentEvents(formId, 20, "dialogue");
 *   }
 * @endcode
 *
 * ABI requirement: Both DLLs must use the same MSVC version and CRT linkage
 * (dynamic /MD). All CommonLibSSE-NG SKSE plugins satisfy this.
 *
 * Thread safety: All data query functions (v3+) are thread-safe and return
 * empty results gracefully if called before the database is ready. Action
 * registration should be done during plugin initialization only.
 */
extern "C" {

// =============================================================================
// Core (v2+)
// =============================================================================

/**
 * Returns the runtime API version (currently 9).
 * Version history: 2 = action registration, 3 = data queries + UUID + config,
 *                  4 = diary queries,
 *                  5 = decorator registration + event callbacks + memory creation,
 *                  6 = actor busy state,
 *                  7 = save unique ID + world knowledge CRUD,
 *                  8 = send custom prompt to LLM,
 *                  9 = per-actor world knowledge for prompt enrichment.
 */
int (*PublicGetVersion)() = nullptr;

/**
 * Register a custom action that NPCs can perform via the LLM action system.
 *
 * @param name                  Unique action identifier (e.g., "MyMod_DoThing").
 * @param description           Human-readable description for LLM context.
 * @param eligibleCallback      Called to test if an NPC can perform this action.
 *                              Receives the NPC's Actor*. Must be thread-safe.
 * @param executeCallback       Called when the NPC executes this action.
 *                              Receives Actor* and a JSON params string.
 *                              Return true on success.
 * @param triggeringEventTypesCSV  Comma-separated event types that trigger
 *                              eligibility checks (e.g., "combat_hit,dialogue").
 * @param categoryStr           Built-in category: "Combat", "Social", etc.
 *                              Use customCategory for mod-defined categories.
 * @param priority              Execution priority (higher = checked first). 50
 *                              is a reasonable default.
 * @param parameterSchemaJSON   JSON Schema describing parameters your action
 *                              accepts. The LLM uses this to generate params.
 *                              Pass "{}" if no parameters.
 * @param customCategory        Custom category name (empty to use categoryStr).
 * @param customParentCategory  Parent category for nesting (empty = top-level).
 * @param tagsCSV               Comma-separated tags for filtering.
 * @return true if registration succeeded.
 */
bool (*PublicRegisterCPPAction)(const std::string name, const std::string description, std::function<bool(RE::Actor *)> eligibleCallback,
                                std::function<bool(RE::Actor *, std::string json_params)> executeCallback,
                                const std::string triggeringEventTypesCSV, std::string categoryStr, int priority,
                                std::string parameterSchemaJSON, std::string customCategory, std::string customParentCategory,
                                std::string tagsCSV) = nullptr;

/**
 * Register an action subcategory for organizational grouping.
 *
 * Subcategories appear as folders in the action tree. They don't execute
 * on their own but provide structure for related actions.
 *
 * @param name                  Unique subcategory identifier.
 * @param description           Human-readable description.
 * @param eligibleCallback      Controls visibility — shown only when this
 *                              returns true for the current NPC.
 * @param triggeringEventTypesCSV  Comma-separated triggering event types.
 * @param priority              Display priority within the parent category.
 * @param parameterSchemaJSON   Reserved, pass "{}".
 * @param customCategory        Category name for this subcategory.
 * @param customParentCategory  Parent category (empty = top-level).
 * @param tagsCSV               Comma-separated tags.
 * @return true if registration succeeded.
 */
bool (*PublicRegisterCPPSubCategory)(const std::string name, const std::string description,
                                     std::function<bool(RE::Actor *)> eligibleCallback, const std::string triggeringEventTypesCSV,
                                     int priority, std::string parameterSchemaJSON, std::string customCategory,
                                     std::string customParentCategory, std::string tagsCSV) = nullptr;

// =============================================================================
// UUID Resolution (v3+)
// =============================================================================

/**
 * Convert a Skyrim FormID to SkyrimNet's internal UUID.
 * @param formId  Actor FormID (e.g., 0x00000014 for the player).
 * @return UUID, or 0 if the actor is unknown.
 */
uint64_t (*PublicFormIDToUUID)(uint32_t formId) = nullptr;

/**
 * Convert a SkyrimNet UUID back to a Skyrim FormID.
 * @return FormID, or 0 if unknown.
 */
uint32_t (*PublicUUIDToFormID)(uint64_t uuid) = nullptr;

/**
 * Get an actor's display name from their UUID.
 * @return Actor name, or "" if unknown.
 */
std::string (*PublicGetActorNameByUUID)(uint64_t uuid) = nullptr;

// =============================================================================
// Bio Template (v3+)
// =============================================================================

/**
 * Get the bio template name assigned to an actor.
 * @param formId  Actor FormID.
 * @return Template name, or "" if none assigned.
 */
std::string (*PublicGetBioTemplateName)(uint32_t formId) = nullptr;

// =============================================================================
// Data Queries (v3+)
//
// All functions in this section are thread-safe.
// Functions returning arrays return "[]" on error.
// Functions returning objects return a default JSON object on error.
// =============================================================================

/**
 * Retrieve memories stored for an actor.
 *
 * @param formId       Actor FormID.
 * @param maxCount     Maximum memories to return (<=0 defaults to 50).
 * @param contextQuery If non-empty, performs semantic (vector) search ranked
 *                     by relevance. If empty, returns most recent first.
 *
 * @return JSON array of memory objects:
 * @code
 * [
 *   {
 *     "id": 42,
 *     "text": "I saw the Dragonborn defeat a dragon at Whiterun",
 *     "importance": 0.85,
 *     "timestamp": 1234.5,
 *     "type": "observation"
 *   }
 * ]
 * @endcode
 */
std::string (*PublicGetMemoriesForActor)(uint32_t formId, int maxCount, const char* contextQuery) = nullptr;

/**
 * Retrieve recent world events, optionally filtered.
 *
 * @param formId          Actor FormID (0 = all events, non-zero = events
 *                        involving this actor).
 * @param maxCount        Maximum events to return (<=0 defaults to 50).
 * @param eventTypeFilter Comma-separated event types to include
 *                        (e.g., "dialogue,direct_narration"). Empty = all.
 *
 * @return JSON array of event objects:
 * @code
 * [
 *   {
 *     "type": "dialogue",
 *     "text": "Hello, traveler!",
 *     "gameTime": 1234.5,
 *     "originatingActorName": "Lydia",
 *     "targetActorName": "Player"
 *   }
 * ]
 * @endcode
 */
std::string (*PublicGetRecentEvents)(uint32_t formId, int maxCount, const char* eventTypeFilter) = nullptr;

/**
 * Retrieve recent dialogue between the player and an NPC.
 *
 * @param formId       NPC's FormID.
 * @param maxExchanges Maximum exchanges to return (<=0 defaults to 10).
 *
 * @return JSON array in chronological order (oldest first):
 * @code
 * [
 *   {
 *     "speaker": "Player",
 *     "text": "What do you think about the war?",
 *     "gameTime": 1234.5
 *   },
 *   {
 *     "speaker": "Lydia",
 *     "text": "I follow you, my Thane.",
 *     "gameTime": 1234.6
 *   }
 * ]
 * @endcode
 */
std::string (*PublicGetRecentDialogue)(uint32_t formId, int maxExchanges) = nullptr;

/**
 * Get info about the most recent NPC who spoke to the player.
 *
 * @return JSON object:
 * @code
 * {
 *   "npcFormId": 655544,
 *   "gameTime": 1234.5,
 *   "npcName": "Lydia"
 * }
 * @endcode
 */
std::string (*PublicGetLatestDialogueInfo)() = nullptr;

/**
 * Check if the memory/database system is initialized and ready for queries.
 *
 * Returns false until a save is loaded or a new game is started. All data
 * query functions are safe to call regardless — they return empty results
 * when the database isn't ready — but this lets you avoid unnecessary calls.
 *
 * @return true if the database is ready.
 */
bool (*PublicIsMemorySystemReady)() = nullptr;

/**
 * Get per-actor engagement statistics for scoring and prioritization.
 *
 * @param maxCount             Max actors to return (0 = all with any activity).
 * @param excludePlayer        Omit the player (FormID 0x14) from results.
 * @param playerEventsOnly     Only count events involving the player. NPC-to-NPC
 *                             events still tracked as npcToNpcEventCount.
 * @param shortWindowSeconds   Short recency window in game-seconds
 *                             (e.g., 86400 = 1 game-day).
 * @param mediumWindowSeconds  Medium recency window in game-seconds
 *                             (e.g., 604800 = 7 game-days).
 *
 * @return JSON array:
 * @code
 * [
 *   {
 *     "formId": 655544,
 *     "name": "Lydia",
 *     "memoryCount": 12,
 *     "totalMemoryImportance": 8.5,
 *     "recentMemoryImportanceShort": 2.1,
 *     "recentMemoryImportanceMedium": 5.3,
 *     "eventCount": 30,
 *     "recentEventCountShort": 5,
 *     "recentEventCountMedium": 18,
 *     "lastEventTime": 1234.5,
 *     "npcToNpcEventCount": 4
 *   }
 * ]
 * @endcode
 */
std::string (*PublicGetActorEngagement)(int maxCount, bool excludePlayer, bool playerEventsOnly, double shortWindowSeconds, double mediumWindowSeconds) = nullptr;

/**
 * Get actors related to a given actor via shared event history.
 *
 * @param formId               Anchor actor's FormID.
 * @param maxCount             Max related actors to return (0 = all).
 * @param shortWindowSeconds   Short recency window in game-seconds.
 * @param mediumWindowSeconds  Medium recency window in game-seconds.
 *
 * @return JSON array:
 * @code
 * [
 *   {
 *     "formId": 655545,
 *     "name": "Ulfric Stormcloak",
 *     "sharedEventCount": 15,
 *     "recentSharedEventsShort": 3,
 *     "recentSharedEventsMedium": 10,
 *     "lastSharedEventTime": 1234.5
 *   }
 * ]
 * @endcode
 */
std::string (*PublicGetRelatedActors)(uint32_t formId, int maxCount, double shortWindowSeconds, double mediumWindowSeconds) = nullptr;

/**
 * Get comprehensive player context: current time, recent interactions,
 * and relationship data.
 *
 * @param withinGameHours  Time window in game-hours for recent interactions.
 *                         0 = all time.
 *
 * @return JSON object:
 * @code
 * {
 *   "currentTime": 1234.5,
 *   "recentInteractionNames": ["Lydia", "Farengar"],
 *   "relationships": [
 *     {
 *       "name": "Lydia",
 *       "formId": 655544,
 *       "interactionCount": 12
 *     }
 *   ]
 * }
 * @endcode
 */
std::string (*PublicGetPlayerContext)(float withinGameHours) = nullptr;

/**
 * Get NPC-to-NPC event pair counts within a candidate pool.
 *
 * @param formIdListCSV   Comma-separated FormIDs defining the pool
 *                        (e.g., "655544,655545,655546").
 * @param minSharedEvents Minimum shared events to include a pair (0 = all).
 *
 * @return JSON array:
 * @code
 * [
 *   {
 *     "formId1": 655544,
 *     "formId2": 655545,
 *     "sharedEvents": 8
 *   }
 * ]
 * @endcode
 */
std::string (*PublicGetEventPairCounts)(const char* formIdListCSV, int minSharedEvents) = nullptr;

// =============================================================================
// Diary Queries (v4+)
// =============================================================================

/**
 * Retrieve diary entries for an actor, optionally filtered by time range.
 *
 * @param formId    Actor FormID (0 = all actors).
 * @param maxCount  Maximum entries to return (<=0 defaults to 50).
 * @param startTime Only entries at or after this time (seconds since epoch).
 *                  0.0 = no lower bound.
 * @param endTime   Only entries at or before this time (seconds since epoch).
 *                  0.0 = no upper bound.
 *
 * @return JSON array of diary entry objects. Each entry includes all fields
 *         from DiaryEntry::ToJson() plus an `actor_name` field.
 */
std::string (*PublicGetDiaryEntries)(uint32_t formId, int maxCount, double startTime, double endTime) = nullptr;

// =============================================================================
// Memory Creation (v5+)
// =============================================================================

/**
 * Create and store a memory for an actor.
 *
 * Creates a first-class memory with vector embedding for semantic search.
 * The memory integrates with get_relevant_memories(), importance decay, and
 * all existing retrieval mechanisms.
 *
 * @param formId             Actor FormID (the memory owner).
 * @param contentText        Memory content text (embedded for semantic search).
 * @param importance         Importance score, clamped to 0.0-1.0.
 * @param memoryType         One of: "EXPERIENCE", "RELATIONSHIP", "KNOWLEDGE",
 *                           "LOCATION", "SKILL", "TRAUMA", "JOY".
 * @param emotion            Optional emotion tag (e.g., "happy", "anxious").
 * @param location           Optional location name (e.g., "Whiterun").
 * @param tagsJSON           Optional JSON array of tags: ["combat", "dragon"].
 * @param relatedActorsJSON  Optional JSON array of related actor FormIDs.
 * @return Memory ID (>0) on success, 0 on error.
 */
int (*PublicAddMemory)(uint32_t formId, const char* contentText, float importance,
                       const char* memoryType, const char* emotion, const char* location,
                       const char* tagsJSON, const char* relatedActorsJSON) = nullptr;

// =============================================================================
// Plugin Configuration (v3+)
// =============================================================================

/**
 * Get the full JSON configuration for a registered plugin.
 *
 * Plugins register YAML config files under "Plugin_<name>" in ConfigManager.
 *
 * @param pluginName  Plugin name (without "Plugin_" prefix).
 * @return JSON object of the config, or "{}" if not found.
 */
std::string (*PublicGetPluginConfig)(const char* pluginName) = nullptr;

/**
 * Get a single config value by dot-path from a plugin's settings.
 *
 * @param pluginName    Plugin name (without "Plugin_" prefix).
 * @param path          Dot-separated path (e.g., "feature.enabled").
 * @param defaultValue  Returned if the path doesn't exist.
 * @return The config value as a string, or defaultValue if not found.
 */
std::string (*PublicGetPluginConfigValue)(const char* pluginName, const char* path, const char* defaultValue) = nullptr;

// =============================================================================
// Decorator Registration (v5+)
// =============================================================================

/**
 * Register a custom decorator for use in Inja templates and action eligibility rules.
 *
 * Decorators are invoked with the current NPC's Actor* and return a string value.
 * In templates: {{ my_decorator(actor_uuid) }} renders the returned string.
 * In eligibility rules: the returned string is compared via operators (==, !=, >, <, etc.).
 *
 * @param name         Unique decorator identifier (e.g., "intel_standing").
 *                     Must not conflict with built-in decorators.
 * @param description  Human-readable description (for documentation generation).
 * @param callback     Function receiving RE::Actor* and returning a string value.
 *                     Must be thread-safe. Return "" for invalid/unknown actors.
 *
 * @return true if registration succeeded, false if name conflicts or callback is null.
 *
 * @code
 *   // Register during plugin initialization (kDataLoaded):
 *   PublicRegisterDecorator("intel_standing", "Player's standing with this NPC's faction",
 *       [](RE::Actor* actor) -> std::string {
 *           auto* fp = FactionPolitics::GetSingleton();
 *           auto factionId = fp->GetNPCFactionId(actor);
 *           if (factionId.empty()) return "";
 *           return std::to_string(fp->GetPlayerStanding(factionId));
 *       });
 *
 *   // Use in Inja templates:
 *   //   {{ intel_standing(actor_uuid) }}
 *   //
 *   // Use in action YAML eligibility rules:
 *   //   eligibilityRules:
 *   //     - conditions:
 *   //       - decorator: intel_standing
 *   //         arguments: ["currentactor"]
 *   //         operator: ">="
 *   //         expected: "20"
 * @endcode
 */
bool (*PublicRegisterDecorator)(const char* name, const char* description,
                                std::function<std::string(RE::Actor*)> callback) = nullptr;

/**
 * Check if a decorator with the given name exists (built-in or external).
 *
 * @param name  Decorator name to check.
 * @return true if registered, false otherwise.
 */
bool (*PublicHasDecorator)(const char* name) = nullptr;

// =============================================================================
// Event Callbacks (v5+)
// =============================================================================

/**
 * Register a callback for a specific event type (e.g., "dialogue", "combat", "death").
 *
 * The callback fires on SkyrimNet's ThreadPool whenever an event of the specified type
 * is registered. The callback receives a JSON string with event data:
 *   {
 *     "type": "dialogue",
 *     "data": "{\"text\":\"...\",\"speaker\":\"Lydia\"}",
 *     "originatingActorUUID": 12345,
 *     "targetActorUUID": 67890,
 *     "originatingActorFormId": 1234,
 *     "targetActorFormId": 5678,
 *     "id": 42
 *   }
 *
 * Common event types: "dialogue", "dialogue_player_text", "dialogue_player_stt",
 * "combat", "death", "hit", "activation", "spell_cast", "equip"
 *
 * @param eventType  Event type to listen for. Must not be empty.
 * @param callback   Function receiving JSON string. Must be thread-safe.
 *                   Called on ThreadPool — do NOT call RE:: functions directly.
 *                   The const char* is only valid for the duration of the call — copy if needed.
 * @return Callback ID (> 0) for unregistration, or 0 on failure.
 *
 * @code
 *   auto id = PublicRegisterEventCallback("dialogue", [](const char* json) {
 *       auto j = nlohmann::json::parse(json);
 *       uint32_t formId = j["originatingActorFormId"].get<uint32_t>();
 *       // increment counter, check threshold, etc.
 *   });
 * @endcode
 */
uint64_t (*PublicRegisterEventCallback)(const char* eventType,
                                        std::function<void(const char*)> callback) = nullptr;

/**
 * Unregister a previously registered event callback.
 *
 * @param callbackId  The ID returned by PublicRegisterEventCallback.
 * @return true if the callback was found and removed.
 */
bool (*PublicUnregisterEventCallback)(uint64_t callbackId) = nullptr;

// =============================================================================
// Actor Busy State (v6+)
// =============================================================================

/**
 * Mark an actor as busy with a multi-step action.
 *
 * While busy, the is_busy() decorator returns true and busy_reason() returns
 * the reason string, allowing action YAMLs to exclude busy actors via
 * eligibility rules — either all busy states or selectively by reason.
 * The plugin is responsible for calling PublicClearActorBusy() when done.
 *
 * @param formId   The actor's FormID.
 * @param reason   Short reason string (e.g., "arrest", "travel", "crafting").
 *                 Queryable via busy_reason() decorator for selective exclusions.
 * @return true on success, false if the FormID couldn't be resolved.
 */
bool (*PublicSetActorBusy)(uint32_t formId, const char* reason) = nullptr;

/**
 * Clear an actor's busy state.
 *
 * Call this when the multi-step action completes (or fails/is interrupted).
 *
 * @param formId   The actor's FormID.
 * @return true on success, false if the FormID couldn't be resolved.
 */
bool (*PublicClearActorBusy)(uint32_t formId) = nullptr;

/**
 * Check if an actor is currently busy.
 *
 * @param formId   The actor's FormID.
 * @return true if the actor is busy, false otherwise.
 */
bool (*PublicIsActorBusy)(uint32_t formId) = nullptr;

// =============================================================================
// Current save UUID (v7+)
// =============================================================================

/**
 * Get the unique save ID for the current save.
 * @return the unique save ID, empty string if a save is not loaded.
*/
std::string (*PublicGetSaveUniqueID)() = nullptr;

// =============================================================================
// World Knowledge (v7+)
// =============================================================================

/**
 * Create a world knowledge entry.
 *
 * World knowledge entries are shared facts that apply to NPCs based on
 * condition expressions. Unlike PublicAddMemory (per-actor), these are
 * retrieved for any NPC whose condition evaluates to true.
 *
 * @param content       Knowledge text (required, non-empty). Embedded for semantic search.
 * @param conditionExpr Inja condition expression controlling which NPCs receive this.
 *                      Examples:
 *                        - "" (empty = applies to all NPCs)
 *                        - "is_in_faction(actorUUID, \"CompanionsFaction\")"
 *                        - "decnpc(actorUUID).race == \"Nord\""
 *                        - "is_in_npc_group(actorUUID, \"MyGroup\")"
 *                        - "get_quest_stage(\"MQ101\") >= 50"
 * @param alwaysInject  If true, always included when condition passes (deterministic).
 *                      If false, only surfaces via semantic search (probabilistic).
 * @param importance    Importance score 0.0-1.0 (clamped). Affects semantic ranking.
 * @param displayName   Optional human-readable label. Pass "" to omit.
 * @return Memory ID (>0) on success, 0 on error.
 *
 * @code
 *   // All Companions learn about an event:
 *   int id = PublicAddWorldKnowledge(
 *       "Silver Hand attacked Jorrvaskr last night.",
 *       "is_in_faction(actorUUID, \"CompanionsFaction\")",
 *       true, 0.8, "Silver Hand Attack");
 *
 *   // Everyone learns about the dragon:
 *   PublicAddWorldKnowledge(
 *       "A dragon was slain at the Western Watchtower.",
 *       "", true, 0.9, "Dragon Attack");
 * @endcode
 */
int (*PublicAddWorldKnowledge)(const char* content, const char* conditionExpr,
                               bool alwaysInject, float importance,
                               const char* displayName) = nullptr;

/**
 * Remove a world knowledge entry by ID.
 * Refuses to delete per-actor memories (actor_uuid != 0).
 *
 * @param memoryId  The ID returned by PublicAddWorldKnowledge.
 * @return true on success, false if not found or not a world knowledge entry.
 */
bool (*PublicRemoveWorldKnowledge)(int memoryId) = nullptr;

/**
 * Get all world knowledge entries as a JSON array.
 *
 * @param maxCount  Maximum entries to return (<=0 defaults to 100).
 * @return JSON array of knowledge entry objects. Each includes id, content,
 *         condition_expr, always_inject, importance, display_name, is_active.
 */
std::string (*PublicGetWorldKnowledge)(int maxCount) = nullptr;

/**
 * Get world knowledge entries applicable to a specific actor as a JSON array.
 *
 * Mirrors the get_world_knowledge() Inja decorator used in dialogue prompts —
 * but exposed at C++ level so plugins can attach knowledge to their own
 * pre-built prompt context (faction leaders, candidate pools, etc.).
 *
 * Two retrieval modes based on `searchQuery`:
 *   - "" (empty)    — cheap path: deterministic always-inject entries only.
 *                     Cache scan + condition evaluation, no HNSW. Suitable for
 *                     hot per-NPC enrichment loops.
 *   - non-empty     — combined: always-inject + semantic HNSW search. Use only
 *                     when you have a concrete query (e.g., "faction war").
 *
 * Resolves formId → UUID internally via UUIDResolver.
 *
 * Thread-safe (KnowledgeManager uses shared_mutex). Returns "[]" on error,
 * unknown formId, or empty result.
 *
 * @param formId       Actor FormID. 0 returns "[]".
 * @param maxResults   Maximum entries to return (<=0 defaults to 5).
 * @param searchQuery  Inja semantic search query, or "" for always-inject only.
 * @return JSON array: [{"content":"...","always_inject":true,"importance":0.8,
 *         "display_name":"..."}, ...]. "[]" if none.
 */
std::string (*PublicGetWorldKnowledgeForActor)(uint32_t formId, int maxResults,
                                               const char* searchQuery) = nullptr;

// =============================================================================
// Custom LLM Prompts (v8+)
// =============================================================================

/**
 * Send a custom prompt to the LLM and receive the response asynchronously.
 *
 * Renders the named prompt template (with optional context variables), submits
 * it to the configured LLM, and calls the callback on a ThreadPool worker when
 * done. The callback must be thread-safe — do NOT call RE:: functions from it.
 *
 * @param promptName   Template name registered with ContextEngine (required).
 * @param variant      OpenRouter variant to use. Pass "" for the default variant.
 * @param contextJson  JSON object of context variables injected before rendering.
 *                     Pass "" or "{}" if no extra variables are needed.
 *                     Example: "{\"actorName\":\"Lydia\",\"topic\":\"dragons\"}"
 * @param callback     Called on completion with (response, success).
 *                     success == 1 on success, 0 on failure.
 *                     response is the LLM text, or an error string on failure.
 *                     The const char* is only valid for the call — copy if needed.
 * @return true if the task was successfully queued, false on immediate error.
 *
 * @code
 *   PublicSendCustomPromptToLLM("my_prompt", "", "{\"name\":\"Lydia\"}",
 *       [](const char* response, int success) {
 *           if (success) logger::info("LLM: {}", response);
 *       });
 * @endcode
 */
bool (*PublicSendCustomPromptToLLM)(const char* promptName, const char* variant,
                                    const char* contextJson,
                                    std::function<void(const char* response, int success)> callback) = nullptr;

// =============================================================================
// Initialization
// =============================================================================

/**
 * Load SkyrimNet and resolve all exported function pointers.
 *
 * Call once during plugin initialization (e.g., SKSE DataLoaded message).
 * After this returns true, check individual function pointers before use —
 * functions from newer API versions may be nullptr if the installed
 * SkyrimNet is older.
 *
 * @return true if SkyrimNet.dll was loaded and at least PublicGetVersion resolved.
 */
inline bool FindFunctions() {
    auto hDLL = LoadLibraryA("SkyrimNet");
    if (hDLL != nullptr) {
        PublicGetVersion = (int (*)()) GetProcAddress(hDLL, "PublicGetVersion");
        if (PublicGetVersion != nullptr) {
            int version = PublicGetVersion();

            // v2+ functions
            if (version >= 2) {
                PublicRegisterCPPAction =
                    (bool (*)(const std::string name, const std::string description, std::function<bool(RE::Actor *)> eligibleCallback,
                    std::function<bool(RE::Actor *, std::string json_params)> executeCallback, const std::string triggeringEventTypesCSV,
                              std::string categoryStr, int priority, std::string parameterSchemaJSON, std::string customCategory,
                              std::string customParentCategory, std::string tagsCSV)) GetProcAddress(hDLL, "PublicRegisterCPPAction");
                PublicRegisterCPPSubCategory = (bool (*)(
                    const std::string name, const std::string description, std::function<bool(RE::Actor *)> eligibleCallback,
                    const std::string triggeringEventTypesCSV, int priority, std::string parameterSchemaJSON, std::string customCategory,
                    std::string customParentCategory, std::string tagsCSV)) GetProcAddress(hDLL, "PublicRegisterCPPSubCategory");
            }

            // v3+ functions
            if (version >= 3) {
                // UUID resolution
                PublicFormIDToUUID = reinterpret_cast<uint64_t(*)(uint32_t)>(
                    GetProcAddress(hDLL, "PublicFormIDToUUID"));
                PublicUUIDToFormID = reinterpret_cast<uint32_t(*)(uint64_t)>(
                    GetProcAddress(hDLL, "PublicUUIDToFormID"));
                PublicGetActorNameByUUID = reinterpret_cast<std::string(*)(uint64_t)>(
                    GetProcAddress(hDLL, "PublicGetActorNameByUUID"));

                // Bio template
                PublicGetBioTemplateName = reinterpret_cast<std::string(*)(uint32_t)>(
                    GetProcAddress(hDLL, "PublicGetBioTemplateName"));

                // Data API
                PublicGetMemoriesForActor = reinterpret_cast<std::string(*)(uint32_t, int, const char*)>(
                    GetProcAddress(hDLL, "PublicGetMemoriesForActor"));
                PublicGetRecentEvents = reinterpret_cast<std::string(*)(uint32_t, int, const char*)>(
                    GetProcAddress(hDLL, "PublicGetRecentEvents"));
                PublicGetRecentDialogue = reinterpret_cast<std::string(*)(uint32_t, int)>(
                    GetProcAddress(hDLL, "PublicGetRecentDialogue"));
                PublicGetLatestDialogueInfo = reinterpret_cast<std::string(*)()>(
                    GetProcAddress(hDLL, "PublicGetLatestDialogueInfo"));
                PublicIsMemorySystemReady = reinterpret_cast<bool(*)()>(
                    GetProcAddress(hDLL, "PublicIsMemorySystemReady"));
                PublicGetActorEngagement = reinterpret_cast<std::string(*)(int, bool, bool, double, double)>(
                    GetProcAddress(hDLL, "PublicGetActorEngagement"));
                PublicGetRelatedActors = reinterpret_cast<std::string(*)(uint32_t, int, double, double)>(
                    GetProcAddress(hDLL, "PublicGetRelatedActors"));
                PublicGetPlayerContext = reinterpret_cast<std::string(*)(float)>(
                    GetProcAddress(hDLL, "PublicGetPlayerContext"));
                PublicGetEventPairCounts = reinterpret_cast<std::string(*)(const char*, int)>(
                    GetProcAddress(hDLL, "PublicGetEventPairCounts"));

                // Plugin config API
                PublicGetPluginConfig = reinterpret_cast<std::string(*)(const char*)>(
                    GetProcAddress(hDLL, "PublicGetPluginConfig"));
                PublicGetPluginConfigValue = reinterpret_cast<std::string(*)(const char*, const char*, const char*)>(
                    GetProcAddress(hDLL, "PublicGetPluginConfigValue"));
            }

            // v4+ functions
            if (version >= 4) {
                PublicGetDiaryEntries = reinterpret_cast<std::string(*)(uint32_t, int, double, double)>(
                    GetProcAddress(hDLL, "PublicGetDiaryEntries"));
            }

            // v5+ functions
            if (version >= 5) {
                // Decorator registration
                PublicRegisterDecorator = reinterpret_cast<bool(*)(const char*, const char*,
                    std::function<std::string(RE::Actor*)>)>(
                    GetProcAddress(hDLL, "PublicRegisterDecorator"));
                PublicHasDecorator = reinterpret_cast<bool(*)(const char*)>(
                    GetProcAddress(hDLL, "PublicHasDecorator"));

                // Event callbacks
                PublicRegisterEventCallback = reinterpret_cast<uint64_t(*)(const char*,
                    std::function<void(const char*)>)>(
                    GetProcAddress(hDLL, "PublicRegisterEventCallback"));
                PublicUnregisterEventCallback = reinterpret_cast<bool(*)(uint64_t)>(
                    GetProcAddress(hDLL, "PublicUnregisterEventCallback"));

                // Memory creation
                PublicAddMemory = reinterpret_cast<int(*)(uint32_t, const char*, float,
                    const char*, const char*, const char*, const char*, const char*)>(
                    GetProcAddress(hDLL, "PublicAddMemory"));
            }

            // v6+ functions: Actor busy state
            if (version >= 6) {
                PublicSetActorBusy = reinterpret_cast<bool(*)(uint32_t, const char*)>(
                    GetProcAddress(hDLL, "PublicSetActorBusy"));
                PublicClearActorBusy = reinterpret_cast<bool(*)(uint32_t)>(
                    GetProcAddress(hDLL, "PublicClearActorBusy"));
                PublicIsActorBusy = reinterpret_cast<bool(*)(uint32_t)>(
                    GetProcAddress(hDLL, "PublicIsActorBusy"));
            }

            // v7+ functions
            if (version >= 7) {
                PublicGetSaveUniqueID = reinterpret_cast<std::string(*)()>(
                    GetProcAddress(hDLL, "PublicGetSaveUniqueID"));
                PublicAddWorldKnowledge = reinterpret_cast<int(*)(const char*, const char*,
                    bool, float, const char*)>(
                    GetProcAddress(hDLL, "PublicAddWorldKnowledge"));
                PublicRemoveWorldKnowledge = reinterpret_cast<bool(*)(int)>(
                    GetProcAddress(hDLL, "PublicRemoveWorldKnowledge"));
                PublicGetWorldKnowledge = reinterpret_cast<std::string(*)(int)>(
                    GetProcAddress(hDLL, "PublicGetWorldKnowledge"));
            }

            // v8+ functions
            if (version >= 8) {
                PublicSendCustomPromptToLLM = reinterpret_cast<bool(*)(const char*, const char*,
                    const char*, std::function<void(const char*, int)>)>(
                    GetProcAddress(hDLL, "PublicSendCustomPromptToLLM"));
            }

            // v9+ functions
            if (version >= 9) {
                PublicGetWorldKnowledgeForActor = reinterpret_cast<std::string(*)(uint32_t, int, const char*)>(
                    GetProcAddress(hDLL, "PublicGetWorldKnowledgeForActor"));
            }
        }
        return true;
    }
    return false;
}
}
