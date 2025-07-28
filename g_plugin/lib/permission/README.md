# Permission Plugin

Flutter 앱에서 권한 관리를 위한 플러그인입니다. `permission_handler` 패키지를 기반으로 하며, 플랫폼별 권한 처리를 추상화하여 제공합니다.

## 주요 기능

- **플랫폼별 권한 처리**: Android, iOS, macOS, Web 지원
- **권한 상태 추적**: 권한 상태를 실시간으로 추적하고 관리
- **권한 요청 전략**: 다양한 권한 요청 전략 제공
- **간편한 API**: Facade 패턴을 통한 간편한 사용법
- **에러 처리**: 포괄적인 에러 처리 및 로깅

## 설치

`pubspec.yaml`에 다음 의존성을 추가하세요:

```yaml
dependencies:
  permission_handler: ^11.0.0
```

## 초기화

앱 시작 시 한 번만 초기화하세요:

```dart
import 'package:g_plugin/permission/permission.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // 권한 플러그인 초기화
  await GPermission.initialize();
  
  runApp(MyApp());
}
```

## 기본 사용법

### 단일 권한 요청

```dart
// 기본 권한 요청
final result = await GPermission.request(PermissionType.camera);

if (result.isGranted) {
  print('카메라 권한이 허용되었습니다.');
} else {
  print('카메라 권한이 거부되었습니다: ${result.errorMessage}');
}
```

### 상세한 권한 요청

```dart
final request = PermissionRequest.detailed(
  type: PermissionType.camera,
  reason: '사진 촬영을 위해 카메라 권한이 필요합니다.',
  description: '사진을 촬영하여 프로필 사진으로 설정할 수 있습니다.',
  deniedMessage: '카메라 권한이 거부되었습니다.',
  permanentlyDeniedMessage: '카메라 권한이 영구적으로 거부되었습니다.',
  failedMessage: '카메라 권한 요청에 실패했습니다.',
  showRationale: true,
  openSettingsOnDenied: true,
  maxRetryCount: 3,
);

final result = await GPermission.requestPermission(request);
```

### 다중 권한 요청

```dart
// 간편한 다중 권한 요청
final results = await GPermission.requestMultiple([
  PermissionType.camera,
  PermissionType.microphone,
  PermissionType.location,
]);

// 상세한 다중 권한 요청
final requests = [
  PermissionRequest.detailed(
    type: PermissionType.camera,
    reason: '사진 촬영을 위해 카메라 권한이 필요합니다.',
  ),
  PermissionRequest.detailed(
    type: PermissionType.microphone,
    reason: '음성 녹음을 위해 마이크 권한이 필요합니다.',
  ),
];

final results = await GPermission.requestMultiplePermissions(requests);
```

### 권한 상태 확인

```dart
// 단일 권한 상태 확인
final status = await GPermission.checkPermission(PermissionType.camera);

// 다중 권한 상태 확인
final statuses = await GPermission.checkMultiplePermissions([
  PermissionType.camera,
  PermissionType.microphone,
]);

// 권한 허용 여부 확인
final isGranted = await GPermission.isPermissionGranted(PermissionType.camera);

// 권한 거부 여부 확인
final isDenied = await GPermission.isPermissionDenied(PermissionType.camera);

// 권한 영구 거부 여부 확인
final isPermanentlyDenied = await GPermission.isPermissionPermanentlyDenied(PermissionType.camera);

// 권한 제한 여부 확인
final isRestricted = await GPermission.isPermissionRestricted(PermissionType.camera);

// 권한 사용 불가 여부 확인
final isUnavailable = await GPermission.isPermissionUnavailable(PermissionType.camera);
```

### 설정 화면 열기

```dart
// 앱 설정 화면 열기
await GPermission.openAppSettings();

// 권한 설정 화면 열기
await GPermission.openPermissionSettings();
```

## 고급 사용법

### 권한 상태 추적기 사용

