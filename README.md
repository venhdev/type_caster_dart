# Type Caster

[![Pub Version](https://img.shields.io/pub/v/type_caster?style=flat-square)](https://pub.dev/packages/type_caster)
[![License: MIT](https://img.shields.io/badge/license-MIT-purple.svg?style=flat-square)](https://opensource.org/licenses/MIT)
[![Build Status](https://img.shields.io/github/actions/workflow/status/venhdev/type_caster_dart/release.yml?branch=main&style=flat-square)](https://github.com/venhdev/type_caster_dart/actions)
[![Code Coverage](https://img.shields.io/badge/Coverage-80%25%2B-brightgreen?style=flat-square)](https://github.com/venhdev/type_caster_dart/actions)

A powerful type casting and conversion library for Dart that provides safe and flexible type conversion utilities.

## Features

- Safe type casting with clear error handling
- Support for common Dart types (int, double, String, bool, List, Set, etc.)
- Extensible extension API system for type conversion (e.g., StringApi)
- Advanced string utilities, including flexible truncation
- ListCaster supports Set to List conversion and robust string parsing
- Null safety support
- Clear and descriptive error messages
- No external dependencies

## Installation

Add `type_caster` to your `pubspec.yaml`:

```yaml
dependencies:
  type_caster: ^0.0.3
```

Then run:

```bash
flutter pub get
# or
# dart pub get
```

## Usage

### Basic Usage

```dart
import 'package:type_caster/type_caster.dart';

void main() {
  final Object? value = '123';

  // Global Functions
  final int? intValue = tryAs<int>(value);
  print('tryAs<int>(value): $intValue'); // Output: 123

  final String stringValue = asString(value);
  print('asString(value): $stringValue'); // Output: 123

  final bool boolValue = asBool(value, orElse: () => false);
  print('asBool(value, orElse: () => false): $boolValue'); // Output: false

  final List<int> listValue = asList<int>('[1,2,3]', itemDecoder: (e) => asInt(e));
  print('asList<int>(\'[1,2,3]\', itemDecoder: (e) => asInt(e)): $listValue'); // Output: [1, 2, 3]

  // Handle errors
  try {
    final bool boolValue = asBool(value);
  } on CastException catch (e) {
    print('Failed to cast: ${e.message}');
  }
}
```

### String Truncation

The new extension API provides advanced string truncation:

```dart
import 'package:type_caster/type_caster.dart';

void main() {
  final text = 'Hello, this is a long string!';
  print(text.truncate(10)); // 'Hello, ...'
  print(text.truncate(10, omission: '***', position: TruncatePosition.start)); // '***ng string!'
}
```

- `TruncatePosition.end` (default): Truncates at the end, appending the omission.
- `TruncatePosition.start`: Truncates at the start, prepending the omission.

### List and Set Conversion

```dart
import 'package:type_caster/type_caster.dart';

void main() {
  final set = {'1', '2', '3'};
  final list = set.asList<String>();
  print(list); // [1, 2, 3]

  final csv = 'a,b,c';
  final listFromString = csv.asList<String>();
  print(listFromString); // [a, b, c]
}
```

### Custom Caster Example

```dart
class User {
  final String name;
  final int age;

  User({required this.name, required this.age});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      name: json['name']?.asString(),
      age: json['age']?.asInt(),
    );
  }
}
```

## API Reference

### Extension Methods (via Extension API)

- `String.truncate([int? maxLength, String omission = '...', TruncatePosition position = TruncatePosition.end])`: Truncate a string with flexible options.
- `String asString([String Function()? orElse])`: Casts the string to `String` or throws `CastException`.
- `String? tryString([String Function()? orElse])`: Tries to cast the string to `String`.
- `num asNum([num Function()? orElse])`: Casts the string to `num` or throws `CastException`.
- `num? tryNum([num Function()? orElse])`: Tries to cast the string to `num`.
- `int asInt([int Function()? orElse])`: Casts the string to `int` or throws `CastException`.
- `int? tryInt([int Function()? orElse])`: Tries to cast the string to `int`.
- `double asDouble([double Function()? orElse])`: Casts the string to `double` or throws `CastException`.
- `double? tryDouble([double Function()? orElse])`: Tries to cast the string to `double`.
- `bool asBool([bool Function()? orElse])`: Casts the string to `bool` or throws `CastException`.
- `bool? tryBool([bool Function()? orElse])`: Tries to cast the string to `bool`.
- `List<T> asList<T>([List<T> Function()? orElse, T Function(dynamic)? itemDecoder, String separator = ','])`: Casts the string to `List<T>` or throws `CastException`.
- `List<T>? tryList<T>([List<T> Function()? orElse, T Function(dynamic)? itemDecoder, String separator = ','])`: Tries to cast the string to `List<T>`.

#### Enum

- `enum TruncatePosition { start, end }`

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Support

If you find this package useful, please consider giving it a star on [GitHub](https://github.com/venhdev/type_caster_dart).

For issues and feature requests, please use the [issue tracker](https://github.com/venhdev/type_caster_dart/issues).
