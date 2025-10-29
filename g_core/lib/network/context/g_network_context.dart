import 'package:g_common/g_common.dart';
import 'package:g_core/network/common/g_network_option.dart';
import 'package:g_core/network/common/g_network_type.dart';
import 'package:g_core/network/strategy/g_network_strategy.dart';
import 'package:g_core/network/strategy/impl/g_http_network_strategy.dart';
import 'package:g_core/network/strategy/impl/g_socket_network_strategy.dart';
import 'package:g_lib/g_lib_network.dart';
import 'package:g_model/base/g_either.dart';
import 'package:g_model/network/g_exception.dart';
import 'package:g_model/network/g_response.dart';

/// 네트워크 컨텍스트 클래스
/// HTTP와 Socket 전략을 관리하고 적절한 전략으로 요청을 위임합니다.
class GNetworkContext {
  // 타입별 전략 저장 (타입 안전성 확보)
  GHttpStrategy? _httpStrategy;
  GSocketStrategy? _socketStrategy;
  GNetworkType? _currentType;
  GNetworkStrategy? _currentStrategy;

  GNetworkContext({
    GHttpNetworkStrategy? httpStrategy,
    GSocketNetworkStrategy? socketStrategy,
  }) {
    if (httpStrategy != null) {
      registerHttpStrategy(httpStrategy);
    }
    if (socketStrategy != null) {
      registerSocketStrategy(socketStrategy);
    }
  }

  /// HTTP 전략 등록
  void registerHttpStrategy(GHttpStrategy strategy) {
    _httpStrategy = strategy;

    // 첫 번째 등록된 전략을 기본 전략으로 설정
    if (_currentType == null) {
      _currentType = GNetworkType.http;
      _currentStrategy = strategy;
    }
  }

  /// Socket 전략 등록
  void registerSocketStrategy(GSocketStrategy strategy) {
    _socketStrategy = strategy;

    // 첫 번째 등록된 전략을 기본 전략으로 설정
    if (_currentType == null) {
      _currentType = GNetworkType.socket;
      _currentStrategy = strategy;
    }
  }

  /// 전략 등록 (하위 호환성을 위한 메서드)
  void registerStrategy(GNetworkType type, GNetworkStrategy strategy) {
    if (strategy is GHttpStrategy) {
      registerHttpStrategy(strategy);
    } else if (strategy is GSocketStrategy) {
      registerSocketStrategy(strategy);
    } else {
      throw ArgumentError(
        'Strategy must implement either GHttpStrategy or GSocketStrategy',
      );
    }
  }

  /// 현재 활성 전략 설정
  void _setCurrentStrategy(GNetworkType type) {
    final strategy = type == GNetworkType.http ? _httpStrategy : _socketStrategy;
    if (strategy == null) {
      throw Exception('Strategy for $type not found');
    }
    _currentType = type;
    _currentStrategy = strategy;
  }

  /// 전략 전환
  Future<void> switchTo({
    required GNetworkType type,
    GNetworkOption? options,
  }) async {
    // 동일한 전략이지만 새로운 옵션이 있는 경우 재설정
    if (_currentType == type && options != null) {
      await _currentStrategy!.reinitializeWithOptions(options);
      return;
    }

    // 전략 전환
    _setCurrentStrategy(type);

    // 새 전략으로 switchTo 호출
    await _currentStrategy!.switchTo(type: type, options: options);
  }

  /// 연결 상태 확인
  bool get isConnected {
    final strategy = _getCurrentStrategy();
    return strategy.isConnected;
  }

  /// 현재 전략 가져오기
  GNetworkStrategy _getCurrentStrategy() {
    if (_currentStrategy == null) {
      throw Exception('No strategy is currently set');
    }
    return _currentStrategy!;
  }

  /// HTTP 전략 가져오기 (타입 안전)
  GHttpStrategy _getHttpStrategy() {
    if (_httpStrategy == null) {
      throw Exception('HTTP strategy not registered');
    }
    return _httpStrategy!;
  }

  /// Socket 전략 가져오기 (타입 안전)
  GSocketStrategy _getSocketStrategy() {
    if (_socketStrategy == null) {
      throw Exception('Socket strategy not registered');
    }
    return _socketStrategy!;
  }

  // HTTP 메서드들 - HTTP 전략으로 위임
  Future<GEither<GException, GResponse<T>>> get<T>({
    required String path,
    GJson? headers,
    GJson? queryParameters,
    Options? options,
    GJsonConverter<T>? fromJsonT,
    bool? isCache = true,
  }) {
    return _getHttpStrategy().get<T>(
      path: path,
      headers: headers,
      queryParameters: queryParameters,
      options: options,
      fromJsonT: fromJsonT,
      isCache: isCache,
    );
  }

  Future<GEither<GException, GResponse<T>>> post<T>({
    required String path,
    Object? data,
    GJson? headers,
    GJson? queryParameters,
    Options? options,
    GJsonConverter<T>? fromJsonT,
  }) {
    return _getHttpStrategy().post<T>(
      path: path,
      data: data,
      headers: headers,
      queryParameters: queryParameters,
      options: options,
      fromJsonT: fromJsonT,
    );
  }

  Future<GEither<GException, GResponse<T>>> put<T>({
    required String path,
    Object? data,
    GJson? headers,
    GJson? queryParameters,
    Options? options,
    GJsonConverter<T>? fromJsonT,
  }) {
    return _getHttpStrategy().put<T>(
      path: path,
      data: data,
      headers: headers,
      queryParameters: queryParameters,
      options: options,
      fromJsonT: fromJsonT,
    );
  }

  Future<GEither<GException, GResponse<T>>> patch<T>({
    required String path,
    Object? data,
    GJson? headers,
    GJson? queryParameters,
    Options? options,
    GJsonConverter<T>? fromJsonT,
  }) {
    return _getHttpStrategy().patch<T>(
      path: path,
      data: data,
      headers: headers,
      queryParameters: queryParameters,
      options: options,
      fromJsonT: fromJsonT,
    );
  }

  Future<GEither<GException, GResponse<T>>> delete<T>({
    required String path,
    GJson? headers,
    GJson? queryParameters,
    Options? options,
    GJsonConverter<T>? fromJsonT,
  }) {
    return _getHttpStrategy().delete<T>(
      path: path,
      headers: headers,
      queryParameters: queryParameters,
      options: options,
      fromJsonT: fromJsonT,
    );
  }

  // Socket 메서드들 - Socket 전략으로 위임
  Future<void> connect() {
    return _getSocketStrategy().connect();
  }

  Future<void> disconnect() {
    return _getSocketStrategy().disconnect();
  }

  void on({
    required String event,
    Function(dynamic data)? handler,
  }) {
    _getSocketStrategy().on(event: event, handler: handler);
  }

  Future<void> emit({
    required String event,
    required dynamic data,
  }) {
    return _getSocketStrategy().emit(event: event, data: data);
  }

  Stream<GJson> subscribe({
    required String event,
    GJson? payload,
  }) {
    return _getSocketStrategy().subscribe(event: event, payload: payload);
  }

  Future<void> unsubscribe({required String event}) {
    return _getSocketStrategy().unsubscribe(event: event);
  }

  Future<GJson> sendWithAck(
    String channel,
    GJson data, {
    Duration timeout = const Duration(seconds: 5),
  }) {
    return _getSocketStrategy().sendWithAck(channel, data, timeout: timeout);
  }
}
