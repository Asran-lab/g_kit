import 'dart:io' as io;
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:g_lib/g_lib_common.dart';

/// 파일 관련 유틸리티 클래스
///
/// 사용된 라이브러리: path_provider
///
///
/// 1. 파일 이름 관련
/// - getNameWithoutExtension: 확장자 제거한 이름 추출
/// - getFileName: 파일 이름 (확장자 포함)
/// - getFileSizeReadable: 읽기 쉬운 파일 크기 (1.5 MB)
///
/// 2. 파일 읽기/쓰기
/// - readAsBytes: 파일 → Bytes
/// - readAsString: 파일 읽기 (String)
/// - readAsJson: JSON 파일 읽기
/// - writeString: String → 파일로 저장
/// - writeJson: JSON → 파일로 저장
/// - writeBytes: Bytes → 파일로 저장
///
/// 3. 디렉토리 관리
/// - createDirectory: 디렉토리 생성
/// - listFiles: 디렉토리 내 파일 목록
/// - listAllFiles: 디렉토리 내 모든 파일 (재귀)
/// - deleteDirectory: 디렉토리 삭제 (재귀)
/// - getModifiedTime: 파일 수정 시간
/// - filterByExtension: 파일 확장자로 필터링
///
/// 4. 파일 정보
/// - getModifiedTime: 파일 수정 시간
/// - filterByExtension: 파일 확장자로 필터링
///
class GFileHelper {
  GFileHelper._();

  /// 파일 이름 추출
  /// ex) final name = FileHelper.getFileName('/path/to/file.txt');
  /// name: 'file.txt'
  static String basename(String fullPath) =>
      fullPath.substring(fullPath.lastIndexOf('/') + 1);

  /// 파일 확장자 추출
  /// ex) final ext = FileHelper.getExtension('/path/to/file.txt');
  /// ext: '.txt'
  static String getExtension(String fullPath) {
    final dot = fullPath.lastIndexOf('.');
    if (dot == -1) return ''; // 확장자 없음
    return fullPath.substring(dot).toLowerCase(); // '.png'
  }

  /// 파일 확장자 제거한 이름
  /// ex) final name = FileHelper.getNameWithoutExtension('/path/to/file.txt');
  /// name: 'file'
  static String getNameWithoutExtension(String fullPath) {
    final name = basename(fullPath);
    final dot = name.lastIndexOf('.');
    if (dot == -1) return name;
    return name.substring(0, dot);
  }

  /// path 라이브러리의 base 구현
  /// 파일 경로에서 파일명만 추출
  static String _basename(String path) {
    if (path.isEmpty) return '';
    final separators = ['/', '\\'];

    for (final sep in separators) {
      if (path.contains(sep)) {
        path = path.split(sep).where((segment) => segment.isNotEmpty).last;
      }
    }
    return path;
  }

  /// 🏷 파일 이름 (확장자 포함)
  /// ex) final name = FileHelper.getFileName('/path/to/file.txt');
  /// name: 'file.txt'
  static String getFileName(String path) => _basename(path);

  /// 📏 파일 사이즈 (byte 단위)
  /// ex) final size = await FileHelper.getFileSize('/path/to/file.txt');
  /// size: 1024
  static Future<int> getFileSize(String path) async {
    final file = io.File(path);
    if (await file.exists()) return (await file.stat()).size;
    throw io.FileSystemException("파일이 존재하지 않습니다.", path);
  }

  /// 📏 파일 사이즈를 읽기 쉬운 형태로 변환
  /// ex) final size = await FileHelper.getFileSizeReadable('/path/to/file.txt');
  /// size: '1.5 MB'
  static Future<String> getFileSizeReadable(String path) async {
    final bytes = await getFileSize(path);
    return _formatBytes(bytes);
  }

  /// 바이트를 읽기 쉬운 형태로 변환
  static String _formatBytes(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }

