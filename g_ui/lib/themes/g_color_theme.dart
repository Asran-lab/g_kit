import 'package:flutter/material.dart';
import 'package:g_common/utils/g_color.dart';
import 'package:g_ui/configs/g_color_config.dart';

ColorScheme gColorScheme(
  GColorConfig config,
  Brightness brightness,
) {
  if (brightness == Brightness.dark) {
    return gDarkColorScheme(config);
  } else {
    return gLightColorScheme(config);
  }
}

// ================================
// Light Theme 생성
// ================================
ColorScheme gLightColorScheme(GColorConfig config) {
  final primary = toColor(config.primary);
  final secondary = toColor(config.secondary);
  final tertiary = toColor(config.tertiary);
  final error = toColor(config.error);
  final surface = toColor(config.surface);
  final outline = toColor(config.outline);

  // Material3 시드 알고리즘으로 각 팔레트 생성 (색감 일관성 향상)
  final csP =
      ColorScheme.fromSeed(seedColor: primary, brightness: Brightness.light);
  final csS =
      ColorScheme.fromSeed(seedColor: secondary, brightness: Brightness.light);
  final csT =
      ColorScheme.fromSeed(seedColor: tertiary, brightness: Brightness.light);
  final csE =
      ColorScheme.fromSeed(seedColor: error, brightness: Brightness.light);

  // Container/Fixed 계열은 각 시드의 결과값을 사용
  final primaryContainer = csP.primaryContainer;
  final secondaryContainer = csS.secondaryContainer;
  final tertiaryContainer = csT.tertiaryContainer;
  final errorContainer = csE.errorContainer;

  final primaryFixed = csP.primaryFixed;
  final primaryFixedDim = csP.primaryFixedDim;
  final secondaryFixed = csS.secondaryFixed;
  final secondaryFixedDim = csS.secondaryFixedDim;
  final tertiaryFixed = csT.tertiaryFixed;
  final tertiaryFixedDim = csT.tertiaryFixedDim;

  // Surface 변형들
  final surfaceDim = darken(surface, 0.05);
  final surfaceBright = lighten(surface, 0.05);
  final surfaceContainerLowest = Colors.white;
  final surfaceContainerLow = lighten(surface, 0.02);
  final surfaceContainer = lighten(surface, 0.04);
  final surfaceContainerHigh = lighten(surface, 0.06);
  final surfaceContainerHighest = lighten(surface, 0.08);

  return ColorScheme(
    brightness: Brightness.light,

    // Primary
    primary: csP.primary,
    onPrimary: csP.onPrimary,
    primaryContainer: primaryContainer,
    onPrimaryContainer: csP.onPrimaryContainer,
    primaryFixed: primaryFixed,
    primaryFixedDim: primaryFixedDim,
    onPrimaryFixed: csP.onPrimaryFixed,
    onPrimaryFixedVariant: csP.onPrimaryFixedVariant,

    // Secondary
    secondary: csS.secondary,
    onSecondary: csS.onSecondary,
    secondaryContainer: secondaryContainer,
    onSecondaryContainer: csS.onSecondaryContainer,
    secondaryFixed: secondaryFixed,
    secondaryFixedDim: secondaryFixedDim,
    onSecondaryFixed: csS.onSecondaryFixed,
    onSecondaryFixedVariant: csS.onSecondaryFixedVariant,

    // Tertiary
    tertiary: csT.tertiary,
    onTertiary: csT.onTertiary,
    tertiaryContainer: tertiaryContainer,
    onTertiaryContainer: csT.onTertiaryContainer,
    tertiaryFixed: tertiaryFixed,
    tertiaryFixedDim: tertiaryFixedDim,
    onTertiaryFixed: csT.onTertiaryFixed,
    onTertiaryFixedVariant: csT.onTertiaryFixedVariant,

    // Error
    error: csE.error,
    onError: csE.onError,
    errorContainer: errorContainer,
    onErrorContainer: csE.onErrorContainer,

    // Surface
    surface: surface,
    onSurface: onColor(surface),
    surfaceDim: surfaceDim,
    surfaceBright: surfaceBright,
    surfaceContainerLowest: surfaceContainerLowest,
    surfaceContainerLow: surfaceContainerLow,
    surfaceContainer: surfaceContainer,
    surfaceContainerHigh: surfaceContainerHigh,
    surfaceContainerHighest: surfaceContainerHighest,
    onSurfaceVariant: onColor(surfaceContainer),

    // Outline
    outline: outline,
    outlineVariant: lighten(outline, 0.3),

    // System
    shadow: const Color(0xFF000000),
    scrim: const Color(0xFF000000),

    // Inverse
    inverseSurface: darken(surface, 0.8),
    onInverseSurface: onColor(darken(surface, 0.8)),
    inversePrimary: lighten(primary, 0.6),
    surfaceTint: primary,
  );
}

