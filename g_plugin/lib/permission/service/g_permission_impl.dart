import 'package:g_common/utils/g_logger.dart' show Logger;
import '../common/permission_type.dart';
import '../common/permission_status.dart';
import '../common/permission_request.dart';
import '../common/permission_result.dart';
import '../platform/permission_platform.dart';
import '../platform/android_permission.dart';
import '../platform/ios_permission.dart';
import '../platform/macos_permission.dart';
import '../platform/web_permission.dart';
import 'permission_state_tracker_impl.dart';
import 'permission_request_strategy_impl.dart';
import 'g_permission_service.dart';
import 'dart:io';
import 'package:flutter/foundation.dart';

/// 권한 서비스 구현체
///
/// permission_handler 패키지를 사용하여 권한을 관리합니다.
class GPermissionImpl implements GPermissionService {
  PermissionPlatform? _platform;
  PermissionStateTracker? _stateTracker;
  PermissionRequestStrategy? _requestStrategy;
  bool _isInitialized = false;

  @override
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      // 플랫폼 감지 및 초기화
      _platform = _createPlatform();
      _stateTracker = _createStateTracker();
      _requestStrategy = _createRequestStrategy();

      _isInitialized = true;
      Logger.d('GPermissionImpl initialized successfully');
    } catch (e) {
      Logger.e('GPermissionImpl initialize failed', error: e);
      rethrow;
    }
  }

  @override
  Future<void> dispose() async {
    _platform = null;
    _stateTracker = null;
    _requestStrategy = null;
    _isInitialized = false;
  }

  @override
  Future<PermissionStatus> checkPermission(PermissionType type) async {
    _ensureInitialized();

    try {
      final status = await _platform!.checkPermission(type);
      _stateTracker?.updatePermissionState(type, status);
      return status;
    } catch (e) {
      Logger.e('Failed to check permission: $type', error: e);
      return PermissionStatus.unknown;
    }
  }

  @override
  Future<Map<PermissionType, PermissionStatus>> checkMultiplePermissions(
      List<PermissionType> types) async {
    _ensureInitialized();

    final results = <PermissionType, PermissionStatus>{};

    for (final type in types) {
      try {
        final status = await checkPermission(type);
        results[type] = status;
      } catch (e) {
        Logger.e('Failed to check permission: $type', error: e);
        results[type] = PermissionStatus.unknown;
      }
    }

    return results;
  }

  @override
  Future<PermissionResult> requestPermission(PermissionRequest request) async {
    _ensureInitialized();

    try {
      final result = await _platform!.requestPermission(request);
      _stateTracker?.updatePermissionState(request.type, result.status);
      return result;
    } catch (e) {
      Logger.e('Failed to request permission: ${request.type}', error: e);
      return PermissionResult.failure(
        request.type,
        PermissionStatus.unknown,
        e.toString(),
        1,
      );
    }
  }

  @override
  Future<Map<PermissionType, PermissionResult>> requestMultiplePermissions(
      List<PermissionRequest> requests) async {
    _ensureInitialized();

    final results = <PermissionType, PermissionResult>{};

    for (final request in requests) {
      try {
        final result = await requestPermission(request);
        results[request.type] = result;
      } catch (e) {
        Logger.e('Failed to request permission: ${request.type}', error: e);
        results[request.type] = PermissionResult.failure(
          request.type,
          PermissionStatus.unknown,
          e.toString(),
          1,
        );
      }
    }

    return results;
  }

  @override
  Future<bool> isPermissionGranted(PermissionType type) async {
    final status = await checkPermission(type);
    return status == PermissionStatus.granted;
  }

  @override
  Future<bool> isPermissionDenied(PermissionType type) async {
    final status = await checkPermission(type);
    return status == PermissionStatus.denied;
  }

  @override
  Future<bool> isPermissionPermanentlyDenied(PermissionType type) async {
    final status = await checkPermission(type);
    return status == PermissionStatus.permanentlyDenied;
  }

  @override
  Future<bool> isPermissionRestricted(PermissionType type) async {
    final status = await checkPermission(type);
    return status == PermissionStatus.restricted;
  }

  @override
  Future<bool> isPermissionUnavailable(PermissionType type) async {
    final status = await checkPermission(type);
    return status == PermissionStatus.unavailable;
  }

  @override
  Future<void> openAppSettings() async {
    _ensureInitialized();
    await _platform!.openAppSettings();
  }

  @override
  Future<void> openPermissionSettings() async {
    _ensureInitialized();
    await _platform!.openPermissionSettings();
  }

  @override
  Future<bool> shouldShowRequestRationale(PermissionType type) async {
    _ensureInitialized();
    return await _platform!.shouldShowRequestRationale(type);
  }

  @override
  List<PermissionType> getAvailablePermissionsForPlatform() {
    _ensureInitialized();
    return _platform!.supportedPermissions;
  }

  @override
  PermissionStateTracker get stateTracker {
    _ensureInitialized();
    return _stateTracker!;
  }

  @override
  PermissionRequestStrategy get requestStrategy {
    _ensureInitialized();
    return _requestStrategy!;
  }

  /// 초기화 상태 확인
  void _ensureInitialized() {
    if (!_isInitialized) {
      throw StateError(
          'GPermissionImpl is not initialized. Call initialize() first.');
    }
  }

  /// 플랫폼 생성
  PermissionPlatform _createPlatform() {
    if (kIsWeb) {
      return WebPermission();
    } else if (Platform.isAndroid) {
      return AndroidPermission();
    } else if (Platform.isIOS) {
      return IOSPermission();
    } else if (Platform.isMacOS) {
      return MacOSPermission();
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }

  /// 상태 추적기 생성
  PermissionStateTracker _createStateTracker() {
    return PermissionStateTrackerImpl();
  }

  /// 요청 전략 생성
  PermissionRequestStrategy _createRequestStrategy() {
    return PermissionRequestStrategyImpl();
  }
}
