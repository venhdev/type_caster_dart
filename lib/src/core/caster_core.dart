import 'dart:convert';
import 'package:intl/intl.dart';

import '../error/exceptions.dart';
import '../utils/string_utils.dart';

// Built-in types
// The Dart language has special support for the following:
// https://dart.dev/language/built-in-types

// ✅ Numbers (int, double)
// ✅ Strings (String)
// ✅ Booleans (bool)
// ⏹️ Records ((value1, value2)) -- Redundant
// Functions (Function)
// ✅ Lists (List, also known as arrays) -- Iterrable
// ✅ Sets (Set)
// ✅ Maps (Map)
// Runes (Runes; often replaced by the characters API)
// Symbols (Symbol)
// The value null (Null)
// ✅ DateTime

// Import registry but avoid circular dependency
import 'type_registry.dart';

/// Tries to cast [src] to type [T].
/// If [src] is already of type [T], returns it.
/// If [caster] is provided, uses it to attempt conversion.
/// If a custom caster is registered for type T, uses it.
/// Returns the result of [orElse] if provided and casting fails, otherwise null.
T? tryAs<T>(
  dynamic src, {
  T? Function()? orElse,
  T Function(dynamic)? caster,
}) {
  try {
    if (src is T) return src;
    
    // Use provided caster if available
    if (caster != null) return caster(src);
    
    // Try using registered custom caster
    final registry = TypeCasterRegistry.instance;
    if (registry.hasCustomCaster<T>()) {
      try {
        return registry.tryCustomCast<T>(src, orElse: orElse as T Function()?);
      } catch (_) {
        // Fall through to orElse
      }
    }
    
    return orElse?.call();
  } catch (_) {
    return null;
  }
}

String? tryString(dynamic val, {String Function()? orElse}) =>
    StringCaster().tryCast(val, orElse: orElse);
num? tryNum(dynamic val, {num Function()? orElse}) =>
    NumberCaster().tryCast(val, orElse: orElse);
int? tryInt(dynamic val, {int Function()? orElse}) =>
    IntCaster().tryCast(val, orElse: orElse);
double? tryDouble(dynamic val, {double Function()? orElse}) =>
    DoubleCaster().tryCast(val, orElse: orElse);
bool? tryBool(dynamic val, {bool Function()? orElse}) =>
    BoolCaster().tryCast(val, orElse: orElse);
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
    
DateTime? tryDateTime(dynamic val, {DateTime Function()? orElse, String? pattern}) =>
    DateTimeCaster().tryCast(val, orElse: orElse, pattern: pattern);
    
Map<K, V>? tryMap<K, V>(
  dynamic val, {
  Map<K, V> Function()? orElse,
  K Function(dynamic)? keyDecoder,
  V Function(dynamic)? valueDecoder,
}) =>
    MapCaster<K, V>().tryCast(
      val,
      orElse: orElse,
      keyDecoder: keyDecoder,
      valueDecoder: valueDecoder,
    );
    
Set<T>? trySet<T>(
  dynamic val, {
  Set<T> Function()? orElse,
  T Function(dynamic)? itemDecoder,
  String separator = ',',
}) =>
    SetCaster<T>().tryCast(
      val,
      orElse: orElse,
      itemDecoder: itemDecoder,
      separator: separator,
    );



String asString(dynamic val, {String Function()? orElse}) =>
    StringCaster().cast(val, orElse: orElse);
num asNum(dynamic val, {num Function()? orElse}) =>
    NumberCaster().cast(val, orElse: orElse);
int asInt(dynamic val, {int Function()? orElse}) =>
    IntCaster().cast(val, orElse: orElse);
double asDouble(dynamic val, {double Function()? orElse}) =>
    DoubleCaster().cast(val, orElse: orElse);
bool asBool(dynamic val, {bool Function()? orElse}) =>
    BoolCaster().cast(val, orElse: orElse);
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
    
DateTime asDateTime(dynamic val, {DateTime Function()? orElse, String? pattern}) =>
    DateTimeCaster().cast(val, orElse: orElse, pattern: pattern);
    
Map<K, V> asMap<K, V>(
  dynamic val, {
  Map<K, V> Function()? orElse,
  K Function(dynamic)? keyDecoder,
  V Function(dynamic)? valueDecoder,
}) =>
    MapCaster<K, V>().cast(
      val,
      orElse: orElse,
      keyDecoder: keyDecoder,
      valueDecoder: valueDecoder,
    );
    
