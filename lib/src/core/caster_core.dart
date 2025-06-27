import 'dart:convert';

import '../error/exceptions.dart';
import '../utils/string_utils.dart';

// Built-in types
// The Dart language has special support for the following:
// https://dart.dev/language/built-in-types

// ✅ Numbers (int, double)
// ✅ Strings (String)
// ✅ Booleans (bool)
// Records ((value1, value2))
// Functions (Function)
// ✅ Lists (List, also known as arrays) -- Iterrable
// ✅ Sets (Set)
// Maps (Map)
// Runes (Runes; often replaced by the characters API)
// Symbols (Symbol)
// The value null (Null)

/// Tries to cast [src] to type [T].
/// If [src] is already of type [T], returns it.
/// Returns the result of [orElse] if provided and casting fails, otherwise null.
T? tryAs<T>(
  dynamic src, {
  T? Function()? orElse,
}) {
  try {
    if (src is T) return src;
    return orElse?.call();
  } catch (_) {
    return null;
  }
}

String? tryString(dynamic val, {String Function()? orElse}) => StringCaster().tryCast(val, orElse: orElse);
num? tryNum(dynamic val, {num Function()? orElse}) => NumberCaster().tryCast(val, orElse: orElse);
int? tryInt(dynamic val, {int Function()? orElse}) => IntCaster().tryCast(val, orElse: orElse);
double? tryDouble(dynamic val, {double Function()? orElse}) => DoubleCaster().tryCast(val, orElse: orElse);
bool? tryBool(dynamic val, {bool Function()? orElse}) => BoolCaster().tryCast(val, orElse: orElse);
List<T>? tryList<T>(
  dynamic val, {
  List<T> Function()? orElse,
  T Function(dynamic)? itemDecoder,
  String separator = ',',
}) =>
    ListCaster<T>().tryCast(
      val,
      orElse: orElse,
      itemDecoder: itemDecoder,
      separator: separator,
    );

String asString(dynamic val, {String Function()? orElse}) => StringCaster().cast(val, orElse: orElse);
num asNum(dynamic val, {num Function()? orElse}) => NumberCaster().cast(val, orElse: orElse);
int asInt(dynamic val, {int Function()? orElse}) => IntCaster().cast(val, orElse: orElse);
double asDouble(dynamic val, {double Function()? orElse}) => DoubleCaster().cast(val, orElse: orElse);
bool asBool(dynamic val, {bool Function()? orElse}) => BoolCaster().cast(val, orElse: orElse);
List<T> asList<T>(
  dynamic val, {
  List<T> Function()? orElse,
  T Function(dynamic)? itemDecoder,
  String separator = ',',
}) =>
    ListCaster<T>().cast(
      val,
      orElse: orElse,
      itemDecoder: itemDecoder,
      separator: separator,
    );

abstract interface class Castable<T> {
  T cast(dynamic value, {T Function()? orElse});
  T? tryCast(dynamic value, {T Function()? orElse});
}

abstract class TypeCaster<T> implements Castable<T> {
  T call(dynamic value, {T Function()? orElse});

  /// Casts a dynamic value to the type [T].
  ///
  /// Throws a [CastException] if the value cannot be cast to the type [T].
  /// If [orElse] is provided, its result is returned instead of throwing an exception.
  @override
  T cast(dynamic value, {T Function()? orElse});

  /// Tries to cast a dynamic value to the type [T].
  ///
  /// Returns null if the value cannot be cast to the type [T].
  /// If [orElse] is provided, its result is returned instead of null.
  @override
  T? tryCast(dynamic value, {T Function()? orElse}) {
    try {
      if (value == null) return null;
      return cast(value);
    } catch (e) {
      try {
        return orElse?.call();
      } catch (e) {
        return null;
      }
    }
  }
}

class NumberCaster extends TypeCaster<num> {
  @override
  num call(dynamic value, {num Function()? orElse}) => cast(value, orElse: orElse);

  @override
  num cast(dynamic value, {num Function()? orElse}) {
    if (value is num) {
      return value;
    } else if (value is String) {
      final number = num.tryParse(value);
      if (number == null) {
        throw CastException(value, 'num');
      }

      // wether number is int or double
      if (number is int) return number.toInt();
      if (number is double) return number.toDouble();

      return number;
    } else {
      throw CastException(value, 'num');
    }
  }
}

