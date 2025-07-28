import 'package:g_lib/g_lib_plugin.dart';
import 'package:g_plugin/biometric/service/g_biometric_service.dart';

class GBiometricImpl extends GBiometricService {
  late final LocalAuthentication _auth;

  @override
  Future<void> initialize() async {
    _auth = LocalAuthentication();
  }

  @override
  Future<bool> isDeviceSupported() async => _auth.isDeviceSupported();

  @override
  Future<bool> canCheckBiometrics() => _auth.canCheckBiometrics;

  @override
  Future<List<BiometricType>> availableBiometrics() =>
      _auth.getAvailableBiometrics();

  @override
  Future<bool> authenticate({
    required String localizedReason,
    bool biometricOnly = true,
    bool stickyAuth = false,
  }) async {
    return await _auth.authenticate(
      localizedReason: localizedReason,
      options: AuthenticationOptions(
        biometricOnly: biometricOnly,
        stickyAuth: stickyAuth,
      ),
    );
  }
}
