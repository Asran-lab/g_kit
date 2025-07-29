import 'dart:convert';

/// Storage에 저장되는 데이터 아이템
/// TTL(Time To Live) 기능을 지원합니다.
class GStorageItem {
  final String value;
  final DateTime? expirationTime;
  final DateTime createdAt;

  GStorageItem({
    required this.value,
    this.expirationTime,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  /// 데이터가 만료되었는지 확인
  bool get isExpired {
    if (expirationTime == null) return false;
    return DateTime.now().isAfter(expirationTime!);
  }

  /// 남은 TTL 시간 (초 단위)
  int? get remainingTtlSeconds {
    if (expirationTime == null) return null;
    final remaining = expirationTime!.difference(DateTime.now()).inSeconds;
    return remaining > 0 ? remaining : 0;
  }

  /// JSON으로 직렬화
  Map<String, dynamic> toJson() {
    return {
      'value': value,
      'expirationTime': expirationTime?.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
    };
  }

  /// JSON에서 역직렬화
  factory GStorageItem.fromJson(Map<String, dynamic> json) {
    return GStorageItem(
      value: json['value'] as String,
      expirationTime: json['expirationTime'] != null
          ? DateTime.parse(json['expirationTime'] as String)
          : null,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  /// 문자열로 직렬화 (Storage에 저장용)
  String toStorageString() {
    return jsonEncode(toJson());
  }

  /// 문자열에서 역직렬화
  factory GStorageItem.fromStorageString(String storageString) {
    final json = jsonDecode(storageString) as Map<String, dynamic>;
    return GStorageItem.fromJson(json);
  }

  /// 단순 값으로 생성 (TTL 없음)
  factory GStorageItem.simple(String value) {
    return GStorageItem(value: value);
  }

  /// TTL과 함께 생성
  factory GStorageItem.withTtl(String value, DateTime until) {
    return GStorageItem(value: value, expirationTime: until);
  }

  @override
  String toString() {
    return 'GStorageItem{value: $value, expirationTime: $expirationTime, createdAt: $createdAt}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is GStorageItem &&
        other.value == value &&
        other.expirationTime == expirationTime &&
        other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return value.hashCode ^ expirationTime.hashCode ^ createdAt.hashCode;
  }
}
