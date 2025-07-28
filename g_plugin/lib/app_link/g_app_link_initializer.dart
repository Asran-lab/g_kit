import 'package:flutter/services.dart';
import 'package:g_common/utils/g_guard.dart' show guardFuture;
import 'package:g_common/utils/g_logger.dart' show Logger;
import 'package:g_model/initializer/g_initializer.dart';
import 'service/g_app_link_service.dart';
import 'service/g_app_link_impl.dart';

/// 앱 링크 초기화 클래스
///
/// GInitializer를 상속하여 플러그인 초기화 시스템과 통합됩니다.
class GAppLinkInitializer extends GInitializer {
  static final GAppLinkInitializer _instance = GAppLinkInitializer._internal();
  factory GAppLinkInitializer() => _instance;
  GAppLinkInitializer._internal();

  GAppLinkService? _service;
  bool _isInitialized = false;
  DeepLinkCallback? onDeepLink;
  DeepLinkErrorCallback? onError;
  Map<String, DeepLinkTypeMatcher>? deepLinkTypes;

  @override
  String get name => 'app_link';

  @override
  Future<void> initialize() async {
    if (_isInitialized) return;

    await guardFuture<void>(() async {
      _service = GAppLinkImpl();
      onDeepLink = onDeepLink;
      onError = onError;
      deepLinkTypes = deepLinkTypes;

      await _service!.initialize(
        onDeepLink: onDeepLink ?? _defaultDeepLinkHandler,
        onError: onError ?? _defaultErrorHandler,
        deepLinkTypes: deepLinkTypes,
      );

      _isInitialized = true;
    }, typeHandlers: {
      PlatformException: (e, s) {
        Logger.e('GAppLinkInitializer initialize failed', error: e);
        throw e;
      },
    });
  }

  void _defaultDeepLinkHandler(String link) {
    Logger.d('GAppLink: 딥링크 수신 - $link');
  }

  void _defaultErrorHandler(String error) {
    Logger.e('GAppLink: 에러 발생 - $error');
  }

  GAppLinkService get service {
    if (!_isInitialized) {
      throw StateError(
          'GAppLinkInitializer is not initialized. Call initialize() first.');
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
    onDeepLink = null;
    onError = null;
    deepLinkTypes = null;
  }

  Future<void> reinitialize({
    DeepLinkCallback? onDeepLink,
    DeepLinkErrorCallback? onError,
    Map<String, DeepLinkTypeMatcher>? deepLinkTypes,
  }) async {
    await dispose();
    this.onDeepLink = onDeepLink;
    this.onError = onError;
    this.deepLinkTypes = deepLinkTypes;
    await initialize();
  }
}
