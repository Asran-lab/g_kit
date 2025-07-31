import 'package:flutter/material.dart';

class GThemeModeManager extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;

  /// 현재 테마 모드
  ThemeMode get themeMode => _themeMode;

  /// 라이트 모드로 변경
  void setLightMode() {
    _themeMode = ThemeMode.light;
    notifyListeners();
  }

  /// 다크 모드로 변경
  void setDarkMode() {
    _themeMode = ThemeMode.dark;
    notifyListeners();
  }

  /// 시스템 모드로 변경
  void setSystemMode() {
    _themeMode = ThemeMode.system;
    notifyListeners();
  }

  /// 다음 모드로 순환 (Light → Dark → System → Light...)
  void cycleNextMode() {
    switch (_themeMode) {
      case ThemeMode.light:
        _themeMode = ThemeMode.dark;
        break;
      case ThemeMode.dark:
        _themeMode = ThemeMode.system;
        break;
      case ThemeMode.system:
        _themeMode = ThemeMode.light;
        break;
    }
    notifyListeners();
  }

  /// 현재 모드가 라이트인지 확인
  bool get isLightMode => _themeMode == ThemeMode.light;

  /// 현재 모드가 다크인지 확인
  bool get isDarkMode => _themeMode == ThemeMode.dark;

  /// 현재 모드가 시스템인지 확인
  bool get isSystemMode => _themeMode == ThemeMode.system;
}
