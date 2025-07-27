import 'dart:async';

/// 쓰로틀 함수 - 콜백을 바로 받아서 사용
///
/// 사용법:
/// ```dart
/// // 매개변수 없는 콜백
/// final throttledPrint = throttle(() {
///   print('API 호출');
/// });
///
/// // 매개변수가 있는 콜백
/// final throttledSearch = throttle((String value) {
///   print('API 호출: $value');
/// });
///
/// TextField(
///   onChanged: (value) {
///     throttledSearch(value);
///   },
/// );
/// ```
Function([T? value]) throttle<T>(
  void Function([T? value]) callback, {
  Duration duration = const Duration(milliseconds: 1000),
}) {
  Timer? throttleTimer;
  T? lastValue;
  bool isThrottled = false;

  return ([T? value]) {
    lastValue = value;

    if (isThrottled) {
      return; // 쓰로틀링 중이면 무시
    }

    isThrottled = true;
    callback(lastValue);

    throttleTimer?.cancel();
    throttleTimer = Timer(duration, () {
      isThrottled = false;
    });
  };
}
