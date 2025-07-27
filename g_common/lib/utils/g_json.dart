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
String to GJson (수동 파싱형)
@param jsonStr: 문자열
@return GJson: JSON 객체
*/
GJson stringToJson(String jsonStr) {
  jsonStr = jsonStr.replaceAll('{', '').replaceAll('}', '').trim();
  final map = <String, dynamic>{};
  for (var item in jsonStr.split(',')) {
    final keyValue = item.split(':');
    if (keyValue.length == 2) {
      map[keyValue[0].trim()] = keyValue[1].trim();
    }
  }
  return GJson.from(map);
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
