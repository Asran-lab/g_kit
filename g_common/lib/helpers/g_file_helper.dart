import 'dart:io' as io;
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:archive/archive.dart';
import 'package:http/http.dart' as http;
import 'package:g_lib/g_lib_common.dart';

/// 📊 파일 작업 진행률 정보
class GFileProgress {
  final double progress; // 0.0 ~ 1.0
  final int currentStep;
  final int totalSteps;
  final String currentTask;
  final int? bytesProcessed;
  final int? totalBytes;
  final Duration? elapsedTime;
  final Duration? estimatedTimeRemaining;

  const GFileProgress({
    required this.progress,
    required this.currentStep,
    required this.totalSteps,
    required this.currentTask,
    this.bytesProcessed,
    this.totalBytes,
    this.elapsedTime,
    this.estimatedTimeRemaining,
  });

  /// 진행률을 퍼센트로 반환
  int get progressPercent => (progress * 100).round();

  /// 사람이 읽기 쉬운 형태로 반환
  String get readableProgress => '$progressPercent% ($currentStep/$totalSteps)';

  /// 바이트 진행률 정보 (있는 경우)
  String? get readableBytesProgress {
    if (bytesProcessed != null && totalBytes != null) {
      return '${GFileHelper._formatBytes(bytesProcessed!)} / ${GFileHelper._formatBytes(totalBytes!)}';
    }
    return null;
  }

  @override
  String toString() => 'GFileProgress($readableProgress, task: $currentTask)';
}

/// 🚨 파일 작업 에러 유형
enum GFileErrorType {
  fileNotFound, // 파일이 존재하지 않음
  directoryNotFound, // 디렉토리가 존재하지 않음
  permissionDenied, // 권한 부족
  diskSpaceInsufficient, // 디스크 공간 부족
  fileAlreadyExists, // 파일이 이미 존재함
  invalidFormat, // 잘못된 파일 형식
  networkError, // 네트워크 오류
  corruptedFile, // 손상된 파일
  operationCancelled, // 작업 취소됨
  unknownError, // 알 수 없는 오류
}

/// 🚨 파일 작업 에러 정보
class GFileError extends Error {
  final GFileErrorType type;
  final String message;
  final String? filePath;
  final Object? originalError;
  final StackTrace? originalStackTrace;
  final Map<String, dynamic>? additionalInfo;
  final bool isRecoverable;

  GFileError({
    required this.type,
    required this.message,
    this.filePath,
    this.originalError,
    this.originalStackTrace,
    this.additionalInfo,
    this.isRecoverable = false,
  });

  /// 사용자 친화적인 에러 메시지
  String get userFriendlyMessage {
    switch (type) {
      case GFileErrorType.fileNotFound:
        return '파일을 찾을 수 없습니다: ${filePath ?? '알 수 없는 파일'}';
      case GFileErrorType.directoryNotFound:
        return '폴더를 찾을 수 없습니다: ${filePath ?? '알 수 없는 폴더'}';
      case GFileErrorType.permissionDenied:
        return '파일에 접근할 권한이 없습니다: ${filePath ?? ''}';
      case GFileErrorType.diskSpaceInsufficient:
        return '저장 공간이 부족합니다';
      case GFileErrorType.fileAlreadyExists:
        return '파일이 이미 존재합니다: ${filePath ?? ''}';
      case GFileErrorType.invalidFormat:
        return '지원하지 않는 파일 형식입니다: ${filePath ?? ''}';
      case GFileErrorType.networkError:
        return '네트워크 연결에 문제가 있습니다';
      case GFileErrorType.corruptedFile:
        return '파일이 손상되었습니다: ${filePath ?? ''}';
      case GFileErrorType.operationCancelled:
        return '작업이 취소되었습니다';
      case GFileErrorType.unknownError:
        return '알 수 없는 오류가 발생했습니다: $message';
    }
  }

