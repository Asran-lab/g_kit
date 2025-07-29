import 'package:g_common/g_common.dart';
import 'package:g_core/network/common/g_certificate_config.dart'
    show GCertificateConfig;
import 'package:g_core/network/common/g_network_option.dart'
    show GNetworkOption, HttpNetworkOption;
import 'package:g_core/network/common/g_network_type.dart';
import 'package:g_lib/g_lib_network.dart';
import 'package:g_core/network/common/g_network_executor.dart'
    show GNetworkExecutor;
import 'package:g_core/network/strategy/g_network_strategy.dart';
import 'package:g_model/base/g_either.dart';
import 'package:g_model/network/g_exception.dart';
import 'package:g_model/network/g_response.dart';

class GHttpNetworkStrategy extends GNetworkStrategy
    with GNetworkExecutor
    implements GHttpStrategy {
  Dio _dio;
  bool _isConnected = false;
  HttpNetworkOption? currentOptions;

  GHttpNetworkStrategy([HttpNetworkOption? options]) : _dio = Dio() {
    _isConnected = true;
    currentOptions = options;
    if (options != null) {
      _configureDio(options);
    }
  }

  void _configureDio(HttpNetworkOption options) {
    _dio.options = BaseOptions(
      baseUrl: options.baseUrl,
      headers: options.defaultHeaders,
      connectTimeout: options.timeout,
      receiveTimeout: options.timeout,
      sendTimeout: options.timeout,
    );

    // Certificate Pinning 설정 (향후 구현)
    if (options.certificateConfig != null) {
      _configureCertificatePinning(options.certificateConfig!);
    }
  }

  /// Certificate Pinning 설정
  void _configureCertificatePinning(GCertificateConfig config) {
    if (!config.enabled) return;

    Logger.d('🔒 Certificate Pinning 설정됨: ${config.domainPins.keys.toList()}');

    guard(() {
      // Certificate Pinning 인터셉터 추가
      final allFingerprints = _getAllowedFingerprints(config);

      // http_certificate_pinning 패키지의 CertificatePinningInterceptor 사용
      _dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) async {
            // 요청 전 Certificate Pinning 검증
            final result = await _validateCertificate(
              options.uri.toString(),
              options.headers,
              allFingerprints,
            );

            if (result) {
              handler.next(options);
            } else {
              handler.reject(
                DioException(
                  requestOptions: options,
                  message: 'Certificate pinning validation failed',
                  type: DioExceptionType.connectionError,
                ),
              );
            }
          },
        ),
      );

      Logger.i('✅ Certificate Pinning이 활성화되었습니다.');
      Logger.i('   설정된 도메인: ${config.domainPins.keys.join(', ')}');
    });
  }

  /// Certificate 검증
  Future<bool> _validateCertificate(
    String url,
    Map<String, dynamic> headers,
    List<String> allowedFingerprints,
  ) async {
    try {
      final result = await HttpCertificatePinning.check(
        serverURL: url,
        headerHttp: headers.cast<String, String>(),
        sha: SHA.SHA256,
        allowedSHAFingerprints: allowedFingerprints,
        timeout: 30,
      );

      return result.contains("CONNECTION_SECURE");
    } catch (e) {
      Logger.e('Certificate 검증 실패: $e');
      return false;
    }
  }

  /// 모든 도메인의 허용된 fingerprint 목록을 반환
  List<String> _getAllowedFingerprints(GCertificateConfig config) {
    final allFingerprints = <String>[];

    for (final pins in config.domainPins.values) {
      allFingerprints.addAll(pins);
    }

    return allFingerprints;
  }

  /// Dio 인스턴스를 재초기화합니다
  void reinitializeDio([HttpNetworkOption? newOptions]) {
    //  Dio 인스턴스 정리 (안전하게 처리)
    guard(() {
      if (_isConnected) {
        _dio.close();
      }
    }, finallyBlock: () {
      _isConnected = false;
    });

    // 새로운 Dio 인스턴스 생성
    _dio = Dio();
    _isConnected = true;

    // 옵션 적용
    final options = newOptions ?? currentOptions;
    if (options != null) {
      currentOptions = options;
      _configureDio(options);
    }
  }

  // 기본 헤더
  static Map<String, dynamic> get headers => {
        'accept': '*/*',
        'content-type': 'application/json; charset=utf-8',
      };

  /// 헤더 병합 유틸리티 메서드
  Options mergedOptions(Options? options, Map<String, dynamic>? extraHeaders) {
    final defaultHeaders = headers;
    final mergedHeaders = {...defaultHeaders, ...?extraHeaders};
    return options?.copyWith(headers: mergedHeaders) ??
        Options(headers: mergedHeaders);
  }

  @override
  Future<GEither<GException, GResponse<T>>> get<T>({
    required String path,
    GJson? headers,
    GJson? queryParameters,
    Options? options,
    GJsonConverter<T>? fromJsonT,
    bool? isCache = true,
  }) async {
    return execute<T>(
      () => _dio.get(
        path,
        queryParameters: queryParameters,
        options: headers != null ? mergedOptions(options, headers) : options,
      ),
      fromJsonT: fromJsonT,
    );
  }

  @override
  Future<GEither<GException, GResponse<T>>> post<T>({
    required String path,
    Object? data,
    GJson? headers,
    GJson? queryParameters,
    Options? options,
    GJsonConverter<T>? fromJsonT,
  }) async {
    return execute<T>(
      () => _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: headers != null ? mergedOptions(options, headers) : options,
      ),
      fromJsonT: fromJsonT,
    );
  }

  @override
  Future<GEither<GException, GResponse<T>>> patch<T>({
    required String path,
    Object? data,
    GJson? headers,
    GJson? queryParameters,
    Options? options,
    GJsonConverter<T>? fromJsonT,
  }) async {
    return execute<T>(
      () => _dio.patch(
        path,
        data: data,
        queryParameters: queryParameters,
        options: headers != null ? mergedOptions(options, headers) : options,
      ),
      fromJsonT: fromJsonT,
    );
  }

  @override
  Future<GEither<GException, GResponse<T>>> put<T>({
    required String path,
    Object? data,
    GJson? headers,
    GJson? queryParameters,
    Options? options,
    GJsonConverter<T>? fromJsonT,
  }) async {
    return execute<T>(
      () => _dio.put(
        path,
        data: data,
        queryParameters: queryParameters,
        options: headers != null ? mergedOptions(options, headers) : options,
      ),
      fromJsonT: fromJsonT,
    );
  }

  @override
  Future<GEither<GException, GResponse<T>>> delete<T>({
    required String path,
    GJson? headers,
    GJson? queryParameters,
    Options? options,
    GJsonConverter<T>? fromJsonT,
  }) async {
    return execute<T>(
      () => _dio.delete(
        path,
        queryParameters: queryParameters,
        options: headers != null ? mergedOptions(options, headers) : options,
      ),
      fromJsonT: fromJsonT,
    );
  }

  @override
  Future<void> switchTo(
      {required GNetworkType type, GNetworkOption? options}) async {
    if (type == GNetworkType.socket) {
      await guardFuture(() async {
        _dio.close();
      }, finallyBlock: () {
        _isConnected = false;
      });
    }
  }

  @override
  bool get isConnected => _isConnected;
}
