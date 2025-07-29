import 'package:g_common/g_common.dart';
import 'package:g_core/network/common/g_network_option.dart';
import 'package:g_core/network/common/g_network_type.dart';
import 'package:g_core/network/context/g_network_context.dart';
import 'package:g_core/network/factory/g_network_factory.dart';
import 'package:g_lib/g_lib_network.dart';
import 'package:g_model/base/g_either.dart';
import 'package:g_model/network/g_exception.dart';
import 'package:g_model/network/g_response.dart';

/// 네트워크 Facade 클래스
/// 네트워크 기능에 대한 간단한 인터페이스를 제공합니다.
class GNetwork {
  static GNetworkContext? _instance;
  static GNetworkContext get instance {
    _instance ??= GNetworkFactory.createDefaultContext();
    return _instance!;
  }

  /// 네트워크 컨텍스트 초기화
  static void initialize({
    HttpNetworkOption? httpOptions,
    SocketNetworkOption? socketOptions,
  }) {
    _instance = GNetworkFactory.createContext(
      httpOptions: httpOptions,
      socketOptions: socketOptions,
    );
  }

  /// 전략 전환
  static Future<void> switchTo({
    required GNetworkType type,
    GNetworkOption? options,
  }) async {
    await instance.switchTo(type: type, options: options);
  }

  /// 연결 상태 확인
  static bool get isConnected => instance.isConnected;

  // HTTP 메서드들
  static Future<GEither<GException, GResponse<T>>> get<T>({
    required String path,
    GJson? headers,
    GJson? queryParameters,
    Options? options,
    GJsonConverter<T>? fromJsonT,
    bool? isCache = true,
  }) {
    return instance.get<T>(
      path: path,
      headers: headers,
      queryParameters: queryParameters,
      options: options,
      fromJsonT: fromJsonT,
      isCache: isCache,
    );
  }

  static Future<GEither<GException, GResponse<T>>> post<T>({
    required String path,
    Object? data,
    GJson? headers,
    GJson? queryParameters,
    Options? options,
    GJsonConverter<T>? fromJsonT,
  }) {
    return instance.post<T>(
      path: path,
      data: data,
      headers: headers,
      queryParameters: queryParameters,
      options: options,
      fromJsonT: fromJsonT,
    );
  }

  static Future<GEither<GException, GResponse<T>>> put<T>({
    required String path,
    Object? data,
    GJson? headers,
    GJson? queryParameters,
    Options? options,
    GJsonConverter<T>? fromJsonT,
  }) {
    return instance.put<T>(
      path: path,
      data: data,
      headers: headers,
      queryParameters: queryParameters,
      options: options,
      fromJsonT: fromJsonT,
    );
  }

  static Future<GEither<GException, GResponse<T>>> patch<T>({
    required String path,
    Object? data,
    GJson? headers,
    GJson? queryParameters,
    Options? options,
    GJsonConverter<T>? fromJsonT,
  }) {
    return instance.patch<T>(
      path: path,
      data: data,
      headers: headers,
      queryParameters: queryParameters,
      options: options,
      fromJsonT: fromJsonT,
    );
  }

  static Future<GEither<GException, GResponse<T>>> delete<T>({
    required String path,
    GJson? headers,
    GJson? queryParameters,
    Options? options,
    GJsonConverter<T>? fromJsonT,
  }) {
    return instance.delete<T>(
      path: path,
      headers: headers,
      queryParameters: queryParameters,
      options: options,
      fromJsonT: fromJsonT,
    );
  }

  // Socket 메서드들
  static Future<void> connect() => instance.connect();
  static Future<void> disconnect() => instance.disconnect();

  static void on({
    required String event,
    Function(dynamic data)? handler,
  }) {
    instance.on(event: event, handler: handler);
  }

  static Future<void> emit({
    required String event,
    required dynamic data,
  }) {
    return instance.emit(event: event, data: data);
  }

  static Stream<GJson> subscribe({
    required String event,
    GJson? payload,
  }) {
    return instance.subscribe(event: event, payload: payload);
  }

  static Future<void> unsubscribe({required String event}) {
    return instance.unsubscribe(event: event);
  }

  static Future<GJson> sendWithAck(
    String channel,
    GJson data, {
    Duration timeout = const Duration(seconds: 5),
  }) {
    return instance.sendWithAck(channel, data, timeout: timeout);
  }
}
