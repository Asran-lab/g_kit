import 'package:flutter/material.dart';
import 'package:g_common/utils/g_theme_mode_manager.dart';

/// [GThemeModeToggle]
///
/// 완전히 유연한 테마 모드 토글 위젯
/// 어떤 형태의 위젯이든 만들 수 있는 빌더 패턴
///
/// 사용 예시:
/// ```dart
/// // 버튼 형태
/// GThemeModeToggle(
///   themeModeManager: themeModeManager,
///   widgetBuilder: (context, themeMode, child, actions) =>
///     ElevatedButton(
///       onPressed: actions.cycleNextMode,
///       child: child ?? Icon(Icons.brightness_auto),
///     ),
/// )
///
/// // 토글 스위치 형태
/// GThemeModeToggle(
///   themeModeManager: themeModeManager,
///   widgetBuilder: (context, themeMode, child, actions) =>
///     Switch(
///       value: themeMode == ThemeMode.dark,
///       onChanged: (value) => value ? actions.setDarkMode() : actions.setLightMode(),
///     ),
/// )
///
/// // 드롭다운 형태
/// GThemeModeToggle(
///   themeModeManager: themeModeManager,
///   widgetBuilder: (context, themeMode, child, actions) =>
///     DropdownButton<ThemeMode>(
///       value: themeMode,
///       onChanged: (mode) => actions.setMode(mode!),
///       items: [
///         DropdownMenuItem(value: ThemeMode.light, child: Text('라이트')),
///         DropdownMenuItem(value: ThemeMode.dark, child: Text('다크')),
///         DropdownMenuItem(value: ThemeMode.system, child: Text('시스템')),
///       ],
///     ),
/// )
/// ```
class GThemeModeToggle extends StatelessWidget {
  final GThemeModeManager themeModeManager;
  final Widget Function(
    BuildContext context,
    ThemeMode themeMode,
    Widget? child,
    ThemeModeActions actions,
  ) widgetBuilder;
  final Widget? child;

  const GThemeModeToggle({
    super.key,
    required this.themeModeManager,
    required this.widgetBuilder,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: themeModeManager,
      builder: (context, _) {
        return widgetBuilder.call(
          context,
          themeModeManager.themeMode,
          child,
          ThemeModeActions(themeModeManager),
        );
      },
    );
  }
}

/// 테마 모드 액션들을 캡슐화한 클래스
class ThemeModeActions {
  final GThemeModeManager _themeModeManager;

  ThemeModeActions(this._themeModeManager);

  /// 다음 모드로 순환
  void cycleNextMode() => _themeModeManager.cycleNextMode();

  /// 라이트 모드로 설정
  void setLightMode() => _themeModeManager.setLightMode();

  /// 다크 모드로 설정
  void setDarkMode() => _themeModeManager.setDarkMode();

  /// 시스템 모드로 설정
  void setSystemMode() => _themeModeManager.setSystemMode();

  /// 특정 모드로 설정
  void setMode(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        setLightMode();
        break;
      case ThemeMode.dark:
        setDarkMode();
        break;
      case ThemeMode.system:
        setSystemMode();
        break;
    }
  }

  /// 현재 모드가 라이트인지 확인
  bool get isLightMode => _themeModeManager.isLightMode;

  /// 현재 모드가 다크인지 확인
  bool get isDarkMode => _themeModeManager.isDarkMode;

  /// 현재 모드가 시스템인지 확인
  bool get isSystemMode => _themeModeManager.isSystemMode;

  /// 현재 모드
  ThemeMode get currentMode => _themeModeManager.themeMode;
}

/// 미리 정의된 위젯 빌더들
class GThemeModeWidgetBuilders {
  /// 기본 토글 버튼 빌더
  static Widget Function(BuildContext, ThemeMode, Widget?, ThemeModeActions)
      get toggleButton => (context, themeMode, child, actions) => IconButton(
            onPressed: actions.cycleNextMode,
            icon: child ?? _getDefaultIcon(themeMode),
          );

  /// 스위치 토글 빌더
  static Widget Function(BuildContext, ThemeMode, Widget?, ThemeModeActions)
      get switchToggle => (context, themeMode, child, actions) => Switch(
            value: themeMode == ThemeMode.dark,
            onChanged: (value) =>
                value ? actions.setDarkMode() : actions.setLightMode(),
          );

  /// 드롭다운 빌더
  static Widget Function(BuildContext, ThemeMode, Widget?, ThemeModeActions)
      get dropdown => (context, themeMode, child, actions) =>
          DropdownButton<ThemeMode>(
            value: themeMode,
            onChanged: (mode) => mode != null ? actions.setMode(mode) : null,
            items: const [
              DropdownMenuItem(
                value: ThemeMode.light,
                child: Row(children: [Icon(Icons.light_mode), Text('라이트')]),
              ),
              DropdownMenuItem(
                value: ThemeMode.dark,
                child: Row(children: [Icon(Icons.dark_mode), Text('다크')]),
              ),
              DropdownMenuItem(
                value: ThemeMode.system,
                child:
                    Row(children: [Icon(Icons.brightness_auto), Text('시스템')]),
              ),
            ],
          );

  /// 세그먼트 컨트롤 빌더
  static Widget Function(BuildContext, ThemeMode, Widget?, ThemeModeActions)
      get segmentedControl => (context, themeMode, child, actions) =>
          SegmentedButton<ThemeMode>(
            segments: const [
              ButtonSegment(
                  value: ThemeMode.light,
                  icon: Icon(Icons.light_mode),
                  label: Text('라이트')),
              ButtonSegment(
                  value: ThemeMode.dark,
                  icon: Icon(Icons.dark_mode),
                  label: Text('다크')),
              ButtonSegment(
                  value: ThemeMode.system,
                  icon: Icon(Icons.brightness_auto),
                  label: Text('시스템')),
            ],
            selected: {themeMode},
            onSelectionChanged: (selection) => actions.setMode(selection.first),
          );

  /// 커스텀 버튼 빌더
  static Widget Function(BuildContext, ThemeMode, Widget?, ThemeModeActions)
      customButton({Color? backgroundColor, Color? foregroundColor}) =>
          (context, themeMode, child, actions) => ElevatedButton(
                onPressed: actions.cycleNextMode,
                style: ElevatedButton.styleFrom(
                  backgroundColor: backgroundColor,
                  foregroundColor: foregroundColor,
                ),
                child: child ?? _getDefaultIcon(themeMode),
              );

  /// 기본 아이콘 반환
  static Widget _getDefaultIcon(ThemeMode themeMode) {
    return switch (themeMode) {
      ThemeMode.light => const Icon(Icons.light_mode),
      ThemeMode.dark => const Icon(Icons.dark_mode),
      ThemeMode.system => const Icon(Icons.brightness_auto),
    };
  }
}
