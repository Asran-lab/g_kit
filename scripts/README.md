# g_kit 정리 스크립트 & 라우터 시스템

g_kit 프로젝트의 용량을 절약하고 빌드 캐시를 정리하는 스크립트들과 새로운 라우터 시스템에 대한 문서입니다.

## 📁 스크립트 목록

### 1. `clean.sh` - 메인 정리 스크립트

가장 포괄적인 정리 스크립트로, melos를 활용하여 모든 캐시를 정리합니다.

#### 사용법

```bash
# 기본 정리 (권장)
./scripts/clean.sh

# pubspec.lock 파일까지 정리 (완전 초기화)
./scripts/clean.sh --clean-lock
```

#### 정리 대상
- `.dart_tool/` 디렉토리들
- `build/` 디렉토리들
- Flutter pub cache
- pubspec.lock 파일들 (선택사항)

### 2. `git_commit.sh` - Git 커밋/푸시 스크립트

staging된 파일들의 수정 내용을 자동으로 감지하여 커밋 메시지를 생성하고 커밋/푸시를 실행합니다.

#### 사용법

```bash
# 기본 커밋 (자동 메시지 생성)
./scripts/git_commit.sh

# 커밋 후 푸시
./scripts/git_commit.sh --push

# 커스텀 메시지로 커밋
./scripts/git_commit.sh -m "커스텀 커밋 메시지"

# 커스텀 메시지로 커밋 후 푸시
./scripts/git_commit.sh -m "커스텀 메시지" --push
```

#### 기능
- ✅ **자동 메시지 생성**: 파일 타입별로 변경사항 감지
- ✅ **Git 상태 확인**: staging/unstaged/untracked 파일 표시
- ✅ **안전한 커밋**: staging된 파일만 커밋
- ✅ **자동 푸시**: 선택적으로 푸시 실행

#### 자동 감지되는 변경사항
- 📦 **Dart 파일**: `*.dart` 파일 수정
- ⚙️ **설정 파일**: `*.yaml`, `*.yml` 파일 수정
- 📝 **문서**: `*.md` 파일 수정
- 🔧 **스크립트**: `*.sh` 파일 수정
- 📄 **기타 파일**: 그 외 모든 파일 수정

## 🚀 새로운 라우터 시스템

Flutter의 표준 `RouterConfig<Object?>`를 기반으로 한 강력한 라우터 시스템입니다. GoRouter 라이브러리 없이도 모든 기능을 제공합니다.

### 📋 주요 기능

- ✅ **표준 Flutter Router**: `RouterConfig`, `RouterDelegate`, `RouteInformationParser` 사용
- ✅ **Shell Routes**: 중첩 네비게이션 지원
- ✅ **Route Guards**: 보안 및 접근 제어
- ✅ **Redirects**: 자동 리다이렉트 처리
- ✅ **Custom Transitions**: 커스텀 페이지 전환 효과
- ✅ **State Management**: 라우터 상태 모니터링
- ✅ **Error Handling**: 에러 처리 및 로깅
- ✅ **Debug Logging**: 디버그 모드 지원

### 🏗️ 아키텍처

```
g_core/lib/router/
├── facade/
│   └── g_router.dart          # 외부 사용 Facade
├── service/
│   ├── g_router_service.dart  # 라우터 서비스 인터페이스
│   └── g_router_impl.dart     # 라우터 구현체
├── common/
│   ├── g_router_config.dart   # 라우터 설정 클래스들
│   ├── g_route_typedef.dart   # 타입 정의
│   └── g_router_state.dart    # 라우터 상태 관리
└── g_router_initializer.dart  # 라우터 초기화
```

### 🎯 사용법

#### 1. 기본 라우터 생성

```dart
import 'package:g_core/g_core.dart';

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
    ),
  ],
  initialPath: '/',
  debugLogging: true,
);
```

#### 2. Shell Routes 사용