```dart
final stateTracker = GPermission.stateTracker;

// 권한 상태 업데이트
stateTracker.updatePermissionState(PermissionType.camera, PermissionStatus.granted);

// 권한 상태 가져오기
final status = stateTracker.getPermissionState(PermissionType.camera);

// 거부된 권한 목록
final deniedPermissions = stateTracker.getDeniedPermissions();

// 허용된 권한 목록
final grantedPermissions = stateTracker.getGrantedPermissions();

// 영구 거부된 권한 목록
final permanentlyDeniedPermissions = stateTracker.getPermanentlyDeniedPermissions();

// 모든 상태 초기화
stateTracker.clearAllStates();
```

### 권한 요청 전략 사용

```dart
final requestStrategy = GPermission.requestStrategy;

// 점진적 권한 요청
final results = await requestStrategy.requestPermissionsProgressively([
  PermissionRequest.basic(PermissionType.camera),
  PermissionRequest.basic(PermissionType.microphone),
]);

// 컨텍스트 기반 권한 요청
final result = await requestStrategy.requestPermissionWithContext(
  PermissionRequest.basic(PermissionType.camera),
  '사진 촬영 화면',
);

// 최적 타이밍 권한 요청
final result = await requestStrategy.requestPermissionAtOptimalTime(
  PermissionRequest.basic(PermissionType.camera),
);

// 권한 요청 재시도
final result = await requestStrategy.retryPermissionRequest(
  PermissionRequest.basic(PermissionType.camera),
  3, // 최대 재시도 횟수
);
```

## API 참조

### GPermission (Facade)

#### 초기화 및 정리
- `initialize()`: 권한 서비스 초기화
- `dispose()`: 권한 서비스 정리
- `isInitialized`: 초기화 상태 확인

#### 권한 상태 확인
- `checkPermission(PermissionType type)`: 단일 권한 상태 확인
- `checkMultiplePermissions(List<PermissionType> types)`: 다중 권한 상태 확인
- `isPermissionGranted(PermissionType type)`: 권한 허용 여부 확인
- `isPermissionDenied(PermissionType type)`: 권한 거부 여부 확인
- `isPermissionPermanentlyDenied(PermissionType type)`: 권한 영구 거부 여부 확인
- `isPermissionRestricted(PermissionType type)`: 권한 제한 여부 확인
- `isPermissionUnavailable(PermissionType type)`: 권한 사용 불가 여부 확인

#### 권한 요청
- `requestPermission(PermissionRequest request)`: 단일 권한 요청
- `requestMultiplePermissions(List<PermissionRequest> requests)`: 다중 권한 요청
- `request(PermissionType type, {String? reason})`: 간편한 권한 요청
- `requestMultiple(List<PermissionType> types, {String? reason})`: 간편한 다중 권한 요청

#### 설정 화면
- `openAppSettings()`: 앱 설정 화면 열기
- `openPermissionSettings()`: 권한 설정 화면 열기
- `shouldShowRequestRationale(PermissionType type)`: 권한 요청 rationale 표시 여부 확인

#### 기타
- `getAvailablePermissionsForPlatform()`: 현재 플랫폼에서 사용 가능한 권한 목록
- `stateTracker`: 권한 상태 추적기
- `requestStrategy`: 권한 요청 전략

### PermissionType

#### 공통 권한
- `camera`: 카메라 권한
- `microphone`: 마이크 권한
- `storage`: 저장소 권한
- `location`: 위치 권한
- `notification`: 알림 권한

#### Android 특화 권한
- `androidPhone`: 전화 권한
- `androidSms`: SMS 권한
- `androidContacts`: 연락처 권한
- `androidCalendar`: 캘린더 권한
- `androidSensors`: 센서 권한
- `androidActivityRecognition`: 활동 인식 권한

#### iOS 특화 권한
- `iosPhotos`: 사진 권한
- `iosCalendar`: 캘린더 권한
- `iosReminders`: 알림 권한
- `iosContacts`: 연락처 권한
- `iosMediaLibrary`: 미디어 라이브러리 권한
- `iosSpeech`: 음성 인식 권한

