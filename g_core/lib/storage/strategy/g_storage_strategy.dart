abstract class GStorageStrategy {
  /// 초기화
  Future<void> initialize();

  /// 초기화 상태 확인
  bool get isInitialized;

  /// 키에 대한 값 조회
  Future<dynamic> get({required String key});

  /// 키에 대한 값 설정
  Future<void> set(
      {required String key, required String value, DateTime? until});

  /// 키에 대한 값 삭제
  Future<void> delete({required String key});

  /// 키에 대한 값 삭제
  Future<void> clear({required String key});

  /// 모든 키에 대한 값 삭제
  Future<void> clearAll();

  /// 모든 키 조회
  Future<List<String>?> getKeys();

  /// 만료된 데이터 정리
  Future<void> cleanupExpired();

  /// 특정 키의 만료 시간 확인
  Future<DateTime?> getExpiration({required String key});
}