  /// 복구 제안 메시지
  String? get recoverySuggestion {
    if (!isRecoverable) return null;

    switch (type) {
      case GFileErrorType.permissionDenied:
        return '설정에서 앱의 저장소 접근 권한을 허용해주세요';
      case GFileErrorType.diskSpaceInsufficient:
        return '불필요한 파일을 삭제하여 저장 공간을 확보해주세요';
      case GFileErrorType.fileAlreadyExists:
        return '다른 이름으로 저장하거나 기존 파일을 덮어쓸 수 있습니다';
      case GFileErrorType.networkError:
        return '인터넷 연결을 확인하고 다시 시도해주세요';
      case GFileErrorType.fileNotFound:
        return '파일 경로를 확인하거나 다른 파일을 선택해주세요';
      default:
        return '잠시 후 다시 시도해주세요';
    }
  }

  @override
  String toString() =>
      'GFileError($type): $message${filePath != null ? ' (path: $filePath)' : ''}';

  /// Exception에서 GFileError로 변환
  static GFileError fromException(Object error, {String? filePath}) {
    if (error is io.FileSystemException) {
      return _fromFileSystemException(error, filePath);
    } else if (error is FormatException) {
      return GFileError(
        type: GFileErrorType.invalidFormat,
        message: error.message,
        filePath: filePath,
        originalError: error,
        isRecoverable: true,
      );
    } else if (error is http.ClientException) {
      return GFileError(
        type: GFileErrorType.networkError,
        message: error.message,
        filePath: filePath,
        originalError: error,
        isRecoverable: true,
      );
    } else {
      return GFileError(
        type: GFileErrorType.unknownError,
        message: error.toString(),
        filePath: filePath,
        originalError: error,
        isRecoverable: false,
      );
    }
  }

  static GFileError _fromFileSystemException(
      io.FileSystemException error, String? filePath) {
    final message = error.message.toLowerCase();

    if (message.contains('no such file') || message.contains('cannot find')) {
      return GFileError(
        type: GFileErrorType.fileNotFound,
        message: error.message,
        filePath: filePath ?? error.path,
        originalError: error,
        isRecoverable: true,
      );
    } else if (message.contains('permission denied') ||
        message.contains('access denied')) {
      return GFileError(
        type: GFileErrorType.permissionDenied,
        message: error.message,
        filePath: filePath ?? error.path,
        originalError: error,
        isRecoverable: true,
      );
    } else if (message.contains('no space') || message.contains('disk full')) {
      return GFileError(
        type: GFileErrorType.diskSpaceInsufficient,
        message: error.message,
        filePath: filePath ?? error.path,
        originalError: error,
        isRecoverable: true,
      );
    } else if (message.contains('already exists')) {
      return GFileError(
        type: GFileErrorType.fileAlreadyExists,
        message: error.message,
        filePath: filePath ?? error.path,
        originalError: error,
        isRecoverable: true,
      );
    } else {
      return GFileError(
        type: GFileErrorType.unknownError,
        message: error.message,
        filePath: filePath ?? error.path,
        originalError: error,
        isRecoverable: false,
      );
    }
  }
}

/// 📊 배치 처리 결과 래퍼
class _BatchResult<T> {
  final T? value;
  final GFileError? error;
  final bool isSuccess;

  _BatchResult.success(this.value)
      : error = null,
        isSuccess = true;
  _BatchResult.error(this.error)
      : value = null,
        isSuccess = false;
}

/// 📈 진행률 추적 헬퍼
class _ProgressTracker {
  final DateTime startTime = DateTime.now();
  final void Function(GFileProgress)? onProgress;

  int _currentStep = 0;
  int _totalSteps = 1;
  String _currentTask = '';
  int? _bytesProcessed;
  int? _totalBytes;

  _ProgressTracker(this.onProgress);

  void setTotalSteps(int total) {
    _totalSteps = total;
    _updateProgress();
  }

  void setCurrentStep(int step) {
    _currentStep = step;
    _updateProgress();
  }

  void nextStep(String task) {
    _currentStep++;
    _currentTask = task;
    _updateProgress();
  }

  void updateBytes(int processed, int total) {
    _bytesProcessed = processed;
    _totalBytes = total;
    _updateProgress();
  }

  void updateProgress(double progress, [String? task]) {
    if (task != null) _currentTask = task;
    final step = (_totalSteps * progress).round();
    if (step != _currentStep) {
      _currentStep = step;
      _updateProgress();
    }
  }

