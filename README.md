# Type Caster

[![Pub Version](https://img.shields.io/pub/v/type_caster?style=flat-square)](https://pub.dev/packages/type_caster)
[![License: MIT](https://img.shields.io/badge/license-MIT-purple.svg?style=flat-square)](https://opensource.org/licenses/MIT)
[![Build Status](https://img.shields.io/github/actions/workflow/status/venhdev/type_caster_dart/release.yml?branch=main&style=flat-square)](https://github.com/venhdev/type_caster_dart/actions)
[![Code Coverage](https://img.shields.io/badge/Coverage-80%25%2B-brightgreen?style=flat-square)](https://github.com/venhdev/type_caster_dart/actions)

A powerful type casting and conversion library for Dart that provides safe and flexible type conversion utilities.

## Features

- Safe type casting with clear error handling
- Support for common Dart types (int, double, String, bool, List, Map, etc.)
- Extensible architecture for custom type converters
- Null safety support
- Clear and descriptive error messages
- No external dependencies

## Installation

Add `type_caster` to your `pubspec.yaml`:

```yaml
dependencies:
  type_caster: ^1.0.0
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
  // Safe type casting
  final dynamic value = '123';
  
  // Cast to int
  final int? number = value.tryInt();
  print(number); // 123
  
  // With default value (using orElse)
  final double doubleValue = value.asDouble(orElse: () => 0.0);
  print(doubleValue); // 123.0
  
  // Handle errors
  try {
    final bool boolValue = value.asBool();
  } on CastException catch (e) {
    print('Failed to cast: ${e.message}');
  }
}
```

### Advanced Usage

```dart
// Custom type conversion
class User {
  final String name;
  final int age;
  
  User({required this.name, required this.age});
  
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      name: json['name'].asString(),
      age: json['age'].asInt(),
    );
  }
}

void main() {
  final data = {
    'name': 'John Doe',
    'age': 30,
  };
  
  final user = User.fromJson(data);
  print('${user.name} is ${user.age} years old');
}
```

## API Reference

### Extension Methods

- `T? tryAs<T>()`: Attempts to cast the object to type `T`.
- `String asString({String Function()? orElse})`: Casts the object to `String` or throws `CastException`.
- `String? tryString({String Function()? orElse})`: Tries to cast the object to `String`.
- `num asNum({num Function()? orElse})`: Casts the object to `num` or throws `CastException`.
- `num? tryNum({num Function()? orElse})`: Tries to cast the object to `num`.
- `int asInt({int Function()? orElse})`: Casts the object to `int` or throws `CastException`.
- `int? tryInt({int Function()? orElse})`: Tries to cast the object to `int`.
- `double asDouble({double Function()? orElse})`: Casts the object to `double` or throws `CastException`.
- `double? tryDouble({double Function()? orElse})`: Tries to cast the object to `double`.
- `bool asBool({bool Function()? orElse})`: Casts the object to `bool` or throws `CastException`.
- `bool? tryBool({bool Function()? orElse})`: Tries to cast the object to `bool`.
- `List<T> asList<T>({List<T> Function()? orElse, T Function(dynamic)? itemDecoder, bool allowStringToList = true, String separator = ','})`: Casts the object to `List<T>` or throws `CastException`.
- `List<T>? tryList<T>({List<T> Function()? orElse, T Function(dynamic)? itemDecoder, bool allowStringToList = true, String separator = ','})`: Tries to cast the object to `List<T>`.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Support

If you find this package useful, please consider giving it a star on [GitHub](https://github.com/venhdev/type_caster_dart).

For issues and feature requests, please use the [issue tracker](https://github.com/venhdev/type_caster_dart/issues).