Set<T> asSet<T>(
  dynamic val, {
  Set<T> Function()? orElse,
  T Function(dynamic)? itemDecoder,
  String separator = ',',
}) =>
    SetCaster<T>().cast(
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
  /// 
  /// If the value is null and T is nullable, returns null.
  /// If the value is null and T is not nullable, throws a [CastException] or returns orElse.
  @override
  T cast(dynamic value, {T Function()? orElse});

  /// Tries to cast a dynamic value to the type [T].
  ///
  /// Returns null if the value cannot be cast to the type [T].
  /// If [orElse] is provided, its result is returned instead of null.
  /// 
  /// Safely handles null values by returning null if the value is null
  /// (regardless of whether T is nullable).
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
  
  /// Helper method to check if a value is null and handle it appropriately.
  ///
  /// If the value is null, either throws a [CastException] or returns the result of [orElse].
  /// This method helps enforce null safety in casters.
  ///
  /// Returns true if the value is not null, false otherwise.
  bool _checkNull(dynamic value, {T Function()? orElse, String? typeName, String? context}) {
    if (value == null) {
      if (orElse != null) {
        return false;
      }
      throw CastException(
        null, 
        typeName ?? T.toString(),
        message: 'Cannot cast null to non-nullable type',
        context: context ?? '$runtimeType._checkNull',
        stackTrace: StackTrace.current,
      );
    }
    return true;
  }
}

class NumberCaster extends TypeCaster<num> {
  @override
  num call(dynamic value, {num Function()? orElse}) =>
      cast(value, orElse: orElse);

  @override
  num cast(dynamic value, {num Function()? orElse}) {
    if (value is num) {
      return value;
    } else if (value is String) {
      // Handle empty string explicitly
      if (value.isEmpty) {
        throw CastException(value, 'num', srcType: 'empty string');
      }
      
      final number = num.tryParse(value);
      if (number == null) {
        throw CastException(value, 'num');
      }

      // wether number is int or double
      if (number is int) return number.toInt();
      if (number is double) return number;

      return number;
    } else {
      throw CastException(value, 'num');
    }
  }
}

class IntCaster extends TypeCaster<int> {
  @override
  int call(dynamic value, {int Function()? orElse}) =>
      cast(value, orElse: orElse);

