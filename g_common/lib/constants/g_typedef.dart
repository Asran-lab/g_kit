import 'dart:ui';

typedef ValueCallback<T> = void Function(T? value);
typedef VoidCallback = void Function();
typedef ErrorCallback = void Function(Object error, StackTrace stack);
typedef GJsonConverter<T> = T Function(Object? json);
typedef GExceptionHandler<T extends Object> = void Function(
    T error, StackTrace trace);
typedef GAppLifecycleCallback = void Function(AppLifecycleState state);
typedef RecoverHandler<T> = T Function(Object error, StackTrace stackTrace);
typedef ShouldRethrow = bool Function(Object error);

/* 비동기 함수 타입 */
typedef AsyncVoidCallback = Future<void> Function();
typedef AsyncValueCallback<T> = Future<void> Function(T? value);

/* Object Type */
typedef GJson = Map<String, dynamic>;
typedef GList = List<dynamic>;
typedef GenericGJson<T, R> = Map<T, R>;
typedef GenericList<T> = List<T>;

/* Validation, Filtering */
typedef Validator<T> = String? Function(T value);
typedef Predicate<T> = bool Function(T value);
typedef Comparator<T> = int Function(T a, T b);

/* runtimeType.toString()과 비교 */
const String runtimeTypeGJson = "_Map<String, dynamic>";
const String runtimeTypeGList = "_List<dynamic>";
