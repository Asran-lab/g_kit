/* 숫자먼 */
bool numberOnly(dynamic value) => RegExp(r'^[0-9]+$').hasMatch(value);

/* 알파벳만 */
bool engOnly(dynamic value) =>
    RegExp(r'^[A-Za-z]+$').hasMatch(value.toString().toLowerCase());

/* 한글만 */
bool koreanOnly(dynamic value) => RegExp(r'^[가-힣]+$').hasMatch(value);

/* 영문 + 숫자만 */
bool engNumOnly(dynamic value) => RegExp(r'^[A-Za-z0-9]+$').hasMatch(value);

/* URL */
bool isUrl(dynamic value) =>
    RegExp(r'^(https?|ftp):\/\/[^\s/$.?#].[^\s]*$').hasMatch(value);

/* 이미지 확장자 */
bool isImage(dynamic value) =>
    RegExp(r'\.(jpe?g|png|gif|bmp|webp|svg|ico|heic|heif)$',
            caseSensitive: false)
        .hasMatch(value);

/* 파일명 안전 */
bool isFileNameSafe(dynamic value) =>
    RegExp(r'^[^\\/:*?"<>|]+$').hasMatch(value);

/* 시간: HH:mm */
bool isTime(dynamic value) =>
    RegExp(r'^([01]\d|2[0-3]):[0-5]\d$').hasMatch(value);

/* 날짜 + 시간: YYYY-MM-dd HH:mm */
bool isDateTime(dynamic value) => RegExp(
      r'^(19\d{2}|20\d{2})-(0[1-9]|1[0-2])-(0[1-9]|[12]\d|3[01]) ([01]\d|2[0-3]):[0-5]\d$',
    ).hasMatch(value);

/* UUID */
bool isUuid(dynamic value) => RegExp(
      r'^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$',
    ).hasMatch(value);
