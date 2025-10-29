import 'package:flutter/services.dart';
import 'package:g_common/utils/g_guard.dart' show guardFuture;
import 'package:g_common/utils/g_logger.dart' show Logger;
import 'package:g_model/g_model.dart';
import 'service/g_share_service.dart';
import 'service/g_share_impl.dart';

/// 공유 초기화 클래스
///
/// GInitializer를 상속하여 플러그인 초기화 시스템과 통합됩니다.
class GShareInitializer extends GInitializer
    implements GServiceInitializer<GShareService> {
  static final GShareInitializer _instance = GShareInitializer._internal();
  factory GShareInitializer() => _instance;
  GShareInitializer._internal();

  GShareService? _service;
  bool _isInitialized = false;

  @override
  String get name => 'share';

  @override
  Future<void> initialize() async {
    if (_isInitialized) return;

    await guardFuture<void>(() async {
      _service = GShareImpl();
      await _service!.initialize();
      _isInitialized = true;
    }, typeHandlers: {
      PlatformException: (e, s) {
        Logger.e('GShareInitializer initialize failed', error: e);
        throw e;
      },
    });
  }

  @override
  GShareService get service {
    if (!_isInitialized) {
      throw StateError(
          'GShareInitializer is not initialized. Call initialize() first.');
    }
    return _service!;
  }

  @override
  bool get isInitialized => _isInitialized;

  Future<void> dispose() async {
    if (_service != null) {
      await _service!.dispose();
      _service = null;
    }
    _isInitialized = false;
  }
}
