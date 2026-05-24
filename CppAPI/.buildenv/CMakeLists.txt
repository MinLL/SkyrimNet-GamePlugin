cmake_minimum_required(VERSION 3.21)

project(SkyrimNetPlugins VERSION 1.0.0 LANGUAGES CXX)

set(OUTPUT_FOLDER "${CMAKE_CURRENT_SOURCE_DIR}/../../")

find_package(CommonLibSSE CONFIG REQUIRED)

function(add_skse_plugin PLUGIN_NAME)
    add_commonlibsse_plugin(${PLUGIN_NAME} VERSION 1.0.0 SOURCES ${ARGN})
    target_compile_features(${PLUGIN_NAME} PRIVATE cxx_std_23)
    target_include_directories(${PLUGIN_NAME} PRIVATE ${CMAKE_CURRENT_SOURCE_DIR}/..)
    target_precompile_headers(${PLUGIN_NAME} PRIVATE ../PCH.h)

    if(DEFINED OUTPUT_FOLDER)
        set(DLL_FOLDER "${OUTPUT_FOLDER}/SKSE/Plugins")
        message(STATUS "${PLUGIN_NAME} output: ${DLL_FOLDER}")
        add_custom_command(
            TARGET "${PLUGIN_NAME}"
            POST_BUILD
            COMMAND "${CMAKE_COMMAND}" -E make_directory "${DLL_FOLDER}"
            COMMAND "${CMAKE_COMMAND}" -E copy_if_different "$<TARGET_FILE:${PLUGIN_NAME}>" "${DLL_FOLDER}/$<TARGET_FILE_NAME:${PLUGIN_NAME}>"
            VERBATIM
        )
    endif()
endfunction()

add_skse_plugin("SkyrimNetMountDecorator" "../src/main.mount.cpp")
add_skse_plugin("SkyrimNetTemperDecorator" "../src/main.temper.cpp")
add_skse_plugin("SkyrimNetQuestJournalDecorator" "../src/main.quest_journal.cpp")
