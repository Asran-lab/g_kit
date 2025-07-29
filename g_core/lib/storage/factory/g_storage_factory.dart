import 'package:g_core/storage/storage.dart';

class GStorageFactory {
  static Future<GStorageStrategy> create(GStorageType type) async {
    return switch (type) {
      GStorageType.prefs => GPrefsStorageStrategy(),
      GStorageType.secure => GSecureStorageStrategy(),
    };
  }
}
