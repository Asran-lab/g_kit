import 'package:g_lib/g_lib.dart';
import 'package:g_common/utils/g_platform.dart';
import 'package:g_common/utils/g_uuid.dart';
import 'package:g_common/utils/g_logger.dart';

/// 디바이스 정보를 관리하는 유틸리티 클래스
class GDeviceInfo {
  static final DeviceInfoPlugin _deviceInfo = DeviceInfoPlugin();

  /// 디바이스 ID 생성
  static Future<String> generateDeviceId() async {
    try {
      if (isAndroid) {
        final androidInfo = await _deviceInfo.androidInfo;
        return androidInfo.id; // Android ID
      } else if (isIOS) {
        final iosInfo = await _deviceInfo.iosInfo;
        return iosInfo.identifierForVendor ??
            'ios_${DateTime.now().millisecondsSinceEpoch}';
      } else if (isMacOS) {
        final macOsInfo = await _deviceInfo.macOsInfo;
        return macOsInfo.systemGUID ??
            'macos_${DateTime.now().millisecondsSinceEpoch}';
      } else if (isWindows) {
        final windowsInfo = await _deviceInfo.windowsInfo;
        return windowsInfo.deviceId;
      } else if (isLinux) {
        final linuxInfo = await _deviceInfo.linuxInfo;
        return linuxInfo.machineId ??
            'linux_${DateTime.now().millisecondsSinceEpoch}';
      } else if (isWeb) {
        // 웹에서는 UUID 기반 ID 생성
        return 'web_${GUuid.generate()}';
      } else {
        // 기타 플랫폼
        return 'unknown_${GUuid.generate()}';
      }
    } catch (e) {
      Logger.w('디바이스 ID 생성 실패: $e');
      // 폴백: UUID 기반 ID
      return 'fallback_${GUuid.generate()}';
    }
  }

  /// 디바이스 정보 가져오기
  static Future<Map<String, String>> getDeviceInfo() async {
    try {
      String deviceType = 'unknown';
      String deviceName = 'Unknown Device';
      String osVersion = 'Unknown';

      if (isAndroid) {
        final androidInfo = await _deviceInfo.androidInfo;
        deviceType = 'android';
        deviceName = androidInfo.model;
        osVersion = 'Android ${androidInfo.version.release}';
      } else if (isIOS) {
        final iosInfo = await _deviceInfo.iosInfo;
        deviceType = 'ios';
        deviceName = iosInfo.model;
        osVersion = 'iOS ${iosInfo.systemVersion}';
      } else if (isMacOS) {
        final macOsInfo = await _deviceInfo.macOsInfo;
        deviceType = 'macos';
        deviceName = macOsInfo.computerName;
        osVersion = 'macOS ${macOsInfo.osRelease}';
      } else if (isWindows) {
        final windowsInfo = await _deviceInfo.windowsInfo;
        deviceType = 'windows';
        deviceName = windowsInfo.computerName;
        osVersion = 'Windows ${windowsInfo.buildNumber}';
      } else if (isLinux) {
        final linuxInfo = await _deviceInfo.linuxInfo;
        deviceType = 'linux';
        deviceName = linuxInfo.name;
        osVersion = 'Linux ${linuxInfo.version}';
      } else if (isWeb) {
        deviceType = 'web';
        deviceName = 'Web Browser';
        osVersion = 'Web Platform';
      }

      return {
        'deviceType': deviceType,
        'deviceName': deviceName,
        'osVersion': osVersion,
      };
    } catch (e) {
      Logger.w('디바이스 정보 가져오기 실패: $e');
      return {
        'deviceType': 'unknown',
        'deviceName': 'Unknown Device',
        'osVersion': 'Unknown',
      };
    }
  }

