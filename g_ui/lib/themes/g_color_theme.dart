import 'package:flutter/material.dart';
import 'package:g_common/utils/g_color.dart';
import 'package:g_ui/configs/g_color_config.dart';

ColorScheme gColorScheme(
  GColorConfig config,
  Brightness brightness,
) {
  final bool isDark = brightness == Brightness.dark;

  // 색상 캐싱
  final primary = toColor(config.primary);
  final secondary = toColor(config.secondary);
  final tertiary = toColor(config.tertiary);
  final error = toColor(config.error);
  final surface = toColor(config.surface);
  final outline = toColor(config.outline);

  final onPrimary = onColor(primary);
  final onSecondary = onColor(secondary);
  final onTertiary = onColor(tertiary);
  final onError = onColor(error);
  final onSurface = onColor(surface);
  final shadow = Colors.black87;
  final scrim = Colors.black87;

  // Color lighten(Color base, [double amt = .1]) => lighten(base, amt);
  // Color darken(Color base, [double amt = .1]) => darken(base, amt);
  Color on(Color base) => onColor(base);

  return ColorScheme(
    brightness: brightness,
    // Primary
    primary: primary,
    onPrimary: onPrimary,
    primaryContainer: lighten(primary, GColorTone.container),
    onPrimaryContainer: on(lighten(primary, GColorTone.container)),
    primaryFixed: lighten(primary, GColorTone.fixed),
    primaryFixedDim: darken(primary, GColorTone.fixedDim),
    onPrimaryFixed: on(lighten(primary, GColorTone.fixed)),
    onPrimaryFixedVariant: on(darken(primary, GColorTone.fixedDim)),

    // Secondary
    secondary: secondary,
    onSecondary: onSecondary,
    secondaryContainer: lighten(secondary, GColorTone.container),
    onSecondaryContainer: on(lighten(secondary, GColorTone.container)),
    secondaryFixed: lighten(secondary, GColorTone.fixed),
    secondaryFixedDim: darken(secondary, GColorTone.fixedDim),
    onSecondaryFixed: on(lighten(secondary, GColorTone.fixed)),
    onSecondaryFixedVariant: on(darken(secondary, GColorTone.fixedDim)),

    // Tertiary
    tertiary: tertiary,
    onTertiary: onTertiary,
    tertiaryContainer: lighten(tertiary, GColorTone.container),
    onTertiaryContainer: on(lighten(tertiary, GColorTone.container)),
    tertiaryFixed: lighten(tertiary, GColorTone.fixed),
    tertiaryFixedDim: darken(tertiary, GColorTone.fixedDim),
    onTertiaryFixed: on(lighten(tertiary, GColorTone.fixed)),
    onTertiaryFixedVariant: on(darken(tertiary, GColorTone.fixedDim)),

    // Error
    error: error,
    onError: onError,
    errorContainer: lighten(error, GColorTone.container),
    onErrorContainer: on(lighten(error, GColorTone.container)),

    // Surface
    surface: surface,
    onSurface: onSurface,
    surfaceDim: isDark
        ? darken(surface, GColorTone.surfaceDimDark)
        : darken(surface, GColorTone.surfaceDimLight),
    surfaceBright: lighten(surface, GColorTone.surfaceBright),
    surfaceContainerLowest: isDark ? Colors.black : Colors.white,
    surfaceContainerLow: darken(surface, GColorTone.surfaceDimLight),
    surfaceContainer: darken(surface, GColorTone.surfaceDimLight),
    surfaceContainerHigh: darken(surface, GColorTone.surfaceDimLight),
    surfaceContainerHighest: darken(surface, GColorTone.surfaceDimLight),
    onSurfaceVariant: on(lighten(surface, GColorTone.surfaceDimLight)),

    // Outline, etc.
    outline: outline,
    outlineVariant: lighten(outline, GColorTone.outlineVariant),
    shadow: shadow,
    scrim: scrim,
    inverseSurface: lighten(surface, GColorTone.inverse),
    onInverseSurface: on(lighten(surface, GColorTone.inverse)),
    inversePrimary: darken(primary, GColorTone.inverse),
    surfaceTint: primary,
  );
}
