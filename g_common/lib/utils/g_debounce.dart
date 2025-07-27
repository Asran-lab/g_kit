import 'dart:async';

/// 디바운스 함수 - 콜백을 바로 받아서 사용
///
/// 사용법:
/// ```dart
/// // 매개변수 없는 콜백
/// final debouncedPrint = debounce(() {
///   print('API 호출');
/// });
///
/// // 매개변수가 있는 콜백
/// final debouncedSearch = debounce((String value) {
///   print('API 호출: $value');
/// });
///
/// TextField(
///   onChanged: (value) {
///     debouncedSearch(value);
///   },
/// );
/// ```
Function([T? value]) debounce<T>(
  void Function([T? value]) callback, {
  Duration duration = const Duration(milliseconds: 1000),
}) {
  Timer? debounceTimer;
  T? lastValue;

  return ([T? value]) {
    lastValue = value;
    debounceTimer?.cancel();
    debounceTimer = Timer(duration, () => callback(lastValue));
  };
}