#### macOS 특화 권한
- `macosPhotos`: 사진 권한
- `macosCalendar`: 캘린더 권한
- `macosReminders`: 알림 권한
- `macosContacts`: 연락처 권한
- `macosMediaLibrary`: 미디어 라이브러리 권한
- `macosSpeech`: 음성 인식 권한

#### Web 특화 권한
- `webClipboard`: 클립보드 권한
- `webPayment`: 결제 권한
- `webUsb`: USB 권한
- `webBluetooth`: 블루투스 권한

### PermissionStatus

- `denied`: 권한이 거부됨
- `granted`: 권한이 허용됨
- `restricted`: 권한이 제한됨 (iOS)
- `permanentlyDenied`: 권한이 영구적으로 거부됨
- `limited`: 권한이 제한적으로 허용됨 (iOS 14+)
- `provisional`: 권한이 임시로 허용됨 (iOS 14+)
- `unavailable`: 권한이 사용 불가능함
- `unknown`: 권한 상태를 알 수 없음

### PermissionRequest

#### 생성자
- `PermissionRequest.basic(PermissionType type)`: 기본 권한 요청 생성
- `PermissionRequest.detailed(...)`: 상세한 권한 요청 생성

#### 속성
- `type`: 요청할 권한 타입
- `reason`: 권한 요청 이유
- `description`: 권한 요청 설명
- `deniedMessage`: 권한 거부 시 메시지
- `permanentlyDeniedMessage`: 권한 영구 거부 시 메시지
- `failedMessage`: 권한 요청 실패 시 메시지
- `showRationale`: rationale 표시 여부
- `openSettingsOnDenied`: 거부 시 설정 화면 열기 여부
- `maxRetryCount`: 최대 재시도 횟수

### PermissionResult

#### 생성자
- `PermissionResult.success(PermissionType type, int attemptCount)`: 성공 결과 생성
- `PermissionResult.failure(...)`: 실패 결과 생성

#### 속성
- `type`: 권한 타입
- `status`: 권한 상태
- `isGranted`: 권한 허용 여부
- `isDenied`: 권한 거부 여부
- `isPermanentlyDenied`: 권한 영구 거부 여부
- `errorMessage`: 에러 메시지
- `attemptCount`: 시도 횟수

## 플랫폼별 설정

### Android

`android/app/src/main/AndroidManifest.xml`에 필요한 권한을 추가하세요:

```xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android">
    <!-- 카메라 권한 -->
    <uses-permission android:name="android.permission.CAMERA" />
    
    <!-- 마이크 권한 -->
    <uses-permission android:name="android.permission.RECORD_AUDIO" />
    
    <!-- 저장소 권한 -->
    <uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" />
    <uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" />
    
    <!-- 위치 권한 -->
    <uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
    <uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
    
    <!-- 기타 권한들... -->
</manifest>
```

### iOS

`ios/Runner/Info.plist`에 권한 설명을 추가하세요:

```xml
<dict>
    <!-- 카메라 권한 설명 -->
    <key>NSCameraUsageDescription</key>
    <string>사진 촬영을 위해 카메라 권한이 필요합니다.</string>
    
    <!-- 마이크 권한 설명 -->
    <key>NSMicrophoneUsageDescription</key>
    <string>음성 녹음을 위해 마이크 권한이 필요합니다.</string>
    
    <!-- 사진 권한 설명 -->
    <key>NSPhotoLibraryUsageDescription</key>
    <string>사진 선택을 위해 사진 라이브러리 권한이 필요합니다.</string>
    
    <!-- 위치 권한 설명 -->
    <key>NSLocationWhenInUseUsageDescription</key>
    <string>현재 위치 확인을 위해 위치 권한이 필요합니다.</string>
    
    <!-- 기타 권한 설명들... -->
</dict>
```

### macOS

`macos/Runner/Info.plist`에 권한 설명을 추가하세요:

