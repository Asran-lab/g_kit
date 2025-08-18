import 'package:g_common/g_common.dart';
import '../service/g_app_link_service.dart';

/// App Link 모듈의 Facade 클래스
///
/// 초기화된 서비스를 사용하여 딥링크 기능을 제공합니다.
///
/// ## 사용 예제
///
/// ```dart
/// // GAppLinkInitializer에서 서비스 등록 후 사용
/// final metadata = await GAppLink.extractLinkMetadata('https://github.com/ejayjeon');
/// ```
///
/// 주의: 사용 전에 GPluginInitializer.initializeAll()을 통해 초기화해야 합니다.
class GAppLink {
  static final Map<String, GAppLinkService> _services = {};
  static final String _defaultName = 'default';

  /// 특정 이름의 서비스 가져오기
  static GAppLinkService _getService(String? name) {
    final key = name ?? _defaultName;
    if (!_services.containsKey(key)) {
      throw StateError(
          'Service for "$key" not found. Please register it first using registerService()');
    }
    return _services[key]!;
  }

  /// 서비스 등록 (initializer에서 호출됨)
  static void registerService(GAppLinkService service, [String? name]) {
    final key = name ?? _defaultName;
    _services[key] = service;
    Logger.d('🔗 GAppLink: 서비스 "$key" 등록 완료');
  }

  /// 서비스 해제
  static void unregisterService([String? name]) {
    final key = name ?? _defaultName;
    _services.remove(key);
    Logger.d('🔗 GAppLink: 서비스 "$key" 해제 완료');
  }

  /// 초기화 상태 확인
  static bool isInitialized([String? name]) {
    final key = name ?? _defaultName;
    return _services.containsKey(key) && _services[key]!.isInitialized;
  }

  /// 딥링크 수신 상태 확인
  static bool isListening([String? name]) =>
      _getService(name).isListening;

  /// 딥링크 파싱
  ///
  /// URL을 파싱하여 scheme, host, path, query parameters를 반환합니다.
  static Map<String, String> parseDeepLink(String link, [String? name]) {
    return _getService(name).parseDeepLink(link);
  }

  /// 딥링크 유효성 검사
  ///
  /// 주어진 URL이 유효한 딥링크인지 확인합니다.
  static bool isValidDeepLink(String link, [String? name]) {
    return _getService(name).isValidDeepLink(link);
  }

  /// 딥링크 타입 확인
  ///
  /// 딥링크의 타입을 반환합니다. 등록되지 않은 타입은 'unknown'을 반환합니다.
  static String getDeepLinkType(String link, [String? name]) {
    return _getService(name).getDeepLinkType(link);
  }

  /// 특정 타입의 딥링크인지 확인
  ///
  /// 주어진 딥링크가 특정 타입인지 확인합니다.
  static bool isDeepLinkType(String link, String type, [String? name]) {
    return _getService(name).isDeepLinkType(link, type);
  }

  /// 딥링크에서 ID 추출
  ///
  /// 딥링크의 경로나 쿼리 파라미터에서 ID를 추출합니다.
  static String? extractIdFromDeepLink(String link, [String? name]) {
    return _getService(name).extractIdFromDeepLink(link);
  }

  /// 딥링크에서 특정 파라미터 추출
  ///
  /// 딥링크의 쿼리 파라미터에서 특정 값을 추출합니다.
  static String? extractParameterFromDeepLink(String link, String parameter,
      [String? name]) {
    return _getService(name).extractParameterFromDeepLink(link, parameter);
  }

  /// 딥링크 타입 추가
  ///
  /// 런타임에 새로운 딥링크 타입을 추가합니다.
  static void addDeepLinkType(String type, DeepLinkTypeMatcher matcher,
      [String? name]) {
    _getService(name).addDeepLinkType(type, matcher);
  }