  /// 📥 애셋 → 파일로 복사
  /// ex) final file = await FileHelper.copyAssetToFile('assets/file.txt');
  /// file: /path/to/file.txt
  static Future<io.File> copyAssetToFile(
    String assetPath, {
    String? fileName,
  }) async {
    final dir = await getApplicationDocumentsDirectory();
    final name = fileName ?? _basename(assetPath);
    final file = io.File('${dir.path}/$name');

    final byteData = await rootBundle.load(assetPath);
    final bytes = byteData.buffer.asUint8List();

    return file.writeAsBytes(bytes, flush: true);
  }

  /// 📥 웹 URL → 파일로 다운로드
  /// ex) final file = await FileHelper.downloadFromUrl('https://example.com/file.txt');
  /// file: /path/to/file.txt
  static Future<io.File> downloadFromUrl(String url, {String? fileName}) async {
    final dir = await getApplicationDocumentsDirectory();
    final name = fileName ?? _basename(url);
    final file = io.File('${dir.path}/$name');

    final response = await io.HttpClient().getUrl(Uri.parse(url));
    final result = await response.close();
    final bytes = await consolidateHttpClientResponseBytes(result);

    return file.writeAsBytes(bytes, flush: true);
  }

  /// 📋 파일 복사
  /// ex) final copiedFile = await FileHelper.copyFile(
  ///   from: '/path/to/source.txt',
  ///   to: '/path/to/destination.txt',
  ///   overwrite: true,
  /// );
  /// copiedFile: /path/to/destination.txt
  static Future<io.File> copyFile({
    required String from,
    required String to,
    bool overwrite = false,
  }) async {
    final source = io.File(from);
    final destination = io.File(to);

    if (!await source.exists()) {
      throw io.FileSystemException("복사할 원본 파일이 존재하지 않습니다.", from);
    }

    if (await destination.exists() && !overwrite) {
      throw io.FileSystemException("대상 파일이 이미 존재합니다.", to);
    }

    if (await destination.exists()) await destination.delete();
    return await source.copy(to);
  }

  /// ❌ 파일 삭제
  /// ex) await FileHelper.delete('/path/to/file.txt');
  static Future<void> delete(String path) async {
    final file = io.File(path);
    if (await file.exists()) await file.delete();
  }

  /// 📥 파일 → Bytes
  /// ex) final bytes = await FileHelper.readAsBytes('/path/to/file.txt');
  /// bytes: [104, 101, 108, 108, 111]
  static Future<List<int>> readAsBytes(String path) async =>
      io.File(path).readAsBytes();

  /// ✅ 파일 존재 여부
  /// ex) final exists = await GFileHelper.exists('/path/to/file.txt');
  /// exists: true
  static Future<bool> exists(String path) async => io.File(path).exists();

  /// 📖 파일 읽기 (String)
  /// ex) final content = await FileHelper.readAsString('/path/to/file.txt');
  /// content: 'hello, world!'
  static Future<String> readAsString(String path) async =>
      io.File(path).readAsString();

  /// 📖 JSON 파일 읽기
  /// ex) final data = await FileHelper.readAsJson('/path/to/data.json');
  /// data: {'key': 'value'}
  static Future<Map<String, dynamic>> readAsJson(String path) async {
    final content = await readAsString(path);
    return json.decode(content) as Map<String, dynamic>;
  }

  /// 💾 String → 파일로 저장
  /// ex) final file = await GFileHelper.writeString(
  ///   content: 'hello, world!',
  ///   path: '/path/to/file.txt',
  /// );
  /// file: /path/to/file.txt
  static Future<io.File> writeString({
    required String content,
    required String path,
  }) async {
    final file = io.File(path);
    return await file.writeAsString(content, flush: true);
  }

  /// 💾 JSON → 파일로 저장
  /// ex) final file = await GFileHelper.writeJson(
  ///   data: {'key': 'value'},
  ///   path: '/path/to/data.json',
  /// );
  /// file: /path/to/data.json
  static Future<io.File> writeJson({
    required Map<String, dynamic> data,
    required String path,
  }) async {
    final content = json.encode(data);
    return await writeString(content: content, path: path);
  }

