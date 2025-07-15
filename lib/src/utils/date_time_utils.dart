// tryDateTime -> try parse date time with pattern
// if failed, return null
import 'package:intl/intl.dart';

DateTime? tryDateTime(String? value, {String? pattern}) {
  if (value == null) {
    return null;
  }
  try {
    if (pattern == null) {
      return DateTime.tryParse(value);
    }
    return DateFormat(pattern).parse((value));
  } catch (e) {
    return null;
  }
}
