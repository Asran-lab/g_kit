class GColorConfig {
  /// [Primary] - 브랜드 컬러, 헤더, 버튼 등
  final String primary;

  /// [onPrimary] -  메인 색상 위 텍스트나 아이콘
  // final String onPrimary;

  /// [secondary] - 보조 색상, 텍스트 등
  final String secondary;

  /// [onSecondary] - 보조 색상 위 텍스트나 아이콘
  // final String onSecondary;

  /// [tertiary] - 세 번째 보조 색상
  final String tertiary;

  /// [onTertiary] - 세 번째 보조 색상 위 텍스트나 아이콘
  // final String onTertiary;

  /// [error] - 에러 색상
  final String error;

  /// [onError] - 에러 색상 위 텍스트나 아이콘
  // final String onError;

  /// [surface] - 백그라운드 색상
  final String surface;

  /// [onSurface] - 백그라운드 색상 위 텍스트나 아이콘
  // final String onSurface;

  /// [outline] - 테두리 색상
  final String outline;

  /// [shadow] - 그림자 색상
  // final String shadow;

  /// [scrim] - 오버레이의 어두운 색상, 모달이나 드로어가 활성화될 때 배경을 어둡게 처리
  // final String scrim;

  GColorConfig({
    required this.primary,
    // required this.onPrimary,
    required this.secondary,
    // required this.onSecondary,
    required this.tertiary,
    // required this.onTertiary,
    required this.error,
    // required this.onError,
    required this.surface,
    // required this.onSurface,
    required this.outline,
    // required this.shadow,
    // required this.scrim,
  });

  /// 현재 사용 중인 색상 설정 (초기화 후 사용)
  static GColorConfig? _current;

  /// 현재 색상 설정 조회
  static GColorConfig get current {
    if (_current == null) {
      throw StateError(
        'GColorConfig가 초기화되지 않았습니다. '
        'runApp 호출 전에 GColorConfig.initialize()를 호출해주세요.',
      );
    }
    return _current!;
  }

  /// 기본 라이트 테마 색상
  static GColorConfig get defaultLight => GColorConfig(
    primary: '#000000',
    secondary: '#000000',
    tertiary: '#000000',
    error: '#000000',
    surface: '#ffffff',
    outline: '#000000',
  );

  /// 색상 설정 초기화
  ///
  /// [config]: 직접 설정할 색상 설정 (옵션)
  /// [useDartDefine]: dart-define 값 사용 여부 (기본값: true)
  ///
  /// 사용법:
  /// ```dart
  /// // 방법 1: dart-define 사용
  /// GColorConfig.initialize(); // dart-define 값 자동 적용
  ///
  /// // 방법 2: 직접 설정
  /// GColorConfig.initialize(
  ///   config: GColorConfig(
  ///     primary: '#FF5722',
  ///     secondary: '#FFC107',
  ///     // ...
  ///   ),
  /// );
  ///
  /// // 방법 3: dart-define + 일부 오버라이드
  /// GColorConfig.initialize(
  ///   config: GColorConfig.fromDartDefine().copyWith(
  ///     primary: '#FF5722',
  ///   ),
  /// );
  /// ```
  static void initialize({GColorConfig? config, bool useDartDefine = true}) {
    if (config != null) {
      _current = config;
    } else if (useDartDefine) {
      _current = fromDartDefine();
    } else {
      _current = defaultLight;
    }
  }

  /// dart-define 값으로부터 색상 설정 생성
  ///
  /// 사용법:
  /// ```bash
  /// flutter run --dart-define=COLOR_PRIMARY=#FF5722 \
  ///              --dart-define=COLOR_SECONDARY=#FFC107 \
  ///              --dart-define=COLOR_TERTIARY=#4CAF50 \
  ///              --dart-define=COLOR_ERROR=#F44336 \
  ///              --dart-define=COLOR_SURFACE=#FFFFFF \
  ///              --dart-define=COLOR_OUTLINE=#000000
  /// ```
  static GColorConfig fromDartDefine() {
    return GColorConfig(
      primary: const String.fromEnvironment(
        'COLOR_PRIMARY',
        defaultValue: '#000000',
      ),
      secondary: const String.fromEnvironment(
        'COLOR_SECONDARY',
        defaultValue: '#000000',
      ),
      tertiary: const String.fromEnvironment(
        'COLOR_TERTIARY',
        defaultValue: '#000000',
      ),
      error: const String.fromEnvironment(
        'COLOR_ERROR',
        defaultValue: '#F44336',
      ),
      surface: const String.fromEnvironment(
        'COLOR_SURFACE',
        defaultValue: '#FFFFFF',
      ),
      outline: const String.fromEnvironment(
        'COLOR_OUTLINE',
        defaultValue: '#000000',
      ),
    );
  }

  /// 색상 설정 복사본 생성 (일부 값 변경)
  GColorConfig copyWith({
    String? primary,
    String? secondary,
    String? tertiary,
    String? error,
    String? surface,
    String? outline,
  }) {
    return GColorConfig(
      primary: primary ?? this.primary,
      secondary: secondary ?? this.secondary,
      tertiary: tertiary ?? this.tertiary,
      error: error ?? this.error,
      surface: surface ?? this.surface,
      outline: outline ?? this.outline,
    );
  }

  /// JSON에서 색상 설정 생성
  factory GColorConfig.fromJson(Map<String, dynamic> json) {
    return GColorConfig(
      primary: json['primary'] ?? '#000000',
      secondary: json['secondary'] ?? '#000000',
      tertiary: json['tertiary'] ?? '#000000',
      error: json['error'] ?? '#F44336',
      surface: json['surface'] ?? '#FFFFFF',
      outline: json['outline'] ?? '#000000',
    );
  }

  /// JSON으로 변환
  Map<String, dynamic> toJson() {
    return {
      'primary': primary,
      'secondary': secondary,
      'tertiary': tertiary,
      'error': error,
      'surface': surface,
      'outline': outline,
    };
  }

  @override
  String toString() {
    return 'GColorConfig(primary: $primary, secondary: $secondary, tertiary: $tertiary, error: $error, surface: $surface, outline: $outline)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is GColorConfig &&
        other.primary == primary &&
        other.secondary == secondary &&
        other.tertiary == tertiary &&
        other.error == error &&
        other.surface == surface &&
        other.outline == outline;
  }

  @override
  int get hashCode {
    return Object.hash(primary, secondary, tertiary, error, surface, outline);
  }
}

class GColorTone {
  static const double container = 0.2;
  static const double fixed = 0.3;
  static const double fixedDim = 0.1;
  static const double surfaceBright = 0.2;
  static const double surfaceDimLight = 0.2;
  static const double surfaceDimDark = 0.05;
  static const double inverse = 0.4;
  static const double outlineVariant = 0.1;
}
