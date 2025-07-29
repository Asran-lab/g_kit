import 'package:g_common/g_common.dart';
import 'package:g_core/network/common/g_network_option.dart'
    show GNetworkOption;
import 'package:g_core/network/common/g_network_type.dart' show GNetworkType;
import 'package:g_lib/g_lib_network.dart';
import 'package:g_model/base/g_either.dart' show GEither;
import 'package:g_model/network/g_exception.dart' show GException;
import 'package:g_model/network/g_response.dart' show GResponse;

abstract class GNetworkStrategy {
  bool get isConnected;

  Future<void> switchTo({
    required GNetworkType type,
    GNetworkOption? options,
  });
}

/// HTTP 전략
abstract class GHttpStrategy extends GNetworkStrategy {
  Future<GEither<GException, GResponse<T>>> get<T>({
    required String path,
    GJson? headers,
    GJson? queryParameters,
    Options? options,
    GJsonConverter<T>? fromJsonT,
    bool? isCache = true,
  });

  Future<GEither<GException, GResponse<T>>> post<T>({
    required String path,
    Object? data,
    GJson? headers,
    GJson? queryParameters,
    Options? options,
    GJsonConverter<T>? fromJsonT,
  });

  Future<GEither<GException, GResponse<T>>> put<T>({
    required String path,
    Object? data,
    GJson? headers,
    GJson? queryParameters,
    Options? options,
    GJsonConverter<T>? fromJsonT,
  });

  Future<GEither<GException, GResponse<T>>> patch<T>({
    required String path,
    Object? data,
    GJson? headers,
    GJson? queryParameters,
    Options? options,
    GJsonConverter<T>? fromJsonT,
  });

  Future<GEither<GException, GResponse<T>>> delete<T>({
    required String path,
    GJson? headers,
    GJson? queryParameters,
    Options? options,
    GJsonConverter<T>? fromJsonT,
  });
}

/// Socket 전략
abstract class GSocketStrategy extends GNetworkStrategy {
  Future<void> connect();
  Future<void> disconnect();

  void on({
    required String event,
    Function(dynamic data)? handler,
  });

  Future<void> emit({
    required String event,
    required dynamic data,
  });

  Stream<GJson> subscribe({
    required String event,
    GJson? payload,
  });

  Future<void> unsubscribe({required String event});

  Future<GJson> sendWithAck(
    String channel,
    GJson data, {
    Duration timeout = const Duration(seconds: 5),
  });
}
