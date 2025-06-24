import 'dart:convert';

import '../error/exceptions.dart';
import '../utils/cast_string_utils.dart';

// Built-in types
// The Dart language has special support for the following:
// https://dart.dev/language/built-in-types

// ✅ Numbers (int, double)
// ✅ Strings (String)
// ✅ Booleans (bool)
// Records ((value1, value2))
// Functions (Function)
// ✅ Lists (List, also known as arrays)
// Sets (Set)
// Maps (Map)
// Runes (Runes; often replaced by the characters API)
// Symbols (Symbol)
// The value null (Null)
abstract interface class Castable<T> {
  T cast(dynamic value, {T Function()? orElse});
  T? tryCast(dynamic value, {T Function()? orElse});
}

abstract class TypeCaster<T> implements Castable<T> {
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
  List<T> cast(
    dynamic value, {
    List<T> Function()? orElse,
    T Function(dynamic)? itemDecoder,
    bool allowStringToList = true,
    String separator = ',',
  }) {
    try {
      if (value is List) {
        return value.cast<T>();
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
    bool allowStringToList = true,
    String separator = ',',
  }) {
    try {
      if (value == null) return null;
      return cast(
        value,
        orElse: orElse,
        itemDecoder: itemDecoder,
        allowStringToList: allowStringToList,
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
