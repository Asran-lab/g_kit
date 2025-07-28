import 'package:flutter/material.dart';

extension WidgetsExtension on Widget {
  /// Alignment

  /// center
  Widget get center => Center(child: this);

  /// centerLeft
  Widget get centerLeft => Align(
        alignment: Alignment.centerLeft,
        child: this,
      );

  /// centerRight
  Widget get centerRight => Align(
        alignment: Alignment.centerRight,
        child: this,
      );

  /// topCenter
  Widget get topCenter => Align(
        alignment: Alignment.topCenter,
        child: this,
      );

  /// topLeft
  Widget get topLeft => Align(
        alignment: Alignment.topLeft,
        child: this,
      );

  /// topRight
  Widget get topRight => Align(
        alignment: Alignment.topRight,
        child: this,
      );

  /// bottomCenter
  Widget get bottomCenter => Align(
        alignment: Alignment.bottomCenter,
        child: this,
      );

  /// bottomLeft
  Widget get bottomLeft => Align(
        alignment: Alignment.bottomLeft,
        child: this,
      );

  /// bottomRight
  Widget get bottomRight => Align(
        alignment: Alignment.bottomRight,
        child: this,
      );

  /// Expanded / Flexible
  Widget expanded({int flex = 1}) => Expanded(flex: flex, child: this);

  Widget flexible({int flex = 1}) => Flexible(flex: flex, child: this);

  /// Visibility
  Widget visible(bool isVisible) => isVisible ? this : const SizedBox.shrink();

  /// On Tap
  Widget onTap(
    VoidCallback onTap, {
    HitTestBehavior behavior = HitTestBehavior.opaque,
  }) =>
      GestureDetector(behavior: behavior, onTap: onTap, child: this);

  /// SafeArea
  Widget safeArea({bool top = true, bool bottom = true}) =>
      SafeArea(top: top, bottom: bottom, child: this);

  /// gap
  Widget gap({
    double? height,
    double? width,
  }) =>
      SizedBox(height: height, width: width, child: this);

  /// Positioned
  Widget positioned({
    double? left,
    double? top,
    double? right,
    double? bottom,
  }) =>
      Positioned(
        left: left,
        top: top,
        right: right,
        bottom: bottom,
        child: this,
      );

  Widget get intrinsitHeight => IntrinsicHeight(child: this);

  /// Padding & Margin
  Widget paddingOnly({
    double? top,
    double? bottom,
    double? left,
    double? right,
  }) =>
      Padding(
        padding: EdgeInsets.only(
          top: top ?? 0.0,
          bottom: bottom ?? 0.0,
          left: left ?? 0.0,
          right: right ?? 0.0,
        ),
        child: this,
      );

  /// Padding All
  Widget paddingAll(double padding) =>
      Padding(padding: EdgeInsets.all(padding), child: this);

  /// Padding Symmetric
  Widget paddingSymmetric({double vertical = 0.0, double horizontal = 0.0}) =>
      Padding(
        padding: EdgeInsets.symmetric(
          vertical: vertical,
          horizontal: horizontal,
        ),
        child: this,
      );

  /// Margin
  Widget marginOnly({
    double? top,
    double? bottom,
    double? left,
    double? right,
  }) =>
      Container(
        margin: EdgeInsets.only(
          top: top ?? 0.0,
          bottom: bottom ?? 0.0,
          left: left ?? 0.0,
          right: right ?? 0.0,
        ),
        child: this,
      );

  /// Margin All
  Widget marginAll(double margin) =>
      Container(margin: EdgeInsets.all(margin), child: this);

  /// Margin Symmetric
  Widget marginSymmetric({double vertical = 0.0, double horizontal = 0.0}) =>
      Container(
        margin: EdgeInsets.symmetric(
          vertical: vertical,
          horizontal: horizontal,
        ),
        child: this,
      );

  /// ColorFiltered
  Widget colorFiltered(
    Color color, {
    double opacity = 0.5,
    BlendMode blendMode = BlendMode.darken,
  }) =>
      ColorFiltered(
        colorFilter:
            ColorFilter.mode(color.withValues(alpha: opacity), blendMode),
        child: this,
      );

  /// [IgnorePointer]
  /// 예를 들어 버튼 위에 반투명한 레이어를 덮어 씌워 버튼이 클릭되지 않도록 방지
  /// ignoring: true 로 설정하면 해당 위젯과 자식 위젯들이 터치 이벤트를 받지 않는다
  Widget ignorePointer(bool ignoring, {Color? color}) => IgnorePointer(
        ignoring: ignoring,
        child: Container(color: color?.withValues(alpha: 0.3), child: this),
      );

  /// [Opacity]
  /// 위젯의 투명도를 조절
  /// 0.0 은 완전 투명, 1.0 은 완전 불투명
  Widget opacity(double opacity) => Opacity(opacity: opacity, child: this);

  /// [Card] - 카드 형태로 감싸기
  Widget card({
    Key? key,
    Color? color,
    Color? shadowColor,
    double? elevation,
    ShapeBorder? shape,
    bool borderOnForeground = true,
    EdgeInsetsGeometry? margin,
    Clip? clipBehavior,
    Widget? child,
  }) =>
      Card(
        key: key,
        color: color,
        shadowColor: shadowColor,
        elevation: elevation,
        shape: shape,
        borderOnForeground: borderOnForeground,
        margin: margin,
        clipBehavior: clipBehavior,
        child: this,
      );
}