class IntCaster extends TypeCaster<int> {
  @override
  int call(dynamic value, {int Function()? orElse}) => cast(value, orElse: orElse);

  @override
  int cast(dynamic value, {int Function()? orElse}) {
    try {
      if (value is int) {
        return value;
      } else if (value is num) {
        return value.toInt();
      } else if (value is String) {
        return num.parse(value).toInt();
      } else {
        throw CastException(value, 'int');
      }
    } catch (e) {
      if (orElse != null) return orElse();
      rethrow;
    }
  }
}

class DoubleCaster extends TypeCaster<double> {
  @override
  double call(dynamic value, {double Function()? orElse}) => cast(value, orElse: orElse);

  @override
  double cast(dynamic value, {double Function()? orElse}) {
    try {
      if (value is double) {
        return value;
      } else if (value is num) {
        return value.toDouble();
      } else if (value is String) {
        return double.parse(value);
      } else {
        throw CastException(value, 'double');
      }
    } catch (e) {
      if (orElse != null) return orElse();
      rethrow;
    }
  }
}

class StringCaster extends TypeCaster<String> {
  @override
  String call(dynamic value, {String Function()? orElse}) => cast(value, orElse: orElse);

  @override
  String cast(dynamic value, {String Function()? orElse}) {
    try {
      return stringify(value);
    } catch (e) {
      if (orElse != null) return orElse();
      rethrow;
    }
  }
}

class BoolCaster extends TypeCaster<bool> {
  @override
  bool call(dynamic value, {bool Function()? orElse}) => cast(value, orElse: orElse);

  @override
  bool cast(dynamic value, {bool Function()? orElse}) {
    try {
      if (value is bool) {
        return value;
      } else if (value is String) {
        final lowerCaseValue = value.toLowerCase();
        if (lowerCaseValue == 'true') return true;
        if (lowerCaseValue == 'false') return false;
        throw CastException(value, 'bool');
      } else if (value is int) {
        return value == 1
            ? true
            : value == 0
                ? false
                : throw CastException(value, 'bool');
      } else {
        throw CastException(value, 'bool');
      }
    } catch (e) {
      if (orElse != null) return orElse();
      rethrow;
    }
  }
}

class ListCaster<T> extends TypeCaster<List<T>> {
  @override
  List<T> call(
    dynamic value, {
    List<T> Function()? orElse,
    T Function(dynamic)? itemDecoder,
    String separator = ',',
  }) =>
      cast(
        value,
        orElse: orElse,
        itemDecoder: itemDecoder,
        separator: separator,
      );

  @override
  List<T> cast(
    dynamic value, {
    List<T> Function()? orElse,
    T Function(dynamic)? itemDecoder,
    String separator = ',',
  }) {
    try {
      if (value is List) {
        return value.cast<T>();
      } else if (value is Set) {
        return value.cast<T>().toList();
      } else if (value is String) {
        final trimmed = value.trim();
        // Handle JSON array string
        if (trimmed.startsWith('[') && trimmed.endsWith(']')) {
          try {
            final decoded = json.decode(trimmed) as List;
            if (itemDecoder == null) return decoded.cast<T>();
            return decoded.map((e) => itemDecoder(e)).toList();
          } catch (_) {
            // If JSON parsing fails, split by separator
            final items = value.split(separator).map((e) => e.trim()).toList();
            if (itemDecoder == null) return items.cast<T>();
            return items.map((e) => itemDecoder(e)).toList();
          }
        }
        // Split regular string by separator
        final items = value.split(separator).map((e) => e.trim()).toList();
        if (itemDecoder == null) return items.cast<T>();
        return items.map((e) => itemDecoder(e)).toList();
      } else {
        throw CastException(value, 'List<${T.runtimeType}>');
      }
    } catch (e) {
      if (orElse != null) return orElse();
      rethrow;
    }
  }

  @override
  List<T>? tryCast(
    dynamic value, {
    List<T> Function()? orElse,
    T Function(dynamic)? itemDecoder,
    String separator = ',',
  }) {
    try {
      if (value == null) return null;
      return cast(
        value,
        orElse: orElse,
        itemDecoder: itemDecoder,
        separator: separator,
      );
    } catch (e) {
      try {
        return orElse?.call();
      } catch (e) {
        return null;
      }
    }
  }
}
