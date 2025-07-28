# BIOMETRIC

Flutter 앱에서 생체인식(지문, Face ID 등) 기능을 쉽게 구현할 수 있는 모듈입니다.

## 📋 목차

- [개요](#개요)
- [설치](#설치)
- [초기화](#초기화)
- [기본 사용법](#기본-사용법)
- [고급 사용법](#고급-사용법)
- [상황별 사용법](#상황별-사용법)
- [API 참조](#api-참조)
- [예제](#예제)

## 🎯 개요

`biometric` 모듈은 다음과 같은 구조로 구성되어 있습니다:

- **`GBiometric`**: 메인 Facade 클래스 (정적 메서드 제공)
- **`GBiometricInitializer`**: 초기화 관리 (GInitializer 상속)
- **`GBiometricService`**: 추상 서비스 인터페이스
- **`GBiometricImpl`**: 구체적 구현체

## 📦 설치

### 1. 의존성 추가

```yaml
dependencies:
  local_auth: ^2.1.8
  g_plugin:
    path: ../g_plugin
```

### 2. import 추가

```dart
import 'package:g_plugin/biometric/biometric.dart';
```

## 🚀 초기화

### 기본 초기화

가장 간단한 초기화 방법입니다:

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // 기본 초기화
  await GBiometric.initialize();
  
  runApp(MyApp());
}
```

## 📖 기본 사용법

### 1. 디바이스 지원 확인

```dart
// 생체인식 하드웨어 지원 확인
if (await GBiometric.isDeviceSupported()) {
  print('이 디바이스는 생체인식을 지원합니다');
}

// 생체인식 사용 가능 여부 확인 (하드웨어 + 등록된 생체정보)
if (await GBiometric.canCheckBiometrics()) {
  print('생체인식을 사용할 수 있습니다');
}
```

### 2. 사용 가능한 생체인식 타입 확인

```dart
// 사용 가능한 생체인식 타입 목록
final biometrics = await GBiometric.availableBiometrics();
print('사용 가능한 생체인식: $biometrics');
// 예: [BiometricType.fingerprint, BiometricType.face]
```

### 3. 생체인식 인증

```dart
// 기본 인증
final success = await GBiometric.authenticate(
  localizedReason: '로그인을 위해 생체인식을 확인해주세요',
);

if (success) {
  print('인증 성공');
} else {
  print('인증 실패');
}
```

### 4. 고급 인증 옵션

```dart
// 모든 옵션을 사용한 인증
final success = await GBiometric.authenticate(
  localizedReason: '보안을 위해 생체인식을 확인해주세요',
  biometricOnly: false,  // 생체인식 외 다른 방법도 허용
  stickyAuth: true,      // 인증 상태 유지
);
```

## 🔧 고급 사용법

### 1. 생체인식 타입별 처리

```dart
final biometrics = await GBiometric.availableBiometrics();

if (biometrics.contains(BiometricType.fingerprint)) {
  print('지문 인식 사용 가능');
}

if (biometrics.contains(BiometricType.face)) {
  print('Face ID 사용 가능');
}

if (biometrics.contains(BiometricType.iris)) {
  print('홍채 인식 사용 가능');
}
```

### 2. 에러 처리

```dart
try {
  final success = await GBiometric.authenticate(
    localizedReason: '인증을 진행해주세요',
  );
  
  if (success) {
    // 인증 성공 처리
  } else {
    // 인증 실패 처리
  }
} catch (e) {
  if (e is PlatformException) {
    switch (e.code) {
      case 'NotAvailable':
        print('생체인식을 사용할 수 없습니다');
        break;
      case 'NotEnrolled':
        print('등록된 생체인식이 없습니다');
        break;
      case 'PasscodeNotSet':
        print('기기 잠금이 설정되지 않았습니다');
        break;
      case 'PermanentlyLocked':
        print('생체인식이 영구적으로 잠겼습니다');
        break;
      default:
        print('알 수 없는 오류: ${e.message}');
    }
  }
}
```

## 🎯 상황별 사용법

### 1. 로그인 앱

```dart
class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isBiometricAvailable = false;

  @override
  void initState() {
    super.initState();
    _checkBiometricAvailability();
  }

  Future<void> _checkBiometricAvailability() async {
    final isSupported = await GBiometric.isDeviceSupported();
    final canCheck = await GBiometric.canCheckBiometrics();
    
    setState(() {
      _isBiometricAvailable = isSupported && canCheck;
    });
  }

  Future<void> _authenticateWithBiometric() async {
    try {
      final success = await GBiometric.authenticate(
        localizedReason: '로그인을 위해 생체인식을 확인해주세요',
      );
      
      if (success) {
        // 로그인 성공 처리
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        // 인증 실패 처리
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('인증에 실패했습니다')),
        );
      }
    } catch (e) {
      // 에러 처리
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('생체인식 인증 중 오류가 발생했습니다')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('로그인')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_isBiometricAvailable)
              ElevatedButton(
                onPressed: _authenticateWithBiometric,
                child: Text('생체인식으로 로그인'),
              ),
            // 기타 로그인 방법들...
          ],
        ),
      ),
    );
  }
}
```

### 2. 보안 앱

```dart
class SecurityScreen extends StatefulWidget {
  @override
  _SecurityScreenState createState() => _SecurityScreenState();
}

