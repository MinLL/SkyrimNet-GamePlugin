#include "PublicAPI.h"

static const char* TemperTier(float hp)
{
	if (hp <= 1.0f)  return "Standard";
	if (hp <= 1.33f) return "Fine";
	if (hp <= 1.66f) return "Superior";
	if (hp <= 2.0f)  return "Exquisite";
	if (hp <= 2.33f) return "Flawless";
	if (hp <= 2.66f) return "Epic";
	return "Legendary";
}

static std::string BuildTemperedItemsJson(RE::Actor* actor)
{
	auto inv = actor->GetInventory([](RE::TESBoundObject& obj) {
		auto ft = obj.GetFormType();
		return ft == RE::FormType::Weapon || ft == RE::FormType::Armor;
	});

	std::string result = "[";
	bool first = true;

	for (auto& [boundObj, entry] : inv) {
		auto count = entry.first;
		if (count <= 0) continue;

		auto& entryData = entry.second;
		if (!entryData) continue;

		auto* obj = entryData->object;
		if (!obj) continue;

		float healthPercent = 1.0f;

		if (entryData->extraLists) {
			for (auto& xList : *entryData->extraLists) {
				if (!xList) continue;
				auto* extraHealth = xList->GetByType<RE::ExtraHealth>();
				if (extraHealth && extraHealth->health != 1.0f) {
					healthPercent = extraHealth->health;
					break;
				}
			}
		}

		if (healthPercent <= 1.0f) continue;

		auto formId = obj->GetFormID();

		char hpBuf[32];
		snprintf(hpBuf, sizeof(hpBuf), "%.2f", healthPercent);

		if (!first) result += ",";
		first = false;

		result += "{\"formID\":";
		result += std::to_string(formId);
		result += ",\"quality\":\"";
		result += TemperTier(healthPercent);
		result += "\",\"healthPercent\":";
		result += hpBuf;
		result += "}";
	}

	result += "]";
	return result;
}

SKSEPluginLoad(const SKSE::LoadInterface* skse) {
	SKSE::Init(skse);
	SKSE::GetMessagingInterface()->RegisterListener(
		[](SKSE::MessagingInterface::Message* msg) {
			if (msg->type == SKSE::MessagingInterface::kDataLoaded) {
				if (!FindFunctions()) {
					logger::warn("SkyrimNet not found - get_tempered_items decorator not registered");
					return;
				}
				logger::info("SkyrimNet API v{}", PublicGetVersion());

				if (!PublicRegisterDecorator) {
					logger::error("PublicRegisterDecorator not available (SkyrimNet API v5+ required)");
					return;
				}

				bool ok = PublicRegisterDecorator(
					"get_tempered_items",
					"Returns JSON array of tempered weapons/armor with formID (int), quality tier, and healthPercent.",
					[](RE::Actor* actor) -> std::string {
						if (!actor) return "[]";
						return BuildTemperedItemsJson(actor);
					});

				if (ok) {
					logger::info("Registered get_tempered_items decorator");
				} else {
					logger::error("Failed to register get_tempered_items decorator");
				}
			}
		});
	return true;
}
