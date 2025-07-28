extension DateTimeExtension on DateTime {
  /// yyyy-MM-dd
  /// ex) 2025-04-29
  String get yyyymmdd {
    final year = this.year.toString().padLeft(4, '0');
    final month = this.month.toString().padLeft(2, '0');
    final day = this.day.toString().padLeft(2, '0');
    return '$year-$month-$day';
  }

  /// yyyy.MM.dd
  /// ex) 2025.04.29
  String get yyyymmddDot {
    final year = this.year.toString().padLeft(4, '0');
    final month = this.month.toString().padLeft(2, '0');
    final day = this.day.toString().padLeft(2, '0');
    return '$year.$month.$day';
  }

  /// yyyy년 M월 d일
  /// ex) 2025년 4월 29일
  String get yyyymmddKR {
    final year = this.year.toString().padLeft(4, '0');
    final month = this.month.toString().padLeft(2, '0');
    final day = this.day.toString().padLeft(2, '0');
    return '$year년 $month월 $day일';
  }

  /// HH:mm
  /// ex) 12:00
  String get hhmm {
    final hour = this.hour.toString().padLeft(2, '0');
    final minute = this.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  /// a h:mm
  /// ex) 오전 12:00
  String get ampmhhmm {
    final isAM = hour < 12;
    final hour12 = hour % 12 == 0 ? 12 : hour % 12;
    final minuteStr = minute.toString().padLeft(2, '0');
    final ampm = isAM ? '오전' : '오후';
    return '$ampm $hour12:$minuteStr';
  }

  /// yyyy-MM-dd HH:mm:ss
  /// ex) 2025-04-29 12:00:00
  String get fullDateTime {
    final year = this.year.toString().padLeft(4, '0');
    final month = this.month.toString().padLeft(2, '0');
    final day = this.day.toString().padLeft(2, '0');
    final hour = this.hour.toString().padLeft(2, '0');
    final minute = this.minute.toString().padLeft(2, '0');
    final second = this.second.toString().padLeft(2, '0');
    return '$year-$month-$day $hour:$minute:$second';
  }

  /// 요일 (월, 화, 수...)
  /// ex) 2025-04-29 => 월
  String get weekdayKR {
    const weekdays = ['월', '화', '수', '목', '금', '토', '일'];
    return weekdays[(weekday + 5) % 7]; // Sunday=7이므로 보정
  }

  /// 요일 (Mon, Tue, Wed...)
  /// ex) 2025-04-29 => Mon
  String get weekdayEn {
    const weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return weekdays[(weekday + 5) % 7];
  }

  /// 날짜가 오늘인지?
  /// ex) DateTime(2025, 4, 29) - DateTime.now() => true
  bool get isToday {
    final now = DateTime.now();
    return now.year == year && now.month == month && now.day == day;
  }

  /// 날짜가 어제인지?
  /// ex) DateTime(2025, 4, 29) - DateTime(2025, 4, 28) => true
  bool get isYesterday {
    final yesterday = subtract(const Duration(days: 1));
    return yesterday.year == year &&
        yesterday.month == month &&
        yesterday.day == day;
  }

  /// 날짜가 같은 날인지 비교
  /// ex) true
  bool isSameDay(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }

  /// 상대적 시간 차이 계산
  /// ex) DateTime.now() - DateTime(2025, 4, 28) => 1일 전
  String get timeDiff {
    final now = DateTime.now();
    final diff = now.difference(this);

    if (diff.inSeconds < 60) return '방금 전';
    if (diff.inMinutes < 60) return '${diff.inMinutes}분 전';
    if (diff.inHours < 24) return '${diff.inHours}시간 전';
    if (diff.inDays == 1) return '어제';
    if (diff.inDays < 7) return '${diff.inDays}일 전';
    if (diff.inDays < 30) return '${(diff.inDays / 7).floor()}주 전';
    if (diff.inDays < 365) return '${(diff.inDays / 30).floor()}달 전';

    return '${(diff.inDays / 365).floor()}년 전';
  }
}
