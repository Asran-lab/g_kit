# APP_LINK

Flutter 앱에서 딥링크(Deep Link) 기능을 쉽게 구현할 수 있는 모듈입니다.

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

`app_link` 모듈은 다음과 같은 구조로 구성되어 있습니다:

- **`GAppLink`**: 메인 Facade 클래스 (정적 메서드 제공)
- **`GAppLinkInitializer`**: 초기화 관리 (GInitializer 상속)
- **`GAppLinkService`**: 추상 서비스 인터페이스
- **`GAppLinkImpl`**: 구체적 구현체

## 📦 설치

### 1. 의존성 추가

```yaml
dependencies:
  app_links: ^3.4.5
  g_plugin:
    path: ../g_plugin
```

### 2. import 추가

```dart
import 'package:g_plugin/app_link/app_link.dart';
```

## 🚀 초기화

### 기본 초기화

가장 간단한 초기화 방법입니다:

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // 기본 초기화
  await GAppLink.initialize();
  
  runApp(MyApp());
}
```

### 콜백과 함께 초기화

딥링크 처리 로직을 정의하여 초기화:

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await GAppLink.initialize(
    onDeepLink: (link) {
      print('딥링크 수신: $link');
      // 딥링크 처리 로직
    },
    onError: (error) {
      print('딥링크 에러: $error');
    },
  );
  
  runApp(MyApp());
}
```

### 커스텀 딥링크 타입과 함께 초기화

프로젝트에 맞는 딥링크 타입을 정의:

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  final Map<String, DeepLinkTypeMatcher> deepLinkTypes = {
    'product': (path) => path.contains('product'),
    'category': (path) => path.contains('category'),
    'user': (path) => path.contains('user'),
    'article': (path) => path.contains('article'),
  };
  
  await GAppLink.initialize(
    onDeepLink: (link) {
      final type = GAppLink.getDeepLinkType(link);
      switch (type) {
        case 'product':
          handleProductLink(link);
          break;
        case 'category':
          handleCategoryLink(link);
          break;
        case 'user':
          handleUserLink(link);
          break;
        case 'article':
          handleArticleLink(link);
          break;
      }
    },
    deepLinkTypes: deepLinkTypes,
  );
  
  runApp(MyApp());
}
```

## 📖 기본 사용법

### 1. 딥링크 상태 확인

```dart
// 초기화 상태 확인
if (GAppLink.isInitialized) {
  print('앱링크가 초기화되었습니다');
}

// 리스닝 상태 확인
if (GAppLink.isListening) {
  print('딥링크를 수신 중입니다');
}
```

### 2. 딥링크 파싱

```dart
// URL 파싱
final result = GAppLink.parseDeepLink('myapp://product/123?color=red&size=large');
print(result['scheme']); // 'myapp'
print(result['host']); // 'product'
print(result['path']); // '/123'
print(result['color']); // 'red'
print(result['size']); // 'large'
```

### 3. 딥링크 검증

```dart
// 유효한 딥링크인지 확인
if (GAppLink.isValidDeepLink('myapp://product/123')) {
  print('유효한 딥링크입니다');
}

// 특정 타입의 딥링크인지 확인
if (GAppLink.isDeepLinkType('myapp://product/123', 'product')) {
  print('상품 딥링크입니다');
}
```

### 4. 파라미터 추출

```dart
// ID 추출
final id = GAppLink.extractIdFromDeepLink('myapp://product/123');
print(id); // '123'

// 특정 파라미터 추출
final color = GAppLink.extractParameterFromDeepLink(
  'myapp://product/123?color=red&size=large', 
  'color'
);
print(color); // 'red'
```

## 🔧 고급 사용법

### 1. 런타임에 딥링크 타입 추가

```dart
// 초기화 후 새로운 타입 추가
GAppLink.addDeepLinkType('video', (path) => path.contains('video'));

// 새로운 타입으로 딥링크 처리
final type = GAppLink.getDeepLinkType('myapp://video/456');
print(type); // 'video'
```

### 2. 딥링크 타입 제거

```dart
// 등록된 타입 제거
GAppLink.removeDeepLinkType('category');

