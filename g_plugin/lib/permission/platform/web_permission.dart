import 'package:g_lib/g_lib_plugin.dart' as g_lib;
import '../common/permission_type.dart';
import '../common/permission_status.dart';
import '../common/permission_request.dart';
import '../common/permission_result.dart';
import 'permission_platform.dart';

/// Web 플랫폼 권한 처리 구현체
class WebPermission implements PermissionPlatform {
  @override
  String get platformName => 'Web';

  @override
  List<PermissionType> get supportedPermissions => [
        // 공통 권한
        PermissionType.camera,
        PermissionType.microphone,
        PermissionType.storage,
        PermissionType.location,
        PermissionType.notification,

        // Web 특화 권한
        PermissionType.webClipboard,
        PermissionType.webPayment,
        PermissionType.webUsb,
        PermissionType.webBluetooth,
      ];

  @override
  Future<PermissionStatus> checkPermission(PermissionType type) async {
    final permission = convertToPlatformPermission(type);
    final status = await permission.status;
    return convertFromPlatformStatus(status);
  }

  @override
  Future<PermissionResult> requestPermission(PermissionRequest request) async {
    final permission = convertToPlatformPermission(request.type);
    int attemptCount = 0;

    while (attemptCount < request.maxRetryCount) {
      attemptCount++;

      try {
        final status = await permission.request();
        final resultStatus = convertFromPlatformStatus(status);

        if (resultStatus == PermissionStatus.granted) {
          return PermissionResult.success(request.type, attemptCount);
        } else if (resultStatus == PermissionStatus.permanentlyDenied) {
          return PermissionResult.failure(
            request.type,
            resultStatus,
            request.permanentlyDeniedMessage ?? '권한이 영구적으로 거부되었습니다.',
            attemptCount,
          );
        } else {
          return PermissionResult.failure(
            request.type,
            resultStatus,
            request.deniedMessage ?? '권한이 거부되었습니다.',
            attemptCount,
          );
        }
      } catch (e) {
        if (attemptCount >= request.maxRetryCount) {
          return PermissionResult.failure(
            request.type,
            PermissionStatus.unknown,
            request.failedMessage ?? '권한 요청 중 오류가 발생했습니다.',
            attemptCount,
          );
        }
      }
    }

    return PermissionResult.failure(
      request.type,
      PermissionStatus.denied,
      '최대 재시도 횟수를 초과했습니다.',
      attemptCount,
    );
  }

  @override
  Future<bool> shouldShowRequestRationale(PermissionType type) async {
    // Web에서는 rationale이 항상 false를 반환합니다.
    return false;
  }

  @override
  Future<void> openAppSettings() async {
    // Web에서는 설정 화면을 열 수 없습니다.
    throw UnsupportedError('Web에서는 앱 설정 화면을 열 수 없습니다.');
  }

  @override
  Future<void> openPermissionSettings() async {
    // Web에서는 권한 설정 화면을 열 수 없습니다.
    throw UnsupportedError('Web에서는 권한 설정 화면을 열 수 없습니다.');
  }

  @override
  bool isPermissionAvailable(PermissionType type) {
    return supportedPermissions.contains(type);
  }

  @override
  dynamic convertToPlatformPermission(PermissionType type) {
    switch (type) {
      // 공통 권한
      case PermissionType.camera:
        return g_lib.Permission.camera;
      case PermissionType.microphone:
        return g_lib.Permission.microphone;
      case PermissionType.storage:
        return g_lib.Permission.storage;
      case PermissionType.location:
        return g_lib.Permission.location;
      case PermissionType.notification:
        return g_lib.Permission.notification;

      // Web 특화 권한 (Web에서는 제한적으로 지원)
      case PermissionType.webClipboard:
        // Web에서는 clipboard API를 직접 사용
        throw UnsupportedError('Web clipboard 권한은 별도로 처리해야 합니다.');
      case PermissionType.webPayment:
        // Web에서는 Payment Request API를 직접 사용
        throw UnsupportedError('Web payment 권한은 별도로 처리해야 합니다.');
      case PermissionType.webUsb:
        // Web에서는 Web USB API를 직접 사용
        throw UnsupportedError('Web USB 권한은 별도로 처리해야 합니다.');
      case PermissionType.webBluetooth:
        // Web에서는 Web Bluetooth API를 직접 사용
        throw UnsupportedError('Web Bluetooth 권한은 별도로 처리해야 합니다.');

      default:
        throw ArgumentError('Unsupported permission type: $type');
    }
  }

  @override
  PermissionStatus convertFromPlatformStatus(dynamic platformStatus) {
    if (platformStatus is PermissionStatus) {
      switch (platformStatus) {
        case PermissionStatus.denied:
          return PermissionStatus.denied;
        case PermissionStatus.granted:
          return PermissionStatus.granted;
        case PermissionStatus.restricted:
          return PermissionStatus.restricted;
        case PermissionStatus.permanentlyDenied:
          return PermissionStatus.permanentlyDenied;
        case PermissionStatus.limited:
          return PermissionStatus.limited;
        case PermissionStatus.provisional:
          return PermissionStatus.provisional;
        default:
          return PermissionStatus.unknown;
      }
    }
    return PermissionStatus.unknown;
  }
}
