abstract class GInitializer {
  String get name;

  /// 기본 초기화 메서드
  Future<void> initialize();

  /// 콜백과 함께 초기화하는 메서드 (선택적)
  Future<void> initializeWithCallbacks({
    Map<String, dynamic>? callbacks,
    Map<String, dynamic>? options,
  }) async {
    // 기본 구현: 일반 initialize 호출
    await initialize();
  }
}
