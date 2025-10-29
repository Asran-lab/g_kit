import 'package:g_core/storage/common/g_storage_type.dart' show GStorageType;
import 'package:g_core/storage/context/g_storage_context.dart';
import 'package:g_core/storage/g_storage_initializer.dart';
import 'package:g_model/g_model.dart';

/// Storage Facade 클래스
///
/// GContextFacade를 상속하여 표준화된 패턴을 따릅니다.
class GStorage extends GContextFacade<GStorageContext, GStorageInitializer> {
  GStorage._() : super(GStorageInitializer());
  static final GStorage _instance = GStorage._();

  /// 읽기
  static Future<dynamic> get({
    required String key,
    bool isSecure = false,
  }) async {
    return _instance.context.get(
      key: key,
      type: GStorageType.fromBool(isSecure),
    );
  }

  /// 쓰기
  static Future<void> set({
    required String key,
    required dynamic value,
    DateTime? until,
    bool isSecure = false,
  }) async {
    if (key.isEmpty) {
      throw ArgumentError('Key cannot be empty');
    }

    return _instance.context.set(
      key: key,
      value: value,
      until: until,
      type: GStorageType.fromBool(isSecure),
    );
  }

  /// 삭제
  static Future<void> delete({
    required String key,
    bool isSecure = false,
  }) async {
    return _instance.context.delete(
      key: key,
      type: GStorageType.fromBool(isSecure),
    );
  }

  /// 삭제
  static Future<void> clear({
    required String key,
    bool isSecure = false,
  }) async {
    return _instance.context.clear(
      key: key,
      type: GStorageType.fromBool(isSecure),
    );
  }

  /// 모두 삭제
  static Future<void> clearAll({
    bool isSecure = false,
  }) async {
    return _instance.context.clearAll(
      type: GStorageType.fromBool(isSecure),
    );
  }

  /// 키 조회
  static Future<List<String>?> getKeys({
    bool isSecure = false,
  }) async {
    return _instance.context.getKeys(
      type: GStorageType.fromBool(isSecure),
    );
  }

  /// 만료된 데이터 정리
  static Future<void> cleanupExpired({
    bool? isSecure,
  }) async {
    if (isSecure != null) {
      return _instance.context.cleanupExpired(
        type: GStorageType.fromBool(isSecure),
      );
    } else {
      // 모든 타입에서 만료된 데이터 정리
      return _instance.context.cleanupExpired();
    }
  }

  /// 특정 키의 만료 시간 확인
  static Future<DateTime?> getExpiration({
    required String key,
    bool isSecure = false,
  }) async {
    return _instance.context.getExpiration(
      key: key,
      type: GStorageType.fromBool(isSecure),
    );
  }

  /// TTL과 함께 데이터 저장
  static Future<void> setWithTtl({
    required String key,
    required String value,
    required Duration ttl,
    bool isSecure = false,
  }) async {
    final until = DateTime.now().add(ttl);
    return set(key: key, value: value, until: until, isSecure: isSecure);
  }

  /// 남은 TTL 시간 확인
  static Future<int?> getRemainingTtl({
    required String key,
    bool isSecure = false,
  }) async {
    final expiration = await getExpiration(key: key, isSecure: isSecure);
    if (expiration == null) return null;

    final remaining = expiration.difference(DateTime.now()).inSeconds;
    return remaining > 0 ? remaining : 0;
  }
}
