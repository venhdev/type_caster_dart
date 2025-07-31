/// These methods are aliases for the core casting functions.
/// - tryParse* methods are aliases for try* functions (nullable return)
/// - parse* methods are aliases for as* functions (non-nullable return)
library;

import 'package:intl/intl.dart';

import '../core/caster_core.dart';

String? tryParseString(dynamic value, {String Function()? orElse}) =>
    tryString(value, orElse: orElse);
String parseString(dynamic value, {String Function()? orElse}) =>
    asString(value, orElse: orElse);

num? tryParseNum(dynamic value, {num Function()? orElse}) =>
    tryNum(value, orElse: orElse);
num parseNum(dynamic value, {num Function()? orElse}) =>
    asNum(value, orElse: orElse);

int? tryParseInt(dynamic value, {int Function()? orElse}) =>
    tryInt(value, orElse: orElse);
int parseInt(dynamic value, {int Function()? orElse}) =>
    asInt(value, orElse: orElse);

double? tryParseDouble(dynamic value, {double Function()? orElse}) =>
    tryDouble(value, orElse: orElse);
double parseDouble(dynamic value, {double Function()? orElse}) =>
    asDouble(value, orElse: orElse);

bool? tryParseBool(dynamic value, {bool Function()? orElse}) =>
    tryBool(value, orElse: orElse);
bool parseBool(dynamic value, {bool Function()? orElse}) =>
    asBool(value, orElse: orElse);

List<T>? tryParseList<T>(dynamic value,
        {List<T> Function()? orElse,
        T Function(dynamic)? itemDecoder,
        String separator = ','}) =>
    tryList(value,
        orElse: orElse, itemDecoder: itemDecoder, separator: separator);
List<T> parseList<T>(dynamic value,
        {List<T> Function()? orElse,
        T Function(dynamic)? itemDecoder,
        String separator = ','}) =>
    asList(value,
        orElse: orElse, itemDecoder: itemDecoder, separator: separator);

// others public method
enum UnitPosition { leading, trailing }

String formatCurrency(
  num value, {
  bool isUnitVisible = false,
  String unit = '',
  UnitPosition unitPosition = UnitPosition.trailing,
  String? locale,
  NumberFormat? customFormat,
}) {
  final f = customFormat ?? NumberFormat.decimalPattern(locale);
  if (!isUnitVisible || unit.isEmpty) return f.format(value);

  return unitPosition == UnitPosition.leading
      ? '$unit ${f.format(value)}'
      : '${f.format(value)} $unit';
}
