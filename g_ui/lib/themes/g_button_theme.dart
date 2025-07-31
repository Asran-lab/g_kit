import 'package:flutter/material.dart';
import 'package:g_common/utils/g_color.dart';
import 'package:g_ui/configs/g_color_config.dart';
import 'package:g_ui/configs/g_text_config.dart';

/// [Button Theme]
///
/// 사용 예시
/// ```dart
/// // 기본 버튼 스타일 가져오기
/// final baseElevatedStyle = GButtonTheme.elevated(config);
///
/// // 특정 속성만 오버라이드
/// final customStyle = baseElevatedStyle.copyWith(
///   backgroundColor: WidgetStateProperty.all(Colors.red),
///   textStyle: WidgetStateProperty.all(TextStyle(fontSize: 18)),
/// );
/// // 상태별 다른 스타일 적용
/// final statefulStyle = baseElevatedStyle.copyWith(
///   backgroundColor: WidgetStateProperty.resolveWith((states) {
///     if (states.contains(WidgetState.pressed)) return Colors.darkRed;
///     if (states.contains(WidgetState.hovered)) return Colors.lightRed;
///     return Colors.red;
///   }),
/// );
/// ```
class GButtonTheme {
  /// Elevated Button Theme
  static ButtonStyle elevated(
    GColorConfig config, {
    double? radius,
  }) {
    final primary = toColor(config.primary);
    final onPrimary = onColor(primary);
    final scrim = toColor(config.outline).withValues(alpha: 0.5);
    return ButtonStyle(
      backgroundColor: WidgetStateProperty.resolveWith<Color?>((states) {
        if (states.contains(WidgetState.disabled)) return scrim;
        if (states.contains(WidgetState.pressed)) {
          return darken(primary, 0.1);
        }
        if (states.contains(WidgetState.hovered)) {
          return lighten(primary, 0.05);
        }
        return primary;
      }),
      foregroundColor: WidgetStateProperty.all(onPrimary),
      textStyle: WidgetStateProperty.all(
        GTextStyle.get(
          size: GTextSize.x14,
          weight: GTextWeight.regular,
          color: onPrimary,
        ),
      ),
      shape: WidgetStateProperty.all(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius ?? 12),
        ),
      ),
      elevation: WidgetStateProperty.all(0),
    );
  }

  /// Outlined Button Theme
  static ButtonStyle outlined(
    GColorConfig c, {
    double? radius,
    bool isPrimary = false,
  }) {
    final primary = toColor(c.primary);
    final outline = toColor(c.outline);
    final surface = toColor(c.surface);
    final onSurface = onColor(surface);
    return ButtonStyle(
      backgroundColor: WidgetStateProperty.all(Colors.transparent),
      foregroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return onSurface.withValues(alpha: 0.5);
        }
        return isPrimary ? primary : onSurface;
      }),
      side: WidgetStateProperty.resolveWith((states) {
        final color = isPrimary ? primary : outline;
        final width = 1.0;
        if (states.contains(WidgetState.disabled)) {
          return BorderSide(color: color.withValues(alpha: 0.5), width: width);
        }
        if (states.contains(WidgetState.pressed)) {
          return BorderSide(color: darken(color, 0.1), width: width);
        }
        return BorderSide(color: color, width: width);
      }),
      shape: WidgetStateProperty.all(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius ?? 12),
        ),
      ),
      textStyle: WidgetStateProperty.all(
        GTextStyle.get(
          size: GTextSize.x18,
          weight: GTextWeight.regular,
          color: onSurface,
        ),
      ),
    );
  }

  /// Text Button Theme
  static ButtonStyle text(
    GColorConfig c, {
    double? radius,
  }) {
    final primary = toColor(c.primary);
    final onPrimary = onColor(toColor(c.primary));
    return TextButton.styleFrom(
      foregroundColor: onPrimary,
      textStyle: GTextStyle.get(
        size: GTextSize.x14,
        weight: GTextWeight.regular,
        color: primary,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radius ?? 12),
      ),
    );
  }
}

/// 외부에서 ButtonStyle을 쉽게 오버라이드할 수 있는 확장 메서드
extension ButtonStyleCopyWith on ButtonStyle {
  ButtonStyle copyWith({
    WidgetStateProperty<Color?>? backgroundColor,
    WidgetStateProperty<Color?>? foregroundColor,
    WidgetStateProperty<Color?>? overlayColor,
    WidgetStateProperty<Color?>? shadowColor,
    WidgetStateProperty<Color?>? surfaceTintColor,
    WidgetStateProperty<Color?>? iconColor,
    WidgetStateProperty<double?>? elevation,
    WidgetStateProperty<EdgeInsetsGeometry?>? padding,
    WidgetStateProperty<Size?>? minimumSize,
    WidgetStateProperty<Size?>? fixedSize,
    WidgetStateProperty<Size?>? maximumSize,
    WidgetStateProperty<BorderSide?>? side,
    WidgetStateProperty<OutlinedBorder?>? shape,
    WidgetStateProperty<MouseCursor?>? mouseCursor,
    WidgetStateProperty<TextStyle?>? textStyle,
  }) {
    return ButtonStyle(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      foregroundColor: foregroundColor ?? this.foregroundColor,
      overlayColor: overlayColor ?? this.overlayColor,
      shadowColor: shadowColor ?? this.shadowColor,
      surfaceTintColor: surfaceTintColor ?? this.surfaceTintColor,
      iconColor: iconColor ?? this.iconColor,
      elevation: elevation ?? this.elevation,
      padding: padding ?? this.padding,
      minimumSize: minimumSize ?? this.minimumSize,
      fixedSize: fixedSize ?? this.fixedSize,
      maximumSize: maximumSize ?? this.maximumSize,
      side: side ?? this.side,
      shape: shape ?? this.shape,
      mouseCursor: mouseCursor ?? this.mouseCursor,
      textStyle: textStyle ?? this.textStyle,
    );
  }
}
