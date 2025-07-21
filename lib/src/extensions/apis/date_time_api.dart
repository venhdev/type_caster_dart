part of 'apis.dart';

extension DateTimeApi on DateTime {
  // static DateTime? tryPattern(dynamic src, [String? pattern]) {
  //   return tryDateTime(src, pattern: pattern);
  // }

  /// Returns today's date with time set to midnight (00:00:00)
  static DateTime today() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  /// Returns a new DateTime with time removed (00:00:00)
  DateTime get withoutTime => DateTime(year, month, day);

  /// Returns `true` if this date is today (ignores time)
  bool get isToday {
    final now = DateTime.now();
    return year == now.year && month == now.month && day == now.day;
  }

  /// Returns `true` if this date is tomorrow (ignores time)
  bool get isTomorrow {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    return year == tomorrow.year &&
        month == tomorrow.month &&
        day == tomorrow.day;
  }

  /// Returns `true` if this date is yesterday (ignores time)
  bool get isYesterday {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return year == yesterday.year &&
        month == yesterday.month &&
        day == yesterday.day;
  }

  /// Returns `true` if this date is in the future (ignores time)
  bool get isFuture {
    final now = DateTime.now();
    return isAfter(now);
  }

  /// Returns `true` if this date is in the past (ignores time)
  bool get isPast {
    final now = DateTime.now();
    return isBefore(now);
  }

  /// Returns `true` if this date is in the same day as the given date (ignores time)
  bool isSameDayAs(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }

  /// Returns `true` if this date is in the same month as the given date (ignores time)
  bool isSameMonthAs(DateTime other) {
    final thisYear = year;
    final thisMonth = month;
    final otherYear = other.year;
    final otherMonth = other.month;
    return thisYear == otherYear && thisMonth == otherMonth;
  }

  /// Returns `true` if this date is in the same year as the given date (ignores time)
  bool isSameYearAs(DateTime other) {
    final thisYear = year;
    final otherYear = other.year;
    return thisYear == otherYear;
  }

  /// Parse string to DateTime with custom format pattern
  static DateTime? parseWithPattern(dynamic src, [String? pattern]) {
    if (src == null) return null;
    try {
      return DateFormat(pattern).parse(src);
    } catch (e) {
      return null;
    }
  }

  /// Format DateTime to string with custom pattern
  String formatWithPattern(String pattern) {
    return DateFormat(pattern).format(this);
  }

  /// Get start of day (00:00:00)
  DateTime get startOfDay => DateTime(year, month, day);

  /// Get end of day (23:59:59)
  DateTime get endOfDay => DateTime(year, month, day, 23, 59, 59);

  /// Add duration helpers
  DateTime addYears(int years) =>
      DateTime(year + years, month, day, hour, minute, second);
  DateTime addMonths(int months) =>
      DateTime(year, month + months, day, hour, minute, second);
  DateTime addDays(int days) => add(Duration(days: days));
  DateTime addHours(int hours) => add(Duration(hours: hours));

  /// Check if date is between range
  bool isBetween(DateTime from, DateTime to) => isAfter(from) && isBefore(to);

  /// Get age from birthday
  int getAge() {
    final today = DateTime.now();
    var age = today.year - year;
    if (today.month < month || (today.month == month && today.day < day)) {
      age--;
    }
    return age;
  }
}
