import '../g_app_link_initializer.dart';
import '../service/g_app_link_service.dart';

/// App Link 모듈의 Facade 클래스
///
/// 딥링크 기능을 쉽게 사용할 수 있도록 정적 메서드를 제공합니다.
///
/// ## 사용 예제
///
/// ```dart
/// // 기본 초기화
/// await GAppLink.initialize();
///
/// // 콜백과 함께 초기화
/// await GAppLink.initialize(
///   onDeepLink: (link) => print('딥링크: $link'),
///   onError: (error) => print('에러: $error'),
///   deepLinkTypes: {
///     'product': (path) => path.contains('product'),
///   },
/// );
/// ```
class GAppLink {
  static final GAppLinkInitializer _initializer = GAppLinkInitializer();

  /// 초기화 상태 확인
  static bool get isInitialized => _initializer.isInitialized;

  /// 딥링크 수신 상태 확인
  static bool get isListening => _initializer.service.isListening;

  /// App Link 초기화
  ///
  /// [onDeepLink] - 딥링크 수신 시 호출될 콜백 (선택사항)
  /// [onError] - 에러 발생 시 호출될 콜백 (선택사항)
  /// [deepLinkTypes] - 커스텀 딥링크 타입 정의 (선택사항)
  static Future<void> initialize({
    DeepLinkCallback? onDeepLink,
    DeepLinkErrorCallback? onError,
    Map<String, DeepLinkTypeMatcher>? deepLinkTypes,
  }) async {
    _initializer.onDeepLink = onDeepLink;
    _initializer.onError = onError;
    _initializer.deepLinkTypes = deepLinkTypes;
    await _initializer.initialize();
  }

  /// 딥링크 파싱
  ///
  /// URL을 파싱하여 scheme, host, path, query parameters를 반환합니다.
  ///
  /// ```dart
  /// final result = GAppLink.parseDeepLink('myapp://product/123?color=red');
  /// print(result['scheme']); // 'myapp'
  /// print(result['host']); // 'product'
  /// print(result['path']); // '/123'
  /// print(result['color']); // 'red'
  /// ```
  static Map<String, String> parseDeepLink(String link) {
    return _initializer.service.parseDeepLink(link);
  }

  /// 딥링크 유효성 검사
  ///
  /// 주어진 URL이 유효한 딥링크인지 확인합니다.
  static bool isValidDeepLink(String link) {
    return _initializer.service.isValidDeepLink(link);
  }

  /// 딥링크 타입 확인
  ///
  /// 딥링크의 타입을 반환합니다. 등록되지 않은 타입은 'unknown'을 반환합니다.
  static String getDeepLinkType(String link) {
    return _initializer.service.getDeepLinkType(link);
  }

  /// 특정 타입의 딥링크인지 확인
  ///
  /// 주어진 딥링크가 특정 타입인지 확인합니다.
  static bool isDeepLinkType(String link, String type) {
    return _initializer.service.isDeepLinkType(link, type);
  }

  /// 딥링크에서 ID 추출
  ///
  /// 딥링크의 경로나 쿼리 파라미터에서 ID를 추출합니다.
  ///
  /// ```dart
  /// final id = GAppLink.extractIdFromDeepLink('myapp://product/123');
  /// print(id); // '123'
  /// ```
  static String? extractIdFromDeepLink(String link) {
    return _initializer.service.extractIdFromDeepLink(link);
  }

  /// 딥링크에서 특정 파라미터 추출
  ///
  /// 딥링크의 쿼리 파라미터에서 특정 값을 추출합니다.
  ///
  /// ```dart
  /// final color = GAppLink.extractParameterFromDeepLink(
  ///   'myapp://product/123?color=red&size=large',
  ///   'color'
  /// );
  /// print(color); // 'red'
  /// ```
  static String? extractParameterFromDeepLink(String link, String parameter) {
    return _initializer.service.extractParameterFromDeepLink(link, parameter);
  }

  /// 딥링크 타입 추가
  ///
  /// 런타임에 새로운 딥링크 타입을 추가합니다.
  ///
  /// ```dart
  /// GAppLink.addDeepLinkType('video', (path) => path.contains('video'));
  /// ```
  static void addDeepLinkType(String type, DeepLinkTypeMatcher matcher) {
    _initializer.service.addDeepLinkType(type, matcher);
  }

  /// 딥링크 타입 제거
  ///
  /// 등록된 딥링크 타입을 제거합니다.
  static void removeDeepLinkType(String type) {
    _initializer.service.removeDeepLinkType(type);
  }

  /// 등록된 딥링크 타입 목록
  ///
  /// 현재 등록된 모든 딥링크 타입을 반환합니다.
  static List<String> get registeredDeepLinkTypes {
    return _initializer.service.registeredDeepLinkTypes;
  }

  /// 수동 딥링크 처리
  ///
  /// 수동으로 딥링크를 처리합니다.
  static void handleDeepLink(String link) {
    _initializer.service.handleDeepLink(link);
  }

  /// 딥링크 수신 일시정지
  ///
  /// 딥링크 수신을 일시적으로 중단합니다.
  static void pause() {
    _initializer.service.pause();
  }

  /// 딥링크 수신 재개
  ///
  /// 일시정지된 딥링크 수신을 재개합니다.
  static void resume() {
    _initializer.service.resume();
  }

  /// 서비스 정리
  ///
  /// 앱 종료 시 호출하여 리소스를 정리합니다.
  static Future<void> dispose() async {
    await _initializer.dispose();
  }

  /// 서비스 재초기화
  ///
  /// 기존 서비스를 정리하고 새로운 설정으로 재초기화합니다.
  static Future<void> reinitialize({
    DeepLinkCallback? onDeepLink,
    DeepLinkErrorCallback? onError,
    Map<String, DeepLinkTypeMatcher>? deepLinkTypes,
  }) async {
    await _initializer.reinitialize(
      onDeepLink: onDeepLink,
      onError: onError,
      deepLinkTypes: deepLinkTypes,
    );
  }
}
