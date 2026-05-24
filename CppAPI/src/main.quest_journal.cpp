#include "PublicAPI.h"
#include <spdlog/spdlog.h>
#include <spdlog/sinks/basic_file_sink.h>
#include <algorithm>
#include <cctype>
#include <cstdio>
#include <unordered_set>

// Set to 0 to disable all logging (default for production/integration)
#define QJ_LOG_ENABLED 1

#if QJ_LOG_ENABLED
static std::shared_ptr<spdlog::logger> g_logger;

static void QJLogInit()
{
	if (g_logger) return;
	auto logDir = SKSE::log::log_directory();
	if (!logDir) return;
	auto path = logDir->string() + "\\SkyrimNetQuestJournalDecorator.log";
	g_logger = spdlog::basic_logger_mt("QuestJournal", path);
	g_logger->set_level(spdlog::level::debug);
	g_logger->flush_on(spdlog::level::debug);
}

static void QJLogInfo(const std::string& msg) { if (g_logger) g_logger->info(msg); }
static void QJLogDebug(const std::string& msg) { if (g_logger) g_logger->debug(msg); }
#else
static void QJLogInit() {}
static void QJLogInfo([[maybe_unused]] const std::string&) {}
static void QJLogDebug([[maybe_unused]] const std::string&) {}
#endif

static void ResolveAliasTokens(RE::BSString& text, const RE::TESQuest* quest, std::uint32_t instanceID)
{
	using func_t = void(*)(RE::BSString*, const RE::TESQuest*, std::uint32_t);
	REL::Relocation<func_t> func{ RELOCATION_ID(23429, 23897) };
	func(&text, quest, instanceID);
}

static const char* ResolveJournalEntryText(RE::TESQuestStageItem* stageItem, const RE::TESQuest* quest)
{
	using func_t = const char*(*)(RE::TESQuestStageItem*, const RE::TESQuest*);
	REL::Relocation<func_t> func{ RELOCATION_ID(24778, 25259) };
	return func(stageItem, quest);
}

static std::string EscapeJson(const std::string& s)
{
	std::string out;
	out.reserve(s.size() + 8);
	for (char c : s) {
		switch (c) {
		case '"':  out += "\\\""; break;
		case '\\': out += "\\\\"; break;
		case '\n': out += "\\n"; break;
		case '\r': out += "\\r"; break;
		case '\t': out += "\\t"; break;
		default:
			if (static_cast<unsigned char>(c) < 0x20) {
				char buf[8];
				snprintf(buf, sizeof(buf), "\\u%04x", static_cast<unsigned char>(c));
				out += buf;
			} else {
				out += c;
			}
			break;
		}
	}
	return out;
}

static bool HasAliasToken(const std::string& s)
{
	auto pos = s.find('<');
	if (pos == std::string::npos) return false;
	return (s.compare(pos, 6, "<Alias") == 0 || s.compare(pos, 6, "<alias") == 0);
}

static std::string ResolveText(const std::string& raw, const RE::TESQuest* quest)
{
	std::string result = raw;

	if (HasAliasToken(result)) {
		std::string lower = result;
		std::transform(lower.begin(), lower.end(), lower.begin(), ::tolower);
		for (size_t i = 0; i < lower.size(); i++) {
			if (lower.compare(i, 7, "<alias=") == 0) {
				result.replace(i, 6, "<Alias");
			}
		}
		RE::BSString resolved(result.c_str());
		ResolveAliasTokens(resolved, quest, quest->currentInstanceID);
		if (resolved.c_str() && resolved.c_str()[0] != '\0')
			result = resolved.c_str();
	}

	auto gpos = result.find("<Global=");
	while (gpos != std::string::npos) {
		auto endPos = result.find('>', gpos);
		if (endPos == std::string::npos) break;
		auto globalName = result.substr(gpos + 8, endPos - gpos - 8);
		std::string replacement;
		auto& globals = RE::TESDataHandler::GetSingleton()->GetFormArray<RE::TESGlobal>();
		for (auto* g : globals) {
			if (g) {
				auto* eid = g->GetFormEditorID();
				if (eid && globalName == eid) {
					replacement = std::to_string(static_cast<int>(g->value));
					break;
				}
			}
		}
		if (!replacement.empty()) {
			result.replace(gpos, endPos - gpos + 1, replacement);
			gpos = result.find("<Global=", gpos + replacement.size());
		} else {
			gpos = result.find("<Global=", endPos);
		}
	}

	return result;
}

