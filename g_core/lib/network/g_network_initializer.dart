import 'package:g_common/g_common.dart';
import 'package:g_core/network/common/g_network_option.dart';
import 'package:g_core/network/common/g_network_type.dart';
import 'package:g_core/network/context/g_network_context.dart';
import 'package:g_core/network/factory/g_network_factory.dart';
import 'package:g_model/g_model.dart';

/// 네트워크 초기화 클래스
/// 네트워크 모듈의 초기화를 담당하며, 다양한 설정 옵션을 지원합니다.
class GNetworkInitializer extends GInitializer
    implements GContextInitializer<GNetworkContext> {
  static final GNetworkInitializer _instance = GNetworkInitializer._internal();
  factory GNetworkInitializer() => _instance;
  GNetworkInitializer._internal();

  GNetworkType? _type;
  HttpNetworkOption? _httpOptions;
  SocketNetworkOption? _socketOptions;
  bool _autoConnect = true;

  GNetworkContext? _context;
  bool _isInitialized = false;

  /// 초기화 설정 (initialize 호출 전에 설정 가능)
  void configure({
    GNetworkType? type,
    HttpNetworkOption? httpOptions,
    SocketNetworkOption? socketOptions,
    bool autoConnect = true,
  }) {
    _type = type;
    _httpOptions = httpOptions;
    _socketOptions = socketOptions;
    _autoConnect = autoConnect;
  }

  @override
  String get name => 'network';

  @override
  GNetworkContext get context {
    if (!_isInitialized) {
      throw StateError(
          'GNetworkInitializer is not initialized. Call initialize() first.');
    }
    return _context!;
  }

  @override
  bool get isInitialized => _isInitialized;

  @override
  Future<void> initialize() async {
    if (_isInitialized) {
      Logger.d('🔄 Network already initialized, skipping...');
      return;
    }

    await guardFuture<void>(() async {
      Logger.i('🚀 Initializing GNetwork...');

      try {
        // 컨텍스트 생성
        _context = _createContext();

        // 전략 등록
        await _registerStrategies();

        // 자동 연결 설정
        if (_autoConnect) {
          await _setupAutoConnect();
        }

        // Facade 초기화
        _initializeFacade();

        _isInitialized = true;
        Logger.i('✅ GNetwork initialized successfully');
      } catch (e, stackTrace) {
        Logger.e('❌ Failed to initialize GNetwork: $e');
        Logger.e('Stack trace: $stackTrace');
        rethrow;
      }
    });
  }

  /// 컨텍스트 생성
  GNetworkContext _createContext() {
    return GNetworkFactory.createContext(
      httpOptions: _httpOptions,
      socketOptions: _socketOptions,
    );
  }

  /// 전략 등록
  Future<void> _registerStrategies() async {
    if (_type == null) {
      // 모든 전략 등록
      await _registerAllStrategies();
    } else {
      // 특정 전략만 등록
      await _registerSpecificStrategy(_type!);
    }
  }

  /// 모든 전략 등록
  Future<void> _registerAllStrategies() async {
    // HTTP 전략 등록
    final httpStrategy = GNetworkFactory.createHttpStrategy(_httpOptions);
    _context!.registerStrategy(GNetworkType.http, httpStrategy);

    // Socket 전략 등록
    final socketStrategy = GNetworkFactory.createSocketStrategy(_socketOptions);
    _context!.registerStrategy(GNetworkType.socket, socketStrategy);

    // 기본 전략 설정
    await _context!.switchTo(type: _type ?? GNetworkType.http);
  }

  /// 특정 전략만 등록
  Future<void> _registerSpecificStrategy(GNetworkType type) async {
    switch (type) {
      case GNetworkType.http:
        final httpStrategy = GNetworkFactory.createHttpStrategy(_httpOptions);
        _context!.registerStrategy(GNetworkType.http, httpStrategy);
        await _context!.switchTo(type: GNetworkType.http);
        break;

      case GNetworkType.socket:
        final socketStrategy = GNetworkFactory.createSocketStrategy(_socketOptions);
        _context!.registerStrategy(GNetworkType.socket, socketStrategy);
        await _context!.switchTo(type: GNetworkType.socket);
        break;
    }
  }

  /// 자동 연결 설정
  Future<void> _setupAutoConnect() async {
    if (_type == GNetworkType.socket || _type == null) {
      // Socket 자동 연결 시도
      await guardFuture(() async {
        await _context!.connect();
        Logger.i('✅ Socket auto-connected successfully');
      }, onError: (error, stackTrace) {
        Logger.w('⚠️ Socket auto-connect failed: $error');
        // 자동 연결 실패는 치명적이지 않음
      });
    }
  }

  /// Facade 초기화
  void _initializeFacade() {
    // Facade가 이 initializer의 context를 사용하도록 연결
    // GNetwork는 이제 GContextFacade를 통해 자동으로 context에 접근
  }

  /// 초기화 리셋 (테스트용)
  void reset() {
    _context = null;
    _isInitialized = false;
    Logger.d('🔄 Network context reset');
  }

  /// 정리
  Future<void> dispose() async {
    if (_context != null) {
      await guardFuture(() async {
        // Socket 연결 해제
        if (_context!.isConnected) {
          await _context!.disconnect();
        }
        _context = null;
        _isInitialized = false;
        Logger.i('🧹 Network context disposed');
      });
    }
  }
}