```xml
<dict>
    <!-- 카메라 권한 설명 -->
    <key>NSCameraUsageDescription</key>
    <string>사진 촬영을 위해 카메라 권한이 필요합니다.</string>
    
    <!-- 마이크 권한 설명 -->
    <key>NSMicrophoneUsageDescription</key>
    <string>음성 녹음을 위해 마이크 권한이 필요합니다.</string>
    
    <!-- 기타 권한 설명들... -->
</dict>
```

## 에러 처리

권한 요청 시 발생할 수 있는 에러들을 적절히 처리하세요:

```dart
try {
  final result = await GPermission.request(PermissionType.camera);
  
  if (result.isGranted) {
    // 권한이 허용된 경우
    print('카메라 권한이 허용되었습니다.');
  } else if (result.isPermanentlyDenied) {
    // 권한이 영구적으로 거부된 경우
    print('카메라 권한이 영구적으로 거부되었습니다.');
    // 설정 화면으로 이동하는 다이얼로그 표시
    await _showSettingsDialog();
  } else {
    // 권한이 거부된 경우
    print('카메라 권한이 거부되었습니다: ${result.errorMessage}');
  }
} catch (e) {
  // 예외 발생 시 처리
  print('권한 요청 중 오류가 발생했습니다: $e');
}
```

## 구현된 기능

### 완료된 구현

1. **모델 클래스들**
   - `PermissionType`: 권한 타입 enum
   - `PermissionStatus`: 권한 상태 enum
   - `PermissionRequest`: 권한 요청 모델
   - `PermissionResult`: 권한 요청 결과 모델

2. **플랫폼별 구현체**
   - `AndroidPermission`: Android 권한 처리
   - `IOSPermission`: iOS 권한 처리
   - `MacOSPermission`: macOS 권한 처리
   - `WebPermission`: Web 권한 처리

3. **서비스 구현체**
   - `GPermissionImpl`: 메인 권한 서비스 구현
   - `PermissionStateTrackerImpl`: 권한 상태 추적기 구현
   - `PermissionRequestStrategyImpl`: 권한 요청 전략 구현

4. **초기화 및 Facade**
   - `GPermissionInitializer`: 권한 서비스 초기화
   - `GPermission`: 사용자 친화적인 Facade 인터페이스

5. **테스트**
   - 포괄적인 단위 테스트 구현
   - 모든 주요 기능에 대한 테스트 케이스

### 미구현된 기능

1. **권한 요청 전략의 실제 연결**
   - `PermissionRequestStrategyImpl`의 `_requestSinglePermission` 메서드가 실제 권한 요청 로직과 연결되지 않음
   - 현재는 기본적인 실패 결과만 반환

2. **Web 특화 권한 처리**
   - Web 특화 권한들(`webClipboard`, `webPayment`, `webUsb`, `webBluetooth`)은 브라우저 API를 직접 사용해야 함
   - 현재는 `UnsupportedError`를 발생시킴

3. **고급 권한 요청 전략**
   - 컨텍스트 기반 권한 요청
   - 최적 타이밍 권한 요청
   - 사용자 행동 패턴 분석

## 주의사항

1. **초기화**: 앱 시작 시 반드시 `GPermission.initialize()`를 호출하세요.
2. **플랫폼별 권한**: 각 플랫폼에서 지원하는 권한이 다를 수 있습니다.
3. **권한 설명**: iOS와 macOS에서는 권한 요청 시 설명이 필수입니다.
4. **Web 권한**: Web 특화 권한들은 별도의 브라우저 API를 사용해야 합니다.
5. **에러 처리**: 권한 요청 실패 시 적절한 에러 처리를 구현하세요.
6. **사용자 경험**: 권한 요청 시 사용자에게 명확한 이유를 설명하세요.
7. **테스트 환경**: 테스트 시 `MissingPluginException`이 발생할 수 있습니다.

## 예제

전체 예제는 `test/permission_test.dart` 파일을 참조하세요. 