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
 * Returns the runtime API version (currently 4).
 * Version history: 2 = action registration, 3 = data queries + UUID + config,
 *                  4 = diary queries.
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
        }
        return true;
    }
    return false;
}
}
