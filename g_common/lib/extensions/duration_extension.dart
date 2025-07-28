extension DurationExtension on Duration {
  String get inMinutesText => '$inMinutes분';
  String get inHoursText => '$inHours시간';
  String get inDaysText => '$inDays일';
  String get inSecondsText => '$inSeconds초';

  String get asReadable {
    if (inSeconds < 60) return '$inSeconds초';
    if (inMinutes < 60) return '$inMinutes분';
    if (inHours < 24) return '$inHours시간';
    return '$inDays일';
  }
}