// 제거된 타입은 'unknown'으로 처리됨
final type = GAppLink.getDeepLinkType('myapp://category/electronics');
print(type); // 'unknown'
```

### 3. 등록된 타입 목록 확인

```dart
final types = GAppLink.registeredDeepLinkTypes;
print(types); // ['product', 'user', 'article']
```

### 4. 수동 딥링크 처리

```dart
// 수동으로 딥링크 처리
GAppLink.handleDeepLink('myapp://product/123?color=red');
```

### 5. 재초기화

```dart
// 기존 설정을 새로운 설정으로 재초기화
await GAppLink.reinitialize(
  onDeepLink: (link) {
    // 새로운 딥링크 처리 로직
  },
  deepLinkTypes: {
    'new_type': (path) => path.contains('new'),
  },
);
```

## 🎯 상황별 사용법

### 1. 전자상거래 앱

```dart
// 상품, 카테고리, 사용자 프로필 딥링크 처리
final Map<String, DeepLinkTypeMatcher> ecommerceTypes = {
  'product': (path) => path.contains('product'),
  'category': (path) => path.contains('category'),
  'user': (path) => path.contains('user'),
  'cart': (path) => path.contains('cart'),
  'order': (path) => path.contains('order'),
};

await GAppLink.initialize(
  onDeepLink: (link) {
    final type = GAppLink.getDeepLinkType(link);
    final id = GAppLink.extractIdFromDeepLink(link);
    
    switch (type) {
      case 'product':
        Navigator.pushNamed(context, '/product/$id');
        break;
      case 'category':
        Navigator.pushNamed(context, '/category/$id');
        break;
      case 'user':
        Navigator.pushNamed(context, '/profile/$id');
        break;
      case 'cart':
        Navigator.pushNamed(context, '/cart');
        break;
      case 'order':
        Navigator.pushNamed(context, '/order/$id');
        break;
    }
  },
  deepLinkTypes: ecommerceTypes,
);
```

### 2. 소셜 미디어 앱

```dart
// 게시물, 사용자, 해시태그 딥링크 처리
final Map<String, DeepLinkTypeMatcher> socialTypes = {
  'post': (path) => path.contains('post'),
  'user': (path) => path.contains('user'),
  'hashtag': (path) => path.contains('hashtag'),
  'story': (path) => path.contains('story'),
};

await GAppLink.initialize(
  onDeepLink: (link) {
    final type = GAppLink.getDeepLinkType(link);
    final id = GAppLink.extractIdFromDeepLink(link);
    
    switch (type) {
      case 'post':
        Navigator.pushNamed(context, '/post/$id');
        break;
      case 'user':
        Navigator.pushNamed(context, '/user/$id');
        break;
      case 'hashtag':
        final hashtag = GAppLink.extractParameterFromDeepLink(link, 'tag');
        Navigator.pushNamed(context, '/hashtag/$hashtag');
        break;
      case 'story':
        Navigator.pushNamed(context, '/story/$id');
        break;
    }
  },
  deepLinkTypes: socialTypes,
);
```

### 3. 뉴스/콘텐츠 앱

```dart
// 기사, 카테고리, 작성자 딥링크 처리
final Map<String, DeepLinkTypeMatcher> newsTypes = {
  'article': (path) => path.contains('article'),
  'category': (path) => path.contains('category'),
  'author': (path) => path.contains('author'),
  'search': (path) => path.contains('search'),
};

await GAppLink.initialize(
  onDeepLink: (link) {
    final type = GAppLink.getDeepLinkType(link);
    final id = GAppLink.extractIdFromDeepLink(link);
    
    switch (type) {
      case 'article':
        Navigator.pushNamed(context, '/article/$id');
        break;
      case 'category':
        Navigator.pushNamed(context, '/category/$id');
        break;
      case 'author':
        Navigator.pushNamed(context, '/author/$id');
        break;
      case 'search':
        final query = GAppLink.extractParameterFromDeepLink(link, 'q');
        Navigator.pushNamed(context, '/search?q=$query');
        break;
    }
  },
  deepLinkTypes: newsTypes,
);
```

### 4. 게임 앱

```dart
// 게임 모드, 레벨, 친구 초대 딥링크 처리
final Map<String, DeepLinkTypeMatcher> gameTypes = {
  'level': (path) => path.contains('level'),
  'mode': (path) => path.contains('mode'),
  'friend': (path) => path.contains('friend'),
  'shop': (path) => path.contains('shop'),
};

