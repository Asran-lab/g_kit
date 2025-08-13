import '../common/share_type.dart';

/// 공유 서비스 추상 인터페이스
///
/// 공유 기능의 핵심 기능들을 정의합니다.
abstract class GShareService {
  Future<void> initialize();
  Future<void> dispose();

  /// 텍스트 공유
  Future<void> text(String text, {String? title, String? subject});

  /// 파일 공유
  Future<void> files(List<String> files,
      {String? title, String? subject, String? text});

  /// 이미지 공유
  Future<void> images(List<String> images,
      {String? title, String? subject, String? text});

  /// 링크 공유
  Future<void> links(String link,
      {String? title, String? subject, String? text});

  /// 공유 가능 여부 확인
  Future<bool> canShare(ShareType type);

  /// 공유 가능한 앱 목록 가져오기
  Future<List<String>> getAvailableApps(ShareType type);
}
