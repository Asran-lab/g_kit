import 'package:flutter_test/flutter_test.dart';
import 'package:g_plugin/app_link/facade/g_app_link.dart';
import 'package:g_plugin/app_link/g_app_link_initializer.dart';
import 'package:g_plugin/g_plugin_initializer.dart';
import 'package:g_common/utils/g_logger.dart' show Logger;

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('GAppLink Multiple Instances Test', () {
    // 테스트용 수신된 딥링크 저장
    final List<String> receivedLinks = [];
    final List<String> receivedErrors = [];
    final Map<String, List<String>> instanceLinks = {
      'default': [],
      'shopping': [],
      'social': [],
    };

    setUp(() async {
      // 각 테스트 전에 초기화
      receivedLinks.clear();
      receivedErrors.clear();
      instanceLinks.forEach((key, value) => value.clear());

      // GPluginInitializer를 통한 초기화
      final pluginInitializer = GPluginInitializer([
        GAppLinkInitializer(
          onDeepLink: (link) => Logger.d('Default handler: $link'),
          onError: (error) => Logger.e('Default error: $error'),
          deepLinkTypes: {
            'default': (path) => true,
          },
        ),
      ]);
      await pluginInitializer.initializeAll();
    });

    tearDown(() async {
      // 각 테스트 후에 정리
      await GAppLink.dispose();
    });

    test('3개의 서로 다른 딥링크 인스턴스 설정 및 테스트', () async {
      // 1. 기본 인스턴스 (일반적인 앱 딥링크)
      await GAppLink.setCallbacks(
        onDeepLink: (link) {
          receivedLinks.add('default: $link');
          instanceLinks['default']!.add(link);
        },
        onError: (error) {
          receivedErrors.add('default: $error');
        },
        deepLinkTypes: {
          'home': (path) => path.isEmpty || path == '/',
          'profile': (path) => path.contains('profile'),
          'settings': (path) => path.contains('settings'),
        },
      );

      // 2. 쇼핑 전용 인스턴스
      await GAppLink.setCallbacks(
        name: 'shopping',
        onDeepLink: (link) {
          receivedLinks.add('shopping: $link');
          instanceLinks['shopping']!.add(link);
        },
        onError: (error) {
          receivedErrors.add('shopping: $error');
        },
        deepLinkTypes: {
          'product': (path) => path.contains('product'),
          'cart': (path) => path.contains('cart'),
          'order': (path) => path.contains('order'),
          'category': (path) => path.contains('category'),
        },
      );

      // 3. 소셜 기능 전용 인스턴스
      await GAppLink.setCallbacks(
        name: 'social',
        onDeepLink: (link) {
          receivedLinks.add('social: $link');
          instanceLinks['social']!.add(link);
        },
        onError: (error) {
          receivedErrors.add('social: $error');
        },
        deepLinkTypes: {
          'friend': (path) => path.contains('friend'),
          'chat': (path) => path.contains('chat'),
          'share': (path) => path.contains('share'),
          'invite': (path) => path.contains('invite'),
        },
      );

      // 인스턴스 등록 확인
      final registeredNames = GAppLink.registeredInstanceNames;
      expect(registeredNames.length, 3);
      expect(registeredNames.contains('default'), true);
      expect(registeredNames.contains('shopping'), true);
      expect(registeredNames.contains('social'), true);

      // 초기화 상태 확인
      expect(GAppLink.isInitialized(), true);
      expect(GAppLink.isInitialized('shopping'), true);
      expect(GAppLink.isInitialized('social'), true);

      // 각 인스턴스의 딥링크 타입 확인
      expect(GAppLink.registeredDeepLinkTypes().length, 3); // default
      expect(GAppLink.registeredDeepLinkTypes('shopping').length, 4);
      expect(GAppLink.registeredDeepLinkTypes('social').length, 4);
    });

    test('각 인스턴스별 딥링크 처리 테스트', () async {
      // 인스턴스 설정 (위와 동일)
      await _setupInstances(instanceLinks, receivedLinks, receivedErrors);

      // 1. 기본 인스턴스 딥링크 처리
      GAppLink.handleDeepLink('myapp://profile/123');
      GAppLink.handleDeepLink('myapp://settings/theme');

      // 2. 쇼핑 인스턴스 딥링크 처리
      GAppLink.handleDeepLink('myapp://product/456', 'shopping');
      GAppLink.handleDeepLink('myapp://cart/add/789', 'shopping');

      // 3. 소셜 인스턴스 딥링크 처리
      GAppLink.handleDeepLink('myapp://friend/invite/abc', 'social');
      GAppLink.handleDeepLink('myapp://chat/room/def', 'social');

      // 결과 검증
      expect(instanceLinks['default']!.length, 2);
      expect(instanceLinks['shopping']!.length, 2);
      expect(instanceLinks['social']!.length, 2);

      expect(instanceLinks['default']![0], 'myapp://profile/123');
      expect(instanceLinks['shopping']![0], 'myapp://product/456');
      expect(instanceLinks['social']![0], 'myapp://friend/invite/abc');
    });

    test('딥링크 파싱 및 타입 확인 테스트', () async {
      await _setupInstances(instanceLinks, receivedLinks, receivedErrors);

      // 1. 기본 인스턴스 - 프로필 딥링크
      final profileLink = 'myapp://profile/123?tab=info';
      final profileParsed = GAppLink.parseDeepLink(profileLink);
      expect(profileParsed['scheme'], 'myapp');
      expect(profileParsed['host'], 'profile');
      expect(profileParsed['path'], '/123');
      expect(profileParsed['tab'], 'info');
      expect(GAppLink.getDeepLinkType(profileLink), 'profile');
      expect(GAppLink.isDeepLinkType(profileLink, 'profile'), true);

      // 2. 쇼핑 인스턴스 - 상품 딥링크
      final productLink = 'myapp://product/456?color=red&size=L';
      final productParsed = GAppLink.parseDeepLink(productLink, 'shopping');
      expect(productParsed['scheme'], 'myapp');
      expect(productParsed['host'], 'product');
      expect(productParsed['path'], '/456');
      expect(productParsed['color'], 'red');
      expect(productParsed['size'], 'L');
      expect(GAppLink.getDeepLinkType(productLink, 'shopping'), 'product');
      expect(GAppLink.isDeepLinkType(productLink, 'product', 'shopping'), true);

      // 3. 소셜 인스턴스 - 친구 초대 딥링크
      final friendLink = 'myapp://friend/invite/abc?from=john';
      final friendParsed = GAppLink.parseDeepLink(friendLink, 'social');
      expect(friendParsed['scheme'], 'myapp');
      expect(friendParsed['host'], 'friend');
      expect(friendParsed['path'], '/invite/abc');
      expect(friendParsed['from'], 'john');
      expect(GAppLink.getDeepLinkType(friendLink, 'social'), 'friend');
      expect(GAppLink.isDeepLinkType(friendLink, 'friend', 'social'), true);
    });

    test('딥링크 파라미터 추출 테스트', () async {
      await _setupInstances(instanceLinks, receivedLinks, receivedErrors);

      // 1. 기본 인스턴스 - ID 추출
      final profileLink = 'myapp://profile/user123';
      final profileId = GAppLink.extractIdFromDeepLink(profileLink);
      expect(profileId, 'user123');

      // 2. 쇼핑 인스턴스 - 상품 ID 및 파라미터 추출
      final productLink = 'myapp://product/item456?color=blue&discount=20';
      final productId = GAppLink.extractIdFromDeepLink(productLink, 'shopping');
      final color = GAppLink.extractParameterFromDeepLink(
          productLink, 'color', 'shopping');
      final discount = GAppLink.extractParameterFromDeepLink(
          productLink, 'discount', 'shopping');

      expect(productId, 'item456');
      expect(color, 'blue');
      expect(discount, '20');

      // 3. 소셜 인스턴스 - 채팅방 ID 및 파라미터 추출
      final chatLink = 'myapp://chat/room/room789?userId=john&type=private';
      final roomId = GAppLink.extractIdFromDeepLink(chatLink, 'social');
      final userId =
          GAppLink.extractParameterFromDeepLink(chatLink, 'userId', 'social');
      final type =
          GAppLink.extractParameterFromDeepLink(chatLink, 'type', 'social');

      expect(roomId, 'room789');
      expect(userId, 'john');
      expect(type, 'private');
    });

    test('런타임 딥링크 타입 추가/제거 테스트', () async {
      await _setupInstances(instanceLinks, receivedLinks, receivedErrors);

      // 1. 쇼핑 인스턴스에 새 타입 추가
      GAppLink.addDeepLinkType(
          'wishlist', (path) => path.contains('wishlist'), 'shopping');
      expect(GAppLink.registeredDeepLinkTypes('shopping').contains('wishlist'),
          true);

      final wishlistLink = 'myapp://wishlist/add/123';
      expect(GAppLink.getDeepLinkType(wishlistLink, 'shopping'), 'wishlist');

      // 2. 소셜 인스턴스에 새 타입 추가
      GAppLink.addDeepLinkType(
          'event', (path) => path.contains('event'), 'social');
      expect(
          GAppLink.registeredDeepLinkTypes('social').contains('event'), true);

      final eventLink = 'myapp://event/create/456';
      expect(GAppLink.getDeepLinkType(eventLink, 'social'), 'event');

      // 3. 타입 제거
      GAppLink.removeDeepLinkType('wishlist', 'shopping');
      expect(GAppLink.registeredDeepLinkTypes('shopping').contains('wishlist'),
          false);
      expect(GAppLink.getDeepLinkType(wishlistLink, 'shopping'), 'unknown');
    });

    test('개별 인스턴스 dispose 테스트', () async {
      await _setupInstances(instanceLinks, receivedLinks, receivedErrors);

      // 초기 상태 확인
      expect(GAppLink.registeredInstanceNames.length, 3);
      expect(GAppLink.isInitialized(), true);
      expect(GAppLink.isInitialized('shopping'), true);
      expect(GAppLink.isInitialized('social'), true);

      // 쇼핑 인스턴스만 dispose
      await GAppLink.dispose('shopping');
      expect(GAppLink.registeredInstanceNames.length, 2);
      expect(GAppLink.registeredInstanceNames.contains('shopping'), false);
      expect(GAppLink.registeredInstanceNames.contains('default'), true);
      expect(GAppLink.registeredInstanceNames.contains('social'), true);

      // 나머지 모든 인스턴스 dispose
      await GAppLink.dispose();
      expect(GAppLink.registeredInstanceNames.length, 0);
    });

    test('일시정지/재개 기능 테스트', () async {
      await _setupInstances(instanceLinks, receivedLinks, receivedErrors);

      // 쇼핑 인스턴스 일시정지
      GAppLink.pause('shopping');
      expect(GAppLink.isListening('shopping'), false);
      expect(GAppLink.isListening('default'), true);
      expect(GAppLink.isListening('social'), true);

      // 쇼핑 인스턴스 재개
      GAppLink.resume('shopping');
      expect(GAppLink.isListening('shopping'), true);

      // 모든 인스턴스 일시정지
      GAppLink.pause();
      GAppLink.pause('shopping');
      GAppLink.pause('social');
      expect(GAppLink.isListening(), false);
      expect(GAppLink.isListening('shopping'), false);
      expect(GAppLink.isListening('social'), false);
    });
  });
}

