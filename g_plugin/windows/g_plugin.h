#ifndef FLUTTER_PLUGIN_G_PLUGIN_H_
#define FLUTTER_PLUGIN_G_PLUGIN_H_

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>

#include <memory>

namespace g_plugin {

class GPlugin : public flutter::Plugin {
 public:
  static void RegisterWithRegistrar(flutter::PluginRegistrarWindows *registrar);

  GPlugin();

  virtual ~GPlugin();

  // Disallow copy and assign.
  GPlugin(const GPlugin&) = delete;
  GPlugin& operator=(const GPlugin&) = delete;

  // Called when a method is called on this plugin's channel from Dart.
  void HandleMethodCall(
      const flutter::MethodCall<flutter::EncodableValue> &method_call,
      std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
};

}  // namespace g_plugin

#endif  // FLUTTER_PLUGIN_G_PLUGIN_H_
