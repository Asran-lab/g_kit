import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:g_plugin/app_link/facade/g_app_link.dart';

/// GAppLink 다중 인스턴스 사용 예제
///
/// 3개의 서로 다른 딥링크 도메인을 처리하는 실제 앱 시나리오
class AppLinkUsageExample extends StatefulWidget {
  const AppLinkUsageExample({super.key});

  @override
  State<AppLinkUsageExample> createState() => _AppLinkUsageExampleState();
}

class _AppLinkUsageExampleState extends State<AppLinkUsageExample> {
  final List<String> _receivedLinks = [];

  @override
  void initState() {
    super.initState();
    _setupDeepLinkHandlers();
  }

  /// 3개의 딥링크 인스턴스 설정
  void _setupDeepLinkHandlers() {
    // 1. 기본 앱 딥링크 (메인 네비게이션)
    GAppLink.setCallbacks(
      onDeepLink: (link) {
        setState(() {
          _receivedLinks.add('🏠 메인: $link');
        });
        _handleMainDeepLink(link);
      },
      onError: (error) {
        log('메인 딥링크 에러: $error');
      },
      deepLinkTypes: {
        'home': (path) => path.isEmpty || path == '/' || path == '/home',
        'profile': (path) => path.contains('profile'),
        'settings': (path) => path.contains('settings'),
        'notifications': (path) => path.contains('notifications'),
      },
    );

    // 2. 쇼핑몰 딥링크 (이커머스 기능)
    GAppLink.setCallbacks(
      name: 'shopping',
      onDeepLink: (link) {
        setState(() {
          _receivedLinks.add('🛒 쇼핑: $link');
        });
        _handleShoppingDeepLink(link);
      },
      onError: (error) {
        log('쇼핑 딥링크 에러: $error');
      },
      deepLinkTypes: {
        'product': (path) => path.contains('product'),
        'cart': (path) => path.contains('cart'),
        'order': (path) => path.contains('order'),
        'category': (path) => path.contains('category'),
        'search': (path) => path.contains('search'),
        'wishlist': (path) => path.contains('wishlist'),
      },
    );

    // 3. 소셜 딥링크 (커뮤니티 기능)
    GAppLink.setCallbacks(
      name: 'social',
      onDeepLink: (link) {
        setState(() {
          _receivedLinks.add('👥 소셜: $link');
        });
        _handleSocialDeepLink(link);
      },
      onError: (error) {
        log('소셜 딥링크 에러: $error');
      },
      deepLinkTypes: {
        'friend': (path) => path.contains('friend'),
        'chat': (path) => path.contains('chat'),
        'post': (path) => path.contains('post'),
        'share': (path) => path.contains('share'),
        'invite': (path) => path.contains('invite'),
        'group': (path) => path.contains('group'),
      },
    );
  }

  /// 메인 딥링크 처리
  void _handleMainDeepLink(String link) {
    // final parsed = GAppLink.parseDeepLink(link);
    final type = GAppLink.getDeepLinkType(link);

    switch (type) {
      case 'profile':
        final userId = GAppLink.extractIdFromDeepLink(link);
        _navigateToProfile(userId);
        break;
      case 'settings':
        final section = GAppLink.extractParameterFromDeepLink(link, 'section');
        _navigateToSettings(section);
        break;
      case 'notifications':
        final notificationId = GAppLink.extractIdFromDeepLink(link);
        _navigateToNotification(notificationId);
        break;
      case 'home':
      default:
        _navigateToHome();
        break;
    }
  }

  /// 쇼핑 딥링크 처리
  void _handleShoppingDeepLink(String link) {
    final type = GAppLink.getDeepLinkType(link, 'shopping');

    switch (type) {
      case 'product':
        final productId = GAppLink.extractIdFromDeepLink(link, 'shopping');
        final variant =
            GAppLink.extractParameterFromDeepLink(link, 'variant', 'shopping');
        _navigateToProduct(productId, variant: variant);
        break;
      case 'cart':
        _navigateToCart();
        break;
      case 'order':
        final orderId = GAppLink.extractIdFromDeepLink(link, 'shopping');
        _navigateToOrder(orderId);
        break;
      case 'category':
        final categoryId = GAppLink.extractIdFromDeepLink(link, 'shopping');
        final filter =
            GAppLink.extractParameterFromDeepLink(link, 'filter', 'shopping');
        _navigateToCategory(categoryId, filter: filter);
        break;
      case 'search':
        final query =
            GAppLink.extractParameterFromDeepLink(link, 'q', 'shopping');
        _navigateToSearch(query);
        break;
      case 'wishlist':
        _navigateToWishlist();
        break;
    }
  }

