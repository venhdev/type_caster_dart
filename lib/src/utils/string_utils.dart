import 'dart:convert';

import '../core/types.dart';

String truncate(
  String text, {
  int? maxLength,
  String omission = '...',
  TruncatePosition position = TruncatePosition.end,
}) {
  if (maxLength == null) return text;

  if (text.length <= maxLength) {
    return text;
  }
  switch (position) {
    case TruncatePosition.start:
      final availableLength = maxLength - omission.length;
      if (availableLength <= 0) return omission;
      return omission + text.substring(text.length - availableLength);
    case TruncatePosition.end:
      final availableLength = maxLength - omission.length;
      if (availableLength <= 0) return omission;
      return text.substring(0, availableLength) + omission;
  }
}

// String truncate(String s, int? max) {
//   if (max == null || s.length <= max) {
//     return s;
//   }
//   return s.substring(0, max);
// }

/// Formats JSON data with indentation and optional field length truncation.
/// [data] The data to format as JSON
/// [indent] The indentation string (default: null)
/// [maxStringLength] Maximum length for string fields (optional)
/// [separator] The separator string for lists and maps (default: ',')
/// Returns: Formatted JSON string
String indentJson(
  dynamic data, {
  String? indent,
  int? maxStringLength,
  String separator = ',',
}) {
  try {
    final truncated = maxStringLength != null
        ? truncateInnerString(data, maxStringLength)
        : data;
    final encoder = JsonEncoder.withIndent(indent);
    return encoder.convert(truncated);
  } on JsonUnsupportedObjectError catch (_) {
    // Fallback to toString() to avoid circular dependency with stringify
    return _fallbackToString(data,
        indent: indent, maxStringLength: maxStringLength, separator: separator);
  } catch (e) {
    // Fallback to toString() to avoid circular dependency with stringify
    return _fallbackToString(data,
        indent: indent, maxStringLength: maxStringLength, separator: separator);
  }
}

/// Fallback function to convert data to string without calling stringify
/// to avoid circular dependency
String _fallbackToString(
  dynamic data, {
  String? indent,
  int? maxStringLength,
  String separator = ',',
}) {
  if (data == null) return 'null';

  try {
    // For Maps and Iterables, try to convert to a simple string representation
    if (data is Map) {
      final entries =
          data.entries.map((e) => '${e.key}: ${e.value}').join(separator);
      return '{ $entries }';
    } else if (data is Iterable) {
      final items = data.map((e) => e.toString()).join(separator);
      return '[ $items ]';
    } else {
      return data.toString();
    }
  } catch (e) {
    return 'Cannot convert data(${data.runtimeType}) to string';
  }
}

/// Recursively truncates string fields in JSON-like data structures.
/// [input] The input data to process
/// [maxLen] Maximum length for string fields
/// Returns: Processed data with truncated string fields
dynamic truncateInnerString(dynamic input, int? maxLen) {
  if (maxLen == null) return input;

  if (input is Map) {
    return input.map(
      (key, value) => MapEntry(
        key,
        value is String
            ? value.length > maxLen
                ? value.substring(0, maxLen)
                : value
            : value is Map
                ? truncateInnerString(value, maxLen)
                : value is Iterable
                    ? value
                        .map((e) => e is String
                            ? e.length > maxLen
                                ? e.substring(0, maxLen)
                                : e
                            : e)
                        .toList()
                    : value,
      ),
    );
  } else if (input is Iterable) {
    return input
        .map((e) => e is String
            ? e.length > maxLen
                ? e.substring(0, maxLen)
                : e
            : e)
        .toList();
  } else if (input is String) {
    return input.length > maxLen ? input.substring(0, maxLen) : input;
  } else {
    return input;
  }
}

/// Replaces substrings in a string using a map of replacements.
///
/// Replaces substrings in a string using a map of replacements.
/// [str] The input string
/// [replacements] Map of key-value pairs for replacements
/// Returns: Modified string with replacements applied
String _replaceInString(String str, Map<String, String> replacements) {
  var result = str;
  replacements.forEach((key, value) => result = result.replaceAll(key, value));
  return result;
}

