import '../models/permission_type.dart';
import '../models/permission_status.dart';
import 'g_permission_service.dart';

/// 권한 상태 추적기 구현체
class PermissionStateTrackerImpl implements PermissionStateTracker {
  final Map<PermissionType, PermissionStatus> _permissionStates = {};

  @override
  void updatePermissionState(PermissionType type, PermissionStatus status) {
    _permissionStates[type] = status;
  }

  @override
  PermissionStatus? getPermissionState(PermissionType type) {
    return _permissionStates[type];
  }

  @override
  List<PermissionType> getDeniedPermissions() {
    return _permissionStates.entries
        .where((entry) => entry.value == PermissionStatus.denied)
        .map((entry) => entry.key)
        .toList();
  }

  @override
  List<PermissionType> getGrantedPermissions() {
    return _permissionStates.entries
        .where((entry) => entry.value == PermissionStatus.granted)
        .map((entry) => entry.key)
        .toList();
  }

  @override
  List<PermissionType> getPermanentlyDeniedPermissions() {
    return _permissionStates.entries
        .where((entry) => entry.value == PermissionStatus.permanentlyDenied)
        .map((entry) => entry.key)
        .toList();
  }

  @override
  void clearAllStates() {
    _permissionStates.clear();
  }
}
