import 'package:g_common/utils/g_guard.dart' show guardFuture;
import 'package:g_core/storage/storage.dart';
import 'package:g_lib/g_lib_storage.dart';

class GSecureStorageStrategy extends GStorageStrategy {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  @override
  Future<void> initialize() async {
    await guardFuture<void>(() async {
      // 초기화 시 만료된 데이터 정리
      await cleanupExpired();
    });
  }

  @override
  Future<dynamic> get({required String key}) async {
    return await guardFuture<String?>(() async {
      final storageString = await _storage.read(key: key);
      if (storageString == null) return null;
      try {
        final item = GStorageItem.fromStorageString(storageString);

        // 만료 확인
        if (item.isExpired) {
          await delete(key: key);
          return null;
        }

        return item.value;
      } catch (e) {
        // 기존 단순 문자열 데이터 처리 (하위 호환성)
        return storageString;
      }
    });
  }

  @override
  Future<void> set({
    required String key,
    required String value,
    DateTime? until,
  }) async {
    await guardFuture<void>(() async {
      final item = until != null
          ? GStorageItem.withTtl(value, until)
          : GStorageItem.simple(value);

      await _storage.write(key: key, value: item.toStorageString());
    });
  }

  @override
  Future<void> clear({required String key}) async {
    await guardFuture<void>(() async {
      await _storage.delete(key: key);
    });
  }

  @override
  Future<void> delete({required String key}) async {
    await guardFuture<void>(() async {
      await _storage.delete(key: key);
    });
  }

  @override
  Future<void> clearAll() async {
    await guardFuture<void>(() async {
      await _storage.deleteAll();
    });
  }

  @override
  Future<List<String>?> getKeys() async {
    return await guardFuture<List<String>?>(() async {
      final all = await _storage.readAll();
      return all.keys.toList();
    });
  }

  @override
  Future<void> cleanupExpired() async {
    await guardFuture<void>(() async {
      final all = await _storage.readAll();

      for (final entry in all.entries) {
        final key = entry.key;
        final storageString = entry.value;

        try {
          final item = GStorageItem.fromStorageString(storageString);
          if (item.isExpired) {
            await _storage.delete(key: key);
          }
        } catch (e) {
          // 기존 단순 문자열 데이터는 유지
          continue;
        }
      }
    });
  }

  @override
  Future<DateTime?> getExpiration({required String key}) async {
    return await guardFuture<DateTime?>(() async {
      final storageString = await _storage.read(key: key);
      if (storageString == null) return null;

      try {
        final item = GStorageItem.fromStorageString(storageString);
        return item.expirationTime;
      } catch (e) {
        // 기존 단순 문자열 데이터는 만료 시간 없음
        return null;
      }
    });
  }
}
