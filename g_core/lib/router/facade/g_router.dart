import 'package:flutter/material.dart';
import 'package:g_common/g_common.dart';
import 'package:g_core/router/router.dart';

/// GRouter Facade 클래스
/// 라우터 기능을 통합하여 제공하는 static 인터페이스
class GRouter {
  static GRouterService? _instance;

  /// Router 인스턴스 반환
  static GRouterService get instance {
    if (_instance == null) {
      throw Exception('GRouter가 초기화되지 않았습니다. GRouter.initialize()를 먼저 호출하세요.');
    }
    return _instance!;
  }

  /// Router 초기화 여부 확인
  static bool get isInitialized => _instance != null;

  /// Router 초기화
  ///
  /// [configs] - 라우트 설정 목록
  /// [shellConfigs] - 쉘 라우트 설정 목록 (선택사항)
  /// [initialPath] - 초기 경로 (기본값: '/splash')
  static void initialize(
    List<GRouteConfig> configs, {
    List<GShellRouteConfig>? shellConfigs,
    String initialPath = '/splash',
    bool enableLogging = true,
    GRouterErrorHandler? errorHandler,
  }) {
    _instance = GRouterImpl();
    _instance!.initialize(
      configs,
      shellConfigs: shellConfigs,
      initialPath: initialPath,
    );
  }

  /// 지정된 경로로 이동
  ///
  /// [path] - 이동할 경로
  /// [arguments] - 전달할 인수
  static Future<void> go(String path, {GJson? arguments}) async {
    await instance.go(path, arguments: arguments);
  }

  /// 이름으로 지정된 라우트로 이동
  ///
  /// [name] - 라우트 이름
  /// [arguments] - 전달할 인수
  static Future<void> goNamed(String name, {GJson? arguments}) async {
    await instance.goNamed(name, arguments: arguments);
  }

  /// 지정된 경로로 이동하고 이전 스택 제거
  ///
  /// [path] - 이동할 경로
  /// [arguments] - 전달할 인수
  static Future<void> goUntil(String path, {GJson? arguments}) async {
    await instance.goUntil(path, arguments: arguments);
  }

  /// 이전 화면으로 돌아가기
  static Future<void> goBack() async {
    await instance.goBack();
  }

  /// 뒤로 갈 수 있는지 확인
  static Future<bool> canGoBack() async {
    return await instance.canGoBack();
  }

  /// 스택에 페이지 push (뒤로가기로 복귀 가능)
  static Future<void> replace(String path, {GJson? arguments}) async {
    await instance.replace(path, arguments: arguments);
  }

  /// Router Widget 빌드
  ///
  /// MaterialApp.router를 반환합니다.
  ///
  /// [colorConfig] - G_UI 색상 설정
  /// [themeMode] - 테마 모드 (light/dark/system)
  /// [brightness] - 밝기 설정
  /// [theme] - 라이트 테마 (커스텀)
  /// [locale] - 현재 로케일
  /// [supportedLocales] - 지원하는 로케일 목록
  /// [localizationsDelegates] - 로컬라이제이션 델리게이트
  /// [debugShowCheckedModeBanner] - 디버그 배너 표시 여부
  static Widget buildRouter({
    ThemeMode? themeMode,
    Brightness? brightness,
    ThemeData? theme,
    Locale? locale,
    Iterable<Locale>? supportedLocales,
    Iterable<LocalizationsDelegate<dynamic>>? localizationsDelegates,
    bool? debugShowCheckedModeBanner,
  }) {
    return instance.buildRouter(
      themeMode: themeMode,
      brightness: brightness,
      lightTheme: theme,
      locale: locale,
      supportedLocales: supportedLocales,
      localizationsDelegates: localizationsDelegates,
      debugShowCheckedModeBanner: debugShowCheckedModeBanner,
    );
  }

  /// Router 인스턴스 재설정 (테스트용)
  static void reset() {
    _instance = null;
  }
}
