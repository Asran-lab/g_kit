import 'package:g_common/utils/util.dart';
import 'package:g_core/storage/common/g_storage_type.dart';
import 'package:g_core/storage/context/g_storage_context.dart';
import 'package:g_core/storage/factory/g_storage_factory.dart';
import 'package:g_model/initializer/g_initializer.dart';

class GStorageInitializer extends GInitializer {
  final GStorageType? _type;
  GStorageInitializer({GStorageType? type}) : _type = type;

  static GStorageContext? _context;

  @override
  String get name => 'storage';
  @override
  Future<void> initialize() async {
    await guardFuture<void>(() async {
      if (_context != null) return;
      final context = GStorageContext();

      if (_type == null) {
        final prefsStrategy = await GStorageFactory.create(GStorageType.prefs);
        final secureStrategy =
            await GStorageFactory.create(GStorageType.secure);
      } else {}

      // 전략 초기화 완료
      _context = context;
    }, onError: (e, s) {
      Logger.e('Failed to initialize storage', error: e);
      throw e;
    });
  }

  static GStorageContext get context {
    if (_context == null) {
      throw Exception('GStorageContext가 초기화되지 않았습니다');
    }
    return _context!;
  }
}
