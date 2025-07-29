# GNetwork 모듈

네트워크 통신을 위한 전략 패턴 기반 모듈입니다.

## 구조

```
network/
├── common/           # 공통 타입과 옵션
├── context/          # 네트워크 컨텍스트
├── facade/           # 간단한 인터페이스
├── factory/          # 객체 생성 팩토리
├── strategy/         # 전략 인터페이스와 구현체
└── g_network_initializer.dart  # 초기화
```

## 초기화

### 1. 기본 초기화

```dart
import 'package:g_core/network/g_network_initializer.dart';

// 모든 전략 초기화
final initializer = GNetworkInitializer();
await initializer.initialize();

// 또는 헬퍼 사용
final initializer = GNetworkInitializerHelper.all();
await initializer.initialize();
```

### 2. 특정 전략만 초기화

```dart
// HTTP만 초기화
final httpInitializer = GNetworkInitializerHelper.http();
await httpInitializer.initialize();

// Socket만 초기화
final socketInitializer = GNetworkInitializerHelper.socket();
await socketInitializer.initialize();
```

### 3. 고급 설정으로 초기화

```dart
import 'package:g_core/network/common/g_network_option.dart';

// HTTP 옵션 설정
final httpOptions = HttpNetworkOption(
  baseUrl: 'https://api.example.com',
  timeout: Duration(seconds: 30),
  defaultHeaders: {'Authorization': 'Bearer token'},
);

// Socket 옵션 설정
final socketOptions = SocketNetworkOption(
  baseUrl: 'wss://socket.example.com',
  token: 'your-socket-token',
);

// 모든 전략 초기화
final initializer = GNetworkInitializer(
  httpOptions: httpOptions,
  socketOptions: socketOptions,
  autoConnect: true, // Socket 자동 연결
);
await initializer.initialize();
```

### 4. 초기화 상태 확인

```dart
// 초기화 상태 확인
if (GNetworkInitializer.isInitialized) {
  print('Network is initialized');
}

// 연결 상태 확인
if (GNetworkInitializer.isConnected) {
  print('Network is connected');
}
```

### 5. 정리

```dart
// 리소스 정리
await GNetworkInitializer.dispose();

// 테스트용 리셋
GNetworkInitializer.reset();
```

## 사용법

### 1. 기본 사용법

```dart
import 'package:g_core/network/facade/g_network.dart';

// 기본 초기화
GNetwork.initialize();

// HTTP 요청
final response = await GNetwork.get<User>(
  path: '/api/users/1',
  fromJsonT: User.fromJson,
);

// Socket 연결
await GNetwork.connect();
GNetwork.on(event: 'message', handler: (data) {
  print('Received: $data');
});
```

### 2. 고급 설정

```dart
import 'package:g_core/network/facade/g_network.dart';
import 'package:g_core/network/common/g_network_option.dart';

// HTTP 옵션 설정
final httpOptions = HttpNetworkOption(
  baseUrl: 'https://api.example.com',
  timeout: Duration(seconds: 30),
  defaultHeaders: {'Authorization': 'Bearer token'},
);

// Socket 옵션 설정
final socketOptions = SocketNetworkOption(
  baseUrl: 'wss://socket.example.com',
  token: 'your-socket-token',
);

// 초기화
GNetwork.initialize(
  httpOptions: httpOptions,
  socketOptions: socketOptions,
);
```

### 3. 전략 전환

```dart
// HTTP로 전환
await GNetwork.switchTo(type: GNetworkType.http);

// Socket으로 전환
await GNetwork.switchTo(type: GNetworkType.socket);
```

### 4. 직접 컨텍스트 사용

```dart
import 'package:g_core/network/factory/g_network_factory.dart';
import 'package:g_core/network/context/g_network_context.dart';

// 팩토리를 통한 생성
final context = GNetworkFactory.createContext();

// 또는 직접 생성
final httpStrategy = GNetworkFactory.createHttpStrategy();
final socketStrategy = GNetworkFactory.createSocketStrategy();
final context = GNetworkContext(
  httpStrategy: httpStrategy,
  socketStrategy: socketStrategy,
);
```

## 주요 클래스

### GNetworkInitializer
- 네트워크 모듈 초기화 담당
- 다양한 설정 옵션 지원
- 스레드 안전한 초기화
- 자동 연결 기능

### GNetworkContext
- HTTP와 Socket 전략을 관리
- 요청을 적절한 전략으로 위임
- 전략 전환 기능 제공

### GNetworkFactory
- 전략 객체 생성
- 컨텍스트 구성
- 기본 설정 제공

### GNetwork (Facade)
- 간단한 정적 인터페이스
- 싱글톤 패턴
- 초기화 및 설정 관리

## 전략 패턴 구조

```
GNetworkStrategy (추상)
├── GHttpStrategy (추상)
│   └── GHttpNetworkStrategy (구현)
└── GSocketStrategy (추상)
    └── GSocketNetworkStrategy (구현)
```

## 에러 처리

모든 네트워크 요청은 `GEither<GException, GResponse<T>>`를 반환합니다:

```dart
final result = await GNetwork.get<User>('/api/users/1');
result.fold(
  (exception) => print('Error: ${exception.message}'),
  (response) => print('Success: ${response.data}'),
);
```

## 연결 상태 확인

```dart
if (GNetwork.isConnected) {
  // 연결된 상태에서 작업
}
```

## 초기화 모범 사례

### 1. 앱 시작 시 초기화

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // 네트워크 초기화
  final networkInitializer = GNetworkInitializerHelper.all(
    httpOptions: HttpNetworkOption(
      baseUrl: 'https://api.example.com',
      timeout: Duration(seconds: 30),
    ),
    socketOptions: SocketNetworkOption(
      baseUrl: 'wss://socket.example.com',
    ),
    autoConnect: true,
  );
  
  await networkInitializer.initialize();
  
  runApp(MyApp());
}
```

### 2. 테스트 환경

```dart
// 테스트 전 리셋
GNetworkInitializer.reset();

// 테스트용 초기화
final testInitializer = GNetworkInitializerHelper.http();
await testInitializer.initialize();

// 테스트 후 정리
await GNetworkInitializer.dispose();
``` 