import 'package:flutter/material.dart';

// 텍스트 타입
enum GTextType { normal, rich, auto }

enum GTextSize {
  x8,
  x10,
  x12,
  x14,
  x16,
  x18,
  x20,
  x22,
  x24,
  x28,
  x32,
  x36,
  x48,
  x64,
}

enum GTextWeight { thin, regular, medium, bold }

/// 텍스트 스타일 전용
class GTextStyle {
  static TextStyle get({
    required GTextSize size,
    required GTextWeight weight,
    double? height,
    Color? color,
  }) {
    final double tSize = switch (size) {
      GTextSize.x8 => 8,
      GTextSize.x10 => 10,
      GTextSize.x12 => 12,
      GTextSize.x14 => 14,
      GTextSize.x16 => 16,
      GTextSize.x18 => 18,
      GTextSize.x20 => 20,
      GTextSize.x22 => 22,
      GTextSize.x24 => 24,
      GTextSize.x28 => 28,
      GTextSize.x32 => 32,
      GTextSize.x36 => 36,
      GTextSize.x48 => 48,
      GTextSize.x64 => 64,
    };

    final FontWeight tWeight = switch (weight) {
      GTextWeight.thin => FontWeight.w200,
      GTextWeight.regular => FontWeight.w400,
      GTextWeight.medium => FontWeight.w500,
      GTextWeight.bold => FontWeight.w900,
    };

    return TextStyle(
      fontSize: tSize,
      fontWeight: tWeight,
      height: height ?? 1.4,
      color: color,
    );
  }
}
