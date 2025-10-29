import 'package:g_common/utils/util.dart';
import 'package:g_core/storage/common/g_storage_type.dart';
import 'package:g_core/storage/context/g_storage_context.dart';
import 'package:g_core/storage/factory/g_storage_factory.dart';
import 'package:g_model/g_model.dart';

/// Storage 초기화 클래스
///
/// GContextInitializer를 구현하여 GContextFacade 패턴을 지원합니다.
class GStorageInitializer extends GInitializer
    implements GContextInitializer<GStorageContext> {
  static final GStorageInitializer _instance = GStorageInitializer._internal();
  factory GStorageInitializer() => _instance;
  GStorageInitializer._internal();

  final GStorageType? _type = null;
  GStorageContext? _context;
  bool _isInitialized = false;

  @override
  String get name => 'storage';

  @override
  Future<void> initialize() async {
    if (_isInitialized) return;

    await guardFuture<void>(() async {
      final context = GStorageContext();

      if (_type == null) {
        final prefsStrategy = await GStorageFactory.create(GStorageType.prefs);
        final secureStrategy =
            await GStorageFactory.create(GStorageType.secure);

        context.registerStrategy(GStorageType.prefs, prefsStrategy);
        context.registerStrategy(GStorageType.secure, secureStrategy);
      } else {
        context.setType = _type!;
        final strategy = await GStorageFactory.create(_type!);
        context.registerStrategy(_type!, strategy);
      }
      // context 초기화
      await context.initialize();

      // 전략 초기화 완료
      _context = context;
      _isInitialized = true;
    }, onError: (e, s) {
      Logger.e('Failed to initialize storage', error: e);
      throw e;
    });
  }

  @override
  GStorageContext get context {
    if (!_isInitialized) {
      throw StateError(
        'GStorageInitializer is not initialized. Call initialize() first.',
      );
    }
    return _context!;
  }

  @override
  bool get isInitialized => _isInitialized;

  Future<void> dispose() async {
    if (_context != null) {
      _context = null;
    }
    _isInitialized = false;
  }
}
