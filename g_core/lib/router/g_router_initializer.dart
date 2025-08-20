import 'package:g_common/utils/g_guard.dart' show guardFuture;
import 'package:g_common/utils/g_logger.dart';
import 'package:g_core/router/router.dart';
import 'package:g_model/initializer/g_initializer.dart';

class GRouterInitializer extends GInitializer {
  final List<GRouteConfig>? configs;
  final List<GShellRouteConfig>? shellConfigs;
  final String initialPath;
  final bool enableLogging;
  final GRouterErrorHandler? errorHandler;
  final GRouterRedirectHandler? redirectHandler;

  GRouterInitializer({
    this.configs,
    this.shellConfigs,
    this.initialPath = '/splash',
    this.enableLogging = true,
    this.errorHandler,
    this.redirectHandler,
  });

  @override
  String get name => 'router';

  @override
  Future<void> initialize() async {
    await guardFuture<void>(
      () async {
        GRouter.initialize(
          configs ?? [],
          shellConfigs: shellConfigs,
          initialPath: initialPath,
          enableLogging: enableLogging,
          errorHandler: errorHandler,
          redirectHandler: redirectHandler,
        );
      },
      onError: (e, s) {
        Logger.e('Failed to initialize router', error: e);
        throw e;
      },
    );
  }
}
