import 'dart:async';

// 전역 잠금 맵
final Map<String, Future<void>> _locks = {};

/// 비동기 작업을 잠그고 순차 처리하는 함수
///
/// 사용법:
/// ```dart
/// // 특정 키로 잠금
/// await lock('user_update', () async {
///   await updateUser(userId);
///   await updateFile(userId);
/// });
///
/// // 전역 잠금
/// await globalLock(() async {
///   await criticalOperation();
/// });
/// ```
Future<T> lock<T>(
  String key,
  Future<T> Function() task,
) async {
  final previous = _locks[key] ?? Future.value();
  final completer = Completer<void>();
  _locks[key] = completer.future;

  try {
    await previous; // 이전 작업이 끝날 때까지 대기
    return await task();
  } finally {
    // 다음 작업을 위해 잠금 해제
    if (_locks[key] == completer.future) {
      _locks.remove(key);
    }
    completer.complete();
  }
}

/// 단일 전역 잠금 함수
///
/// 사용법:
/// ```dart
/// await globalLock(() async {
///   await criticalOperation();
/// });
/// ```
Future<T> globalLock<T>(Future<T> Function() task) => lock('_global_', task);

/// 특정 키가 잠겨있는지 확인하는 함수
///
/// 사용법:
/// ```dart
/// if (isLocked('user_update')) {
///   print('사용자 업데이트 중...');
/// }
/// ```
bool isLocked(String key) => _locks.containsKey(key);

/// 특정 키의 잠금을 해제하는 함수
///
/// 사용법:
/// ```dart
/// unlock('user_update');
/// ```
Future<void>? unlock(String key) => _locks.remove(key);

/// 모든 잠금을 해제하는 함수
///
/// 사용법:
/// ```dart
/// clearAllLocks();
/// ```
void clearAllLocks() => _locks.clear();
