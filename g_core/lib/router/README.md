# G-Core Router

Flutter의 표준 `RouterConfig<Object?>`를 사용하는 라우터 시스템입니다.

## 주요 특징

- **표준 RouterConfig 사용**: Flutter의 표준 라우터 시스템 활용
- **타입 안전성**: 강력한 타입 시스템으로 컴파일 타임 에러 방지
- **메모리 효율성**: `replace`와 `go`의 명확한 구분
- **에러 처리**: `guardFuture`를 사용한 안전한 에러 처리
- **상태 관리**: 라우터 상태 변경 스트림 제공
- **가드 시스템**: 라우트 접근 제어
- **리다이렉트**: 동적 라우트 리다이렉트
- **트랜지션**: 커스텀 페이지 전환 효과
- **쉘 라우트**: 중첩 라우트 구조 지원
- **Facade 패턴**: 간편한 `GRouter` 인터페이스

## 기본 사용법

### 1. 라우터 설정

```dart
import 'package:g_core/g_core.dart';

// 라우터 생성
final router = GRouter.create(
  routes: [
    GRouter.route(
      path: '/',
      name: 'home',
      builder: (context, arguments) => const HomePage(),
    ),
    GRouter.route(
      path: '/login',
      name: 'login',
      builder: (context, arguments) => const LoginPage(),
      guard: () => !isLoggedIn, // 로그인 필요
    ),
    GRouter.route(
      path: '/detail/:id',
      name: 'detail',
      builder: (context, arguments) => DetailPage(id: arguments?['id']),
      transition: (context, animation, secondaryAnimation, child) {
        return SlideTransition(
          position: animation.drive(Tween(begin: Offset(1.0, 0.0), end: Offset.zero)),
          child: child,
        );
      },
    ),
  ],
  shellRoutes: [
    GRouter.shellRoute(
      name: 'app',
      builder: (context, child) => AppShell(child: child),
      children: [
        GRouter.route(
          path: '/dashboard',
          name: 'dashboard',
          builder: (context, arguments) => const DashboardPage(),
        ),
        GRouter.route(
          path: '/profile',
          name: 'profile',
          builder: (context, arguments) => const ProfilePage(),
          guard: () => isLoggedIn, // 로그인 필요
        ),
      ],
    ),
  ],
  initialPath: '/',
  debugLogging: true,
);
```

### 2. MaterialApp 설정

```dart
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: router.routerConfig, // 여기가 핵심!
      title: 'My App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
    );
  }
}
```

### 3. 네비게이션 사용

```dart
class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () async {
                // replace: 현재 페이지를 교체 (뒤로 가기 불가능)
                await router.replace('/login');
              },
              child: const Text('로그인 (Replace)'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                // go: 새 페이지를 스택에 추가 (뒤로 가기 가능)
                await router.go('/detail/123');
              },
              child: const Text('상세 페이지 (Go)'),
            ),
          ],
        ),
      ),
    );
  }
}
```

## 네비게이션 메서드

### replace vs go

| 메서드 | 동작 | 사용 시나리오 |
|--------|------|---------------|
| `replace` | 현재 페이지를 새 페이지로 교체 | 로그인 후 메인 페이지로 이동 |
| `go` | 새 페이지를 스택에 추가 | 상세 페이지로 이동 |

### 예시

```dart
// 로그인 후 메인 페이지로 이동 (뒤로 가기 불가능)
await router.replace('/main');

// 상세 페이지로 이동 (뒤로 가기 가능)
await router.go('/detail/123');

// 뒤로 가기
if (await router.canGoBack()) {
  await router.goBack();
}

// 특정 경로까지 뒤로 가기
await router.goBackUntil('/main');

// 스택을 특정 경로로 교체
await router.goUntil('/main');
```

## 라우트 구성 요소

### 일반 라우트 (GRouter.route)

```dart
GRouter.route(
  path: '/path',
  name: 'route_name',
  builder: (context, arguments) => Widget(),
  guard: () => bool, // 접근 제어
  redirect: () => String?, // 리다이렉트
  transition: (context, animation, secondaryAnimation, child) => Widget(), // 트랜지션
)
```

### 쉘 라우트 (GRouter.shellRoute)

```dart
GRouter.shellRoute(
  name: 'shell_name',
  builder: (context, child) => ShellWidget(child: child),
  children: [/* 자식 라우트들 */],
  guard: () => bool, // 쉘 전체 접근 제어
  redirect: () => String?, // 쉘 전체 리다이렉트
)
```

## 가드 시스템

