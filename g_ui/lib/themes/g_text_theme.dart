import 'package:flutter/material.dart';
import 'package:g_common/utils/g_color.dart';
import 'package:g_ui/configs/g_color_config.dart';

TextTheme gTextTheme(GColorConfig config, {String? fontFamily}) {
  // Letter Spacing - Material Design 3 표준에 맞게 조정
  const double ls = 0.0;

  double calcHeight(double fontSize, double lineHeight) =>
      double.parse((lineHeight / fontSize).toStringAsFixed(2));

  TextStyle baseStyle({
    required double fontSize,
    required double lineHeight,
    required FontWeight fontWeight,
  }) =>
      TextStyle(
        fontSize: fontSize,
        height: calcHeight(fontSize, lineHeight),
        letterSpacing: ls,
        fontWeight: fontWeight,
        fontFamily: fontFamily,
        color: onColor(toColor(config.surface)),
      );

  return TextTheme(
    displayLarge: baseStyle(
      fontSize: 96,
      lineHeight: 112,
      fontWeight: FontWeight.w300,
    ),
    headlineLarge: baseStyle(
      fontSize: 48,
      lineHeight: 68,
      fontWeight: FontWeight.w400,
    ),
    headlineMedium: baseStyle(
      fontSize: 44,
      lineHeight: 60,
      fontWeight: FontWeight.w400,
    ),
    headlineSmall: baseStyle(
      fontSize: 40,
      lineHeight: 56,
      fontWeight: FontWeight.w400,
    ),
    titleLarge: baseStyle(
      fontSize: 32,
      lineHeight: 46,
      fontWeight: FontWeight.w400,
    ),
    titleMedium: baseStyle(
      fontSize: 26,
      lineHeight: 38,
      fontWeight: FontWeight.w500,
    ),
    titleSmall: baseStyle(
      fontSize: 22,
      lineHeight: 32,
      fontWeight: FontWeight.w500,
    ),
    bodyLarge: baseStyle(
      fontSize: 18,
      lineHeight: 26,
      fontWeight: FontWeight.w400,
    ),
    bodyMedium: baseStyle(
      fontSize: 14,
      lineHeight: 20,
      fontWeight: FontWeight.w400,
    ),
    bodySmall: baseStyle(
      fontSize: 12,
      lineHeight: 18,
      fontWeight: FontWeight.w400,
    ),
    labelLarge: baseStyle(
      fontSize: 14,
      lineHeight: 20,
      fontWeight: FontWeight.w500,
    ),
    labelMedium: baseStyle(
      fontSize: 12,
      lineHeight: 18,
      fontWeight: FontWeight.w500,
    ),
    labelSmall: baseStyle(
      fontSize: 11,
      lineHeight: 16,
      fontWeight: FontWeight.w500,
    ),
  );
}
