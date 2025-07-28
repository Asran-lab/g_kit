import 'package:g_core/storage/storage.dart';
import 'package:g_core/storage/strategy/impl/g_prefs_storage_strategy.dart';
import 'package:g_core/storage/strategy/impl/g_secure_storage_strategy.dart';

class GStorageFactory {
  static Future<GStorageStrategy> create(GStorageType type) async {
    return switch (type) {
      GStorageType.prefs => GPrefsStorageStrategy(),
      GStorageType.secure => GSecureStorageStrategy(),
    };
  }
}
