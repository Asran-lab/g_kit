import '../g_stt_initializer.dart';
import '../service/g_stt_service.dart';

/// STT 모듈 Facade
///
/// 사용 전 `GPluginInitializer([... GSttInitializer() ...]).initializeAll()` 호출 필요
class GStt {
  static final GSttInitializer _initializer = GSttInitializer();

  static Future<void> dispose() async => await _initializer.dispose();

  /// 리스닝 시작 (시스템 로케일 기준)
  /// 사용예시
  /// ```dart
  /// final ok = await GStt.listen(
  ///   onResult: (text, isFinal) {
  ///     Logger.d('🔥 인식 결과: $text, 최종: $isFinal');
  ///   },
  ///   onStatus: (status) {
  ///     Logger.d('🔥 상태: $status');
  ///   },
  ///   onError: (error, stack) {
  ///     Logger.e('🔥 오류: $error', stackTrace: stack);
  ///   },
  ///   listenFor: Duration(seconds: 10),
  ///   partialResults: true,
  ///   pauseForSeconds: 3.0,
  ///   localeId: 'ko-KR',
  /// );
  static Future<bool> listen({
    void Function(String recognizedWords, bool isFinal)? onResult,
    void Function(String status)? onStatus,
    void Function(Object error, StackTrace? stack)? onError,
    Duration? listenFor,
    bool partialResults = true,
    double pauseForSeconds = 3.0,
  }) async {
    return await _initializer.service.listen(
      onResult: onResult,
      onStatus: onStatus,
      onError: onError,
      listenFor: listenFor,
      partialResults: partialResults,
      pauseForSeconds: pauseForSeconds,
    );
  }

  /// 수동 중지
  static Future<void> stop() async => await _initializer.service.stop();

  /// 세션 취소
  static Future<void> cancel() async => await _initializer.service.cancel();

  /// 현재 사용 가능 여부
  static bool get isAvailable => _initializer.service.isAvailable;

  /// 현재 리스닝 여부
  static bool get isListening => _initializer.service.isListening;

  /// 마지막 인식 텍스트
  static String get lastRecognizedText =>
      _initializer.service.lastRecognizedText;

  /// 로케일 목록
  static Future<List<GSimpleLocale>> locales() async =>
      await _initializer.service.locales();

  /// 현재 로케일
  static Future<GSimpleLocale?> currentLocale() async =>
      await _initializer.service.currentLocale();
}
