import '../g_app_link_initializer.dart';
import '../service/g_app_link_service.dart';

/// App Link 모듈의 Facade 클래스
///
/// 딥링크 기능을 쉽게 사용할 수 있도록 정적 메서드를 제공합니다.
///
/// ## 사용 예제
///
/// ```dart
/// // 기본 인스턴스 딥링크 콜백 설정
/// GAppLink.setCallbacks(
///   onDeepLink: (link) => print('딥링크: $link'),
///   onError: (error) => print('에러: $error'),
///   deepLinkTypes: {
///     'product': (path) => path.contains('product'),
///   },
/// );
///
/// // 특정 이름의 인스턴스 설정
/// GAppLink.setCallbacks(
///   name: 'shopping',
///   onDeepLink: (link) => print('쇼핑 딥링크: $link'),
///   deepLinkTypes: {
///     'cart': (path) => path.contains('cart'),
///   },
/// );
/// ```
///
/// 주의: 사용 전에 GPluginInitializer.initializeAll()을 통해 초기화해야 합니다.
class GAppLink {
  static final Map<String, GAppLinkInitializer> _initializers = {};
  static final String _defaultName = 'default';

  /// 특정 이름의 초기화자 가져오기
  static GAppLinkInitializer _getInitializer(String? name) {
    final key = name ?? _defaultName;
    if (!_initializers.containsKey(key)) {
      throw StateError(
          'Initializer for "$key" not found. Please register it first using setCallbacks()');
    }
    return _initializers[key]!;
  }

  /// 초기화 상태 확인
  static bool isInitialized([String? name]) =>
      _getInitializer(name).isInitialized;

  /// 딥링크 수신 상태 확인
  static bool isListening([String? name]) =>
      _getInitializer(name).service.isListening;

