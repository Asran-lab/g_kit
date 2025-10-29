/// Facade 패턴의 기본 추상 클래스
///
/// 모든 Facade 클래스가 상속받아 사용할 수 있는 베이스 클래스입니다.
/// 초기화 패턴과 서비스/컨텍스트 접근을 표준화합니다.
///
/// ## 사용 패턴
///
/// ### 패턴 1: Initializer 기반 (Service 패턴)
/// ```dart
/// class GBiometric extends GServiceFacade<GBiometricService, GBiometricInitializer> {
///   GBiometric._() : super(GBiometricInitializer());
///   static final GBiometric _instance = GBiometric._();
///
///   static Future<bool> authenticate() => _instance.service.authenticate();
/// }
/// ```
///
/// ### 패턴 2: Initializer 기반 (Context 패턴)
/// ```dart
/// class GStorage extends GContextFacade<GStorageContext, GStorageInitializer> {
///   GStorage._() : super(GStorageInitializer());
///   static final GStorage _instance = GStorage._();
///
///   static Future<void> set(String key, dynamic value) =>
///     _instance.context.set(key: key, value: value);
/// }
/// ```
///
/// ### 패턴 3: Instance 직접 관리
/// ```dart
/// class GNetwork extends GInstanceFacade<GNetworkContext> {
///   static GNetworkContext? _instance;
///
///   @override
///   GNetworkContext get instance => _instance ??= GNetworkFactory.createDefault();
///
///   static Future<void> get(String path) => _instance.get(path);
/// }
/// ```
abstract class GFacade {
  const GFacade();

  /// 초기화 상태 확인
  bool get isInitialized;
}

/// Service를 제공하는 Initializer 기반 Facade
///
/// Initializer가 Service를 제공하는 패턴입니다.
/// 예: Biometric, Share, STT 등
abstract class GServiceFacade<TService, TInitializer extends GServiceInitializer<TService>>
    extends GFacade {
  final TInitializer _initializer;

  const GServiceFacade(this._initializer);

  /// Service 인스턴스 접근
  TService get service => _initializer.service;

  @override
  bool get isInitialized => _initializer.isInitialized;
}

/// Context를 제공하는 Initializer 기반 Facade
///
/// Initializer가 Context를 제공하는 패턴입니다.
/// 예: Storage, AppLifecycle 등
abstract class GContextFacade<TContext, TInitializer extends GContextInitializer<TContext>>
    extends GFacade {
  final TInitializer _initializer;

  const GContextFacade(this._initializer);

  /// Context 인스턴스 접근
  TContext get context => _initializer.context;

  @override
  bool get isInitialized => _initializer.isInitialized;
}

/// Instance를 직접 관리하는 Facade
///
/// Factory나 직접 생성으로 인스턴스를 관리하는 패턴입니다.
/// 예: Network
abstract class GInstanceFacade<TInstance> extends GFacade {
  const GInstanceFacade();

  /// Instance 접근 (서브클래스에서 구현)
  TInstance get instance;

  @override
  bool get isInitialized => true; // Instance 존재 여부로 판단
}

/// Service를 제공하는 Initializer 인터페이스
abstract class GServiceInitializer<TService> {
  bool get isInitialized;
  TService get service;
}

/// Context를 제공하는 Initializer 인터페이스
abstract class GContextInitializer<TContext> {
  bool get isInitialized;
  TContext get context;
}

/// Static Context를 제공하는 Initializer 인터페이스 (g_core 패턴)
///
/// g_core 모듈은 Initializer가 static으로 context를 관리합니다.
/// 예: GStorageInitializer.context, GNetworkInitializer.context
abstract class GStaticContextInitializer<TContext> {
  /// Static context getter (구현 클래스에서 static으로 제공)
  static dynamic get context => throw UnimplementedError();

  /// Static isInitialized getter (구현 클래스에서 static으로 제공)
  static bool get isInitialized => throw UnimplementedError();
}

/// Static Context 기반 Facade (g_core 패턴)
///
/// Initializer가 static context를 관리하는 패턴입니다.
/// 예: Storage, Network, Router (일부), AppLifecycle (일부)
///
/// ## 사용 예제
/// ```dart
/// class GStorage extends GStaticContextFacade<GStorageContext> {
///   @override
///   GStorageContext get context => GStorageInitializer.context;
///
///   @override
///   bool get isInitialized => GStorageInitializer.isInitialized;
///
///   static Future<void> set(String key, dynamic value) =>
///     _facade.context.set(key: key, value: value);
/// }
/// ```
abstract class GStaticContextFacade<TContext> extends GFacade {
  const GStaticContextFacade();

  /// Context 접근 (서브클래스에서 Static Initializer로 연결)
  TContext get context;
}
