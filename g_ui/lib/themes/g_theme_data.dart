import 'package:flutter/material.dart';
import 'package:g_ui/configs/g_color_config.dart';
import 'package:g_ui/themes/theme.dart';

/// [Theme Data]
///
/// 사용 예시
/// ```dart
/// // 기본 테마 가져오기
/// final baseTheme = gThemeData(config);
///
/// // 특정 속성만 오버라이드
/// final customTheme = baseTheme.copyWith(
///   fontFamily: 'Roboto',
///   textTheme: customTextTheme,
///   elevatedButtonTheme: customButtonTheme,
/// );
/// ```
ThemeData gThemeData(
  GColorConfig config, {
  Brightness brightness = Brightness.light,
  String? fontFamily,
  List<ThemeExtension<dynamic>>? extensions,
}) {
  return ThemeData(
    useMaterial3: true,
    brightness: brightness,
    fontFamily: fontFamily,
    extensions: extensions,
    colorScheme: gColorScheme(config, brightness),
    textTheme: gTextTheme(config, fontFamily: fontFamily),
    inputDecorationTheme: gInputTheme(config),
    dialogTheme: gDialogTheme(config, brightness),
    elevatedButtonTheme:
        ElevatedButtonThemeData(style: GButtonTheme.elevated(config)),
    outlinedButtonTheme:
        OutlinedButtonThemeData(style: GButtonTheme.outlined(config)),
    textButtonTheme: TextButtonThemeData(style: GButtonTheme.text(config)),
  );
}

/// 외부에서 ThemeData를 쉽게 오버라이드할 수 있는 확장 메서드
extension ThemeDataCopyWith on ThemeData {
  ThemeData copyWith({
    bool? useMaterial3,
    Brightness? brightness,
    String? fontFamily,
    ColorScheme? colorScheme,
    TextTheme? textTheme,
    InputDecorationTheme? inputDecorationTheme,
    DialogThemeData? dialogTheme,
    ElevatedButtonThemeData? elevatedButtonTheme,
    OutlinedButtonThemeData? outlinedButtonTheme,
    TextButtonThemeData? textButtonTheme,
  }) {
    return ThemeData(
      useMaterial3: useMaterial3 ?? this.useMaterial3,
      brightness: brightness ?? this.brightness,
      colorScheme: colorScheme ?? this.colorScheme,
      textTheme: textTheme ?? this.textTheme,
      inputDecorationTheme: inputDecorationTheme ?? this.inputDecorationTheme,
      dialogTheme: dialogTheme ?? this.dialogTheme,
      elevatedButtonTheme: elevatedButtonTheme ?? this.elevatedButtonTheme,
      outlinedButtonTheme: outlinedButtonTheme ?? this.outlinedButtonTheme,
      textButtonTheme: textButtonTheme ?? this.textButtonTheme,
    );
  }
}
