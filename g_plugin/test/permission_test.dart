import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/services.dart';
import 'package:g_plugin/permission/permission.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('GPermission Tests', () {
    setUp(() async {
      // 각 테스트 전에 초기화
      if (GPermission.isInitialized) {
        await GPermission.dispose();
      }
    });

    tearDown(() async {
      // 각 테스트 후에 정리
      if (GPermission.isInitialized) {
        await GPermission.dispose();
      }
    });

    test('초기화 테스트', () async {
      expect(GPermission.isInitialized, false);

      await GPermission.initialize();

      expect(GPermission.isInitialized, true);
    });

    test('중복 초기화 방지', () async {
      await GPermission.initialize();
      expect(GPermission.isInitialized, true);

      // 두 번째 초기화는 무시되어야 함
      await GPermission.initialize();
      expect(GPermission.isInitialized, true);
    });

    test('권한 상태 확인', () async {
      await GPermission.initialize();

      try {
        final status = await GPermission.checkPermission(PermissionType.camera);
        expect(status, isA<PermissionStatus>());
      } catch (e) {
        // MissingPluginException이 발생할 수 있음
        expect(e, isA<MissingPluginException>());
      }
    });

    test('다중 권한 상태 확인', () async {
      await GPermission.initialize();

      try {
        final statuses = await GPermission.checkMultiplePermissions([
          PermissionType.camera,
          PermissionType.microphone,
        ]);

        expect(statuses, isA<Map<PermissionType, PermissionStatus>>());
        expect(statuses.length, 2);
      } catch (e) {
        expect(e, isA<MissingPluginException>());
      }
    });

    test('권한 요청', () async {
      await GPermission.initialize();

      try {
        final result = await GPermission.requestPermission(
          PermissionRequest.basic(PermissionType.camera),
        );

        expect(result, isA<PermissionResult>());
        expect(result.type, PermissionType.camera);
      } catch (e) {
        expect(e, isA<MissingPluginException>());
      }
    });

    test('다중 권한 요청', () async {
      await GPermission.initialize();

      try {
        final results = await GPermission.requestMultiplePermissions([
          PermissionRequest.basic(PermissionType.camera),
          PermissionRequest.basic(PermissionType.microphone),
        ]);

        expect(results, isA<Map<PermissionType, PermissionResult>>());
        expect(results.length, 2);
      } catch (e) {
        expect(e, isA<MissingPluginException>());
      }
    });

    test('권한 허용 여부 확인', () async {
      await GPermission.initialize();

      try {
        final isGranted =
            await GPermission.isPermissionGranted(PermissionType.camera);
        expect(isGranted, isA<bool>());
      } catch (e) {
        expect(e, isA<MissingPluginException>());
      }
    });

    test('권한 거부 여부 확인', () async {
      await GPermission.initialize();

      try {
        final isDenied =
            await GPermission.isPermissionDenied(PermissionType.camera);
        expect(isDenied, isA<bool>());
      } catch (e) {
        expect(e, isA<MissingPluginException>());
      }
    });

    test('권한 영구 거부 여부 확인', () async {
      await GPermission.initialize();

      try {
        final isPermanentlyDenied =
            await GPermission.isPermissionPermanentlyDenied(
                PermissionType.camera);
        expect(isPermanentlyDenied, isA<bool>());
      } catch (e) {
        expect(e, isA<MissingPluginException>());
      }
    });

    test('권한 제한 여부 확인', () async {
      await GPermission.initialize();

      try {
        final isRestricted =
            await GPermission.isPermissionRestricted(PermissionType.camera);
        expect(isRestricted, isA<bool>());
      } catch (e) {
        expect(e, isA<MissingPluginException>());
      }
    });

    test('권한 사용 불가 여부 확인', () async {
      await GPermission.initialize();

      try {
        final isUnavailable =
            await GPermission.isPermissionUnavailable(PermissionType.camera);
        expect(isUnavailable, isA<bool>());
      } catch (e) {
        expect(e, isA<MissingPluginException>());
      }
    });

    test('권한 요청 rationale 표시 여부 확인', () async {
      await GPermission.initialize();

      try {
        final shouldShow =
            await GPermission.shouldShowRequestRationale(PermissionType.camera);
        expect(shouldShow, isA<bool>());
      } catch (e) {
        expect(e, isA<MissingPluginException>());
      }
    });

    test('사용 가능한 권한 목록 가져오기', () async {
      await GPermission.initialize();

      final permissions = GPermission.getAvailablePermissionsForPlatform();
      expect(permissions, isA<List<PermissionType>>());
      expect(permissions.isNotEmpty, true);
    });

    test('상태 추적기 가져오기', () async {
      await GPermission.initialize();

      final stateTracker = GPermission.stateTracker;
      expect(stateTracker, isA<PermissionStateTracker>());
    });

    test('요청 전략 가져오기', () async {
      await GPermission.initialize();

      final requestStrategy = GPermission.requestStrategy;
      expect(requestStrategy, isA<PermissionRequestStrategy>());
    });

    test('간편한 권한 요청', () async {
      await GPermission.initialize();

      try {
        final result = await GPermission.request(PermissionType.camera);
        expect(result, isA<PermissionResult>());
        expect(result.type, PermissionType.camera);
      } catch (e) {
        expect(e, isA<MissingPluginException>());
      }
    });

    test('간편한 다중 권한 요청', () async {
      await GPermission.initialize();

      try {
        final results = await GPermission.requestMultiple([
          PermissionType.camera,
          PermissionType.microphone,
        ]);

        expect(results, isA<Map<PermissionType, PermissionResult>>());
        expect(results.length, 2);
      } catch (e) {
        expect(e, isA<MissingPluginException>());
      }
    });

    test('초기화되지 않은 상태에서 메서드 호출 시 예외 발생', () async {
      expect(() => GPermission.checkPermission(PermissionType.camera),
          throwsStateError);
    });

    test('정리 테스트', () async {
      await GPermission.initialize();
      expect(GPermission.isInitialized, true);

      await GPermission.dispose();
      expect(GPermission.isInitialized, false);
    });
  });

  group('PermissionType Tests', () {
    test('권한 타입 enum 값들', () {
      expect(PermissionType.camera, isA<PermissionType>());
      expect(PermissionType.microphone, isA<PermissionType>());
      expect(PermissionType.storage, isA<PermissionType>());
      expect(PermissionType.location, isA<PermissionType>());
      expect(PermissionType.notification, isA<PermissionType>());
    });
  });

  group('PermissionStatus Tests', () {
    test('권한 상태 enum 값들', () {
      expect(PermissionStatus.denied, isA<PermissionStatus>());
      expect(PermissionStatus.granted, isA<PermissionStatus>());
      expect(PermissionStatus.restricted, isA<PermissionStatus>());
      expect(PermissionStatus.permanentlyDenied, isA<PermissionStatus>());
      expect(PermissionStatus.limited, isA<PermissionStatus>());
      expect(PermissionStatus.provisional, isA<PermissionStatus>());
      expect(PermissionStatus.unavailable, isA<PermissionStatus>());
      expect(PermissionStatus.unknown, isA<PermissionStatus>());
    });
  });

  group('PermissionRequest Tests', () {
    test('기본 권한 요청 생성', () {
      final request = PermissionRequest.basic(PermissionType.camera);
      expect(request.type, PermissionType.camera);
      expect(request.reason, '이 기능을 사용하기 위해 권한이 필요합니다.');
      expect(request.showRationale, true);
      expect(request.openSettingsOnDenied, true);
      expect(request.maxRetryCount, 1);
    });

    test('상세한 권한 요청 생성', () {
      final request = PermissionRequest.detailed(
        type: PermissionType.camera,
        reason: '사진 촬영을 위해 카메라 권한이 필요합니다.',
        description: '사진을 촬영하여 프로필 사진으로 설정할 수 있습니다.',
        deniedMessage: '카메라 권한이 거부되었습니다.',
        permanentlyDeniedMessage: '카메라 권한이 영구적으로 거부되었습니다.',
        failedMessage: '카메라 권한 요청에 실패했습니다.',
        showRationale: false,
        openSettingsOnDenied: false,
        maxRetryCount: 3,
      );

      expect(request.type, PermissionType.camera);
      expect(request.reason, '사진 촬영을 위해 카메라 권한이 필요합니다.');
      expect(request.description, '사진을 촬영하여 프로필 사진으로 설정할 수 있습니다.');
      expect(request.deniedMessage, '카메라 권한이 거부되었습니다.');
      expect(request.permanentlyDeniedMessage, '카메라 권한이 영구적으로 거부되었습니다.');
      expect(request.failedMessage, '카메라 권한 요청에 실패했습니다.');
      expect(request.showRationale, false);
      expect(request.openSettingsOnDenied, false);
      expect(request.maxRetryCount, 3);
    });
  });

  group('PermissionResult Tests', () {
    test('성공 결과 생성', () {
      final result = PermissionResult.success(PermissionType.camera, 1);
      expect(result.type, PermissionType.camera);
      expect(result.status, PermissionStatus.granted);
      expect(result.isGranted, true);
      expect(result.isDenied, false);
      expect(result.isPermanentlyDenied, false);
      expect(result.attemptCount, 1);
    });

    test('실패 결과 생성', () {
      final result = PermissionResult.failure(
        PermissionType.camera,
        PermissionStatus.denied,
        '권한이 거부되었습니다.',
        2,
      );

      expect(result.type, PermissionType.camera);
      expect(result.status, PermissionStatus.denied);
      expect(result.isGranted, false);
      expect(result.isDenied, true);
      expect(result.isPermanentlyDenied, false);
      expect(result.errorMessage, '권한이 거부되었습니다.');
      expect(result.attemptCount, 2);
    });
  });
}