// 헬퍼 함수: 3개 인스턴스 설정
Future<void> _setupInstances(
  Map<String, List<String>> instanceLinks,
  List<String> receivedLinks,
  List<String> receivedErrors,
) async {
  // GPluginInitializer로 이미 초기화됨
  // 기본 인스턴스
  await GAppLink.setCallbacks(
    onDeepLink: (link) {
      receivedLinks.add('default: $link');
      instanceLinks['default']!.add(link);
    },
    onError: (error) => receivedErrors.add('default: $error'),
    deepLinkTypes: {
      'home': (path) => path.isEmpty || path == '/',
      'profile': (path) => path.contains('profile'),
      'settings': (path) => path.contains('settings'),
    },
  );

  // 쇼핑 인스턴스
  await GAppLink.setCallbacks(
    name: 'shopping',
    onDeepLink: (link) {
      receivedLinks.add('shopping: $link');
      instanceLinks['shopping']!.add(link);
    },
    onError: (error) => receivedErrors.add('shopping: $error'),
    deepLinkTypes: {
      'product': (path) => path.contains('product'),
      'cart': (path) => path.contains('cart'),
      'order': (path) => path.contains('order'),
      'category': (path) => path.contains('category'),
    },
  );

  // 소셜 인스턴스
  await GAppLink.setCallbacks(
    name: 'social',
    onDeepLink: (link) {
      receivedLinks.add('social: $link');
      instanceLinks['social']!.add(link);
    },
    onError: (error) => receivedErrors.add('social: $error'),
    deepLinkTypes: {
      'friend': (path) => path.contains('friend'),
      'chat': (path) => path.contains('chat'),
      'share': (path) => path.contains('share'),
      'invite': (path) => path.contains('invite'),
    },
  );
}
