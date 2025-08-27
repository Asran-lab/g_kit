import 'package:g_common/g_common.dart';
import 'package:g_core/network/common/g_network_option.dart';
import 'package:g_core/network/common/g_network_type.dart';
import 'package:g_core/network/context/g_network_context.dart';
import 'package:g_core/network/facade/g_network.dart';
import 'package:g_core/network/factory/g_network_factory.dart';
import 'package:g_model/initializer/g_initializer.dart';

/// 네트워크 초기화 클래스
/// 네트워크 모듈의 초기화를 담당하며, 다양한 설정 옵션을 지원합니다.
class GNetworkInitializer extends GInitializer {
  final GNetworkType? _type;
  final HttpNetworkOption? _httpOptions;
  final SocketNetworkOption? _socketOptions;
  final bool _autoConnect;

  GNetworkInitializer({
    GNetworkType? type,
    HttpNetworkOption? httpOptions,
    SocketNetworkOption? socketOptions,
    bool autoConnect = true,
  })  : _type = type,
        _httpOptions = httpOptions,
        _socketOptions = socketOptions,
        _autoConnect = autoConnect;

  static GNetworkContext? _context;
  static bool _isInitialized = false;

  @override
  String get name => 'network';

  @override
  Future<void> initialize() async {
    await globalLock(() async {
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
          // _initializeFacade();

          _isInitialized = true;
          Logger.i('✅ GNetwork initialized successfully');
        } catch (e, stackTrace) {
          Logger.e('❌ Failed to initialize GNetwork: $e');
          Logger.e('Stack trace: $stackTrace');
          rethrow;
        }
      });
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
    Logger.d('📡 Registering all network strategies...');

    // HTTP 전략 등록
    final httpStrategy = GNetworkFactory.createHttpStrategy(_httpOptions);
    _context!.registerStrategy(GNetworkType.http, httpStrategy);
    Logger.d('✅ HTTP strategy registered');

    // Socket 전략 등록
    final socketStrategy = GNetworkFactory.createSocketStrategy(_socketOptions);
    _context!.registerStrategy(GNetworkType.socket, socketStrategy);
    Logger.d('✅ Socket strategy registered');

    // 기본 전략 설정
    _context!.switchTo(type: _type ?? GNetworkType.http);
    Logger.d('✅ Default strategy set to HTTP');
  }

  /// 특정 전략만 등록
  Future<void> _registerSpecificStrategy(GNetworkType type) async {
    Logger.d('📡 Registering specific strategy: $type');

    switch (type) {
      case GNetworkType.http:
        final httpStrategy = GNetworkFactory.createHttpStrategy(_httpOptions);
        _context!.registerStrategy(GNetworkType.http, httpStrategy);
        _context!.switchTo(type: GNetworkType.http);
        Logger.d('✅ HTTP strategy registered and set as default');
        break;

      case GNetworkType.socket:
        final socketStrategy =
            GNetworkFactory.createSocketStrategy(_socketOptions);
        _context!.registerStrategy(GNetworkType.socket, socketStrategy);
        _context!.switchTo(type: GNetworkType.socket);
        Logger.d('✅ Socket strategy registered and set as default');
        break;
    }
  }

  /// 자동 연결 설정
  Future<void> _setupAutoConnect() async {
    if (_type == GNetworkType.socket || _type == null) {
      Logger.d('🔌 Setting up auto-connect for socket...');

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
    // Facade에 컨텍스트 설정
    GNetwork.initialize(
      httpOptions: _httpOptions,
      socketOptions: _socketOptions,
    );
    Logger.d('✅ Facade initialized');
  }

  /// 컨텍스트 가져오기
  static GNetworkContext get context {
    if (_context == null) {
      throw Exception('GNetworkContext가 초기화되지 않았습니다. initialize()를 먼저 호출하세요.');
    }
    return _context!;
  }

  /// 초기화 상태 확인
  static bool get isInitialized => _isInitialized;

  /// 초기화 리셋 (테스트용)
  static void reset() {
    _context = null;
    _isInitialized = false;
    Logger.d('🔄 Network context reset');
  }

  /// 연결 상태 확인
  static bool get isConnected {
    if (!isInitialized) return false;
    return context.isConnected;
  }

  /// 전략 전환
  static Future<void> switchTo({
    required GNetworkType type,
    GNetworkOption? options,
  }) async {
    if (!isInitialized) {
      throw Exception('Network not initialized. Call initialize() first.');
    }
    await context.switchTo(type: type, options: options);
  }

  /// 정리
  static Future<void> dispose() async {
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
