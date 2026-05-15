#include "Plugin.h"
#include "PublicAPI.h"

bool RegisterMountDecorator() {
    if (!PublicRegisterDecorator) {
        logger::error("PublicRegisterDecorator not available (SkyrimNet API v5+ required)");
        return false;
    }

    bool ok = PublicRegisterDecorator(
        "is_mounted",
        "Whether the actor is currently riding a mount. Returns mount name or empty.",
        [](RE::Actor* actor) -> std::string {
            if (!actor) return "";

            RE::NiPointer<RE::Actor> mountPtr;
            if (!actor->GetMount(mountPtr) || !mountPtr) return "";

            auto* name = mountPtr->GetName();
            if (name && name[0] != '\0') return std::string(name);
            return std::string("true");
        });

    if (ok) {
        logger::info("Registered is_mounted decorator");
    } else {
        logger::error("Failed to register is_mounted decorator");
    }

    ok = PublicRegisterDecorator(
        "get_mount_race",
        "Returns the race of the actor's current mount.",
        [](RE::Actor* actor) -> std::string {
            if (!actor) return "";

            RE::NiPointer<RE::Actor> mountPtr;
            if (!actor->GetMount(mountPtr) || !mountPtr) return "";

            auto* race = mountPtr->GetRace();
            if (race) {
                auto* raceName = race->GetName();
                if (raceName && raceName[0] != '\0') return std::string(raceName);
            }
            return std::string("");
        });

    if (ok) {
        logger::info("Registered get_mount_race decorator");
    } else {
        logger::error("Failed to register get_mount_race decorator");
    }

    ok = PublicRegisterDecorator(
        "get_furniture",
        "Returns the name of furniture the actor is currently using.",
        [](RE::Actor* actor) -> std::string {
            if (!actor) return "";

            auto furnitureHandle = actor->GetOccupiedFurniture();
            if (!furnitureHandle) return "";

            auto furniture = furnitureHandle.get();
            if (!furniture) return "";

            auto* name = furniture->GetName();
            if (name && name[0] != '\0') return std::string(name);
            auto* base = furniture->GetBaseObject();
            if (base) {
                auto* baseName = base->GetName();
                if (baseName && baseName[0] != '\0') return std::string(baseName);
                if (base->Is(RE::TESFurniture::FORMTYPE)) {
                    auto* furn = base->As<RE::TESFurniture>();
                    if (furn && furn->GetFormEditorID()) {
                        auto editorId = std::string(furn->GetFormEditorID());
                        if (editorId.find("Cart") != std::string::npos || editorId.find("cart") != std::string::npos)
                            return std::string("Cart");
                    }
                }
            }
            return std::string("");
        });

    if (ok) {
        logger::info("Registered get_furniture decorator");
    } else {
        logger::error("Failed to register get_furniture decorator");
    }

    return true;
}

SKSEPluginLoad(const SKSE::LoadInterface* skse) {
    SKSE::Init(skse);
    SKSE::GetMessagingInterface()->RegisterListener(
        [](SKSE::MessagingInterface::Message* msg) {
            if (msg->type == SKSE::MessagingInterface::kDataLoaded) {
                if (!FindFunctions()) {
                    logger::warn(
                        "SkyrimNet not found - is_mounted decorator not "
                        "registered");
                    return;
                }
                logger::info("SkyrimNet API v{}", PublicGetVersion());
                RegisterMountDecorator();
            }
        });
    return true;
}
