/// 딥링크 콜백 함수 타입 정의
typedef DeepLinkCallback = void Function(String link);
typedef DeepLinkErrorCallback = void Function(String error);
typedef DeepLinkTypeMatcher = bool Function(String path);

/// 링크 프리뷰 메타데이터 모델
class LinkPreviewData {
  final String url;
  final String? title;
  final String? description;
  final String? imageUrl;
  final String? siteName;
  final String? favicon;

  const LinkPreviewData({
    required this.url,
    this.title,
    this.description,
    this.imageUrl,
    this.siteName,
    this.favicon,
  });

  Map<String, dynamic> toJson() => {
    'url': url,
    'title': title,
    'description': description,
    'imageUrl': imageUrl,
    'siteName': siteName,
    'favicon': favicon,
  };

  factory LinkPreviewData.fromJson(Map<String, dynamic> json) => LinkPreviewData(
    url: json['url'] ?? '',
    title: json['title'],
    description: json['description'],
    imageUrl: json['imageUrl'],
    siteName: json['siteName'],
    favicon: json['favicon'],
  );
}

/// 앱 링크 서비스 추상 클래스
///
/// 딥링크 처리를 위한 기본 인터페이스를 정의합니다.
/// 구현체는 각 플랫폼별 특성에 맞게 구현해야 합니다.
abstract class GAppLinkService {
  /// 딥링크 리스너 등록
  ///
  /// [onDeepLink] - 딥링크 수신 시 호출될 콜백
  /// [onError] - 에러 발생 시 호출될 콜백 (선택사항)
  /// [name] - 리스너 이름 (선택사항)
  ///
  /// ```dart
  /// service.listen(
  ///   onDeepLink: (link) => print('딥링크: $link'),
  ///   onError: (error) => print('에러: $error'),
  ///   name: 'main',
  /// );
  /// ```
  void listen({
    required DeepLinkCallback onDeepLink,
    DeepLinkErrorCallback? onError,
    String? name,
  });

  /// 딥링크 리스너 제거
  ///
  /// [name] - 제거할 리스너 이름 (null이면 모든 리스너 제거)
  void removeListener([String? name]);

  /// 등록된 리스너 목록 조회
  List<String> get registeredListeners;

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

  // === 링크 프리뷰 관련 메서드 ===

  /// 링크에서 메타데이터 추출
  /// URL을 분석하여 제목, 설명, 이미지 등의 메타데이터를 추출합니다
  Future<LinkPreviewData?> extractLinkMetadata(String url);

  /// 링크 프리뷰 캐시 클리어
  /// 메모리에 저장된 링크 프리뷰 캐시를 모두 삭제합니다
  void clearLinkPreviewCache();

  /// 특정 URL의 캐시 제거
  /// 지정된 URL의 캐시만 제거합니다
  void removeLinkPreviewCache(String url);

  /// 링크 프리뷰 캐시 크기 조회
  /// 현재 메모리에 저장된 캐시 개수를 반환합니다
  int get linkPreviewCacheSize;
}
