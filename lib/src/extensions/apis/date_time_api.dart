part of 'apis.dart';

extension DateTimeApi on DateTime {
  /// Parse string to DateTime with custom format pattern
  static DateTime? parseWithPattern(String? dateStr, String pattern) {
    if (dateStr == null) return null;
    try {
      return DateFormat(pattern).parse(dateStr);
    } catch (e) {
      return null;
    }
  }

  /// Format DateTime to string with custom pattern
  String formatWithPattern(String pattern) {
    return DateFormat(pattern).format(this);
  }

  /// Common date formats
  String get toDateOnly => DateFormat('dd-MM-yyyy').format(this);
  String get toDateTime => DateFormat('dd-MM-yyyy HH:mm:ss').format(this);
  String get toTimeOnly => DateFormat('HH:mm:ss').format(this);

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

  /// Check if date is today
  bool get isToday {
    final now = DateTime.now();
    return year == now.year && month == now.month && day == now.day;
  }

  /// Get age from birthday
  int getAge() {
    final today = DateTime.now();
    var age = today.year - year;
    if (today.month < month || (today.month == month && today.day < day)) {
      age--;
    }
    return age;
  }

  /// Get remaining time from now
  Duration timeFromNow() => difference(DateTime.now());

  /// Get remaining days from now
  int daysFromNow() => timeFromNow().inDays;
}
