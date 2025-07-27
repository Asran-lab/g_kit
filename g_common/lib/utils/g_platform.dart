import 'package:flutter/foundation.dart';

// 전역 플랫폼 캐시
TargetPlatform? _cachedPlatform;

/// 현재 플랫폼 가져오기 (BuildContext 없이도 가능)
TargetPlatform get getPlatform => _cachedPlatform ??= defaultTargetPlatform;

/// Android 플랫폼인지 확인
bool get isAndroid => getPlatform == TargetPlatform.android;

/// iOS 플랫폼인지 확인
bool get isIOS => getPlatform == TargetPlatform.iOS;

/// macOS 플랫폼인지 확인
bool get isMacOS => getPlatform == TargetPlatform.macOS;

/// Windows 플랫폼인지 확인
bool get isWindows => getPlatform == TargetPlatform.windows;

/// Fuchsia 플랫폼인지 확인
///
bool get isFuchsia => getPlatform == TargetPlatform.fuchsia;

/// Linux 플랫폼인지 확인
bool get isLinux => getPlatform == TargetPlatform.linux;

/// Web 플랫폼인지 확인
bool get isWeb => kIsWeb;

/// 데스크톱 플랫폼인지 확인 (macOS, Windows, Linux)
bool get isDesktop => !isWeb && (isMacOS || isWindows || isLinux);

/// 모바일 플랫폼인지 확인 (Android, iOS)
bool get isMobile => !isWeb && (isAndroid || isIOS);

/// Google 플랫폼인지 확인 (Android, Fuchsia)
bool get isGoogle => !isWeb && (isAndroid || isFuchsia);

/// Apple 플랫폼인지 확인 (iOS, macOS)
bool get isApple => !isWeb && (isIOS || isMacOS);
