# Type Caster

[![Pub Version](https://img.shields.io/pub/v/type_caster?style=flat-square)](https://pub.dev/packages/type_caster)
[![License: MIT](https://img.shields.io/badge/license-MIT-purple.svg?style=flat-square)](https://opensource.org/licenses/MIT)
[![Build Status](https://img.shields.io/github/actions/workflow/status/venhdev/type_caster_dart/release.yml?branch=main&style=flat-square)](https://github.com/venhdev/type_caster_dart/actions)
[![Code Coverage](https://img.shields.io/badge/Coverage-80%25%2B-brightgreen?style=flat-square)](https://github.com/venhdev/type_caster_dart/actions)

A lightweight and safe type casting library for Dart that provides flexible type conversion utilities with clear error handling.

## Features

- Support for common Dart types: `int`, `double`, `String`, `bool`, `List`, `Set`
- Global casting functions: `tryAs<T>()`, `asString()`, `asInt()`, etc.

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

### Basic Type Casting

```dart
import 'package:type_caster/type_caster.dart';

void main() {
  final Object? value = '123';

  // Using global functions
  final int? number = tryInt(value);     // Returns: 123
  final String text = asString(value);    // Returns: "123"
  
  // With fallback values using orElse
  final bool flag = asBool(value, orElse: () => false);  // Returns: false
  
  // Error handling
  try {
    final bool result = asBool('not-a-bool');
  } on CastException catch (e) {
    print(e.toString()); // "Cannot cast String to bool | Source: not-a-bool"
  }
}
```

### List Conversion

```dart
import 'package:type_caster/type_caster.dart';

void main() {
  // From JSON array string
  final numbers = asList<int>('[1,2,3]', itemDecoder: (e) => asInt(e));
  print(numbers); // [1, 2, 3]
  
  // From comma-separated string
  final items = asList<String>('a,b,c');
  print(items); // ["a", "b", "c"]
  
  // From Set to List
  final set = {'1', '2', '3'};
  final list = asList<String>(set);
  print(list); // ["1", "2", "3"]
}
```

### Custom Caster Example

```dart
class User {
  final String? name;
  final int? age;

  User({required this.name, required this.age});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      name: tryString(json['name']),
      age: tryInt(json['age']),
    );
  }
}
```

## API Reference

### Global Functions

#### Type Casting
- `T? tryAs<T>(dynamic src, {T? Function()? orElse})`: Generic type casting
- `String asString(dynamic val, {String Function()? orElse})`
- `String? tryString(dynamic val, {String Function()? orElse})`
- `num asNum(dynamic val, {num Function()? orElse})`
- `num? tryNum(dynamic val, {num Function()? orElse})`
- `int asInt(dynamic val, {int Function()? orElse})`
- `int? tryInt(dynamic val, {int Function()? orElse})`
- `double asDouble(dynamic val, {double Function()? orElse})`
- `double? tryDouble(dynamic val, {double Function()? orElse})`
- `bool asBool(dynamic val, {bool Function()? orElse})`
- `bool? tryBool(dynamic val, {bool Function()? orElse})`

#### List Operations
- `List<T> asList<T>(dynamic val, {List<T> Function()? orElse, T Function(dynamic)? itemDecoder, String separator = ','})`
- `List<T>? tryList<T>(dynamic val, {List<T> Function()? orElse, T Function(dynamic)? itemDecoder, String separator = ','})`

### Error Handling

The library uses `CastException` for error handling, providing:
- Source value and type information
- Target type information
- Optional custom message
- Optional inner exception
- Colorized error output

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Support

If you find this package useful, please consider giving it a star on [GitHub](https://github.com/venhdev/type_caster_dart).

For issues and feature requests, please use the [issue tracker](https://github.com/venhdev/type_caster_dart/issues).