class _SecurityScreenState extends State<SecurityScreen> {
  Future<void> _unlockWithBiometric() async {
    try {
      final success = await GBiometric.authenticate(
        localizedReason: '보안을 위해 생체인식을 확인해주세요',
        biometricOnly: true,  // 생체인식만 허용
        stickyAuth: true,     // 인증 상태 유지
      );
      
      if (success) {
        // 보안 기능 해제
        _showSecureContent();
      } else {
        // 인증 실패
        _showLockedMessage();
      }
    } catch (e) {
      // 에러 처리
      _showErrorMessage();
    }
  }

  void _showSecureContent() {
    // 보안 콘텐츠 표시
  }

  void _showLockedMessage() {
    // 잠금 메시지 표시
  }

  void _showErrorMessage() {
    // 에러 메시지 표시
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('보안')),
      body: Center(
        child: ElevatedButton(
          onPressed: _unlockWithBiometric,
          child: Text('생체인식으로 잠금 해제'),
        ),
      ),
    );
  }
}
```

### 3. 결제 앱

```dart
class PaymentScreen extends StatefulWidget {
  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  Future<void> _confirmPaymentWithBiometric() async {
    try {
      final success = await GBiometric.authenticate(
        localizedReason: '결제를 위해 생체인식을 확인해주세요',
        biometricOnly: false,  // 다른 방법도 허용
      );
      
      if (success) {
        // 결제 진행
        _processPayment();
      } else {
        // 결제 취소
        _cancelPayment();
      }
    } catch (e) {
      // 에러 처리
      _showPaymentError();
    }
  }

  void _processPayment() {
    // 결제 처리 로직
  }

  void _cancelPayment() {
    // 결제 취소 처리
  }

  void _showPaymentError() {
    // 결제 에러 표시
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('결제')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('결제 금액: 10,000원'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _confirmPaymentWithBiometric,
              child: Text('생체인식으로 결제'),
            ),
          ],
        ),
      ),
    );
  }
}
```

## 📚 API 참조

### GBiometric (Facade)

#### 초기화 메서드

```dart
// 기본 초기화
static Future<void> initialize()
```

#### 상태 확인 메서드

```dart
static bool get isInitialized
```

#### 디바이스 지원 확인 메서드

```dart
// 디바이스가 생체인식을 지원하는지 확인
static Future<bool> isDeviceSupported()

// 생체인식을 사용할 수 있는지 확인
static Future<bool> canCheckBiometrics()

// 사용 가능한 생체인식 타입 목록
static Future<List<BiometricType>> availableBiometrics()
```

#### 인증 메서드

```dart
// 생체인식 인증
static Future<bool> authenticate({
  required String localizedReason,
  bool biometricOnly = true,
  bool stickyAuth = false,
})
```

#### 정리 메서드

```dart
// 서비스 정리
static Future<void> dispose()
```

### BiometricType (enum)

```dart
enum BiometricType {
  fingerprint,  // 지문
  face,         // Face ID
  iris,         // 홍채
  weak,         // 약한 생체인식
  strong,       // 강한 생체인식
}
```

## 💡 예제

### 완전한 예제 앱

```dart
import 'package:flutter/material.dart';
import 'package:g_plugin/biometric/biometric.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // 생체인식 초기화
  await GBiometric.initialize();
  
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '생체인식 예제',
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isBiometricAvailable = false;
  String _authResult = '';

  @override
  void initState() {
    super.initState();
    _checkBiometricAvailability();
  }

  Future<void> _checkBiometricAvailability() async {
    final isSupported = await GBiometric.isDeviceSupported();
    final canCheck = await GBiometric.canCheckBiometrics();
    
    setState(() {
      _isBiometricAvailable = isSupported && canCheck;
    });
  }

  Future<void> _authenticate() async {
    try {
      final success = await GBiometric.authenticate(
        localizedReason: '테스트를 위해 생체인식을 확인해주세요',
      );
      
      setState(() {
        _authResult = success ? '인증 성공!' : '인증 실패';
      });
    } catch (e) {
      setState(() {
        _authResult = '오류: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('생체인식 테스트')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('생체인식 사용 가능: $_isBiometricAvailable'),
            SizedBox(height: 20),
            if (_isBiometricAvailable)
              ElevatedButton(
                onPressed: _authenticate,
                child: Text('생체인식 인증'),
              ),
            SizedBox(height: 20),
            Text(_authResult),
          ],
        ),
      ),
    );
  }
}
```

## ⚠️ 주의사항

1. **초기화 순서**: `WidgetsFlutterBinding.ensureInitialized()`를 먼저 호출해야 합니다.
2. **플랫폼 설정**: Android와 iOS에서 생체인식을 사용하려면 추가 설정이 필요합니다.
3. **권한 설정**: Android에서는 `android/app/src/main/AndroidManifest.xml`에 권한을 추가해야 합니다.
4. **iOS 설정**: iOS에서는 `ios/Runner/Info.plist`에 권한 설명을 추가해야 합니다.
5. **에러 처리**: 생체인식은 사용자 상호작용이 필요하므로 적절한 에러 처리가 중요합니다.

## 🔗 관련 링크

- [local_auth 패키지](https://pub.dev/packages/local_auth)
- [Flutter 생체인식 가이드](https://docs.flutter.dev/development/ui/navigation/deep-linking) 