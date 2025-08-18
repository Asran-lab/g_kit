import 'package:flutter/services.dart';
import 'package:g_common/utils/g_guard.dart' show guardFuture;
import 'package:g_common/utils/g_logger.dart' show Logger;
import 'package:g_model/initializer/g_initializer.dart';
import 'service/g_app_link_service.dart';
import 'service/g_app_link_impl.dart';
import 'facade/g_app_link.dart';

/// 앱 링크 초기화 클래스
///
/// GInitializer를 상속하여 플러그인 초기화 시스템과 통합됩니다.
/// 사용 예시
/// ```dart
/// final appLinkInitializer = GAppLinkInitializer(
///   onDeepLink: (link) {
///     print('딥링크 수신: $link');
///   },
///   onError: (error) {
///     print('딥링크 에러: $error');
///   },
/// );
/// ```
class GAppLinkInitializer extends GInitializer {
  GAppLinkService? _service;
  bool _isInitialized = false;
  final DeepLinkCallback? onDeepLink;
  final DeepLinkErrorCallback? onError;
  final Map<String, DeepLinkTypeMatcher>? deepLinkTypes;

  GAppLinkInitializer({
    this.onDeepLink,
    this.onError,
    this.deepLinkTypes,
  });

  @override
  String get name => 'app_link';

  @override
  Future<void> initialize() async {
    if (_isInitialized) return;

    await guardFuture<void>(() async {
      _service = GAppLinkImpl();

      await _service!.initialize(
        onDeepLink: onDeepLink ?? _defaultDeepLinkHandler,
        onError: onError ?? _defaultErrorHandler,
        deepLinkTypes: deepLinkTypes,
      );

      // Facade에 서비스 등록
      GAppLink.registerService(_service!);
      
      _isInitialized = true;
      Logger.d('🔗 GAppLinkInitializer 초기화 및 Facade 등록 완료');
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
      // Facade에서 서비스 해제
      GAppLink.unregisterService();
      
      await _service!.dispose();
      _service = null;
    }
    
    _isInitialized = false;
    Logger.d('🔗 GAppLinkInitializer 정리 완료');
  }
}