  /// 플랫폼별 상세 정보 가져오기
  static Future<Map<String, dynamic>> getDetailedDeviceInfo() async {
    try {
      if (isAndroid) {
        final androidInfo = await _deviceInfo.androidInfo;
        return {
          'platform': 'android',
          'model': androidInfo.model,
          'manufacturer': androidInfo.manufacturer,
          'brand': androidInfo.brand,
          'product': androidInfo.product,
          'device': androidInfo.device,
          'androidId': androidInfo.id,
          'version': {
            'release': androidInfo.version.release,
            'sdkInt': androidInfo.version.sdkInt,
            'codename': androidInfo.version.codename,
          },
          'isPhysicalDevice': androidInfo.isPhysicalDevice,
        };
      } else if (isIOS) {
        final iosInfo = await _deviceInfo.iosInfo;
        return {
          'platform': 'ios',
          'model': iosInfo.model,
          'name': iosInfo.name,
          'systemName': iosInfo.systemName,
          'systemVersion': iosInfo.systemVersion,
          'identifierForVendor': iosInfo.identifierForVendor,
          'isPhysicalDevice': iosInfo.isPhysicalDevice,
          'localizedModel': iosInfo.localizedModel,
          'utsname': {
            'machine': iosInfo.utsname.machine,
            'nodename': iosInfo.utsname.nodename,
            'release': iosInfo.utsname.release,
            'sysname': iosInfo.utsname.sysname,
            'version': iosInfo.utsname.version,
          },
        };
      } else if (isMacOS) {
        final macOsInfo = await _deviceInfo.macOsInfo;
        return {
          'platform': 'macos',
          'computerName': macOsInfo.computerName,
          'hostName': macOsInfo.hostName,
          'arch': macOsInfo.arch,
          'model': macOsInfo.model,
          'systemGUID': macOsInfo.systemGUID,
          'osRelease': macOsInfo.osRelease,
          'activeCPUs': macOsInfo.activeCPUs,
          'memorySize': macOsInfo.memorySize,
        };
      } else if (isWindows) {
        final windowsInfo = await _deviceInfo.windowsInfo;
        return {
          'platform': 'windows',
          'computerName': windowsInfo.computerName,
          'numberOfCores': windowsInfo.numberOfCores,
          'systemMemoryInMegabytes': windowsInfo.systemMemoryInMegabytes,
          'userName': windowsInfo.userName,
          'majorVersion': windowsInfo.majorVersion,
          'minorVersion': windowsInfo.minorVersion,
          'buildNumber': windowsInfo.buildNumber,
          'platformId': windowsInfo.platformId,
          'csdVersion': windowsInfo.csdVersion,
          'servicePackMajor': windowsInfo.servicePackMajor,
          'servicePackMinor': windowsInfo.servicePackMinor,
          'suitMask': windowsInfo.suitMask,
          'productType': windowsInfo.productType,
          'reserved': windowsInfo.reserved,
          'buildLab': windowsInfo.buildLab,
          'buildLabEx': windowsInfo.buildLabEx,
          'digitalProductId': windowsInfo.digitalProductId,
          'displayVersion': windowsInfo.displayVersion,
          'editionId': windowsInfo.editionId,
          'productId': windowsInfo.productId,
          'productName': windowsInfo.productName,
          'registeredOwner': windowsInfo.registeredOwner,
          'releaseId': windowsInfo.releaseId,
          'deviceId': windowsInfo.deviceId,
        };
      } else if (isLinux) {
        final linuxInfo = await _deviceInfo.linuxInfo;
        return {
          'platform': 'linux',
          'name': linuxInfo.name,
          'version': linuxInfo.version,
          'id': linuxInfo.id,
          'idLike': linuxInfo.idLike,
          'versionCodename': linuxInfo.versionCodename,
          'versionId': linuxInfo.versionId,
          'prettyName': linuxInfo.prettyName,
          'buildId': linuxInfo.buildId,
          'variant': linuxInfo.variant,
          'variantId': linuxInfo.variantId,
          'machineId': linuxInfo.machineId,
        };
      } else if (isWeb) {
        return {
          'platform': 'web',
          'userAgent': 'Web Browser',
          'browserName': 'Unknown',
          'browserVersion': 'Unknown',
        };
      } else {
        return {
          'platform': 'unknown',
          'error': 'Unsupported platform',
        };
      }
    } catch (e) {
      Logger.w('상세 디바이스 정보 가져오기 실패: $e');
      return {
        'platform': 'unknown',
        'error': e.toString(),
      };
    }
  }

  /// 디바이스가 물리적 디바이스인지 확인
  static Future<bool> isPhysicalDevice() async {
    try {
      if (isAndroid) {
        final androidInfo = await _deviceInfo.androidInfo;
        return androidInfo.isPhysicalDevice;
      } else if (isIOS) {
        final iosInfo = await _deviceInfo.iosInfo;
        return iosInfo.isPhysicalDevice;
      } else {
        // 데스크톱이나 웹은 항상 물리적 디바이스로 간주
        return true;
      }
    } catch (e) {
      Logger.w('물리적 디바이스 확인 실패: $e');
      return false;
    }
  }
}
