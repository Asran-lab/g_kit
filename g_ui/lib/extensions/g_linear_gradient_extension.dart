import 'dart:math';
import 'package:flutter/material.dart';

/// LinearGradient를 위한 확장 클래스들
///
/// 사용 예시:
/// ```dart
/// // 확장 메서드 사용
/// final gradient = LinearGradient(colors: [Colors.pink, Colors.purple]);
/// final modifiedGradient = gradient
///   .withColors([Colors.blue, Colors.purple])
///   .withDirection(begin: Alignment.topLeft, end: Alignment.bottomRight);
///
/// // 색상 확장 사용
/// final colorGradient = Colors.pink.toGradientWith(Colors.purple);
///
/// // 팩토리 사용
/// final factoryGradient = GGradientFactory.pinkToPurple;
/// ```
extension GLinearGradientExtension on LinearGradient {
  /// 그라데이션을 복사하여 새로운 색상으로 생성합니다
  LinearGradient copyWith({
    List<Color>? colors,
    AlignmentGeometry? begin,
    AlignmentGeometry? end,
    List<double>? stops,
    TileMode? tileMode,
    GradientTransform? transform,
  }) {
    return LinearGradient(
      colors: colors ?? this.colors,
      begin: begin ?? this.begin,
      end: end ?? this.end,
      stops: stops ?? this.stops,
      tileMode: tileMode ?? this.tileMode,
      transform: transform ?? this.transform,
    );
  }

  /// 그라데이션의 방향을 변경합니다
  LinearGradient withDirection({
    AlignmentGeometry? begin,
    AlignmentGeometry? end,
  }) {
    return copyWith(begin: begin, end: end);
  }

  /// 그라데이션의 색상을 변경합니다
  LinearGradient withColors(List<Color> colors) {
    return copyWith(colors: colors);
  }

  /// 그라데이션의 투명도를 변경합니다
  LinearGradient withOpacity(double opacity) {
    return copyWith(
      colors: colors.map((color) => color.withValues(alpha: opacity)).toList(),
    );
  }

  /// 그라데이션을 반전시킵니다
  LinearGradient get reversed {
    return copyWith(
      begin: end,
      end: begin,
      colors: colors.reversed.toList(),
    );
  }

  /// 그라데이션을 회전시킵니다 (각도)
  LinearGradient rotated(double angle) {
    final radians = angle * pi / 180;
    final cosValue = cos(radians);
    final sinValue = sin(radians);

    return copyWith(
      begin: Alignment(-cosValue, -sinValue),
      end: Alignment(cosValue, sinValue),
    );
  }
}

/// 색상 조합을 위한 확장 클래스
extension ColorCombinationExtension on Color {
  /// 두 색상으로 LinearGradient를 생성합니다
  LinearGradient toGradientWith(
    Color other, {
    AlignmentGeometry begin = Alignment.centerLeft,
    AlignmentGeometry end = Alignment.centerRight,
  }) {
    return LinearGradient(
      colors: [this, other],
      begin: begin,
      end: end,
    );
  }

  /// 색상 리스트로 LinearGradient를 생성합니다
  LinearGradient toGradientWithList(
    List<Color> colors, {
    AlignmentGeometry begin = Alignment.centerLeft,
    AlignmentGeometry end = Alignment.centerRight,
  }) {
    return LinearGradient(
      colors: [this, ...colors],
      begin: begin,
      end: end,
    );
  }
}
