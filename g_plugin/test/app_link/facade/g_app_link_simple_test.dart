import 'dart:developer';

import 'package:flutter_test/flutter_test.dart';
import 'package:g_plugin/app_link/facade/g_app_link.dart';
import 'package:g_plugin/app_link/g_app_link_initializer.dart';
import 'package:g_plugin/g_plugin_initializer.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('GAppLink Simple Test', () {
    setUp(() async {
      // GPluginInitializer를 통한 초기화
      final pluginInitializer = GPluginInitializer([
        GAppLinkInitializer(),
      ]);
      await pluginInitializer.initializeAll();
    });

    tearDown(() async {
      await GAppLink.dispose();
    });

    test('기본 인스턴스 생성 확인', () async {
      // 콜백 설정으로 인스턴스 생성
      GAppLink.setCallbacks(
        onDeepLink: (link) => log('Received: $link'),
        deepLinkTypes: {
          'test': (path) => path.contains('test'),
        },
      );

      // 인스턴스 생성 확인
      final names = GAppLink.registeredInstanceNames;
      log('Registered names: $names');
      expect(names.length, 1);
      expect(names.contains('default'), true);

      // 초기화 상태 확인
      expect(GAppLink.isInitialized(), true);
    });

    test('다중 인스턴스 생성 확인', () async {
      // 기본 인스턴스
      GAppLink.setCallbacks(
        onDeepLink: (link) => log('Default: $link'),
        deepLinkTypes: {'home': (path) => path.contains('home')},
      );

      // 쇼핑 인스턴스
      GAppLink.setCallbacks(
        name: 'shopping',
        onDeepLink: (link) => log('Shopping: $link'),
        deepLinkTypes: {'product': (path) => path.contains('product')},
      );

      // 인스턴스 확인
      final names = GAppLink.registeredInstanceNames;
      log('Registered names: $names');
      expect(names.length, 2);
      expect(names.contains('default'), true);
      expect(names.contains('shopping'), true);
    });
  });
}
