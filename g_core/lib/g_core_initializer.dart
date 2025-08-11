import 'package:g_common/utils/g_guard.dart' show guardFuture;
import 'package:g_common/utils/g_logger.dart' show Logger;
import 'package:g_model/initializer/g_initializer.dart';

class GCoreInitializer {
  final List<GInitializer> _initializers;
  GCoreInitializer(this._initializers);


  Future<void> initializeAll() async {
    for (final initializer in _initializers) {
      await guardFuture<void>(
        () async {
          await initializer.initialize();
          Logger.d('${initializer.name} initialized');
        },
      ).catchError((error) {
        Logger.e('${initializer.name} initialize failed', error: error);
      });
    }
  }
}
