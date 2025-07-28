import 'dart:convert';

extension StringExtension on String {
  /// 소문자로 변환
  String get toLower => toLowerCase();

  /// 대문자로 변환
  String get toUpper => toUpperCase();

  /// 첫 글자 대문자로 변환
  String get capitalizeFirst =>
      trim().isEmpty ? '' : this[0].toUpperCase() + substring(1);

  /// 모든 단어의 첫 글자를 대문자로 변환
  String get capitalize =>
      trim().isEmpty ? '' : this[0].toUpperCase() + substring(1);

  /// 양쪽 공백 제거
  String get toTrim => trim();

  /// 왼쪽 공백 제거
  String get toTrimLeft => trimLeft();

  /// 오른쪽 공백 제거
  String get toTrimRight => trimRight();

  /// Base64 인코딩 / 디코딩
  /// ex) 'abc'.toBase64 => 'YWJj'
  String toBase64() => base64Encode(utf8.encode(this));

  /// Base64 디코딩
  /// ex) 'YWJj'.fromBase64 => 'abc'
  String fromBase64() => utf8.decode(base64Decode(this));

  /// 문자열 -> 숫자 안전 파싱
  /// ex) '123'.toInt(defaultValue: 0) => 123
  int toInt({int defaultValue = 0}) => int.tryParse(this) ?? defaultValue;

  double toDouble({double defaultValue = 0.0}) =>
      double.tryParse(this) ?? defaultValue;

  /// 문자열에서 숫자만 추출
  /// ex) 'abc123123'.onlyDigits => '123123'
  String get onlyDigits => replaceAll(RegExp(r'[^\d]'), '');

  /// 문자열에서 알파벳만 추출
  /// ex) 'abc123123'.onlyAlphabets => 'abc'
  String get onlyAlphabets => replaceAll(RegExp(r'[^A-Za-z]'), '');

  /// 이메일 형식인지 검증
  /// URL 형식인지 검증
  /// 전화번호 형식인지 검증
  /// 문자열을 bool로 파싱
  bool get toBool => toLower.trim() == 'true' || trim() == '1';

  /// 길이 제한 후 ...붙이기
  /// ex) '1234567890'.ellipsis(5) => '12345...'
  String ellipsis(int maxLength) {
    if (length <= maxLength) return this;
    return '${substring(0, maxLength)}...';
  }

  /// 문자열 중복 제거 (문자 순서 유지)
  String get removeDuplicates {
    final seen = <String>{};
    return split('').where((c) => seen.add(c)).join();
  }

  /// 자릿수 표시 (정수 단위로 파싱)
  /// ex) '1000'.withComma => '1,000'
  /// ex) '1000.123'.withComma => '1,000.123'
  String get withComma {
    final number = int.tryParse(onlyDigits);
    if (number == null) return this;
    return number.toString().replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (match) => '${match[1]},');
  }

  /// 퍼센트 표시
  /// ex) '1000'.asPercent => '1000%'
  String get asPercent {
    final number = int.tryParse(onlyDigits);
    if (number == null) return this;
    return '$number%';
  }

  /// 통화 심볼 표시
  /// ex) '1000'.withCurrency(symbol: '₩') => '₩1,000'
  String withCurrency({String symbol = '₩'}) => '$symbol$this';

  /// 나라별 통화
  /// ex) '1000'.toCurrency(locale: 'kr') => '₩1,000'
  String toCurrency({String locale = 'kr'}) {
    switch (locale) {
      case 'kr':
        return withCurrency(symbol: '₩');
      case 'us':
        return withCurrency(symbol: '\$');
      case 'jp':
        return withCurrency(symbol: '¥');
      case 'cn':
        return withCurrency(symbol: '￥');
      case 'de':
        return withCurrency(symbol: '€');
      case 'fr':
        return withCurrency(symbol: '€');
      default:
        return withCurrency(symbol: '\$');
    }
  }

  /// DateTime 형식으로 변환
  /// ex) '2021-01-01 12:00:00'.toDateTime => DateTime(2021, 1, 1, 12, 0, 0)
  DateTime? toDateTime({String separator = '-'}) {
    try {
      final parts = split(RegExp(r'[\sT:]'));
      if (parts.length < 3) return null;
      final y = int.tryParse(parts[0]) ?? 0;
      final m = int.tryParse(parts[1]) ?? 1;
      final d = int.tryParse(parts[2]) ?? 1;
      final h = parts.length > 3 ? int.tryParse(parts[3]) ?? 0 : 0;
      final min = parts.length > 4 ? int.tryParse(parts[4]) ?? 0 : 0;
      final s = parts.length > 5 ? int.tryParse(parts[5]) ?? 0 : 0;
      return DateTime(y, m, d, h, min, s);
    } catch (_) {
      return null;
    }
  }

  String? takeIf(bool Function(String) predicate) {
    return predicate(this) ? this : null;
  }
}