await GAppLink.initialize(
  onDeepLink: (link) {
    final type = GAppLink.getDeepLinkType(link);
    final id = GAppLink.extractIdFromDeepLink(link);
    
    switch (type) {
      case 'level':
        Navigator.pushNamed(context, '/level/$id');
        break;
      case 'mode':
        Navigator.pushNamed(context, '/mode/$id');
        break;
      case 'friend':
        Navigator.pushNamed(context, '/friend/$id');
        break;
      case 'shop':
        Navigator.pushNamed(context, '/shop');
        break;
    }
  },
  deepLinkTypes: gameTypes,
);
```

## 📚 API 참조

### GAppLink (Facade)

#### 초기화 메서드

```dart
// 기본 초기화
static Future<void> initialize({
  DeepLinkCallback? onDeepLink,
  DeepLinkErrorCallback? onError,
  Map<String, DeepLinkTypeMatcher>? deepLinkTypes,
})

// 재초기화
static Future<void> reinitialize({
  DeepLinkCallback? onDeepLink,
  DeepLinkErrorCallback? onError,
  Map<String, DeepLinkTypeMatcher>? deepLinkTypes,
})
```

#### 상태 확인 메서드

```dart
static bool get isInitialized
static bool get isListening
```

#### 딥링크 처리 메서드

```dart
// 딥링크 파싱
static Map<String, String> parseDeepLink(String link)

// 딥링크 검증
static bool isValidDeepLink(String link)

// 딥링크 타입 확인
static String getDeepLinkType(String link)
static bool isDeepLinkType(String link, String type)

// 파라미터 추출
static String? extractIdFromDeepLink(String link)
static String? extractParameterFromDeepLink(String link, String parameter)

// 수동 처리
static void handleDeepLink(String link)
```

#### 타입 관리 메서드

```dart
// 타입 추가/제거
static void addDeepLinkType(String type, DeepLinkTypeMatcher matcher)
static void removeDeepLinkType(String type)

// 등록된 타입 확인
static List<String> get registeredDeepLinkTypes
```

#### 스트림 제어 메서드

```dart
static void pause()
static void resume()
static Future<void> dispose()
```

### 타입 정의

```dart
typedef DeepLinkCallback = void Function(String link);
typedef DeepLinkErrorCallback = void Function(String error);
typedef DeepLinkTypeMatcher = bool Function(String path);
```

## 💡 예제

### 완전한 예제 앱

```dart
import 'package:flutter/material.dart';
import 'package:g_plugin/app_link/app_link.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // 딥링크 초기화
  await GAppLink.initialize(
    onDeepLink: (link) {
      print('딥링크 수신: $link');
      
      final type = GAppLink.getDeepLinkType(link);
      final id = GAppLink.extractIdFromDeepLink(link);
      
      switch (type) {
        case 'product':
          print('상품 페이지로 이동: $id');
          break;
        case 'category':
          print('카테고리 페이지로 이동: $id');
          break;
        case 'user':
          print('사용자 프로필로 이동: $id');
          break;
        default:
          print('알 수 없는 딥링크 타입: $type');
      }
    },
    onError: (error) {
      print('딥링크 에러: $error');
    },
    deepLinkTypes: {
      'product': (path) => path.contains('product'),
      'category': (path) => path.contains('category'),
      'user': (path) => path.contains('user'),
    },
  );
  
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '딥링크 예제',
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('딥링크 테스트')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('딥링크를 테스트해보세요:'),
            SizedBox(height: 20),
            Text('myapp://product/123'),
            Text('myapp://category/electronics'),
            Text('myapp://user/456'),
          ],
        ),
      ),
    );
  }
}
```

## ⚠️ 주의사항

1. **초기화 순서**: `WidgetsFlutterBinding.ensureInitialized()`를 먼저 호출해야 합니다.
2. **중복 초기화**: 이미 초기화된 상태에서 `initialize`를 다시 호출하면 기존 설정이 유지됩니다.
3. **메모리 관리**: 앱 종료 시 `dispose()`를 호출하여 리소스를 정리하세요.
4. **플랫폼 설정**: Android와 iOS에서 딥링크를 처리하려면 추가 설정이 필요합니다.

## 🔗 관련 링크

- [app_links 패키지](https://pub.dev/packages/app_links)
- [Flutter 딥링크 가이드](https://docs.flutter.dev/development/ui/navigation/deep-linking)