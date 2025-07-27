import '../constants/g_typedef.dart';
import 'g_logger.dart';

/// 비동기 try - catch 처리
/// /// 사용 예:
/// ```dart
///  await guardFuture(() async {
///   return await doSomething();
/// }, typeHandlers: {
///   FirebaseAuthException: (e, s) {}
///   PlatformException: (e, s) {}
///   ... 여러가지 Exception 처리
/// },
///
/// );
Future<T> guardFuture<T>(
  Future<T> Function() task, {
  Map<Type, GExceptionHandler>? typeHandlers,
  void Function(Object error, StackTrace stackTrace)? onError,
  void Function()? finallyBlock, // ✅ 추가
}) async {
  try {
    return await task();
  } catch (e, stackTrace) {
    Logger.e(e, stackTrace: stackTrace);
    final matched = typeHandlers?.entries.firstWhere(
      (entry) =>
          e.runtimeType == entry.key ||
          e.runtimeType.toString() == entry.key.toString(),
      orElse: () => MapEntry(e.runtimeType, (e, s) {}),
    );

    if (matched != null) {
      matched.value(e, stackTrace);
    } else {
      Logger.e(e, stackTrace: stackTrace);
      onError?.call(e, stackTrace);
    }

    return null as T;
  } finally {
    finallyBlock?.call();
  }
}

/// 동기 try - catch 처리
T? guard<T>(
  T Function() task, {
  Map<Type, GExceptionHandler>? typeHandlers,
  void Function(Object error, StackTrace stackTrace)? onError,
  void Function()? finallyBlock, // ✅ 추가
}) {
  try {
    return task();
  } catch (e, stackTrace) {
    Logger.e(e, stackTrace: stackTrace);
    final matched = typeHandlers?.entries.firstWhere(
      (entry) =>
          e.runtimeType == entry.key ||
          e.runtimeType.toString() == entry.key.toString(),
      orElse: () => MapEntry(e.runtimeType, (e, s) {}),
    );

    if (matched != null) {
      matched.value(e, stackTrace);
    } else {
      Logger.e(e, stackTrace: stackTrace);
      onError?.call(e, stackTrace);
    }

    return null as T;
  } finally {
    finallyBlock?.call();
  }
}