```dart
final router = GRouter.create(
  routes: [
    GRouter.route(
      path: '/',
      name: 'home',
      builder: (context, arguments) => const HomePage(),
    ),
  ],
  shellRoutes: [
    GRouter.shellRoute(
      name: 'app',
      builder: (context, child) => AppScaffold(child: child),
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
        ),
      ],
    ),
    GRouter.shellRoute(
      name: 'auth',
      builder: (context, child) => AuthLayout(child: child),
      children: [
        GRouter.route(
          path: '/login',
          name: 'login',
          builder: (context, arguments) => const LoginPage(),
        ),
        GRouter.route(
          path: '/register',
          name: 'register',
          builder: (context, arguments) => const RegisterPage(),
        ),
      ],
    ),
  ],
);
```

#### 3. Route Guards 사용

```dart
GRouter.route(
  path: '/admin',
  name: 'admin',
  builder: (context, arguments) => const AdminPage(),
  guard: () {
    // 로그인 상태 및 권한 체크
    return isLoggedIn && hasAdminRole;
  },
),
```

#### 4. Redirects 사용

```dart
GRouter.route(
  path: '/profile',
  name: 'profile',
  builder: (context, arguments) => const ProfilePage(),
  redirect: () {
    // 로그인하지 않은 경우 로그인 페이지로 리다이렉트
    return !isLoggedIn ? '/login' : null;
  },
),
```

#### 5. Custom Transitions 사용

```dart
GRouter.route(
  path: '/detail',
  name: 'detail',
  builder: (context, arguments) => const DetailPage(),
  transition: (context, animation, secondaryAnimation, child) {
    return SlideTransition(
      position: animation.drive(
        Tween(begin: const Offset(1.0, 0.0), end: Offset.zero),
      ),
      child: child,
    );
  },
),
```

### 🔄 네비게이션 메소드

```dart
// 페이지 교체 (뒤로 가기 불가)
await router.replace('/new-page');

// 페이지 이동 (뒤로 가기 가능)
await router.go('/next-page');

// 뒤로 가기
await router.goBack();

// 뒤로 가기 가능 여부 확인
bool canGoBack = await router.canGoBack();

// 특정 경로까지 뒤로 가기
await router.goBackUntil('/home');

// 특정 경로까지 이동
await router.goUntil('/target');
```

### 📊 라우터 상태 모니터링

```dart
// 라우터 상태 스트림 구독
router.routerStateStream.listen((state) {
  print('현재 경로: ${state.currentPath}');
  print('뒤로 가기 가능: ${state.canGoBack}');
  print('네비게이션 스택: ${state.navigationStack}');
});

// 현재 상태 확인
print('현재 경로: ${router.currentPath}');
print('초기화됨: ${router.isInitialized}');
```

### 🏭 싱글톤 패턴 사용

```dart
// 싱글톤으로 초기화
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

// 싱글톤 인스턴스 사용
final router = GRouter.instance;
await router.go('/dashboard');

// 정리
await GRouter.dispose();
```

### 🛡️ 에러 처리

```dart
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

### 🔍 디버깅

```dart
final router = GRouter.create(
  routes: [...],
  debugLogging: true, // 디버그 로그 활성화
);
```

## melos 명령어

melos.yaml에 추가된 정리 명령어들:

### 1. 정리 관련 명령어
```bash
# 기본 정리
melos clean

# Flutter clean
melos run clean

# 전체 정리
melos run clean-all

# 캐시 정리
melos run clean-cache
```

### 2. Git 관련 명령어
```bash
# Git 상태 확인
melos run git-status

# 모든 파일 staging
melos run git-add

# 커밋 (자동 메시지)
melos run git-commit

# 커밋 후 푸시
melos run git-commit-push

# 푸시만 실행
melos run git-push

# 풀 받기
melos run git-pull

# 최근 커밋 로그
melos run git-log

# Staged 변경사항 확인
melos run git-diff

# 변경사항 임시 저장
melos run git-stash

# 임시 저장된 변경사항 복원
melos run git-stash-pop
```

## 정리 후 복구

정리 후에는 다음 명령어로 의존성을 다시 가져올 수 있습니다:

### 1. 전체 프로젝트 복구 (권장)
```bash
melos bootstrap
```

### 2. 개별 패키지 복구
```bash
# 모든 패키지에 대해 pub get 실행
melos exec -- dart pub get

# Flutter 프로젝트의 경우
melos exec -- flutter pub get
```

### 3. 수동 복구
```bash
# 루트 패키지
dart pub get

