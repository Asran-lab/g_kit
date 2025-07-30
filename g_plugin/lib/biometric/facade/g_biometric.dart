import 'package:g_lib/g_lib_plugin.dart';
import 'package:g_plugin/biometric/g_biometric_initializer.dart';

/// 생체인식 모듈의 Facade 클래스
///
/// 생체인식 기능을 쉽게 사용할 수 있도록 정적 메서드를 제공합니다.
///
/// ## 사용 예제
///
/// ```dart
/// // 생체인식 지원 확인
/// if (await GBiometric.isDeviceSupported()) {
///   // 생체인식 사용 가능
/// }
///
/// // 생체인식 인증
/// final success = await GBiometric.authenticate(
///   localizedReason: '로그인을 위해 생체인식을 확인해주세요',
/// );
/// ```
///
/// 주의: 사용 전에 GPluginInitializer.initializeAll()을 통해 초기화해야 합니다.
class GBiometric {
  static final GBiometricInitializer _initializer = GBiometricInitializer();

  /// 초기화 상태 확인
  static bool get isInitialized => _initializer.isInitialized;


  /// 디바이스가 생체 인증을 지원하는지 확인
  ///
  /// 지문, Face ID, 홍채 인식 등을 지원하는지 확인합니다.
  static Future<bool> isDeviceSupported() async {
    return await _initializer.service.isDeviceSupported();
  }

  /// 생체인식 사용 가능 여부 확인
  ///
  /// 하드웨어 지원 + 등록된 생체정보 존재 여부를 확인합니다.
  static Future<bool> canCheckBiometrics() async {
    return await _initializer.service.canCheckBiometrics();
  }

  /// 사용 가능한 생체인식 타입 목록
  ///
  /// 디바이스에서 사용 가능한 생체인식 타입들을 반환합니다.
  static Future<List<BiometricType>> availableBiometrics() async {
    return await _initializer.service.availableBiometrics();
  }

  /// 생체인식 인증
  ///
  /// 사용자에게 생체인식 인증 다이얼로그를 표시합니다.
  ///
  /// [localizedReason] - 사용자에게 표시될 인증 이유
  /// [biometricOnly] - 생체인식만 허용할지 여부 (기본값: true)
  /// [stickyAuth] - 인증 상태를 유지할지 여부 (기본값: false)
  static Future<bool> authenticate({
    required String localizedReason,
    bool biometricOnly = true,
    bool stickyAuth = false,
  }) async {
    return await _initializer.service.authenticate(
      localizedReason: localizedReason,
      biometricOnly: biometricOnly,
      stickyAuth: stickyAuth,
    );
  }

  /// 서비스 정리
  ///
  /// 앱 종료 시 호출하여 리소스를 정리합니다.
  static Future<void> dispose() async {
    await _initializer.dispose();
  }
}
