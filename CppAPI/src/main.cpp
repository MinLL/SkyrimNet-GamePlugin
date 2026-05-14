#include "Plugin.h"
#include "PublicAPI.h"

bool RegisterMountDecorator() {
    if (!PublicRegisterDecorator) {
        logger::error("PublicRegisterDecorator not available (SkyrimNet API v5+ required)");
        return false;
    }

    bool ok = PublicRegisterDecorator(
        "is_mounted",
        "Whether the actor is currently riding a mount. Returns debug info.",
        [](RE::Actor* actor) -> std::string {
            if (!actor) return "";

            RE::NiPointer<RE::Actor> mountPtr;
            if (!actor->GetMount(mountPtr) || !mountPtr) return "";

            auto* mountName = mountPtr->GetName();
            if (mountName && mountName[0] != '\0')
                return std::string(mountName);
            return std::string("true");
        });

    if (ok) {
        logger::info("Registered is_mounted decorator");
    } else {
        logger::error("Failed to register is_mounted decorator");
    }
    return ok;
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
