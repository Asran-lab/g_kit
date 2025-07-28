import 'package:g_lib/g_lib_plugin.dart' as g_lib;
import '../models/permission_type.dart';
import '../models/permission_status.dart';
import '../models/permission_request.dart';
import '../models/permission_result.dart';
import 'permission_platform.dart';

/// iOS 플랫폼 권한 처리 구현체
class IOSPermission implements PermissionPlatform {
  @override
  String get platformName => 'iOS';

  @override
  List<PermissionType> get supportedPermissions => [
        // 공통 권한
        PermissionType.camera,
        PermissionType.microphone,
        PermissionType.storage,
        PermissionType.location,
        PermissionType.notification,

        // iOS 특화 권한
        PermissionType.iosPhotos,
        PermissionType.iosCalendar,
        PermissionType.iosReminders,
        PermissionType.iosContacts,
        PermissionType.iosMediaLibrary,
        PermissionType.iosSpeech,
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
    // iOS에서는 rationale이 항상 false를 반환합니다.
    return false;
  }

  @override
  Future<void> openAppSettings() async {
    await openAppSettings();
  }

  @override
  Future<void> openPermissionSettings() async {
    await openAppSettings();
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

      // iOS 특화 권한
      case PermissionType.iosPhotos:
        return g_lib.Permission.photos;
      case PermissionType.iosCalendar:
        return g_lib.Permission.calendarWriteOnly;
      case PermissionType.iosReminders:
        return g_lib.Permission.reminders;
      case PermissionType.iosContacts:
        return g_lib.Permission.contacts;
      case PermissionType.iosMediaLibrary:
        return g_lib.Permission.mediaLibrary;
      case PermissionType.iosSpeech:
        return g_lib.Permission.speech;

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
