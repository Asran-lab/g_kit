import 'package:g_model/initializer/g_initializer.dart';
import 'package:g_core/auth/service/g_auth_service.dart';

class GAuthInitializer extends GInitializer {
  @override
  String get name => 'auth';
  
  @override
  Future<void> initialize() async {
    await GAuthService.I.initialize();
  }
}
