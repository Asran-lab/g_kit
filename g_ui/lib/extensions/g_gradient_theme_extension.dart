import 'package:flutter/material.dart';
import 'package:g_ui/widgets/g_text.dart';

/// 그라데이션 테마 확장 클래스
///
/// 사용법:
/// ```dart
/// // 테마에 그라데이션 확장 추가
/// ThemeData(
///   extensions: [
///     GGradientThemeExtension(
///       gradientMap: {
///         'primary': LinearGradient(
///           colors: [Colors.pink, Colors.purple],
///           begin: Alignment.topLeft,
///           end: Alignment.bottomRight,
///         ),
///         'secondary': LinearGradient(
///           colors: [Colors.blue, Colors.cyan],
///           begin: Alignment.topCenter,
///           end: Alignment.bottomCenter,
///         ),
///       },
///     ),
///   ],
/// )
///
/// // 위젯에서 사용
/// Container(
///   decoration: BoxDecoration(
///     gradient: context.gradientTheme.getGradient('primary'),
///   ),
///   child: Text('그라데이션 배경'),
/// )
/// ```
@immutable
class GGradientThemeExtension extends ThemeExtension<GGradientThemeExtension> {
  final Map<String, Gradient> gradientMap;

  const GGradientThemeExtension({required this.gradientMap});

  /// 특정 키의 그라데이션을 가져옵니다
  Gradient? getGradient(String key) => gradientMap[key];

  /// 특정 키의 그라데이션이 존재하는지 확인합니다
  bool hasGradient(String key) => gradientMap.containsKey(key);

  /// 모든 그라데이션 키 목록을 가져옵니다
  List<String> get keys => gradientMap.keys.toList();

  /// 기본 그라데이션들을 제공합니다
  static Map<String, Gradient> get defaultGradients => {
        'primary': const LinearGradient(
          colors: [Colors.blue, Colors.purple],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        'secondary': const LinearGradient(
          colors: [Colors.green, Colors.blue],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        'tertiary': const LinearGradient(
          colors: [Colors.orange, Colors.red],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        'surface': const LinearGradient(
          colors: [Colors.grey, Colors.white],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        'error': const LinearGradient(
          colors: [Colors.red, Colors.redAccent],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      };

  /// 기본 그라데이션 테마 확장을 생성합니다
  static GGradientThemeExtension get defaultTheme =>
      GGradientThemeExtension(gradientMap: defaultGradients);

  @override
  GGradientThemeExtension copyWith({Map<String, Gradient>? gradientMap}) {
    return GGradientThemeExtension(
      gradientMap: gradientMap ?? this.gradientMap,
    );
  }

  @override
  GGradientThemeExtension lerp(
    ThemeExtension<GGradientThemeExtension>? other,
    double t,
  ) {
    if (other is! GGradientThemeExtension) return this;

    final mergedMap = <String, Gradient>{};
    final allKeys = {...gradientMap.keys, ...other.gradientMap.keys};

    for (final key in allKeys) {
      final thisGradient = gradientMap[key];
      final otherGradient = other.gradientMap[key];

      if (thisGradient != null && otherGradient != null) {
        // 그라데이션 lerp는 복잡하므로 단순히 t에 따라 선택
        mergedMap[key] = t < 0.5 ? thisGradient : otherGradient;
      } else if (thisGradient != null) {
        mergedMap[key] = thisGradient;
      } else if (otherGradient != null) {
        mergedMap[key] = otherGradient;
      }
    }

    return GGradientThemeExtension(gradientMap: mergedMap);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is GGradientThemeExtension &&
        other.gradientMap.length == gradientMap.length &&
        other.gradientMap.keys.every((key) =>
            gradientMap.containsKey(key) &&
            gradientMap[key] == other.gradientMap[key]);
  }

  @override
  int get hashCode => Object.hashAll(gradientMap.values);

  @override
  String toString() {
    return 'GGradientThemeExtension(gradientMap: $gradientMap)';
  }
}

/// 그라데이션 테마 확장을 위한 확장 메서드들
extension GGradientThemeExtensionX on BuildContext {
  /// 현재 테마의 그라데이션 확장을 가져옵니다
  GGradientThemeExtension get gradientTheme {
    final extension = Theme.of(this).extension<GGradientThemeExtension>();
    return extension ?? GGradientThemeExtension.defaultTheme;
  }

  /// 특정 키의 그라데이션을 가져옵니다
  Gradient? getGradient(String key) => gradientTheme.getGradient(key);

  /// 특정 키의 그라데이션이 존재하는지 확인합니다
  bool hasGradient(String key) => gradientTheme.hasGradient(key);
}

/// 그라데이션 위젯들을 위한 유틸리티 클래스
class GGradientWidgets {
  /// 그라데이션 배경을 가진 컨테이너를 생성합니다
  static Widget gradientContainer({
    required BuildContext context,
    required String gradientKey,
    required Widget child,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    BorderRadius? borderRadius,
    BoxBorder? border,
    List<BoxShadow>? boxShadow,
  }) {
    final gradient = context.getGradient(gradientKey);

    return Container(
      padding: padding,
      margin: margin,
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: borderRadius,
        border: border,
        boxShadow: boxShadow,
      ),
      child: child,
    );
  }

  /// 그라데이션 텍스트를 생성합니다
  static Widget gradientText({
    required BuildContext context,
    required String gradientKey,
    required String text,
    TextStyle? style,
    int? maxLines,
    TextOverflow? overflow,
  }) {
    final gradient = context.getGradient(gradientKey);

    if (gradient == null) {
      return GText(
        text,
        style: style,
        maxLines: maxLines,
        overflow: overflow,
      );
    }

    return ShaderMask(
      shaderCallback: (bounds) => gradient.createShader(bounds),
      child: GText(
        text,
        style: style?.copyWith(color: Colors.white) ??
            const TextStyle(color: Colors.white),
        maxLines: maxLines,
        overflow: overflow,
      ),
    );
  }

  /// 그라데이션 아이콘을 생성합니다
  static Widget gradientIcon({
    required BuildContext context,
    required String gradientKey,
    required IconData icon,
    double? size,
    Color? color,
  }) {
    final gradient = context.getGradient(gradientKey);

    if (gradient == null) {
      return Icon(
        icon,
        size: size,
        color: color,
      );
    }

    return ShaderMask(
      shaderCallback: (bounds) => gradient.createShader(bounds),
      child: Icon(
        icon,
        size: size,
        color: Colors.white,
      ),
    );
  }
}