  /// 💾 Bytes → 파일로 저장
  /// ex) final file = await GFileHelper.writeBytes(
  ///   bytes: [104, 101, 108, 108, 111],
  ///   path: '/path/to/file.txt',
  /// );
  /// file: /path/to/file.txt
  static Future<io.File> writeBytes({
    required List<int> bytes,
    required String path,
  }) async {
    final file = io.File(path);
    return await file.writeAsBytes(bytes, flush: true);
  }

  /// 📍 임시 파일에 바이트 쓰기
  /// ex) final file = await GFileHelper.writeTempFile('temp.txt', [104, 101, 108, 108, 111]);
  /// file: /path/to/temp.txt
  static Future<io.File> writeTempFile(String name, List<int> bytes) async {
    final dir = io.Directory.systemTemp;
    final file = io.File('${dir.path}/$name');
    return file.writeAsBytes(bytes, flush: true);
  }

  /// 📍 임시 파일에 문자열 쓰기
  /// ex) final file = await GFileHelper.writeTempString('temp.txt', 'hello');
  /// file: /path/to/temp.txt
  static Future<io.File> writeTempString(String name, String content) async {
    final dir = io.Directory.systemTemp;
    final file = io.File('${dir.path}/$name');
    return file.writeAsString(content, flush: true);
  }

  /// 📁 디렉토리 생성
  /// ex) await GFileHelper.createDirectory('/path/to/new/directory');
  static Future<void> createDirectory(String path) async {
    final dir = io.Directory(path);
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }
  }

  /// 📁 디렉토리 내 파일 목록
  /// ex) final files = await GFileHelper.listFiles('/path/to/directory');
  /// files: ['file1.txt', 'file2.txt']
  static Future<List<String>> listFiles(String directoryPath) async {
    final dir = io.Directory(directoryPath);
    if (!await dir.exists()) return [];

    final entities = await dir.list().toList();
    return entities
        .whereType<io.File>()
        .map((file) => basename(file.path))
        .toList();
  }

  /// 📁 디렉토리 내 모든 파일 (재귀)
  /// ex) final files = await GFileHelper.listAllFiles('/path/to/directory');
  /// files: ['/path/to/file1.txt', '/path/to/sub/file2.txt']
  static Future<List<String>> listAllFiles(String directoryPath) async {
    final dir = io.Directory(directoryPath);
    if (!await dir.exists()) return [];

    final List<String> files = [];
    await for (final entity in dir.list(recursive: true)) {
      if (entity is io.File) {
        files.add(entity.path);
      }
    }
    return files;
  }

  /// 📁 디렉토리 삭제 (재귀)
  /// ex) await GFileHelper.deleteDirectory('/path/to/directory');
  static Future<void> deleteDirectory(String path) async {
    final dir = io.Directory(path);
    if (await dir.exists()) {
      await dir.delete(recursive: true);
    }
  }

  /// 📏 파일 수정 시간
  /// ex) final time = await GFileHelper.getModifiedTime('/path/to/file.txt');
  /// time: DateTime(2023, 1, 1, 12, 0, 0)
  static Future<DateTime> getModifiedTime(String path) async {
    final file = io.File(path);
    if (await file.exists()) {
      return (await file.stat()).modified;
    }
    throw io.FileSystemException("파일이 존재하지 않습니다.", path);
  }

  /// 🔍 파일 확장자로 필터링
  /// ex) final images = await GFileHelper.filterByExtension('/path/to/directory', '.jpg');
  /// images: ['image1.jpg', 'image2.jpg']
  static Future<List<String>> filterByExtension(
      String directoryPath, String extension) async {
    final files = await listFiles(directoryPath);
    return files
        .where((file) => getExtension(file) == extension.toLowerCase())
        .toList();
  }
}
