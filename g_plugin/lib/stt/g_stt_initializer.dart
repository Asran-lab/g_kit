import 'package:flutter/services.dart';
import 'package:g_common/utils/g_guard.dart' show guardFuture;
import 'package:g_common/utils/g_logger.dart' show Logger;
import 'package:g_model/initializer/g_initializer.dart';
import 'service/g_stt_service.dart';
import 'service/g_stt_impl.dart';

class GSttInitializer extends GInitializer {
  static final GSttInitializer _instance = GSttInitializer._internal();
  factory GSttInitializer() => _instance;
  GSttInitializer._internal();

  GSttService? _service;
  bool _isInitialized = false;

  @override
  String get name => 'stt';

  @override
  Future<void> initialize() async {
    if (_isInitialized) return;

    await guardFuture<void>(() async {
      _service = GSttImpl();
      await _service!.initialize();
      _isInitialized = true;
      Logger.d('GSttInitializer initialized successfully');
    }, typeHandlers: {
      PlatformException: (e, s) {
        Logger.e('GSttInitializer initialize failed', error: e);
        throw e;
      },
    });
  }

  GSttService get service {
    if (!_isInitialized) {
      throw StateError(
          'GSttInitializer is not initialized. Call initialize() first.');
    }
    return _service!;
  }

  bool get isInitialized => _isInitialized;

  Future<void> dispose() async {
    if (_service != null) {
      await _service!.dispose();
      _service = null;
    }
    _isInitialized = false;
  }
}