  /// 딥링크 타입 제거
  ///
  /// 등록된 딥링크 타입을 제거합니다.
  static void removeDeepLinkType(String type, [String? name]) {
    _getService(name).removeDeepLinkType(type);
  }

  /// 등록된 딥링크 타입 목록
  ///
  /// 현재 등록된 모든 딥링크 타입을 반환합니다.
  static List<String> registeredDeepLinkTypes([String? name]) {
    return _getService(name).registeredDeepLinkTypes;
  }

  /// 수동 딥링크 처리
  ///
  /// 수동으로 딥링크를 처리합니다.
  static void handleDeepLink(String link, [String? name]) {
    _getService(name).handleDeepLink(link);
  }

  /// 딥링크 수신 일시정지
  ///
  /// 딥링크 수신을 일시적으로 중단합니다.
  static void pause([String? name]) {
    _getService(name).pause();
  }

  /// 딥링크 수신 재개
  ///
  /// 일시정지된 딥링크 수신을 재개합니다.
  static void resume([String? name]) {
    _getService(name).resume();
  }

  /// 딥링크 리스너 등록
  ///
  /// [onDeepLink] - 딥링크 수신 시 호출될 콜백
  /// [onError] - 에러 발생 시 호출될 콜백 (선택사항)
  /// [name] - 리스너 이름 (선택사항)
  /// [instanceName] - 인스턴스 이름 (선택사항)
  static void listen({
    required DeepLinkCallback onDeepLink,
    DeepLinkErrorCallback? onError,
    String? name,
    String? instanceName,
  }) {
    _getService(instanceName).listen(
      onDeepLink: onDeepLink,
      onError: onError,
      name: name,
    );
  }

  /// 딥링크 리스너 제거
  ///
  /// [name] - 제거할 리스너 이름 (null이면 모든 리스너 제거)
  /// [instanceName] - 인스턴스 이름 (선택사항)
  static void removeListener([String? name, String? instanceName]) {
    _getService(instanceName).removeListener(name);
  }

  /// 등록된 리스너 목록 조회
  ///
  /// [instanceName] - 인스턴스 이름 (선택사항)
  static List<String> getRegisteredListeners([String? instanceName]) {
    return _getService(instanceName).registeredListeners;
  }

  /// 등록된 모든 인스턴스 이름 목록
  ///
  /// 현재 등록된 모든 딥링크 인스턴스 이름을 반환합니다.
  static List<String> get registeredInstanceNames {
    return _services.keys.toList();
  }

  // === 링크 프리뷰 관련 API ===

  /// 링크 메타데이터 추출
  ///
  /// URL을 분석하여 제목, 설명, 이미지 등의 메타데이터를 추출합니다.
  static Future<LinkPreviewData?> extractLinkMetadata(String url, [String? name]) {
    try {
      Logger.d('🔗 GAppLink: extractLinkMetadata 호출 - $url');
      final service = _getService(name);
      Logger.d('🔗 GAppLink: 서비스 상태 - ${service.isInitialized}');
      return service.extractLinkMetadata(url);
    } catch (e) {
      Logger.e('🔗 GAppLink: extractLinkMetadata 에러 - $e');
      rethrow;
    }
  }

  /// 링크 프리뷰 캐시 클리어
  ///
  /// 메모리에 저장된 모든 링크 프리뷰 캐시를 삭제합니다.
  static void clearLinkPreviewCache([String? name]) {
    _getService(name).clearLinkPreviewCache();
  }

  /// 특정 URL의 링크 프리뷰 캐시 제거
  ///
  /// 지정된 URL의 캐시만 제거합니다.
  static void removeLinkPreviewCache(String url, [String? name]) {
    _getService(name).removeLinkPreviewCache(url);
  }

  /// 링크 프리뷰 캐시 크기 조회
  ///
  /// 현재 메모리에 저장된 캐시 개수를 반환합니다.
  static int getLinkPreviewCacheSize([String? name]) {
    return _getService(name).linkPreviewCacheSize;
  }
}