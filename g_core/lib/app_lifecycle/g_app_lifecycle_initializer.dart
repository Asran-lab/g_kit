import 'package:g_model/initializer/g_initializer.dart';
import 'package:g_core/app_lifecycle/facade/g_app_lifecycle.dart';

class GAppLifecycleInitializer extends GInitializer {
  @override
  String get name => 'app_lifecycle';

  @override
  Future<void> initialize() async {
    // 앱 라이프사이클 초기화
    GAppLifecycle.initialize();
  }
}
