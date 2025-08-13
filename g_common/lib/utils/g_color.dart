import 'dart:ui';

import 'package:flutter/material.dart' show HSLColor;

/* 색깔 가져오기 */
Color getColor(String color) => Color(int.parse(color));

/* 색깔 변경 */
Color shiftHSL(Color color, double h, double s, double l) {
  final hsl = HSLColor.fromColor(color);
  final shifted = hsl.withHue(h).withSaturation(s).withLightness(l);
  return shifted.toColor();
}

/* 색깔 혼합 */
Color blend(Color dst, Color src, double opacity) {
  return Color.fromARGB(
    255,
    (dst.r.toDouble() * (1.0 - opacity) + src.r.toDouble() * opacity).toInt(),
    (dst.g.toDouble() * (1.0 - opacity) + src.g.toDouble() * opacity).toInt(),
    (dst.b.toDouble() * (1.0 - opacity) + src.b.toDouble() * opacity).toInt(),
  );
}

/* 색깔 변환 
16진수 색상을 Color 객체로 변환
ex) #000000 -> Color(0xFF000000)
*/
Color toColor(String hexColor) {
  hexColor = hexColor.replaceAll('#', '');
  if (hexColor.length != 6) {
    throw ArgumentError("Error_ColorUtil_001");
  }
  hexColor = "FF$hexColor";
  return Color(int.parse(hexColor, radix: 16) + 0xFF000000);
}

/// 색상의 명도 계산
double getLuminance(Color color) => color.computeLuminance();

/* 색깔 변환 
dart-define에서 동적으로 추출할 수 있음
*/
String toHex(Color color, {bool leadingHash = true}) {
  return '${leadingHash ? '#' : ''}'
      '${((color.r * 255.0).round() & 0xff).toRadixString(16).padLeft(2, '0')}'
      '${((color.g * 255.0).round() & 0xff).toRadixString(16).padLeft(2, '0')}'
      '${((color.b * 255.0).round() & 0xff).toRadixString(16).padLeft(2, '0')}';
}

/* 배경색에 따른 글자색 반환 */
/// 접근성을 고려한 대비색 계산 (개선된 버전)
Color onColor(Color backgroundColor) {
  final luminance = backgroundColor.computeLuminance();

  // Material Design 3 가이드라인에 따른 임계값
  if (luminance > 0.5) {
    // 밝은 배경 -> 어두운 텍스트
    return const Color(0xFF1D1B20); // Material Design 3 standard dark
  } else {
    // 어두운 배경 -> 밝은 텍스트
    return const Color(0xFFFEF7FF); // Material Design 3 standard light
  }
}

/* 색깔 어둡게 
ex) darken(Color(0xFF000000), 0.1) -> Color(0xFF000000)
*/
/// HSL 기반 색상 어둡게 만들기
Color darken(Color color, double amount) {
  final hsl = HSLColor.fromColor(color);
  final lightness = (hsl.lightness - amount).clamp(0.0, 1.0);
  return hsl.withLightness(lightness).toColor();
}

/* 색깔 밝게
ex) lighten(Color(0xFF000000), 0.1) -> Color(0xFF000000) 
*/
/// HSL 기반 색상 밝게 만들기
Color lighten(Color color, double amount) {
  final hsl = HSLColor.fromColor(color);
  final lightness = (hsl.lightness + amount).clamp(0.0, 1.0);
  return hsl.withLightness(lightness).toColor();
}

/// 채도 조정
Color saturate(Color color, double amount) {
  final hsl = HSLColor.fromColor(color);
  final saturation = (hsl.saturation + amount).clamp(0.0, 1.0);
  return hsl.withSaturation(saturation).toColor();
}

/// 색조 회전
Color shiftHue(Color color, double degrees) {
  final hsl = HSLColor.fromColor(color);
  final hue = (hsl.hue + degrees) % 360;
  return hsl.withHue(hue).toColor();
}
