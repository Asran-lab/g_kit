import 'package:flutter/services.dart';
import 'package:g_common/utils/g_guard.dart' show guardFuture;
import 'package:g_common/utils/g_logger.dart' show Logger;
import 'package:g_model/initializer/g_initializer.dart';
import 'service/g_biometric_service.dart';
import 'service/g_biometric_impl.dart';

/// 생체인식 초기화 클래스
///
/// GInitializer를 상속하여 플러그인 초기화 시스템과 통합됩니다.
class GBiometricInitializer extends GInitializer {
  static final GBiometricInitializer _instance =
      GBiometricInitializer._internal();
  factory GBiometricInitializer() => _instance;
  GBiometricInitializer._internal();

  GBiometricService? _service;
  bool _isInitialized = false;

  @override
  String get name => 'biometric';

  @override
  Future<void> initialize() async {
    if (_isInitialized) return;

    await guardFuture<void>(() async {
      _service = GBiometricImpl();
      await _service!.initialize();
      _isInitialized = true;
    }, typeHandlers: {
      PlatformException: (e, s) {
        Logger.e('GBiometricInitializer initialize failed', error: e);
        throw e;
      },
    });
  }

  GBiometricService get service {
    if (!_isInitialized) {
      throw StateError(
          'GBiometricInitializer is not initialized. Call initialize() first.');
    }
    return _service!;
  }

  bool get isInitialized => _isInitialized;

  Future<void> dispose() async {
    if (_service != null) {
      _service = null;
    }
    _isInitialized = false;
  }
}