  @override
  int cast(dynamic value, {int Function()? orElse}) {
    try {
      if (value is int) {
        return value;
      } else if (value is num) {
        return value.toInt();
      } else if (value is String) {
        // Handle empty string explicitly
        if (value.isEmpty) {
          throw CastException(value, 'int', srcType: 'empty string');
        }
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
  double call(dynamic value, {double Function()? orElse}) =>
      cast(value, orElse: orElse);

  @override
  double cast(dynamic value, {double Function()? orElse}) {
    try {
      if (value is double) {
        return value;
      } else if (value is num) {
        return value.toDouble();
      } else if (value is String) {
        // Handle empty string explicitly
        if (value.isEmpty) {
          throw CastException(value, 'double', srcType: 'empty string');
        }
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
  String call(dynamic value, {String Function()? orElse}) =>
      cast(value, orElse: orElse);

  @override
  String cast(dynamic value, {String Function()? orElse}) {
    try {
      // Handle null explicitly
      if (!_checkNull(value, orElse: orElse, typeName: 'String')) {
        return orElse!();
      }
      
      return stringify(value);
    } catch (e) {
      if (orElse != null) return orElse();
      rethrow;
    }
  }
}

class BoolCaster extends TypeCaster<bool> {
  @override
  bool call(dynamic value, {bool Function()? orElse}) =>
      cast(value, orElse: orElse);

  @override
  bool cast(dynamic value, {bool Function()? orElse}) {
    try {
      // Handle null explicitly
      if (!_checkNull(value, orElse: orElse, typeName: 'bool')) {
        return orElse!();
      }
      
      if (value is bool) {
        return value;
      } else if (value is String) {
        final lowerCaseValue = value.toLowerCase();
        if (lowerCaseValue == 'true') return true;
        if (lowerCaseValue == 'false') return false;
        
        throw CastException(
          value, 
          'bool',
          message: 'String value must be either "true" or "false"',
          context: 'BoolCaster.cast',
        );
      } else if (value is int) {
        return value == 1
            ? true
            : value == 0
                ? false
                : throw CastException(
                    value, 
                    'bool',
                    message: 'Integer value must be either 0 (false) or 1 (true)',
                    context: 'BoolCaster.cast',
                  );
      } else {
        throw CastException(
          value, 
          'bool',
          message: 'Cannot convert ${value.runtimeType} to bool',
          context: 'BoolCaster.cast',
        );
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
        if (itemDecoder == null) return value.cast<T>();
        return value.map((e) => itemDecoder(e)).toList();
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

class MapCaster<K, V> extends TypeCaster<Map<K, V>> {
  @override
  Map<K, V> call(
    dynamic value, {
    Map<K, V> Function()? orElse,
    K Function(dynamic)? keyDecoder,
    V Function(dynamic)? valueDecoder,
  }) =>
      cast(
        value,
        orElse: orElse,
        keyDecoder: keyDecoder,
        valueDecoder: valueDecoder,
      );

  @override
  Map<K, V> cast(
    dynamic value, {
    Map<K, V> Function()? orElse,
    K Function(dynamic)? keyDecoder,
    V Function(dynamic)? valueDecoder,
  }) {
    try {
      if (value is Map<K, V>) {
        return value;
      } else if (value is Map) {
        if (keyDecoder == null && valueDecoder == null) {
          return Map<K, V>.from(value);
        }

        final result = <K, V>{};
        value.forEach((key, val) {
          final K newKey = keyDecoder != null ? keyDecoder(key) : key as K;
          final V newValue = valueDecoder != null ? valueDecoder(val) : val as V;
          result[newKey] = newValue;
        });
        return result;
      } else if (value is String) {
        // Handle empty string explicitly
        if (value.isEmpty) {
          throw CastException(value, 'Map<$K, $V>', srcType: 'empty string');
        }

        // Try parsing as JSON
        try {
          final decoded = json.decode(value);
          if (decoded is Map) {
            return cast(
              decoded,
              orElse: orElse,
              keyDecoder: keyDecoder,
              valueDecoder: valueDecoder,
            );
          }
          throw CastException(value, 'Map<$K, $V>');
        } catch (_) {
          throw CastException(value, 'Map<$K, $V>');
        }
      } else {
        throw CastException(value, 'Map<$K, $V>');
      }
    } catch (e) {
      if (orElse != null) return orElse();
      rethrow;
    }
  }

  @override
  Map<K, V>? tryCast(
    dynamic value, {
    Map<K, V> Function()? orElse,
    K Function(dynamic)? keyDecoder,
    V Function(dynamic)? valueDecoder,
  }) {
    try {
      if (value == null) return null;
      return cast(
        value,
        orElse: orElse,
        keyDecoder: keyDecoder,
        valueDecoder: valueDecoder,
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

class SetCaster<T> extends TypeCaster<Set<T>> {
  @override
  Set<T> call(
    dynamic value, {
    Set<T> Function()? orElse,
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
  Set<T> cast(
    dynamic value, {
    Set<T> Function()? orElse,
    T Function(dynamic)? itemDecoder,
    String separator = ',',
  }) {
    try {
      if (value is Set<T>) {
        return value;
      } else if (value is Set) {
        if (itemDecoder == null) return value.cast<T>();
        return value.map((e) => itemDecoder(e)).toSet();
      } else if (value is List) {
        if (itemDecoder == null) return value.cast<T>().toSet();
        return value.map((e) => itemDecoder(e)).toSet();
      } else if (value is String) {
        final trimmed = value.trim();
        // Handle empty string explicitly
        if (trimmed.isEmpty) {
          throw CastException(value, 'Set<$T>', srcType: 'empty string');
        }
        
        // Handle JSON array string
        if (trimmed.startsWith('[') && trimmed.endsWith(']')) {
          try {
            final decoded = json.decode(trimmed) as List;
            if (itemDecoder == null) return decoded.cast<T>().toSet();
            return decoded.map((e) => itemDecoder(e)).toSet();
          } catch (_) {
            // If JSON parsing fails, split by separator
            final items = value.split(separator).map((e) => e.trim()).toList();
            if (itemDecoder == null) return items.cast<T>().toSet();
            return items.map((e) => itemDecoder(e)).toSet();
          }
        }
        
        // Split regular string by separator
        final items = value.split(separator).map((e) => e.trim()).toList();
        if (itemDecoder == null) return items.cast<T>().toSet();
        return items.map((e) => itemDecoder(e)).toSet();
      } else {
        throw CastException(value, 'Set<$T>');
      }
    } catch (e) {
      if (orElse != null) return orElse();
      rethrow;
    }
  }

  @override
  Set<T>? tryCast(
    dynamic value, {
    Set<T> Function()? orElse,
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



class DateTimeCaster extends TypeCaster<DateTime> {
  @override
  DateTime call(dynamic value, {DateTime Function()? orElse, String? pattern}) =>
      cast(value, orElse: orElse, pattern: pattern);

  @override
  DateTime cast(dynamic value, {DateTime Function()? orElse, String? pattern}) {
    try {
      if (value is DateTime) {
        return value;
      } else if (value is String) {
        // Handle empty string explicitly
        if (value.isEmpty) {
          throw CastException(value, 'DateTime', srcType: 'empty string');
        }
        
        DateTime? dateTime;
        if (pattern != null) {
          try {
            dateTime = DateFormat(pattern).parse(value);
          } catch (_) {
            dateTime = null;
          }
        } else {
          dateTime = DateTime.tryParse(value);
        }
        
        if (dateTime != null) {
          return dateTime;
        }
        
        throw CastException(value, 'DateTime');
      } else if (value is int) {
        // Assuming milliseconds since epoch
        return DateTime.fromMillisecondsSinceEpoch(value);
      } else {
        throw CastException(value, 'DateTime');
      }
    } catch (e) {
      if (orElse != null) return orElse();
      rethrow;
    }
  }

  @override
  DateTime? tryCast(dynamic value, {DateTime Function()? orElse, String? pattern}) {
    try {
      if (value == null) return null;
      return cast(value, orElse: orElse, pattern: pattern);
    } catch (e) {
      try {
        return orElse?.call();
      } catch (e) {
        return null;
      }
    }
  }
}
