# HomeWidget 모듈

HomeWidget 기능을 제공하는 g_kit 플러그인 모듈입니다.

## 기능

- iOS 및 Android 홈 스크린 위젯 지원
- WorkManager를 사용한 백그라운드 업데이트
- 위젯 데이터 저장/조회
- 위젯 상호작용 처리
- Flutter 위젯 렌더링

## 사용법

### 1. 초기화

```dart
import 'package:g_plugin/home_widget/home_widget.dart';

final homeWidgetInitializer = GHomeWidgetInitializer(
  appGroupId: 'group.mome.app',
  iOSWidgetKind: 'Mome',
  androidProviderSimpleName: 'StickyNoteWidgetProvider',
  enableBackgroundUpdates: true,
);

await homeWidgetInitializer.initialize();
```

### 2. 기본 사용법

```dart
// 데이터 저장
await GHomeWidget.saveData('title', 'Hello World');
await GHomeWidget.saveData('message', 'This is a test message');

// 데이터 조회
final title = await GHomeWidget.getData('title');
final message = await GHomeWidget.getData('message');

// 위젯 업데이트 요청
await GHomeWidget.requestUpdate();
```

### 3. 편의 메서드

```dart
// 노트 저장/조회
await GHomeWidget.saveNote('note1', 'My note content');
final note = await GHomeWidget.getNote('note1');

// 여러 데이터 한번에 저장
await GHomeWidget.saveMultipleData({
  'title': 'Hello',
  'message': 'World',
  'timestamp': DateTime.now().toIso8601String(),
});

// 데이터 저장 후 자동 업데이트
await GHomeWidget.saveDataAndUpdate('status', 'updated');
```

### 4. 백그라운드 업데이트

```dart
// 백그라운드 업데이트 시작 (15분 간격)
await homeWidgetInitializer.startBackgroundUpdates();

// 백그라운드 업데이트 중지
await homeWidgetInitializer.stopBackgroundUpdates();
```

### 5. 위젯 상호작용

```dart
// 위젯 클릭 이벤트 처리
GHomeWidget.widgetClicked.listen((Uri? uri) {
  if (uri != null) {
    print('위젯에서 클릭: $uri');
  }
});

// 앱이 위젯에서 시작되었는지 확인
final launchUri = await GHomeWidget.initiallyLaunchedFromHomeWidget();
if (launchUri != null) {
  print('위젯에서 앱 시작: $launchUri');
}
```

### 6. Flutter 위젯 렌더링

```dart
await GHomeWidget.renderFlutterWidget(
  const Icon(Icons.star, size: 50),
  logicalSize: const Size(50, 50),
  key: 'starIcon',
);
```

## 설정

### iOS 설정

1. App Group 설정이 필요합니다.
2. Widget Extension을 생성하고 위젯을 구현해야 합니다.

### Android 설정

1. Glance 위젯을 구현해야 합니다.
2. WorkManager를 사용한 백그라운드 업데이트가 지원됩니다.

## 의존성

- `home_widget`: 홈 스크린 위젯 기능
- `workmanager`: 백그라운드 업데이트 (Android)
- `g_common`: 유틸리티 함수들
- `g_model`: 초기화 시스템