// ================================
// Dark Theme 생성 (완전히 재작성)
// ================================
ColorScheme gDarkColorScheme(GColorConfig config) {
  // 기본 색상들
  final lightPrimary = toColor(config.primary);
  final lightSecondary = toColor(config.secondary);
  final lightTertiary = toColor(config.tertiary);
  final lightError = toColor(config.error);
  final lightSurface = toColor(config.surface);
  // Dark theme의 기본 원칙:
  // 1. 밝은 색상들을 더 부드럽게 (채도 낮추고 명도 높임)
  // 2. 배경은 매우 어둡게
  // 3. 텍스트는 충분히 밝게 (접근성 고려)

  // 시드 기반 다크 팔레트 생성 (Material3)
  final csP = ColorScheme.fromSeed(
      seedColor: lightPrimary, brightness: Brightness.dark);
  final csS = ColorScheme.fromSeed(
      seedColor: lightSecondary, brightness: Brightness.dark);
  final csT = ColorScheme.fromSeed(
      seedColor: lightTertiary, brightness: Brightness.dark);
  final csE =
      ColorScheme.fromSeed(seedColor: lightError, brightness: Brightness.dark);

  final primary = csP.primary;
  final secondary = csS.secondary;
  final tertiary = csT.tertiary;
  final error = csE.error;

  // Dark surface/outline: config 기반 비율 계산 (하드코딩 금지)
  final surface = darken(lightSurface, 0.85);
  final outline = lighten(toColor(config.outline), 0.15);

  // Container 색상들 (어두운 버전)
  // final primaryContainer = darken(primary, 0.6);
  // final secondaryContainer = darken(secondary, 0.6);
  // final tertiaryContainer = darken(tertiary, 0.6);
  // final errorContainer = darken(error, 0.6);

  // // Fixed 색상들 (dark에서는 light와 동일하게 유지)
  // final primaryFixed = lighten(lightPrimary, 0.8);
  // final primaryFixedDim = lighten(lightPrimary, 0.7);
  // final secondaryFixed = lighten(lightSecondary, 0.8);
  // final secondaryFixedDim = lighten(lightSecondary, 0.7);
  // final tertiaryFixed = lighten(lightTertiary, 0.8);
  // final tertiaryFixedDim = lighten(lightTertiary, 0.7);

  // Surface 변형들 (어두운 톤으로)
  final surfaceDim = darken(surface, 0.05);
  final surfaceBright = lighten(surface, 0.15);
  final surfaceContainerLowest = const Color(0xFF0F0D13);
  final surfaceContainerLow = lighten(surface, 0.02);
  final surfaceContainer = lighten(surface, 0.04);
  final surfaceContainerHigh = lighten(surface, 0.07);
  final surfaceContainerHighest = lighten(surface, 0.11);

  return ColorScheme(
    brightness: Brightness.dark,

    // Primary
    primary: primary,
    onPrimary: csP.onPrimary,
    primaryContainer: csP.primaryContainer,
    onPrimaryContainer: csP.onPrimaryContainer,
    primaryFixed: csP.primaryFixed,
    primaryFixedDim: csP.primaryFixedDim,
    onPrimaryFixed: csP.onPrimaryFixed,
    onPrimaryFixedVariant: csP.onPrimaryFixedVariant,

    // Secondary
    secondary: secondary,
    onSecondary: csS.onSecondary,
    secondaryContainer: csS.secondaryContainer,
    onSecondaryContainer: csS.onSecondaryContainer,
    secondaryFixed: csS.secondaryFixed,
    secondaryFixedDim: csS.secondaryFixedDim,
    onSecondaryFixed: csS.onSecondaryFixed,
    onSecondaryFixedVariant: csS.onSecondaryFixedVariant,

    // Tertiary
    tertiary: tertiary,
    onTertiary: csT.onTertiary,
    tertiaryContainer: csT.tertiaryContainer,
    onTertiaryContainer: csT.onTertiaryContainer,
    tertiaryFixed: csT.tertiaryFixed,
    tertiaryFixedDim: csT.tertiaryFixedDim,
    onTertiaryFixed: csT.onTertiaryFixed,
    onTertiaryFixedVariant: csT.onTertiaryFixedVariant,

    // Error
    error: error,
    onError: csE.onError,
    errorContainer: csE.errorContainer,
    onErrorContainer: csE.onErrorContainer,

    // Surface
    surface: surface,
    onSurface: onColor(surface),
    surfaceDim: surfaceDim,
    surfaceBright: surfaceBright,
    surfaceContainerLowest: surfaceContainerLowest,
    surfaceContainerLow: surfaceContainerLow,
    surfaceContainer: surfaceContainer,
    surfaceContainerHigh: surfaceContainerHigh,
    surfaceContainerHighest: surfaceContainerHighest,
    onSurfaceVariant: onColor(surfaceContainer),

    // Outline
    outline: outline,
    outlineVariant: lighten(outline, 0.2),

    // System
    shadow: const Color(0xFF000000),
    scrim: const Color(0xFF000000),

    // Inverse
    inverseSurface: lighten(surface, 0.8),
    onInverseSurface: onColor(lighten(surface, 0.8)),
    inversePrimary: lighten(primary, 0.6),
    surfaceTint: primary,
  );
}
