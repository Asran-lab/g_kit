import 'package:flutter/material.dart';

extension MediaQueryContextExtension on BuildContext {
  MediaQueryData get mediaQuery => MediaQuery.of(this);
  Size get screenSize => mediaQuery.size;
  double get width => screenSize.width;
  double get height => screenSize.height;
  EdgeInsets get viewPadding => mediaQuery.viewPadding;
  EdgeInsets get viewInsets => mediaQuery.viewInsets;
  Orientation get orientation => mediaQuery.orientation;

  /// 키보드 표시 여부 확인
  bool get isKeyboardVisible => viewInsets.bottom > 0;

  /// 플랫폼 사이즈
  bool get isMobileSize => screenSize.width <= 400.0;
  bool get isTabletSize => screenSize.width <= 834.0;
  bool get isDesktopSize => screenSize.width > 1440.0;
}