static bool ShouldSkipQuest(const std::string& editorID)
{
	if (editorID.empty()) return true;
	if (editorID == "PlayerDialogueQuest") return true;
	if (editorID.find("skynet_") == 0) return true;
	if (editorID.find("Dialogue") == 0) return true;
	if (editorID.find("WIDefault") == 0) return true;
	if (editorID.find("CR") == 0 && editorID.size() > 2 && isdigit(editorID[2])) return true;
	return false;
}

static std::string BuildQuestJournalJson([[maybe_unused]] RE::Actor* actor)
{
	auto* player = RE::PlayerCharacter::GetSingleton();
	if (!player) return "[]";

	auto* dataHandler = RE::TESDataHandler::GetSingleton();
	if (!dataHandler) return "[]";

	auto& questLog = player->GetPlayerRuntimeData().questLog;
	auto& questTargets = player->GetPlayerRuntimeData().questTargets;
	auto& quests = dataHandler->GetFormArray<RE::TESQuest>();

	std::unordered_set<RE::TESQuest*> knownQuests;
	for (auto* stageItem : questLog) {
		if (stageItem && stageItem->owner) knownQuests.insert(stageItem->owner);
	}
	{
		RE::BSSpinLockGuard lock(player->GetPlayerRuntimeData().questTargetsLock);
		for (auto& [quest, targets] : questTargets) {
			if (quest) knownQuests.insert(quest);
		}
	}

	int totalQuests = 0, filteredQuests = 0, miscCount = 0;

	std::string result = "[";
	std::string questListLog;
	bool firstQuest = true;

	for (auto& quest : quests) {
		if (!quest) continue;
		totalQuests++;

		auto* editorID = quest->GetFormEditorID();
		if (!editorID || editorID[0] == '\0') continue;
		std::string editorIDStr(editorID);

		if (!quest->IsRunning()) continue;
		if (quest->IsCompleted()) continue;

		if (ShouldSkipQuest(editorIDStr)) continue;

		bool hasDisplayedObjective = false;
		{
			RE::BSReadLockGuard lock(quest->aliasAccessLock);
			for (auto* obj : quest->objectives) {
				if (obj) {
					auto s = obj->state.underlying();
					if (s == static_cast<std::uint8_t>(RE::QUEST_OBJECTIVE_STATE::kDisplayed) ||
					    s == static_cast<std::uint8_t>(RE::QUEST_OBJECTIVE_STATE::kCompletedDisplayed) ||
					    s == static_cast<std::uint8_t>(RE::QUEST_OBJECTIVE_STATE::kFailedDisplayed)) {
						hasDisplayedObjective = true;
						break;
					}
				}
			}
		}
		bool inKnown = knownQuests.count(quest) > 0;
		if (!hasDisplayedObjective && !inKnown) continue;

		filteredQuests++;
		auto typeNum = static_cast<std::uint32_t>(quest->GetType());
		if (typeNum == 6) miscCount++;

		if (!questListLog.empty()) questListLog += ", ";
		questListLog += editorIDStr;

		auto* questName = quest->GetName();
		std::string questNameStr = questName ? questName : "";
		questNameStr = ResolveText(questNameStr, quest);
		if (questNameStr.empty()) {
			RE::BSReadLockGuard lock(quest->aliasAccessLock);
			for (auto* obj : quest->objectives) {
				if (obj) {
					auto* dt = obj->displayText.c_str();
					if (dt && dt[0] != '\0') {
						questNameStr = ResolveText(dt, quest);
						if (!questNameStr.empty()) break;
					}
				}
			}
		}
		if (questNameStr.empty()) questNameStr = editorIDStr;

		bool inQuestLog = inKnown;

		auto stageNum = quest->GetCurrentStageID();

		if (!firstQuest) result += ",";
		firstQuest = false;

		result += "{\"questName\":\"";
		result += EscapeJson(questNameStr);
		result += "\",\"editorID\":\"";
		result += EscapeJson(editorIDStr);
		result += "\",\"stage\":";
		result += std::to_string(stageNum);
		result += ",\"questType\":";
		result += std::to_string(typeNum);
		result += ",\"completed\":false";
		result += ",\"isMisc\":";
		result += (typeNum == 6) ? "true" : "false";
		result += ",\"inQuestLog\":";
		result += inQuestLog ? "true" : "false";

		{
			RE::BSReadLockGuard lock(quest->aliasAccessLock);
			auto& objectives = quest->objectives;
			if (!objectives.empty()) {
				result += ",\"objectives\":[";
				bool firstObj = true;
				for (auto* obj : objectives) {
					if (!obj) continue;
					auto* dt = obj->displayText.c_str();
					if (!dt || dt[0] == '\0') continue;

					std::string textStr = ResolveText(dt, quest);

					auto objState = obj->state.underlying();
					bool objCompleted = (objState == static_cast<std::uint8_t>(RE::QUEST_OBJECTIVE_STATE::kCompleted) ||
					                     objState == static_cast<std::uint8_t>(RE::QUEST_OBJECTIVE_STATE::kCompletedDisplayed));
					bool objFailed = (objState == static_cast<std::uint8_t>(RE::QUEST_OBJECTIVE_STATE::kFailed) ||
					                  objState == static_cast<std::uint8_t>(RE::QUEST_OBJECTIVE_STATE::kFailedDisplayed));
					bool objDisplayed = (objState == static_cast<std::uint8_t>(RE::QUEST_OBJECTIVE_STATE::kDisplayed) ||
					                    objState == static_cast<std::uint8_t>(RE::QUEST_OBJECTIVE_STATE::kCompletedDisplayed) ||
					                    objState == static_cast<std::uint8_t>(RE::QUEST_OBJECTIVE_STATE::kFailedDisplayed));

					if (!firstObj) result += ",";
					firstObj = false;

					result += "{\"text\":\"";
					result += EscapeJson(textStr);
					result += "\",\"completed\":";
					result += objCompleted ? "true" : "false";
					result += ",\"failed\":";
					result += objFailed ? "true" : "false";
					result += ",\"displayed\":";
					result += objDisplayed ? "true" : "false";
					result += "}";
				}
				result += "]";
			}
		}

		std::string resolvedJournalText;
		int bestStageIndex = -1;
		for (auto* stageItem : questLog) {
			if (!stageItem) continue;
			if (stageItem->owner != quest) continue;
			if (!stageItem->hasLogEntry) continue;
			if (!stageItem->owningStage) continue;
			auto entryStage = stageItem->owningStage->data.index;
			if (entryStage > stageNum) continue;
			if (entryStage <= bestStageIndex) continue;

			const char* logText = ResolveJournalEntryText(stageItem, quest);
			if (logText && logText[0] != '\0') {
				resolvedJournalText = ResolveText(logText, quest);
				bestStageIndex = entryStage;
			}
		}

		if (!resolvedJournalText.empty()) {
			result += ",\"journalText\":\"";
			result += EscapeJson(resolvedJournalText);
			result += "\"";
		}

		result += "}";
	}

	result += "]";
	QJLogDebug("get_quest_journal: " + std::to_string(filteredQuests) + " quests (" + std::to_string(miscCount) + " misc) from " + std::to_string(totalQuests) + " total");
	QJLogDebug("quest list: " + questListLog);
	return result;
}

bool SKSEPluginLoad(const SKSE::LoadInterface* skse) {
	SKSE::Init(skse);
	QJLogInit();
	QJLogInfo("SkyrimNetQuestJournalDecorator loaded");

	SKSE::GetMessagingInterface()->RegisterListener(
		[](SKSE::MessagingInterface::Message* msg) {
			if (!msg || msg->type != SKSE::MessagingInterface::kPostPostLoad) return;

			if (!FindFunctions()) return;

			if (!PublicRegisterDecorator) return;

			PublicRegisterDecorator(
				"get_quest_journal",
				"Returns JSON array of active quests with resolved objective text and journal entries. Each entry: questName, editorID, stage, questType, isMisc, inQuestLog, objectives[{text,completed,failed}], journalText.",
				[](RE::Actor* actor) -> std::string {
					return BuildQuestJournalJson(actor);
				});
			QJLogInfo("Registered decorator 'get_quest_journal'");
		});
	return true;
}
