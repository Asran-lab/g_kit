#include "include/g_plugin/g_plugin_c_api.h"

#include <flutter/plugin_registrar_windows.h>

#include "g_plugin.h"

void GPluginCApiRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  g_plugin::GPlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}