  /// 딥링크 콜백 설정
  ///
  /// [name] - 인스턴스 이름 (선택사항, 기본값: 'default')
  /// [onDeepLink] - 딥링크 수신 시 호출될 콜백 (선택사항)
  /// [onError] - 에러 발생 시 호출될 콜백 (선택사항)
  /// [deepLinkTypes] - 커스텀 딥링크 타입 정의 (선택사항)
  static Future<void> setCallbacks({
    String? name,
    DeepLinkCallback? onDeepLink,
    DeepLinkErrorCallback? onError,
    Map<String, DeepLinkTypeMatcher>? deepLinkTypes,
  }) async {
    final key = name ?? _defaultName;

    // 기존 초기화자가 있으면 먼저 정리
    if (_initializers.containsKey(key)) {
      await _initializers[key]!.dispose();
    }

    // 새로운 초기화자 생성 및 등록
    _initializers[key] = GAppLinkInitializer(
      onDeepLink: onDeepLink,
      onError: onError,
      deepLinkTypes: deepLinkTypes,
    );

    // 초기화 실행
    await _initializers[key]!.initialize();
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
  static Map<String, String> parseDeepLink(String link, [String? name]) {
    return _getInitializer(name).service.parseDeepLink(link);
  }

  /// 딥링크 유효성 검사
  ///
  /// 주어진 URL이 유효한 딥링크인지 확인합니다.
  static bool isValidDeepLink(String link, [String? name]) {
    return _getInitializer(name).service.isValidDeepLink(link);
  }

  /// 딥링크 타입 확인
  ///
  /// 딥링크의 타입을 반환합니다. 등록되지 않은 타입은 'unknown'을 반환합니다.
  static String getDeepLinkType(String link, [String? name]) {
    return _getInitializer(name).service.getDeepLinkType(link);
  }

  /// 특정 타입의 딥링크인지 확인
  ///
  /// 주어진 딥링크가 특정 타입인지 확인합니다.
  static bool isDeepLinkType(String link, String type, [String? name]) {
    return _getInitializer(name).service.isDeepLinkType(link, type);
  }

  /// 딥링크에서 ID 추출
  ///
  /// 딥링크의 경로나 쿼리 파라미터에서 ID를 추출합니다.
  ///
  /// ```dart
  /// final id = GAppLink.extractIdFromDeepLink('myapp://product/123');
  /// print(id); // '123'
  /// ```
  static String? extractIdFromDeepLink(String link, [String? name]) {
    return _getInitializer(name).service.extractIdFromDeepLink(link);
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
  static String? extractParameterFromDeepLink(String link, String parameter,
      [String? name]) {
    return _getInitializer(name)
        .service
        .extractParameterFromDeepLink(link, parameter);
  }

  /// 딥링크 타입 추가
  ///
  /// 런타임에 새로운 딥링크 타입을 추가합니다.
  ///
  /// ```dart
  /// GAppLink.addDeepLinkType('video', (path) => path.contains('video'));
  /// ```
  static void addDeepLinkType(String type, DeepLinkTypeMatcher matcher,
      [String? name]) {
    _getInitializer(name).service.addDeepLinkType(type, matcher);
  }

  /// 딥링크 타입 제거
  ///
  /// 등록된 딥링크 타입을 제거합니다.
  static void removeDeepLinkType(String type, [String? name]) {
    _getInitializer(name).service.removeDeepLinkType(type);
  }

  /// 등록된 딥링크 타입 목록
  ///
  /// 현재 등록된 모든 딥링크 타입을 반환합니다.
  static List<String> registeredDeepLinkTypes([String? name]) {
    return _getInitializer(name).service.registeredDeepLinkTypes;
  }

  /// 수동 딥링크 처리
  ///
  /// 수동으로 딥링크를 처리합니다.
  static void handleDeepLink(String link, [String? name]) {
    _getInitializer(name).service.handleDeepLink(link);
  }

  /// 딥링크 수신 일시정지
  ///
  /// 딥링크 수신을 일시적으로 중단합니다.
  static void pause([String? name]) {
    _getInitializer(name).service.pause();
  }

  /// 딥링크 수신 재개
  ///
  /// 일시정지된 딥링크 수신을 재개합니다.
  static void resume([String? name]) {
    _getInitializer(name).service.resume();
  }

  /// 서비스 정리
  ///
  /// 앱 종료 시 호출하여 리소스를 정리합니다.
  static Future<void> dispose([String? name]) async {
    if (name != null) {
      final initializer = _initializers[name];
      if (initializer != null) {
        await initializer.dispose();
        _initializers.remove(name);
      }
    } else {
      // 모든 인스턴스 정리
      for (final initializer in _initializers.values) {
        await initializer.dispose();
      }
      _initializers.clear();
    }
  }

  /// 딥링크 리스너 등록
  ///
  /// [onDeepLink] - 딥링크 수신 시 호출될 콜백
  /// [onError] - 에러 발생 시 호출될 콜백 (선택사항)
  /// [name] - 리스너 이름 (선택사항)
  /// [instanceName] - 인스턴스 이름 (선택사항)
  ///
  /// ```dart
  /// GAppLink.listen(
  ///   onDeepLink: (link) => print('딥링크: $link'),
  ///   onError: (error) => print('에러: $error'),
  ///   name: 'main',
  /// );
  /// ```
  static void listen({
    required DeepLinkCallback onDeepLink,
    DeepLinkErrorCallback? onError,
    String? name,
    String? instanceName,
  }) {
    _getInitializer(instanceName).service.listen(
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
    _getInitializer(instanceName).service.removeListener(name);
  }

  /// 등록된 리스너 목록 조회
  ///
  /// [instanceName] - 인스턴스 이름 (선택사항)
  static List<String> getRegisteredListeners([String? instanceName]) {
    return _getInitializer(instanceName).service.registeredListeners;
  }

  /// 서비스 재초기화
  ///
  /// 기존 서비스를 정리하고 새로운 설정으로 재초기화합니다.
  static Future<void> reinitialize({
    String? name,
    DeepLinkCallback? onDeepLink,
    DeepLinkErrorCallback? onError,
    Map<String, DeepLinkTypeMatcher>? deepLinkTypes,
  }) async {
    await setCallbacks(
      name: name,
      onDeepLink: onDeepLink,
      onError: onError,
      deepLinkTypes: deepLinkTypes,
    );
  }

  /// 등록된 모든 인스턴스 이름 목록
  ///
  /// 현재 등록된 모든 딥링크 인스턴스 이름을 반환합니다.
  static List<String> get registeredInstanceNames {
    return _initializers.keys.toList();
  }
}
