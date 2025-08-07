# App Lifecycle Module

앱 라이프사이클 상태를 관리하는 모듈입니다.

## 사용법

### 1. 기본 초기화

```dart
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  
  // 앱 라이프사이클 초기화
  GAppLifecycle.initialize();
  
  runApp(const MyApp());
}
```

### 2. 옵션과 함께 초기화

```dart
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  
  // 옵션과 함께 초기화
  GAppLifecycle.initialize(
    option: const GAppLifecycleOption(
      autoInitialize: true,
      useBroadcast: true,
      debug: true,
    ),
  );
  
  runApp(const MyApp());
}
```

### 3. 리스너 사용

```dart
class MyWidget extends StatefulWidget {
  @override
  _MyWidgetState createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  @override
  void initState() {
    super.initState();
    
    // 리스너 추가
    GAppLifecycle.addListener((state) {
      switch (state) {
        case AppLifecycleState.resumed:
          print('[App] 다시 포그라운드');
          break;
        case AppLifecycleState.paused:
          print('[App] 백그라운드로 전환됨');
          break;
        case AppLifecycleState.inactive:
          print('[App] 비활성 상태');
          break;
        case AppLifecycleState.detached:
          print('[App] 프로세스 분리');
          break;
        case AppLifecycleState.hidden:
          print('[App] 숨겨짐 (Android 12+)');
          break;
      }
    });
  }

  @override
  void dispose() {
    // 리스너 제거
    GAppLifecycle.removeListener(_onLifecycleChanged);
    super.dispose();
  }

  void _onLifecycleChanged(AppLifecycleState state) {
    // 라이프사이클 변경 처리
  }
}
```

### 4. Stream 사용 (Riverpod)

```dart
// Riverpod Provider
final appLifecycleProvider = StreamProvider<GAppLifecycleState>((ref) {
  return GAppLifecycle.stateStream;
});

// 사용
class MyWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lifecycle = ref.watch(appLifecycleProvider);
    
    return lifecycle.when(
      data: (state) {
        if (state.isResumedFromBackground) {
          // 백그라운드에서 포그라운드로 복귀 시 처리
        }
        return Text('Current state: ${state.currentState}');
      },
      error: (error, stackTrace) => const SizedBox.shrink(),
      loading: () => const CircularProgressIndicator(),
    );
  }
}
```

### 5. 상태 확인

```dart
// 현재 상태 확인
if (GAppLifecycle.isForeground) {
  // 포그라운드에 있을 때
}

if (GAppLifecycle.isBackground) {
  // 백그라운드에 있을 때
}

// 특정 상태 확인
if (GAppLifecycle.isResumed) {
  // 포그라운드
}

if (GAppLifecycle.isPaused) {
  // 백그라운드
}
```

### 6. 서비스 확장

```dart
class CustomAppLifecycleService extends GAppLifecycleService {
  @override
  void onStateChanged(GAppLifecycleState state) {
    super.onStateChanged(state);
    
    // 커스텀 로직 추가
    if (state.isResumedFromBackground) {
      // 데이터 동기화
      _syncData();
    }
    
    if (state.isPausedFromForeground) {
      // 데이터 저장
      _saveData();
    }
  }
  
  void _syncData() {
    // 데이터 동기화 로직
  }
  
  void _saveData() {
    // 데이터 저장 로직
  }
}
```

## 구조

```
app_lifecycle/
├── common/
│   ├── g_app_lifecycle_option.dart    # 옵션 정의
│   └── g_app_lifecycle_state.dart     # 상태 관리
├── context/
│   └── g_app_lifecycle_context.dart   # 컨텍스트
├── facade/
│   └── g_app_lifecycle.dart          # Facade 패턴
├── service/
│   └── g_app_lifecycle_service.dart   # 서비스 로직
├── g_app_lifecycle_initializer.dart   # 초기화
└── app_lifecycle.dart                 # Export
```

## 특징

- **Clean Architecture**: 각 레이어가 명확히 분리되어 있습니다.
- **Singleton Pattern**: 전역적으로 앱 라이프사이클을 관리합니다.
- **Stream Support**: Riverpod, Bloc 등과 함께 사용할 수 있습니다.
- **Extensible**: 서비스를 확장하여 커스텀 로직을 추가할 수 있습니다.
- **Debug Support**: 디버그 모드를 통해 상태 변경을 추적할 수 있습니다.