/// Recursively replaces strings in a Map structure.
///
/// Recursively replaces strings in a Map structure.
/// [map] The input map
/// [replacements] Map of key-value pairs for replacements
/// Returns: Modified map with replacements applied
Map _replaceInMap(Map map, Map<String, String> replacements) {
  return map.map((key, value) => MapEntry(
        key is String
            ? _replaceInString(key, replacements)
            : key is Iterable
                ? _replaceInIterable(key, replacements)
                : key,
        value is String
            ? _replaceInString(value, replacements)
            : value is Map
                ? _replaceInMap(value, replacements)
                : value is Iterable
                    ? _replaceInIterable(value, replacements)
                    : value,
      ));
}

/// Recursively replaces strings in an Iterable structure.
///
/// Recursively replaces strings in an Iterable structure.
/// [iterable] The input iterable
/// [replacements] Map of key-value pairs for replacements
/// Returns: Modified iterable with replacements applied
List _replaceInIterable(Iterable iterable, Map<String, String> replacements) {
  return iterable
      .map((item) => item is String
          ? _replaceInString(item, replacements)
          : item is Iterable
              ? _replaceInIterable(item, replacements)
              : item is Map
                  ? _replaceInMap(item, replacements)
                  : item)
      .toList();
}

/// Converts a dynamic value to a string.
///
/// ## How it works?
///
/// 1. If the value is null, returns the [onNull] string.
/// 2. If the value is a function, calls it to get the actual value.
/// 3. If the value is a string, applies replacements if provided and returns the
/// result.
/// 4. If the value is an iterable or map, converts it to a JSON string with
/// optional indentation and string length truncation.
///
/// - [val] The dynamic value to convert to a string
/// - [onNull] The string to return if the value is null (default: 'null')
/// - [indent] The indentation string for JSON formatting (optional)
/// - [maxStringLength] The maximum length for string fields (optional)
/// - [maxLen] The maximum length for the result string (optional)
/// - [replacements] Map of key-value pairs for replacements (optional)
/// - Returns: The string representation of the value
String stringify(
  dynamic val, {
  String onNull = 'null',
  String? indent,
  int? maxStringLength,
  int? maxLen,
  Map<String, String>? replacements,
}) {
  if (val == null) {
    return onNull;
  }

  // If it's a function, call it to get the actual value
  dynamic mayString = val is Function ? val() : val;

  if (mayString is String) {
    var result = mayString;
    if (replacements != null) {
      result = _replaceInString(result, replacements);
    }
    return (maxLen != null && result.length > maxLen)
        ? result.substring(0, maxLen)
        : result;
  }

  // Handle Maps and Iterables (Lists, Sets) by converting them to JSON strings
  if (mayString is Iterable || mayString is Map) {
    try {
      if (replacements != null) {
        if (mayString is Map) {
          mayString = _replaceInMap(mayString, replacements);
        } else if (mayString is Iterable) {
          mayString = _replaceInIterable(mayString, replacements);
        }
      }
      // Consistent JSON formatting
      String result = indentJson(
        mayString,
        indent: indent,
        maxStringLength: maxStringLength,
      );
      return (maxLen != null && result.length > maxLen)
          ? result.substring(0, maxLen)
          : result;
    } catch (e) {
      // Fallback in case of JSON encoding errors (e.g., non-serializable objects within Map/Iterable)
      return mayString.toString();
    }
  } else {
    // For all other types (numbers, booleans, custom objects, etc.),
    // use their default toString() representation.
    String result = mayString.toString();
    if (replacements != null) {
      replacements
          .forEach((key, value) => result = result.replaceAll(key, value));
    }
    return (maxLen != null && result.length > maxLen)
        ? result.substring(0, maxLen)
        : result;
  }
}