```dart
// 로그인 필요 라우트
GRouter.route(
  path: '/profile',
  name: 'profile',
  builder: (context, arguments) => const ProfilePage(),
  guard: () => isLoggedIn, // 로그인 체크
);

// 관리자 전용 라우트
GRouter.route(
  path: '/admin',
  name: 'admin',
  builder: (context, arguments) => const AdminPage(),
  guard: () => isLoggedIn && isAdmin, // 로그인 + 관리자 체크
);
```

## 리다이렉트 시스템

```dart
// 로그인 페이지에서 이미 로그인된 경우 메인으로 리다이렉트
GRouter.route(
  path: '/login',
  name: 'login',
  builder: (context, arguments) => const LoginPage(),
  redirect: () => isLoggedIn ? '/main' : null,
);

// 오래된 URL을 새 URL로 리다이렉트
GRouter.route(
  path: '/old-page',
  name: 'old_page',
  builder: (context, arguments) => const OldPage(),
  redirect: () => '/new-page',
);
```

## 트랜지션 시스템

```dart
// 슬라이드 트랜지션
GRouter.route(
  path: '/detail',
  name: 'detail',
  builder: (context, arguments) => const DetailPage(),
  transition: (context, animation, secondaryAnimation, child) {
    return SlideTransition(
      position: animation.drive(Tween(
        begin: const Offset(1.0, 0.0),
        end: Offset.zero,
      )),
      child: child,
    );
  },
);

// 페이드 트랜지션
GRouter.route(
  path: '/modal',
  name: 'modal',
  builder: (context, arguments) => const ModalPage(),
  transition: (context, animation, secondaryAnimation, child) {
    return FadeTransition(
      opacity: animation,
      child: child,
    );
  },
);
```

## 쉘 라우트 사용법

```dart
// 앱 쉘 (네비게이션 바가 있는 레이아웃)
final appShell = GRouter.shellRoute(
  name: 'app',
  builder: (context, child) => Scaffold(
    appBar: AppBar(title: const Text('My App')),
    body: child,
    bottomNavigationBar: BottomNavigationBar(
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
      ],
    ),
  ),
  children: [
    GRouter.route(
      path: '/home',
      name: 'home',
      builder: (context, arguments) => const HomePage(),
    ),
    GRouter.route(
      path: '/profile',
      name: 'profile',
      builder: (context, arguments) => const ProfilePage(),
    ),
  ],
);
```

## 라우터 상태 모니터링

```dart
class RouterStateWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<GRouterState>(
      stream: router.routerStateStream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const CircularProgressIndicator();
        
        final state = snapshot.data!;
        return Column(
          children: [
            Text('현재 경로: ${state.currentPath}'),
            Text('뒤로 가기 가능: ${state.canGoBack}'),
            Text('스택 크기: ${state.navigationStack.length}'),
          ],
        );
      },
    );
  }
}
```

## 싱글톤 패턴 사용

```dart
// 앱 시작 시 초기화
void main() async {
  await GRouter.initialize(
    routes: [
      GRouter.route(
        path: '/',
        name: 'home',
        builder: (context, arguments) => const HomePage(),
      ),
    ],
    initialPath: '/',
  );
  runApp(MyApp());
}

// 앱 종료 시 정리
void dispose() async {
  await GRouter.dispose();
}

// 어디서든 라우터 접근
final router = GRouter.instance!;
```

## 에러 처리

```dart
// 라우터 설정에 에러 핸들러 추가
final router = GRouter.create(
  routes: [...],
  errorHandler: (error, stackTrace) {
    Logger.e('라우터 에러: $error');
    // 에러 처리 로직
  },
  redirectHandler: (path) {
    Logger.d('리다이렉트: $path');
    // 리다이렉트 처리 로직
  },
);
```

## 디버깅

```dart
// 디버그 로깅 활성화
final router = GRouter.create(
  routes: [...],
  debugLogging: true, // 콘솔에 라우터 로그 출력
);
```

## 성능 최적화

1. **라우트 정의 최적화**: 필요한 라우트만 정의
2. **메모리 관리**: `replace` 사용으로 불필요한 스택 제거
3. **상태 모니터링**: 필요한 경우에만 라우터 상태 스트림 구독
4. **가드 최적화**: 가드 함수를 효율적으로 구현
5. **트랜지션 최적화**: 복잡한 트랜지션은 필요한 경우에만 사용

## 주의사항

- `replace`는 뒤로 가기를 불가능하게 만듭니다
- `go`는 메모리 사용량을 증가시킵니다
- 라우터 상태 스트림은 메모리 누수를 방지하기 위해 적절히 구독 해제해야 합니다
- 가드 함수는 빠르게 실행되어야 합니다
- 쉘 라우트는 중첩 구조를 지원하지만 복잡성을 증가시킬 수 있습니다 