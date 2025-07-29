import 'package:g_model/g_model.dart';
import 'package:g_lib/g_lib_network.dart';

mixin GNetworkExecutor {
  Future<GEither<GException, GResponse<T>>> execute<T>(
    Future<Response<dynamic>> Function() request, {
    int retryCount = 1,
    Duration timeout = const Duration(seconds: 10),
    T Function(dynamic json)? fromJsonT,
  }) async {
    for (int attempt = 0; attempt < retryCount; attempt++) {
      try {
        final response = await request().timeout(timeout);
        final statusCode = response.statusCode ?? 500;
        final data = response.data;

        final isJson = data is Map<String, dynamic>;
        final hasSuccess = isJson && data['success'] == true;
        final isSuccess = (statusCode >= 200 && statusCode < 300) || hasSuccess;
        if (isSuccess) {
          return Right(
            GResponse<T>(
              statusCode: statusCode,
              message: isJson ? data['message'] : null,
              data: fromJsonT != null ? fromJsonT(data) : data as T,
            ),
          );
        } else {
          return Left(
            GException(
              statusCode: statusCode,
              message: isJson ? data['message'] : 'Unknown error',
            ),
          );
        }
      } on DioException catch (e) {
        if (attempt >= retryCount - 1) {
          return Left(
            GException(
              statusCode: e.response?.statusCode ?? 500,
              message: e.message,
            ),
          );
        }
      } catch (e) {
        return Left(
          GException(
            statusCode: 500,
            message: 'Unexpected error: ${e.toString()}',
          ),
        );
      }
    }
    return Left(
      GException(
        statusCode: 500,
        message: 'Retry attempts exceeded',
      ),
    );
  }
}
