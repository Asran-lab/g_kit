// ignore_for_file: public_member_api_docs

/// STT 서비스 추상 인터페이스
///
/// 음성 인식의 핵심 기능들을 정의합니다.
abstract class GSttService {
  Future<void> initialize();
  Future<void> dispose();

  /// 현재 기기의 시스템 로케일을 기준으로 가장 적합한 로케일을 선택하여 리스닝을 시작
  Future<bool> listen({
    void Function(String recognizedWords, bool isFinal)? onResult,
    void Function(String status)? onStatus,
    void Function(Object error, StackTrace? stack)? onError,
    Duration? listenFor,
    bool partialResults = true,
    double pauseForSeconds = 3.0,
  });

  /// 수동 중지
  Future<void> stop();

  /// 세션 취소
  Future<void> cancel();

  /// 초기화 및 현재 디바이스에서 사용 가능한지 여부
  bool get isAvailable;

  /// 현재 리스닝 중인지 여부
  bool get isListening;

  /// 마지막으로 인식된 문장
  String get lastRecognizedText;

  /// 사용 가능한 로케일 목록
  Future<List<GSimpleLocale>> locales();

  /// 현재 사용 중인 로케일
  Future<GSimpleLocale?> currentLocale();
}

/// 단순 로케일 표현 (패키지 종속 최소화)
class GSimpleLocale {
  final String localeId; // e.g. en_US, ko_KR
  final String? name;

  const GSimpleLocale({required this.localeId, this.name});
}
