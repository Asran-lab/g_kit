import '../models/permission_type.dart';
import '../models/permission_status.dart';
import '../models/permission_request.dart';
import '../models/permission_result.dart';
import 'g_permission_service.dart';

/// 권한 요청 전략 구현체
class PermissionRequestStrategyImpl implements PermissionRequestStrategy {
  @override
  Future<Map<PermissionType, PermissionResult>> requestPermissionsProgressively(
    List<PermissionRequest> permissions,
  ) async {
    final results = <PermissionType, PermissionResult>{};

    for (final request in permissions) {
      try {
        // 각 권한을 순차적으로 요청
        final result = await _requestSinglePermission(request);
        results[request.type] = result;

        // 권한이 거부되면 다음 권한 요청을 중단할 수 있음
        if (!result.isGranted && result.isPermanentlyDenied) {
          break;
        }
      } catch (e) {
        results[request.type] = PermissionResult.failure(
          request.type,
          PermissionStatus.unknown,
          '권한 요청 중 오류가 발생했습니다: $e',
          1,
        );
      }
    }

    return results;
  }

  @override
  Future<PermissionResult> requestPermissionWithContext(
    PermissionRequest request,
    String context,
  ) async {
    // 컨텍스트에 따른 추가 로직을 여기에 구현할 수 있습니다.
    // 예: 특정 화면에서만 권한 요청, 사용자 행동 패턴 분석 등

    // 현재는 기본 요청 로직을 사용
    return await _requestSinglePermission(request);
  }

  @override
  Future<PermissionResult> requestPermissionAtOptimalTime(
    PermissionRequest request,
  ) async {
    // 최적 타이밍 로직을 여기에 구현할 수 있습니다.
    // 예: 사용자가 특정 기능을 사용하려고 할 때 권한 요청

    // 현재는 기본 요청 로직을 사용
    return await _requestSinglePermission(request);
  }

  @override
  Future<PermissionResult> retryPermissionRequest(
    PermissionRequest request,
    int maxRetries,
  ) async {
    int attemptCount = 0;

    while (attemptCount < maxRetries) {
      attemptCount++;

      try {
        final result = await _requestSinglePermission(request);

        if (result.isGranted) {
          return result;
        }

        // 영구 거부된 경우 재시도하지 않음
        if (result.isPermanentlyDenied) {
          return result;
        }

        // 잠시 대기 후 재시도
        await Future.delayed(Duration(milliseconds: 500 * attemptCount));
      } catch (e) {
        if (attemptCount >= maxRetries) {
          return PermissionResult.failure(
            request.type,
            PermissionStatus.unknown,
            '최대 재시도 횟수를 초과했습니다: $e',
            attemptCount,
          );
        }
      }
    }

    return PermissionResult.failure(
      request.type,
      PermissionStatus.denied,
      '최대 재시도 횟수를 초과했습니다.',
      maxRetries,
    );
  }

  /// 단일 권한 요청 (내부 메서드)
  Future<PermissionResult> _requestSinglePermission(
      PermissionRequest request) async {
    // 이 메서드는 실제로는 GPermissionImpl에서 구현된 권한 요청 로직을 호출해야 합니다.
    // 현재는 기본적인 실패 결과를 반환합니다.
    return PermissionResult.failure(
      request.type,
      PermissionStatus.unknown,
      '권한 요청 전략이 아직 완전히 구현되지 않았습니다.',
      1,
    );
  }
}
