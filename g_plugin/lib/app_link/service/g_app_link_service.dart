/// 딥링크 콜백 함수 타입 정의
typedef DeepLinkCallback = void Function(String link);
typedef DeepLinkErrorCallback = void Function(String error);
typedef DeepLinkTypeMatcher = bool Function(String path);

/// 앱 링크 서비스 추상 클래스
///
/// 딥링크 처리를 위한 기본 인터페이스를 정의합니다.
/// 구현체는 각 플랫폼별 특성에 맞게 구현해야 합니다.
abstract class GAppLinkService {
  /// 서비스 초기화
  /// 딥링크 리스닝을 시작합니다
  Future<void> initialize({
    required DeepLinkCallback onDeepLink,
    DeepLinkErrorCallback? onError,
    Map<String, DeepLinkTypeMatcher>? deepLinkTypes,
  });

  /// 서비스 정리
  /// 리소스를 해제하고 리스닝을 중단합니다
  Future<void> dispose();

  /// 초기화 상태 확인
  bool get isInitialized;

  /// 리스닝 상태 확인
  bool get isListening;

  /// 딥링크 스트림 일시정지
  void pause();

  /// 딥링크 스트림 재개
  void resume();

  /// 딥링크 파싱
  /// URL에서 필요한 정보를 추출합니다
  Map<String, String> parseDeepLink(String link);

  /// 딥링크 타입 확인
  /// 설정된 타입 매핑에 따라 딥링크 타입을 분류합니다
  String getDeepLinkType(String link);

  /// 딥링크 검증
  /// URL이 유효한 딥링크인지 확인합니다
  bool isValidDeepLink(String link);

  /// 특정 딥링크 타입 필터링
  /// 원하는 타입의 딥링크만 처리할 수 있습니다
  bool isDeepLinkType(String link, String type);

  /// 딥링크에서 ID 추출
  /// URL 경로에서 ID 값을 추출합니다
  String? extractIdFromDeepLink(String link);

  /// 딥링크에서 특정 파라미터 추출
  /// URL 쿼리 파라미터에서 특정 값을 추출합니다
  String? extractParameterFromDeepLink(String link, String parameter);

  /// 딥링크 타입 추가
  /// 런타임에 새로운 딥링크 타입을 추가할 수 있습니다
  void addDeepLinkType(String type, DeepLinkTypeMatcher matcher);

  /// 딥링크 타입 제거
  /// 특정 딥링크 타입을 제거할 수 있습니다
  void removeDeepLinkType(String type);

  /// 등록된 딥링크 타입 목록 조회
  List<String> get registeredDeepLinkTypes;

  /// 강제로 딥링크 처리
  /// 테스트나 수동 딥링크 처리를 위해 사용
  void handleDeepLink(String link);
}
