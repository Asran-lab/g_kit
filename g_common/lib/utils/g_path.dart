import 'dart:io' show Platform;
import 'package:g_lib/g_lib_storage.dart';

/* 앱 파일 경로 */
const String kAssetsPath = 'assets/';
const String kImagesPath = '${kAssetsPath}images/';
const String kIconsPath = '${kAssetsPath}icons/';
const String kFontsPath = '${kAssetsPath}fonts/';
const String kTranlationsPath = '${kAssetsPath}translations/';

/* 경로 조합 */
String joinPath(List<String> paths) {
  return paths.join(Platform.pathSeparator);
}

/* 데이터베이스 경로 */
Future<String> getDatabasePath(String dbName) async {
  final dbDir = await getDatabasesPath();
  return joinPath([dbDir, dbName]);
}
