import 'package:flutter/material.dart';
import 'package:g_core/router/service/g_router_impl.dart';
import 'package:g_core/router/common/g_router_config.dart';

/// 사용 예시: Native Navigator 기반 GRouter 사용법
class RouterExampleApp extends StatelessWidget {
  final GRouterImpl router = GRouterImpl();

  RouterExampleApp({super.key}) {
    _initializeRouter();
  }

  void _initializeRouter() {
    // 라우트 설정
    final routes = [
      GRouteConfig(
        path: '/',
        name: 'home',
        builder: (context, args) => const HomePage(),
      ),
      GRouteConfig(
        path: '/profile',
        name: 'profile',
        builder: (context, args) => ProfilePage(userId: args?['userId']),
      ),
      GRouteConfig(
        path: '/settings',
        name: 'settings',
        builder: (context, args) => const SettingsPage(),
        // 가드 예시: 로그인 체크
        guard: () => true, // 실제로는 로그인 상태 체크
      ),
    ];

    // 쉘 라우트 설정 예시
    final shellRoutes = [
      GShellRouteConfig(
        name: 'main_shell',
        builder: (context, child) => MainShell(child: child),
        children: [
          GRouteConfig(
            path: '/dashboard',
            name: 'dashboard',
            builder: (context, args) => const DashboardPage(),
          ),
          GRouteConfig(
            path: '/analytics',
            name: 'analytics',
            builder: (context, args) => const AnalyticsPage(),
          ),
        ],
      ),
    ];

    // 라우터 초기화
    router.initialize(
      routes,
      shellConfigs: shellRoutes,
      initialPath: '/',
    );
  }

  @override
  Widget build(BuildContext context) {
    // MaterialApp.router 대신 네이티브 MaterialApp 사용
    return router.buildMaterialApp(
      title: 'GRouter Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}

/// 홈 페이지
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Welcome to GRouter Example!',
              style: TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _navigateToProfile(context),
              child: const Text('Go to Profile'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => _navigateToSettings(context),
              child: const Text('Go to Settings'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => _navigateToDashboard(context),
              child: const Text('Go to Dashboard (Shell Route)'),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToProfile(BuildContext context) {
    // 라우터 인스턴스에 접근하는 방법 (서비스 로케이터 패턴 사용)
    final router = RouterExampleApp().router;
    router.go('/profile', arguments: {'userId': '123'});
  }

  void _navigateToSettings(BuildContext context) {
    final router = RouterExampleApp().router;
    router.go('/settings');
  }

  void _navigateToDashboard(BuildContext context) {
    final router = RouterExampleApp().router;
    router.go('/dashboard');
  }
}

/// 프로필 페이지
class ProfilePage extends StatelessWidget {
  final String? userId;

  const ProfilePage({super.key, this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Profile Page',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            if (userId != null) ...[
              const SizedBox(height: 10),
              Text('User ID: $userId'),
            ],
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Go Back'),
            ),
          ],
        ),
      ),
    );
  }
}

/// 설정 페이지
class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Settings Page',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),
            Text('Configure your app settings here'),
          ],
        ),
      ),
    );
  }
}

/// 대시보드 페이지
class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Dashboard',
            style: TextStyle(fontSize: 24),
          ),
          SizedBox(height: 10),
          Text('This page is inside a shell route'),
        ],
      ),
    );
  }
}

/// 분석 페이지
class AnalyticsPage extends StatelessWidget {
  const AnalyticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Analytics',
            style: TextStyle(fontSize: 24),
          ),
          SizedBox(height: 10),
          Text('View your analytics here'),
        ],
      ),
    );
  }
}

/// 메인 쉘 - 하단 네비게이션 바 등을 포함
class MainShell extends StatelessWidget {
  final Widget child;

  const MainShell({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.analytics),
            label: 'Analytics',
          ),
        ],
        onTap: (index) {
          final router = RouterExampleApp().router;
          switch (index) {
            case 0:
              router.go('/dashboard');
              break;
            case 1:
              router.go('/analytics');
              break;
          }
        },
      ),
    );
  }
}

/// 앱 진입점
void main() {
  runApp(RouterExampleApp());
}