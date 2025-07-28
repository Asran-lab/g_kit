import 'package:flutter/services.dart';
import 'package:g_common/utils/g_guard.dart' show guardFuture;
import 'package:g_common/utils/g_logger.dart' show Logger;
import 'package:g_model/initializer/g_initializer.dart';
import 'service/g_permission_service.dart';
import 'service/g_permission_impl.dart';

/// 권한 초기화 클래스
///
/// GInitializer를 상속하여 플러그인 초기화 시스템과 통합됩니다.
class GPermissionInitializer extends GInitializer {
  static final GPermissionInitializer _instance =
      GPermissionInitializer._internal();
  factory GPermissionInitializer() => _instance;
  GPermissionInitializer._internal();

  GPermissionService? _service;
  bool _isInitialized = false;

  @override
  String get name => 'permission';

  @override
  Future<void> initialize() async {
    if (_isInitialized) return;

    await guardFuture<void>(() async {
      _service = GPermissionImpl();
      await _service!.initialize();
      _isInitialized = true;
    }, typeHandlers: {
      PlatformException: (e, s) {
        Logger.e('GPermissionInitializer initialize failed', error: e);
        throw e;
      },
    });
  }

  /// 서비스 인스턴스 가져오기
  GPermissionService get service {
    if (!_isInitialized) {
      throw StateError(
          'GPermissionInitializer is not initialized. Call initialize() first.');
    }
    return _service!;
  }

  /// 초기화 상태 확인
  bool get isInitialized => _isInitialized;

  /// 서비스 정리
  ///
  /// 앱 종료 시 호출하여 리소스를 정리합니다.
  Future<void> dispose() async {
    if (_service != null) {
      await _service!.dispose();
      _service = null;
    }
    _isInitialized = false;
  }
}
