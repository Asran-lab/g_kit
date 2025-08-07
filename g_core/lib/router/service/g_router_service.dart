import 'package:flutter/material.dart';
import 'package:g_common/g_common.dart';
import 'package:g_core/router/common/g_router_config.dart';
import 'package:g_ui/configs/g_color_config.dart';

/// 라우터 서비스 인터페이스
/// Flutter의 표준 RouterConfig를 사용하여 라우터를 관리합니다.
abstract class GRouterService {
  void initialize(
    List<GRouteConfig> configs, {
    List<GShellRouteConfig>? shellConfigs,
    String initialPath = '/splash',
  });
  Future<void> go(String path, {GJson? arguments});
  Future<void> goNamed(String name, {GJson? arguments});
  Future<void> goUntil(String path, {GJson? arguments});
  Future<void> goBack();
  Future<bool> canGoBack();
  Future<void> replace(String path, {GJson? arguments});
  Widget buildRouter({
    GColorConfig? colorConfig,
    ThemeMode? themeMode,
    Brightness? brightness,
    ThemeData? themeData,
    Locale? locale,
    Iterable<Locale>? supportedLocales,
    Iterable<LocalizationsDelegate<dynamic>>? localizationsDelegates,
    bool? debugShowCheckedModeBanner,
  });
}