# 개별 패키지들
cd g_common && dart pub get
cd g_core && dart pub get
cd g_lib && dart pub get
cd g_model && dart pub get
cd g_plugin && dart pub get
```

## 용량 절약 효과

정리 전후 용량 비교:

### 정리 전
```
g_kit/
├── .dart_tool/          ~50MB
├── g_common/.dart_tool/ ~30MB
├── g_core/.dart_tool/   ~40MB
├── g_lib/.dart_tool/    ~25MB
├── g_model/.dart_tool/  ~20MB
├── g_plugin/.dart_tool/ ~35MB
└── build/ 디렉토리들     ~100MB+
```

### 정리 후
```
g_kit/
├── .dart_tool/          삭제됨
├── g_common/.dart_tool/ 삭제됨
├── g_core/.dart_tool/   삭제됨
├── g_lib/.dart_tool/    삭제됨
├── g_model/.dart_tool/  삭제됨
├── g_plugin/.dart_tool/ 삭제됨
└── build/ 디렉토리들     삭제됨
```

**총 절약 용량: ~300MB+**

## 사용 시나리오

### 1. 개발 중 정기 정리
```bash
# 주 1회 정도로 실행
./scripts/clean.sh
melos bootstrap
```

### 2. 빌드 문제 해결
```bash
# 빌드 오류가 발생할 때
./scripts/clean.sh --clean-lock
melos bootstrap
```

### 3. 디스크 공간 확보
```bash
# 디스크 공간이 부족할 때
./scripts/clean.sh
```

### 4. CI/CD 환경
```bash
# CI/CD에서 깨끗한 상태로 시작
melos clean
melos bootstrap
```

### 5. Git 작업 워크플로우
```bash
# 1. 파일 수정 후 staging
git add .

# 2. 자동 커밋 (권장)
./scripts/git_commit.sh

# 3. 또는 커밋 후 바로 푸시
./scripts/git_commit.sh --push

# 4. melos 명령어 사용
melos run git-commit-push
```

## 주의사항

1. **정리 후 반드시 의존성 복구**: 정리 후에는 `melos bootstrap`을 실행해야 합니다.

2. **pubspec.lock 삭제 시 주의**: `--clean-lock` 옵션 사용 시 의존성 버전이 변경될 수 있습니다.

3. **개발 중 정리**: 개발 중에는 정리하지 않는 것이 좋습니다. 정기적으로만 실행하세요.

4. **Git 커밋**: `.dart_tool/`과 `build/`는 이미 `.gitignore`에 포함되어 있어 커밋되지 않습니다.

5. **Git 작업 전 확인**: 커밋 전에 `git status`로 변경사항을 확인하세요.

## 문제 해결

### 정리 후 빌드 오류가 발생하는 경우
```bash
# 완전 초기화
./scripts/clean.sh --clean-lock
melos bootstrap
flutter pub get
```

### melos 명령어가 작동하지 않는 경우
```bash
# melos 재설치
dart pub global activate melos
melos bootstrap
```

### 스크립트 실행 권한 오류
```bash
chmod +x scripts/clean.sh
chmod +x scripts/git_commit.sh
```

### Git 커밋 실패 시
```bash
# Git 상태 확인
git status

# Staging된 파일 확인
git diff --cached

# 수동으로 커밋
git commit -m "커밋 메시지"
```

### 라우터 관련 문제

#### 라우터가 초기화되지 않는 경우
```dart
// 초기화 상태 확인
if (!router.isInitialized) {
  await router.initialize();
}
```

#### 라우트를 찾을 수 없는 경우
```dart
// 디버그 로깅 활성화
final router = GRouter.create(
  routes: [...],
  debugLogging: true,
);
```

#### Shell Route가 작동하지 않는 경우
```dart
// Shell Route 구조 확인
GRouter.shellRoute(
  name: 'app',
  builder: (context, child) => AppScaffold(child: child),
  children: [
    // 자식 라우트들이 올바른 경로를 가지고 있는지 확인
    GRouter.route(
      path: '/dashboard', // 절대 경로 사용
      name: 'dashboard',
      builder: (context, arguments) => const DashboardPage(),
    ),
  ],
),
``` 