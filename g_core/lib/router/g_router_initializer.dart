import 'package:g_common/utils/g_guard.dart' show guardFuture;
import 'package:g_common/utils/g_logger.dart';
import 'package:g_core/router/router.dart';
import 'package:g_model/initializer/g_initializer.dart';

import 'common/g_router_config.dart';

class GRouterInitializer extends GInitializer {
  final List<GRouteConfig>? configs;
  final List<GShellRouteConfig>? shellConfigs;
  final String initialPath;
  final GRouterErrorHandler? errorHandler;
  final GRouterRedirectHandler? redirectHandler;
  final bool enableLogging;

  GRouterInitializer({
    this.configs,
    this.shellConfigs,
    this.initialPath = '/',
    this.errorHandler,
    this.redirectHandler,
    this.enableLogging = true,
  });

  @override
  String get name => 'router';

  @override
  Future<void> initialize() async {
    await guardFuture<void>(() async {
      final GRouterService? _service;
      // GRouter.initialize(
      //   routes: configs ?? [],
      //   shellRoutes: shellConfigs,
      //   initialPath: initialPath,
      //   errorHandler: errorHandler,
      //   redirectHandler: redirectHandler,
      //   debugLogging: enableLogging,
      // );
    }, onError: (e, s) {
      Logger.e('Failed to initialize router', error: e);
      throw e;
    });
    // await GRouter.initialize();
  }
}
