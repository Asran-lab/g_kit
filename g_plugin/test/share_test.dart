import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/services.dart';
import 'package:g_plugin/share/share.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('GShare Tests', () {
    setUp(() async {
      // 각 테스트 전에 초기화
      if (GShare.isInitialized) {
        await GShare.dispose();
      }
    });

    tearDown(() async {
      // 각 테스트 후에 정리
      if (GShare.isInitialized) {
        await GShare.dispose();
      }
    });

    test('초기화 테스트', () async {
      expect(GShare.isInitialized, false);

      await GShare.initialize();

      expect(GShare.isInitialized, true);
    });

    test('중복 초기화 방지', () async {
      await GShare.initialize();
      expect(GShare.isInitialized, true);

      // 두 번째 초기화는 무시되어야 함
      await GShare.initialize();
      expect(GShare.isInitialized, true);
    });

    test('텍스트 공유', () async {
      await GShare.initialize();

      try {
        await GShare.text('테스트 텍스트');
        // 성공적으로 완료되면 테스트 통과
      } catch (e) {
        // MissingPluginException이 발생할 수 있음
        expect(e, isA<MissingPluginException>());
      }
    });

    test('파일 공유', () async {
      await GShare.initialize();

      try {
        await GShare.files(['/path/to/file.txt']);
        // 성공적으로 완료되면 테스트 통과
      } catch (e) {
        expect(e, isA<MissingPluginException>());
      }
    });

    test('이미지 공유', () async {
      await GShare.initialize();

      try {
        await GShare.images(['/path/to/image.jpg']);
        // 성공적으로 완료되면 테스트 통과
      } catch (e) {
        expect(e, isA<MissingPluginException>());
      }
    });

    test('링크 공유', () async {
      await GShare.initialize();

      try {
        await GShare.links('https://example.com');
        // 성공적으로 완료되면 테스트 통과
      } catch (e) {
        expect(e, isA<MissingPluginException>());
      }
    });

    test('공유 가능 여부 확인', () async {
      await GShare.initialize();

      try {
        final canShare = await GShare.canShare(ShareType.text);
        expect(canShare, isA<bool>());
      } catch (e) {
        expect(e, isA<MissingPluginException>());
      }
    });

    test('공유 가능한 앱 목록 가져오기', () async {
      await GShare.initialize();

      try {
        final apps = await GShare.getAvailableApps(ShareType.text);
        expect(apps, isA<List<String>>());
      } catch (e) {
        expect(e, isA<MissingPluginException>());
      }
    });

    test('초기화되지 않은 상태에서 메서드 호출 시 예외 발생', () async {
      expect(() => GShare.text('테스트'), throwsStateError);
    });

    test('정리 테스트', () async {
      await GShare.initialize();
      expect(GShare.isInitialized, true);

      await GShare.dispose();
      expect(GShare.isInitialized, false);
    });
  });

  group('ShareType Tests', () {
    test('공유 타입 enum 값들', () {
      expect(ShareType.text, isA<ShareType>());
      expect(ShareType.files, isA<ShareType>());
      expect(ShareType.images, isA<ShareType>());
      expect(ShareType.link, isA<ShareType>());
    });
  });
}