  /// 소셜 딥링크 처리
  void _handleSocialDeepLink(String link) {
    final type = GAppLink.getDeepLinkType(link, 'social');

    switch (type) {
      case 'friend':
        final friendId = GAppLink.extractIdFromDeepLink(link, 'social');
        final action =
            GAppLink.extractParameterFromDeepLink(link, 'action', 'social');
        _navigateToFriend(friendId, action: action);
        break;
      case 'chat':
        final roomId = GAppLink.extractIdFromDeepLink(link, 'social');
        final messageId =
            GAppLink.extractParameterFromDeepLink(link, 'msg', 'social');
        _navigateToChat(roomId, messageId: messageId);
        break;
      case 'post':
        final postId = GAppLink.extractIdFromDeepLink(link, 'social');
        final commentId =
            GAppLink.extractParameterFromDeepLink(link, 'comment', 'social');
        _navigateToPost(postId, commentId: commentId);
        break;
      case 'share':
        final contentId = GAppLink.extractIdFromDeepLink(link, 'social');
        final type =
            GAppLink.extractParameterFromDeepLink(link, 'type', 'social');
        _navigateToShare(contentId, type: type);
        break;
      case 'invite':
        final inviteCode = GAppLink.extractIdFromDeepLink(link, 'social');
        _handleInvite(inviteCode);
        break;
      case 'group':
        final groupId = GAppLink.extractIdFromDeepLink(link, 'social');
        _navigateToGroup(groupId);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('딥링크 테스트'),
      ),
      body: Column(
        children: [
          _buildTestButtons(),
          Divider(),
          _buildReceivedLinks(),
        ],
      ),
    );
  }

  Widget _buildTestButtons() {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('딥링크 테스트 버튼', style: Theme.of(context).textTheme.headlineSmall),
          SizedBox(height: 16),

          // 메인 딥링크 테스트
          Text('🏠 메인 딥링크', style: TextStyle(fontWeight: FontWeight.bold)),
          Row(
            children: [
              Expanded(
                  child: ElevatedButton(
                onPressed: () =>
                    GAppLink.handleDeepLink('myapp://profile/user123?tab=info'),
                child: Text('프로필'),
              )),
              SizedBox(width: 8),
              Expanded(
                  child: ElevatedButton(
                onPressed: () =>
                    GAppLink.handleDeepLink('myapp://settings/theme?mode=dark'),
                child: Text('설정'),
              )),
            ],
          ),

          SizedBox(height: 16),

          // 쇼핑 딥링크 테스트
          Text('🛒 쇼핑 딥링크', style: TextStyle(fontWeight: FontWeight.bold)),
          Row(
            children: [
              Expanded(
                  child: ElevatedButton(
                onPressed: () => GAppLink.handleDeepLink(
                    'myapp://product/item456?variant=red', 'shopping'),
                child: Text('상품'),
              )),
              SizedBox(width: 8),
              Expanded(
                  child: ElevatedButton(
                onPressed: () => GAppLink.handleDeepLink(
                    'myapp://cart/checkout', 'shopping'),
                child: Text('장바구니'),
              )),
            ],
          ),

          SizedBox(height: 16),

          // 소셜 딥링크 테스트
          Text('👥 소셜 딥링크', style: TextStyle(fontWeight: FontWeight.bold)),
          Row(
            children: [
              Expanded(
                  child: ElevatedButton(
                onPressed: () => GAppLink.handleDeepLink(
                    'myapp://chat/room789?msg=123', 'social'),
                child: Text('채팅'),
              )),
              SizedBox(width: 8),
              Expanded(
                  child: ElevatedButton(
                onPressed: () => GAppLink.handleDeepLink(
                    'myapp://friend/invite/abc?action=accept', 'social'),
                child: Text('친구초대'),
              )),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildReceivedLinks() {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('수신된 딥링크', style: Theme.of(context).textTheme.headlineSmall),
            SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                itemCount: _receivedLinks.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: Padding(
                      padding: EdgeInsets.all(8),
                      child: Text(_receivedLinks[index]),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 네비게이션 메서드들 (실제 구현에서는 Navigator를 사용)
  void _navigateToHome() => log('🏠 홈으로 이동');
  void _navigateToProfile(String? userId) => log('👤 프로필로 이동: $userId');
  void _navigateToSettings(String? section) => log('⚙️ 설정으로 이동: $section');
  void _navigateToNotification(String? notificationId) =>
      log('🔔 알림으로 이동: $notificationId');

  void _navigateToProduct(String? productId, {String? variant}) =>
      log('📦 상품으로 이동: $productId (variant: $variant)');
  void _navigateToCart() => log('🛒 장바구니로 이동');
  void _navigateToOrder(String? orderId) => log('📋 주문으로 이동: $orderId');
  void _navigateToCategory(String? categoryId, {String? filter}) =>
      log('📂 카테고리로 이동: $categoryId (filter: $filter)');
  void _navigateToSearch(String? query) => log('🔍 검색으로 이동: $query');
  void _navigateToWishlist() => log('❤️ 위시리스트로 이동');

  void _navigateToFriend(String? friendId, {String? action}) =>
      log('👥 친구로 이동: $friendId (action: $action)');
  void _navigateToChat(String? roomId, {String? messageId}) =>
      log('💬 채팅으로 이동: $roomId (message: $messageId)');
  void _navigateToPost(String? postId, {String? commentId}) =>
      log('📝 포스트로 이동: $postId (comment: $commentId)');
  void _navigateToShare(String? contentId, {String? type}) =>
      log('🔗 공유로 이동: $contentId (type: $type)');
  void _handleInvite(String? inviteCode) => log('📨 초대 처리: $inviteCode');
  void _navigateToGroup(String? groupId) =>
      log('👨‍👩‍👧‍👦 그룹으로 이동: $groupId');

  @override
  void dispose() {
    // 앱 종료 시 모든 딥링크 인스턴스 정리
    GAppLink.dispose();
    super.dispose();
  }
}
