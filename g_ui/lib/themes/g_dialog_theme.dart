import 'package:flutter/material.dart';
import 'package:g_common/utils/g_color.dart';
import 'package:g_ui/configs/g_color_config.dart';
import 'package:g_ui/configs/g_text_config.dart';

/// [Dialog Theme]
///
/// 사용 예시
/// ```dart
/// final baseDialogTheme = gDialogTheme(config, brightness);
///
/// // 특정 속성만 오버라이드
/// final dialogTheme = baseDialogTheme.copyWith(
///   backgroundColor: Colors.red,
///   shape: RoundedRectangleBorder(
///     borderRadius: BorderRadius.circular(16),
///     side: BorderSide(color: Colors.blue, width: 1),
///   ),
/// );
/// ```
DialogThemeData gDialogTheme(
  GColorConfig config,
  Brightness brightness, {
  double? radius,
}) {
  final surface = toColor(config.surface);
  final onSurface = onColor(surface);
  return DialogThemeData(
    backgroundColor: surface,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(radius ?? 16),
      side: BorderSide(
        color: toColor(config.outline),
        width: 1,
      ),
    ),
    titleTextStyle: GTextStyle.get(
      size: GTextSize.x18,
      weight: GTextWeight.bold,
      color: onSurface,
    ),
    contentTextStyle: GTextStyle.get(
      size: GTextSize.x14,
      weight: GTextWeight.regular,
      color: onSurface.withValues(alpha: 0.85),
    ),
  );
}

/// 외부에서 DialogThemeData를 쉽게 오버라이드할 수 있는 확장 메서드
extension DialogThemeDataCopyWith on DialogThemeData {
  DialogThemeData copyWith({
    Color? backgroundColor,
    ShapeBorder? shape,
    TextStyle? titleTextStyle,
    TextStyle? contentTextStyle,
    AlignmentGeometry? alignment,
    EdgeInsets? insetPadding,
    Clip? clipBehavior,
    double? elevation,
    Color? shadowColor,
    Color? surfaceTintColor,
    Color? iconColor,
    EdgeInsets? actionsPadding,
  }) {
    return DialogThemeData(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      shape: shape ?? this.shape,
      titleTextStyle: titleTextStyle ?? this.titleTextStyle,
      contentTextStyle: contentTextStyle ?? this.contentTextStyle,
      alignment: alignment ?? this.alignment,
      insetPadding: insetPadding ?? this.insetPadding,
      clipBehavior: clipBehavior ?? this.clipBehavior,
      elevation: elevation ?? this.elevation,
      shadowColor: shadowColor ?? this.shadowColor,
      surfaceTintColor: surfaceTintColor ?? this.surfaceTintColor,
      iconColor: iconColor ?? this.iconColor,
      actionsPadding: actionsPadding ?? this.actionsPadding,
    );
  }
}