  void _updateProgress() {
    if (onProgress == null) return;

    final elapsed = DateTime.now().difference(startTime);
    final progress =
        _totalSteps > 0 ? (_currentStep / _totalSteps).clamp(0.0, 1.0) : 0.0;

    Duration? estimatedRemaining;
    if (progress > 0 && progress < 1.0) {
      final totalEstimated = elapsed.inMilliseconds / progress;
      estimatedRemaining = Duration(
          milliseconds: (totalEstimated - elapsed.inMilliseconds).round());
    }

    onProgress!(GFileProgress(
      progress: progress,
      currentStep: _currentStep,
      totalSteps: _totalSteps,
      currentTask: _currentTask,
      bytesProcessed: _bytesProcessed,
      totalBytes: _totalBytes,
      elapsedTime: elapsed,
      estimatedTimeRemaining: estimatedRemaining,
    ));
  }
}

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

  // ================================
  // 🚀 고급 기능들 (메모 내보내기용)
  // ================================

  /// 📊 CSV 파일 생성
  /// ex) final file = await GFileHelper.writeCsv(
  ///   headers: ['이름', '내용', '날짜'],
  ///   rows: [
  ///     ['메모1', '내용1', '2024-01-01'],
  ///     ['메모2', '내용2', '2024-01-02'],
  ///   ],
  ///   path: '/path/to/data.csv',
  ///   onProgress: (progress) => print('CSV 생성: ${progress.readableProgress}'),
  /// );
  static Future<io.File> writeCsv({
    required List<String> headers,
    required List<List<String>> rows,
    required String path,
    String separator = ',',
    bool includeHeaders = true,
    void Function(GFileProgress)? onProgress,
  }) async {
    final tracker = _ProgressTracker(onProgress);

    try {
      // 단계 설정: 1(헤더) + rows.length(데이터) + 1(파일쓰기)
      final totalSteps = (includeHeaders ? 1 : 0) + rows.length + 1;
      tracker.setTotalSteps(totalSteps);

      final buffer = StringBuffer();

      // 헤더 추가
      if (includeHeaders && headers.isNotEmpty) {
        tracker.nextStep('CSV 헤더 생성 중...');
        buffer.writeln(_csvRow(headers, separator));
      }

      // 데이터 행 추가
      for (int i = 0; i < rows.length; i++) {
        tracker.nextStep('CSV 데이터 행 ${i + 1}/${rows.length} 처리 중...');
        buffer.writeln(_csvRow(rows[i], separator));
      }

      // 파일 쓰기
      tracker.nextStep('CSV 파일 저장 중...');
      final content = buffer.toString();
      tracker.updateBytes(content.length, content.length);

      return await writeString(content: content, path: path);
    } catch (error) {
      throw GFileError.fromException(error, filePath: path);
    }
  }

  /// CSV 행 생성 (따옴표 처리 포함)
  static String _csvRow(List<String> values, String separator) {
    return values.map((value) {
      // 특수 문자가 포함된 경우 따옴표로 감싸기
      final needsQuotes = value.contains(separator) ||
          value.contains('\n') ||
          value.contains('"');
      if (needsQuotes) {
        // 내부 따옴표는 이중 따옴표로 이스케이프
        final escaped = value.replaceAll('"', '""');
        return '"$escaped"';
      }
      return value;
    }).join(separator);
  }

  /// 🌐 HTML 파일 생성
  /// ex) final file = await GFileHelper.writeHtml(
  ///   title: '내 메모들',
  ///   content: '<h1>메모 제목</h1><p>메모 내용</p>',
  ///   path: '/path/to/memo.html',
  ///   cssStyles: 'body { font-family: Arial; }',
  ///   onProgress: (progress) => print('HTML 생성: ${progress.readableProgress}'),
  /// );
  static Future<io.File> writeHtml({
    required String title,
    required String content,
    required String path,
    String? cssStyles,
    String? customHead,
    String charset = 'UTF-8',
    void Function(GFileProgress)? onProgress,
  }) async {
    final tracker = _ProgressTracker(onProgress);

    try {
      tracker.setTotalSteps(3); // 1(템플릿생성) + 1(HTML생성) + 1(파일저장)

      tracker.nextStep('HTML 템플릿 준비 중...');
      final htmlContent = _generateHtmlTemplate(
        title: title,
        content: content,
        cssStyles: cssStyles,
        customHead: customHead,
        charset: charset,
      );

      tracker.nextStep('HTML 컨텐츠 처리 중...');
      tracker.updateBytes(htmlContent.length, htmlContent.length);

      tracker.nextStep('HTML 파일 저장 중...');
      return await writeString(content: htmlContent, path: path);
    } catch (error) {
      throw GFileError.fromException(error, filePath: path);
    }
  }

  /// HTML 템플릿 생성
  static String _generateHtmlTemplate({
    required String title,
    required String content,
    String? cssStyles,
    String? customHead,
    String charset = 'UTF-8',
  }) {
    final buffer = StringBuffer();

    buffer.writeln('<!DOCTYPE html>');
    buffer.writeln('<html lang="ko">');
    buffer.writeln('<head>');
    buffer.writeln('  <meta charset="$charset">');
    buffer.writeln(
        '  <meta name="viewport" content="width=device-width, initial-scale=1.0">');
    buffer.writeln('  <title>${_escapeHtml(title)}</title>');

    // 기본 CSS 스타일
    buffer.writeln('  <style>');
    buffer.writeln(
        '    body { font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif; }');
    buffer.writeln(
        '    .container { max-width: 800px; margin: 0 auto; padding: 20px; }');
    buffer.writeln(
        '    .memo { margin-bottom: 30px; padding: 20px; border: 1px solid #ddd; border-radius: 8px; }');
    buffer.writeln(
        '    .memo-header { border-bottom: 1px solid #eee; padding-bottom: 10px; margin-bottom: 15px; }');
    buffer.writeln('    .memo-meta { color: #666; font-size: 0.9em; }');
    buffer.writeln('    .memo-content { line-height: 1.6; }');
    buffer.writeln('    .memo-images { margin-top: 15px; }');
    buffer.writeln(
        '    .memo-images img { max-width: 100%; height: auto; margin: 5px; border-radius: 4px; }');

    // 사용자 정의 CSS
    if (cssStyles != null && cssStyles.isNotEmpty) {
      buffer.writeln('    $cssStyles');
    }

    buffer.writeln('  </style>');

    // 사용자 정의 헤드 내용
    if (customHead != null && customHead.isNotEmpty) {
      buffer.writeln(customHead);
    }

    buffer.writeln('</head>');
    buffer.writeln('<body>');
    buffer.writeln('  <div class="container">');
    buffer.writeln(content);
    buffer.writeln('  </div>');
    buffer.writeln('</body>');
    buffer.writeln('</html>');

    return buffer.toString();
  }

  /// HTML 이스케이프 처리
  static String _escapeHtml(String text) {
    return text
        .replaceAll('&', '&amp;')
        .replaceAll('<', '&lt;')
        .replaceAll('>', '&gt;')
        .replaceAll('"', '&quot;')
        .replaceAll("'", '&#x27;');
  }

  /// 📦 ZIP 압축 파일 생성
  /// ex) final zipFile = await GFileHelper.createZip(
  ///   files: {
  ///     'memo.txt': 'utf8:메모 내용',
  ///     'image.jpg': 'file:/path/to/image.jpg',
  ///     'data.json': 'utf8:{"key": "value"}',
  ///   },
  ///   zipPath: '/path/to/archive.zip',
  ///   onProgress: (progress) => print('ZIP 생성: ${progress.readableProgress}'),
  /// );
  static Future<io.File> createZip({
    required Map<String, String> files,
    required String zipPath,
    void Function(GFileProgress)? onProgress,
  }) async {
    final tracker = _ProgressTracker(onProgress);

    try {
      // 단계: 파일 개수 + 1(압축) + 1(저장)
      tracker.setTotalSteps(files.length + 2);

      final archive = Archive();
      var totalBytes = 0;
      var processedBytes = 0;

      // 먼저 총 바이트 수 계산 (선택적)
      for (final entry in files.entries) {
        final fileContent = entry.value;
        if (fileContent.startsWith('file:')) {
          final filePath = fileContent.substring(5);
          final file = io.File(filePath);
          if (await file.exists()) {
            totalBytes += await getFileSize(filePath);
          }
        }
      }

      for (final entry in files.entries) {
        final fileName = entry.key;
        final fileContent = entry.value;

        tracker.nextStep('파일 처리 중: $fileName');

        List<int> bytes;

        try {
          if (fileContent.startsWith('utf8:')) {
            // UTF-8 텍스트 데이터
            final text = fileContent.substring(5);
            bytes = utf8.encode(text);
          } else if (fileContent.startsWith('file:')) {
            // 파일 경로에서 읽기
            final filePath = fileContent.substring(5);
            final file = io.File(filePath);
            if (await file.exists()) {
              bytes = await file.readAsBytes();
            } else {
              throw GFileError(
                type: GFileErrorType.fileNotFound,
                message: "압축할 파일이 존재하지 않습니다.",
                filePath: filePath,
                isRecoverable: true,
              );
            }
          } else if (fileContent.startsWith('base64:')) {
            // Base64 디코딩
            final base64Data = fileContent.substring(7);
            try {
              bytes = base64.decode(base64Data);
            } catch (e) {
              throw GFileError(
                type: GFileErrorType.invalidFormat,
                message: "잘못된 Base64 데이터입니다: $fileName",
                originalError: e,
                isRecoverable: true,
              );
            }
          } else {
            // 기본적으로 UTF-8 텍스트로 처리
            bytes = utf8.encode(fileContent);
          }

          final archiveFile = ArchiveFile(fileName, bytes.length, bytes);
          archive.addFile(archiveFile);

          processedBytes += bytes.length;
          if (totalBytes > 0) {
            tracker.updateBytes(processedBytes, totalBytes);
          }
        } catch (error) {
          if (error is GFileError) {
            rethrow;
          } else {
            throw GFileError.fromException(error, filePath: fileName);
          }
        }
      }

      // ZIP 압축
      tracker.nextStep('ZIP 압축 중...');
      final zipData = ZipEncoder().encode(archive);
      if (zipData.isEmpty) {
        throw GFileError(
          type: GFileErrorType.unknownError,
          message: "ZIP 압축에 실패했습니다.",
          filePath: zipPath,
          isRecoverable: false,
        );
      }

      // 파일 저장
      tracker.nextStep('ZIP 파일 저장 중...');
      tracker.updateBytes(zipData.length, zipData.length);

      return await writeBytes(bytes: zipData, path: zipPath);
    } catch (error) {
      if (error is GFileError) {
        rethrow;
      } else {
        throw GFileError.fromException(error, filePath: zipPath);
      }
    }
  }

  /// 📂 ZIP 파일 압축 해제
  /// ex) final extractedFiles = await GFileHelper.extractZip(
  ///   zipPath: '/path/to/archive.zip',
  ///   extractPath: '/path/to/extract/',
  ///   onProgress: (progress) => print('압축 해제: ${progress.readableProgress}'),
  /// );
  static Future<List<String>> extractZip({
    required String zipPath,
    required String extractPath,
    void Function(GFileProgress)? onProgress,
  }) async {
    final tracker = _ProgressTracker(onProgress);

    try {
      tracker.setTotalSteps(3); // 1(ZIP읽기) + 1(압축해제) + N(파일저장)

      tracker.nextStep('ZIP 파일 읽는 중...');
      final zipFile = io.File(zipPath);
      if (!await zipFile.exists()) {
        throw GFileError(
          type: GFileErrorType.fileNotFound,
          message: "ZIP 파일이 존재하지 않습니다.",
          filePath: zipPath,
          isRecoverable: true,
        );
      }

      final bytes = await zipFile.readAsBytes();
      tracker.updateBytes(bytes.length, bytes.length);

      tracker.nextStep('ZIP 압축 해제 중...');
      Archive archive;
      try {
        archive = ZipDecoder().decodeBytes(bytes);
      } catch (e) {
        throw GFileError(
          type: GFileErrorType.corruptedFile,
          message: "손상된 ZIP 파일입니다.",
          filePath: zipPath,
          originalError: e,
          isRecoverable: false,
        );
      }

      // 파일 추출 단계로 재설정
      tracker.setTotalSteps(2 + archive.length);
      tracker.setCurrentStep(2); // 이미 2단계 완료

      final extractedFiles = <String>[];
      var totalExtractedBytes = 0;
      final totalBytes =
          archive.fold<int>(0, (sum, file) => sum + (file.content.length));

      // 추출 디렉토리 생성
      await createDirectory(extractPath);

      for (final file in archive) {
        final fileName = file.name;
        final filePath = '$extractPath/$fileName';

        tracker.nextStep('파일 추출 중: $fileName');

        if (file.isFile) {
          final data = file.content as List<int>;
          final targetFile = io.File(filePath);

          try {
            // 디렉토리 구조 생성
            await createDirectory(targetFile.parent.path);

            await targetFile.writeAsBytes(data);
            extractedFiles.add(filePath);

            totalExtractedBytes += data.length;
            tracker.updateBytes(totalExtractedBytes, totalBytes);
          } catch (e) {
            throw GFileError.fromException(e, filePath: filePath);
          }
        }
      }

      return extractedFiles;
    } catch (error) {
      if (error is GFileError) {
        rethrow;
      } else {
        throw GFileError.fromException(error, filePath: zipPath);
      }
    }
  }

  /// 🔄 Base64 인코딩/디코딩 유틸리티

  /// 파일을 Base64로 인코딩
  /// ex) final base64 = await GFileHelper.fileToBase64('/path/to/image.jpg');
  static Future<String> fileToBase64(String filePath) async {
    final file = io.File(filePath);
    if (!await file.exists()) {
      throw io.FileSystemException("파일이 존재하지 않습니다.", filePath);
    }

    final bytes = await file.readAsBytes();
    return base64.encode(bytes);
  }

  /// URL에서 이미지를 Base64로 다운로드
  /// ex) final base64 = await GFileHelper.urlToBase64('https://example.com/image.jpg');
  static Future<String> urlToBase64(String url) async {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return base64.encode(response.bodyBytes);
    } else {
      throw Exception("URL에서 파일 다운로드 실패: ${response.statusCode}");
    }
  }

  /// Base64를 파일로 저장
  /// ex) final file = await GFileHelper.base64ToFile(
  ///   base64Data: base64String,
  ///   filePath: '/path/to/output.jpg',
  /// );
  static Future<io.File> base64ToFile({
    required String base64Data,
    required String filePath,
  }) async {
    final bytes = base64.decode(base64Data);
    return await writeBytes(bytes: bytes, path: filePath);
  }

  /// 이미지를 Data URL 형식으로 변환 (HTML 임베딩용)
  /// ex) final dataUrl = await GFileHelper.imageToDataUrl('/path/to/image.jpg');
  /// 결과: 'data:image/jpeg;base64,/9j/4AAQSkZJRgABAQAAAQ...'
  static Future<String> imageToDataUrl(String imagePath) async {
    final extension = getExtension(imagePath).toLowerCase();
    String mimeType;

    switch (extension) {
      case '.jpg':
      case '.jpeg':
        mimeType = 'image/jpeg';
        break;
      case '.png':
        mimeType = 'image/png';
        break;
      case '.gif':
        mimeType = 'image/gif';
        break;
      case '.webp':
        mimeType = 'image/webp';
        break;
      case '.svg':
        mimeType = 'image/svg+xml';
        break;
      default:
        mimeType = 'application/octet-stream';
    }

    final base64Data = await fileToBase64(imagePath);
    return 'data:$mimeType;base64,$base64Data';
  }

  /// ⚡ 배치 처리 - 여러 파일 동시 처리

  /// 여러 파일을 동시에 처리
  /// ex) final results = await GFileHelper.processBatch(
  ///   operations: [
  ///     () => copyFile(from: 'a.txt', to: 'a_copy.txt'),
  ///     () => writeString(content: 'hello', path: 'b.txt'),
  ///     () => delete('old.txt'),
  ///   ],
  ///   onProgress: (progress) => print('배치 처리: ${progress.readableProgress}'),
  ///   concurrency: 3,
  /// );
  static Future<List<T>> processBatch<T>({
    required List<Future<T> Function()> operations,
    void Function(GFileProgress)? onProgress,
    int concurrency = 4,
    bool stopOnError = false,
  }) async {
    final tracker = _ProgressTracker(onProgress);
    tracker.setTotalSteps(operations.length);

    final results = <T>[];
    final errors = <GFileError>[];

    try {
      // 배치를 동시성 제한으로 처리
      for (int i = 0; i < operations.length; i += concurrency) {
        final batch = operations.skip(i).take(concurrency).toList();

        // 각 배치의 시작 인덱스
        final batchStartIndex = i;

        final batchFutures = batch.asMap().entries.map((entry) {
          final batchIndex = entry.key;
          final operation = entry.value;
          final globalIndex = batchStartIndex + batchIndex;

          return _executeOperationWithErrorHandling(
            operation,
            globalIndex,
            tracker,
          );
        }).toList();

        final batchResults = await Future.wait(batchFutures);

        for (final result in batchResults) {
          if (result.isSuccess) {
            results.add(result.value as T);
          } else {
            errors.add(result.error!);
            if (stopOnError) {
              throw result.error!;
            }
          }
        }
      }

      // 에러가 있지만 중단하지 않는 경우 경고
      if (errors.isNotEmpty && !stopOnError) {
        if (kDebugMode) {
          print('배치 처리 중 ${errors.length}개의 에러가 발생했습니다.');
          for (final error in errors) {
            print('- ${error.userFriendlyMessage}');
          }
        }
      }

      return results;
    } catch (error) {
      if (error is GFileError) {
        rethrow;
      } else {
        throw GFileError.fromException(error);
      }
    }
  }

  /// 배치 처리용 작업 실행 래퍼
  static Future<_BatchResult<T>> _executeOperationWithErrorHandling<T>(
    Future<T> Function() operation,
    int index,
    _ProgressTracker tracker,
  ) async {
    try {
      tracker.nextStep('작업 ${index + 1} 실행 중...');
      final result = await operation();
      return _BatchResult.success(result);
    } catch (error) {
      final gError =
          error is GFileError ? error : GFileError.fromException(error);
      return _BatchResult.error(gError);
    }
  }

  /// 🔄 스트림 기반 대용량 파일 처리

  /// 대용량 파일을 청크 단위로 처리
  /// ex) await GFileHelper.processLargeFile(
  ///   inputPath: '/path/to/large_file.txt',
  ///   outputPath: '/path/to/processed_file.txt',
  ///   processor: (chunk) => chunk.toUpperCase(),
  ///   chunkSize: 8192,
  ///   onProgress: (progress) => print('진행률: ${(progress * 100).round()}%'),
  /// );
  static Future<void> processLargeFile({
    required String inputPath,
    required String outputPath,
    required String Function(String chunk) processor,
    int chunkSize = 8192,
    void Function(double progress)? onProgress,
  }) async {
    final inputFile = io.File(inputPath);
    final outputFile = io.File(outputPath);

    if (!await inputFile.exists()) {
      throw io.FileSystemException("입력 파일이 존재하지 않습니다.", inputPath);
    }

    final totalSize = await getFileSize(inputPath);
    var processedSize = 0;

    final inputStream = inputFile.openRead();
    final outputSink = outputFile.openWrite();

    await for (final chunk in inputStream.transform(utf8.decoder)) {
      final processedChunk = processor(chunk);
      outputSink.write(processedChunk);

      processedSize += chunk.length;
      onProgress?.call(processedSize / totalSize);
    }

    await outputSink.close();
  }

  /// 📈 파일 시스템 정보

  /// 디렉토리 크기 계산 (재귀)
  /// ex) final size = await GFileHelper.getDirectorySize('/path/to/directory');
  /// final readable = GFileHelper._formatBytes(size);
  static Future<int> getDirectorySize(String directoryPath) async {
    final dir = io.Directory(directoryPath);
    if (!await dir.exists()) return 0;

    var totalSize = 0;
    await for (final entity in dir.list(recursive: true)) {
      if (entity is io.File) {
        try {
          final stat = await entity.stat();
          totalSize += stat.size;
        } catch (e) {
          // 권한이 없거나 접근할 수 없는 파일은 무시
          continue;
        }
      }
    }
    return totalSize;
  }

  /// 사용 가능한 디스크 공간 확인 (근사치)
  /// ex) final freeSpace = await GFileHelper.getAvailableSpace('/path');
  static Future<int> getAvailableSpace(String path) async {
    if (kIsWeb) {
      // 웹에서는 정확한 디스크 공간을 알 수 없음
      return -1;
    }

    try {
      final dir = io.Directory(path);
      await dir.stat(); // 경로 유효성 확인용
      // StatSync에는 디스크 공간 정보가 없으므로
      // 플랫폼별 명령어를 사용해야 함 (여기서는 기본값 반환)
      return -1; // 구현 필요시 플랫폼별 native code 호출
    } catch (e) {
      return -1;
    }
  }
}
