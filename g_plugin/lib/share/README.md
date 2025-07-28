# Share Plugin

Flutter 앱에서 콘텐츠 공유 기능을 위한 플러그인입니다. `share_plus` 패키지를 기반으로 하며, 텍스트, 파일, 이미지, 링크 공유를 지원합니다.

## 주요 기능

- **다양한 콘텐츠 공유**: 텍스트, 파일, 이미지, 링크 공유 지원
- **플랫폼별 최적화**: Android, iOS, macOS, Web 지원
- **간편한 API**: Facade 패턴을 통한 간편한 사용법
- **에러 처리**: 표준적인 try-catch 에러 처리
- **간결한 코드**: 불필요한 래핑 제거

## 설치

`pubspec.yaml`에 다음 의존성을 추가하세요:

```yaml
dependencies:
  share_plus: ^7.2.1
```

## 초기화

앱 시작 시 한 번만 초기화하세요:

```dart
import 'package:g_plugin/share/share.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // 공유 플러그인 초기화
  await GShare.initialize();
  
  runApp(MyApp());
}
```

## 기본 사용법

### 텍스트 공유

```dart
// 기본 텍스트 공유
try {
  await GShare.text('공유할 텍스트입니다.');
  print('텍스트가 성공적으로 공유되었습니다.');
} catch (e) {
  print('텍스트 공유에 실패했습니다: $e');
}

// 제목과 주제가 포함된 텍스트 공유
try {
  await GShare.text(
    '공유할 텍스트입니다.',
    title: '공유 제목',
    subject: '공유 주제',
  );
} catch (e) {
  print('공유에 실패했습니다: $e');
}
```

### 파일 공유

```dart
// 파일 공유
try {
  await GShare.files([
    '/path/to/file1.txt',
    '/path/to/file2.pdf',
  ]);
} catch (e) {
  print('파일 공유에 실패했습니다: $e');
}

// 텍스트와 함께 파일 공유
try {
  await GShare.files(
    ['/path/to/file.txt'],
    title: '파일 공유',
    subject: '중요한 파일',
    text: '이 파일을 확인해주세요.',
  );
} catch (e) {
  print('파일 공유에 실패했습니다: $e');
}
```

### 이미지 공유

```dart
// 이미지 공유
try {
  await GShare.images([
    '/path/to/image1.jpg',
    '/path/to/image2.png',
  ]);
} catch (e) {
  print('이미지 공유에 실패했습니다: $e');
}

// 텍스트와 함께 이미지 공유
try {
  await GShare.images(
    ['/path/to/image.jpg'],
    title: '이미지 공유',
    subject: '멋진 사진',
    text: '이 사진을 확인해보세요!',
  );
} catch (e) {
  print('이미지 공유에 실패했습니다: $e');
}
```

### 링크 공유

```dart
// 링크 공유
try {
  await GShare.links('https://example.com');
} catch (e) {
  print('링크 공유에 실패했습니다: $e');
}

// 텍스트와 함께 링크 공유
try {
  await GShare.links(
    'https://example.com',
    title: '링크 공유',
    subject: '유용한 링크',
    text: '이 링크를 확인해보세요!',
  );
} catch (e) {
  print('링크 공유에 실패했습니다: $e');
}
```

## API 참조

### GShare (Facade)

#### 초기화 및 정리
- `initialize()`: 공유 서비스 초기화
- `dispose()`: 공유 서비스 정리
- `isInitialized`: 초기화 상태 확인

#### 공유 메서드
- `text(String text, {String? title, String? subject})`: 텍스트 공유
- `files(List<String> files, {String? title, String? subject, String? text})`: 파일 공유
- `images(List<String> images, {String? title, String? subject, String? text})`: 이미지 공유
- `links(String link, {String? title, String? subject, String? text})`: 링크 공유

#### 기타
- `canShare(ShareType type)`: 공유 가능 여부 확인
- `getAvailableApps(ShareType type)`: 공유 가능한 앱 목록 가져오기

### ShareType

- `text`: 텍스트 공유
- `files`: 파일 공유
- `images`: 이미지 공유
- `link`: 링크 공유

## 플랫폼별 동작

### Android

- 네이티브 공유 시트를 사용
- 설치된 앱들 중 공유 가능한 앱들이 표시됨
- 파일 공유 시 파일 URI를 사용

### iOS

- 네이티브 공유 시트를 사용
- AirDrop, 메시지, 메일 등 시스템 앱들이 표시됨
- 파일 공유 시 파일 URL을 사용

### macOS

- 네이티브 공유 시트를 사용
- 메일, 메시지, AirDrop 등 시스템 앱들이 표시됨

### Web

- 브라우저의 네이티브 공유 API를 사용
- Web Share API를 지원하는 브라우저에서만 동작

## 에러 처리

공유 요청 시 발생할 수 있는 에러들을 적절히 처리하세요:

```dart
try {
  await GShare.text('공유할 텍스트');
  print('공유가 성공했습니다.');
} catch (e) {
  print('공유에 실패했습니다: $e');
}
```

## 주의사항

1. **초기화**: 앱 시작 시 반드시 `GShare.initialize()`를 호출하세요.
2. **파일 경로**: 파일 공유 시 올바른 파일 경로를 제공하세요.
3. **권한**: 파일 공유 시 필요한 권한이 있는지 확인하세요.
4. **플랫폼별 제한**: Web에서는 일부 기능이 제한될 수 있습니다.
5. **에러 처리**: 공유 실패 시 적절한 에러 처리를 구현하세요.
6. **사용자 경험**: 공유 전에 사용자에게 명확한 설명을 제공하세요.

## 예제

전체 예제는 `test/share_test.dart` 파일을 참조하세요. 