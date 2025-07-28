import 'package:g_core/storage/storage.dart';

class GStorageContext implements GStorageStrategy {
  final Map<GStorageType, GStorageStrategy> _strategies = {};

  GStorageType _type = GStorageType.prefs;
  GStorageType get type => _type;
  set setType(GStorageType type) {
    _type = type;
  }

  void registerStrategy(GStorageType type, GStorageStrategy strategy) {
    _strategies[type] = strategy;
  }

  Future<void> initialize() async {
    final prefsStrategy = await GStorageFactory.create(GStorageType.prefs);
    final secureStrategy = await GStorageFactory.create(GStorageType.secure);

    registerStrategy(GStorageType.prefs, prefsStrategy);
    registerStrategy(GStorageType.secure, secureStrategy);
  }
}
