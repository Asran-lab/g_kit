import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/services.dart';
import 'package:g_plugin/biometric/facade/g_biometric.dart';
import 'package:g_lib/g_lib_plugin.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('GBiometric Tests', () {
    setUp(() {
      // 각 테스트 전에 초기화 상태 리셋
    });

    tearDown(() async {
      // 각 테스트 후에 정리
      if (GBiometric.isInitialized) {
        await GBiometric.dispose();
      }
    });

    group('초기화 테스트', () {
      test('기본 초기화', () async {
        expect(GBiometric.isInitialized, false);
        // await GBiometric.initialize();
        expect(GBiometric.isInitialized, true);
      });

      // test('중복 초기화', () async {
      //   // await GBiometric.initialize();
      //   // expect(GBiometric.isInitialized, true);
      //   // 중복 초기화는 허용됨 (기존 상태 유지)
      //   // await GBiometric.initialize();
      //   // expect(GBiometric.isInitialized, true);
      // });
    });

    group('디바이스 지원 확인 테스트', () {
      test('isDeviceSupported - 기본 테스트', () async {
        // await GBiometric.initialize();

        // local_auth 플러그인이 테스트 환경에서 사용 불가능하므로 예외 처리
        try {
          final result = await GBiometric.isDeviceSupported();
          expect(result, isA<bool>());
        } catch (e) {
          // MissingPluginException이 발생할 수 있으므로 이를 허용
          expect(e, isA<MissingPluginException>());
        }
      });

      test('canCheckBiometrics - 기본 테스트', () async {
        // await GBiometric.initialize();

        // local_auth 플러그인이 테스트 환경에서 사용 불가능하므로 예외 처리
        try {
          final result = await GBiometric.canCheckBiometrics();
          expect(result, isA<bool>());
        } catch (e) {
          // MissingPluginException이 발생할 수 있으므로 이를 허용
          expect(e, isA<MissingPluginException>());
        }
      });
    });

    group('생체인식 타입 테스트', () {
      test('availableBiometrics - 기본 테스트', () async {
        // await GBiometric.initialize();

        // local_auth 플러그인이 테스트 환경에서 사용 불가능하므로 예외 처리
        try {
          final result = await GBiometric.availableBiometrics();
          expect(result, isA<List<BiometricType>>());
        } catch (e) {
          // MissingPluginException이 발생할 수 있으므로 이를 허용
          expect(e, isA<MissingPluginException>());
        }
      });
    });

    group('인증 테스트', () {
      test('authenticate - 기본 파라미터 테스트', () async {
        // await GBiometric.initialize();

        // local_auth 플러그인이 테스트 환경에서 사용 불가능하므로 예외 처리
        try {
          await GBiometric.authenticate(
            localizedReason: '테스트 인증',
          );
          // 성공 시 아무것도 하지 않음
        } catch (e) {
          // MissingPluginException이 발생할 수 있으므로 이를 허용
          expect(e, isA<MissingPluginException>());
        }
      });

      test('authenticate - 모든 파라미터 테스트', () async {
        // await GBiometric.initialize();

        // local_auth 플러그인이 테스트 환경에서 사용 불가능하므로 예외 처리
        try {
          await GBiometric.authenticate(
            localizedReason: '테스트 인증',
            biometricOnly: false,
            stickyAuth: true,
          );
          // 성공 시 아무것도 하지 않음
        } catch (e) {
          // MissingPluginException이 발생할 수 있으므로 이를 허용
          expect(e, isA<MissingPluginException>());
        }
      });
    });

    group('초기화 상태 테스트', () {
      test('isInitialized - 초기화 상태 확인', () async {
        expect(GBiometric.isInitialized, false);
        // await GBiometric.initialize();
        expect(GBiometric.isInitialized, true);
        await GBiometric.dispose();
        expect(GBiometric.isInitialized, false);
      });
    });

    group('에러 처리 테스트', () {
      test('초기화 전 메서드 호출 시 에러', () async {
        expect(() => GBiometric.isDeviceSupported(), throwsStateError);
        expect(() => GBiometric.canCheckBiometrics(), throwsStateError);
        expect(() => GBiometric.availableBiometrics(), throwsStateError);
        expect(() => GBiometric.authenticate(localizedReason: 'test'),
            throwsStateError);
      });
    });
  });
}
