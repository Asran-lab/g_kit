import 'package:g_lib/g_lib_plugin.dart';

abstract class GBiometricService {
  /// 초기화. GBiometric.instance 에 구현체를 주입한다.
  Future<void> initialize();

  /// 디바이스가 생체 인증(지문·FaceID 등)을 지원하는가?
  Future<bool> isDeviceSupported();

  /// 하드웨어 + 등록된 생체정보 존재 여부
  Future<bool> canCheckBiometrics();

  /// 사용 가능한 바이오메트릭 타입
  Future<List<BiometricType>> availableBiometrics();

  /// 인증 다이얼로그 표시
  Future<bool> authenticate({
    required String localizedReason,
    bool biometricOnly,
    bool stickyAuth,
  });
}
