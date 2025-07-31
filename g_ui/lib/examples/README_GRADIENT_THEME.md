# GGradientThemeExtension 사용법

`GGradientThemeExtension`은 Flutter 앱에서 그라데이션을 테마로 관리할 수 있게 해주는 확장 클래스입니다.

## 기본 사용법

### 1. 테마에 그라데이션 확장 추가

```dart
import 'package:flutter/material.dart';
import 'package:g_ui/g_ui.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '그라데이션 테마 예제',
      theme: ThemeData(
        extensions: [
          // 분홍 -> 보라색 그라데이션을 primary로 설정
          GGradientThemeExtension(
            gradientMap: {
              'primary': const LinearGradient(
                colors: [Colors.pink, Colors.purple],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              'secondary': const LinearGradient(
                colors: [Colors.blue, Colors.cyan],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              'tertiary': const LinearGradient(
                colors: [Colors.orange, Colors.red],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
            },
          ),
        ],
      ),
      home: MyHomePage(),
    );
  }
}
```

### 2. 위젯에서 그라데이션 사용

#### 그라데이션 컨테이너
```dart
GGradientWidgets.gradientContainer(
  context: context,
  gradientKey: 'primary',
  child: Text('그라데이션 배경'),
  borderRadius: BorderRadius.circular(12),
)
```

#### 그라데이션 텍스트
```dart
GGradientWidgets.gradientText(
  context: context,
  gradientKey: 'primary',
  text: '그라데이션 텍스트',
  style: TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
  ),
)
```

#### 그라데이션 아이콘
```dart
GGradientWidgets.gradientIcon(
  context: context,
  gradientKey: 'primary',
  icon: Icons.favorite,
  size: 48,
)
```

#### 직접 그라데이션 사용
```dart
Container(
  decoration: BoxDecoration(
    gradient: context.getGradient('primary'),
    borderRadius: BorderRadius.circular(12),
  ),
  child: Text('직접 그라데이션 사용'),
)
```

## 확장 메서드

### BuildContext 확장

```dart
// 현재 테마의 그라데이션 확장 가져오기
GGradientThemeExtension gradientTheme = context.gradientTheme;

// 특정 키의 그라데이션 가져오기
Gradient? gradient = context.getGradient('primary');

// 그라데이션 존재 여부 확인
bool hasGradient = context.hasGradient('primary');
```

## 기본 그라데이션

`GGradientThemeExtension.defaultGradients`를 사용하여 기본 그라데이션을 가져올 수 있습니다:

```dart
// 기본 그라데이션 테마 확장 생성
GGradientThemeExtension defaultTheme = GGradientThemeExtension.defaultTheme;

// 또는 기본 그라데이션 맵 직접 사용
Map<String, Gradient> defaultGradients = GGradientThemeExtension.defaultGradients;
```

기본 그라데이션 키:
- `primary`: 파란색 → 보라색
- `secondary`: 초록색 → 파란색  
- `tertiary`: 주황색 → 빨간색
- `surface`: 회색 → 흰색
- `error`: 빨간색 → 빨간색 액센트

## 동적 테마 변경

```dart
class DynamicGradientExample extends StatefulWidget {
  @override
  State<DynamicGradientExample> createState() => _DynamicGradientExampleState();
}

class _DynamicGradientExampleState extends State<DynamicGradientExample> {
  bool _isDarkMode = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        extensions: [
          GGradientThemeExtension(
            gradientMap: _isDarkMode ? _darkGradients : _lightGradients,
          ),
        ],
      ),
      home: Scaffold(
        body: GGradientWidgets.gradientContainer(
          context: context,
          gradientKey: 'primary',
          child: Text('동적 그라데이션'),
        ),
      ),
    );
  }

  static const Map<String, Gradient> _lightGradients = {
    'primary': LinearGradient(
      colors: [Colors.blue, Colors.purple],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
  };

  static const Map<String, Gradient> _darkGradients = {
    'primary': LinearGradient(
      colors: [Colors.purple, Colors.indigo],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
  };
}
```

## GColorConfig와 함께 사용

기존 `GColorConfig`와 함께 사용하여 색상과 그라데이션을 모두 관리할 수 있습니다:

```dart
// 색상 설정 초기화
GColorConfig.initialize(
  config: GColorConfig(
    primary: '#FF5722',
    secondary: '#FFC107',
    // ...
  ),
);

// 테마에 그라데이션 확장 추가
ThemeData(
  extensions: [
    GGradientThemeExtension(
      gradientMap: {
        'primary': LinearGradient(
          colors: [Colors.pink, Colors.purple],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      },
    ),
  ],
)
```

## 주의사항

1. **성능**: 그라데이션은 단색보다 렌더링 비용이 높습니다. 과도한 사용을 피하세요.

2. **접근성**: 그라데이션 텍스트나 아이콘의 가독성을 고려하세요.

3. **일관성**: 앱 전체에서 일관된 그라데이션 패턴을 사용하세요.

4. **테마 전환**: `lerp` 메서드는 복잡한 그라데이션 보간을 지원하지 않으므로, 단순한 선택 방식으로 동작합니다.

## 예제 코드

전체 예제는 `g_gradient_theme_example.dart` 파일을 참조하세요. 