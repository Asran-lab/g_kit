import 'dart:convert';

import 'package:g_common/utils/util.dart';

import '../constants/g_typedef.dart';

/* 데이터 인코딩 */
dynamic encode(dynamic data) => jsonEncode(data);

/* 데이터 디코딩 */
dynamic decode(String data) => jsonDecode(data);

/* 데이터 복제 */
GJson cloneJson(GJson jsonObj) => GJson.from(json.decode(json.encode(jsonObj)));

/* 데이터 예쁘게 출력 */
String prettyJson(GJson jsonObj) {
  const encoder = JsonEncoder.withIndent('  ');
  return encoder.convert(jsonObj);
}

/* 데이터 안전하게 디코딩 */
GJson? safeDecode(String? jsonStr) {
  if (jsonStr == null || jsonStr.trim().isEmpty) {
    return {};
  }
  return guard(
    () => GJson.from(decode(jsonStr)),
    onError: (e, stack) => {},
    finallyBlock: () => {},
  );
}

/* 데이터 안전하게 인코딩 */
String safeEncode(dynamic data) {
  if (data == null) {
    return '';
  }
  return encode(data);
}

/* 문자열을 JSON 객체로 변환 
String to GJson (수동 파싱형 + URL 처리)
@param jsonStr: 문자열
@return GJson: JSON 객체
*/
GJson stringToJson(String jsonStr) {
  jsonStr = jsonStr.replaceAll('{', '').replaceAll('}', '').trim();
  final map = <String, dynamic>{};

  // 쉼표로 분리하되, URL 내부의 쉼표는 무시
  final items = _splitJsonItems(jsonStr);

  for (var item in items) {
    final keyValue = _splitKeyValue(item);
    if (keyValue.length > 1) {
      final key = keyValue[0].trim();
      final value = keyValue[1].trim();
      map[key] = value;
    }
  }
  return GJson.from(map);
}

/* JSON 아이템을 안전하게 분리 (URL 내부의 쉼표 무시) */
List<String> _splitJsonItems(String jsonStr) {
  final items = <String>[];
  String currentItem = '';
  int braceCount = 0;
  bool inQuotes = false;

  for (int i = 0; i < jsonStr.length; i++) {
    final char = jsonStr[i];

    if (char == '"' && (i == 0 || jsonStr[i - 1] != '\\')) {
      inQuotes = !inQuotes;
    }

    if (!inQuotes) {
      if (char == '{') braceCount++;
      if (char == '}') braceCount--;
    }

    if (char == ',' && !inQuotes && braceCount == 0) {
      items.add(currentItem.trim());
      currentItem = '';
    } else {
      currentItem += char;
    }
  }

  if (currentItem.isNotEmpty) {
    items.add(currentItem.trim());
  }

  return items;
}

/* 키-값을 안전하게 분리 (URL 내부의 콜론 무시) */
List<String> _splitKeyValue(String item) {
  final parts = <String>[];
  String currentPart = '';
  bool inQuotes = false;
  bool foundFirstColon = false;

  for (int i = 0; i < item.length; i++) {
    final char = item[i];

    if (char == '"' && (i == 0 || item[i - 1] != '\\')) {
      inQuotes = !inQuotes;
    }

    if (char == ':' && !inQuotes && !foundFirstColon) {
      parts.add(currentPart.trim());
      currentPart = '';
      foundFirstColon = true;
    } else {
      currentPart += char;
    }
  }

  if (currentPart.isNotEmpty) {
    parts.add(currentPart.trim());
  }

  return parts;
}

/* 모든 값이 null이 아닌 GJson 반환 
@param json: JSON 객체
@return GJson: 모든 값이 null이 아닌 JSON 객체
*/
GJson filterNotNullValues(GJson json) {
  return json..removeWhere((key, value) => value == null);
}

/* 파라미터를 JSON 객체로 변환
@param keys: 키 리스트
@param values: 값 리스트
@return GJson: JSON 객체
*/
GJson paramsToJson({
  required List<String> keys,
  required List<String> values,
}) {
  if (keys.length != values.length) {
    throw ArgumentError('Error_paramsToJson_001');
  }
  final map = <String, dynamic>{};
  for (var i = 0; i < keys.length; i++) {
    map[keys[i]] = values[i];
  }
  return GJson.from(map);
}
