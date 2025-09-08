# Type Caster

[![Pub Version](https://img.shields.io/pub/v/type_caster?style=flat-square)](https://pub.dev/packages/type_caster)
[![Build Status](https://img.shields.io/github/actions/workflow/status/venhdev/type_caster_dart/ci.yml?branch=main&style=flat-square)](https://github.com/venhdev/type_caster_dart/actions)
[![Code Coverage](https://img.shields.io/badge/Coverage-80%25%2B-brightgreen?style=flat-square)](https://github.com/venhdev/type_caster_dart/actions)

A lightweight type casting library for Dart with safe conversions and clear error handling.

## Features

- **All Dart types**: `int`, `double`, `String`, `bool`, `DateTime`, `List<T>`, `Set<T>`, `Map<K,V>`
- **Simple API**: `tryAs<T>()`, `asString()`, `asInt()`, `"123".asInt()`  
- **Safe conversions**: Clear error messages with context
- **Custom types**: Register your own type casters

## Installation

Add `type_caster` to your `pubspec.yaml`:

```yaml
dependencies:
  type_caster: ^0.1.1
```

```bash
dart pub get
```

## Usage

### Quick Start

```dart
import 'package:type_caster/type_caster.dart';

// Safe conversions with null return on failure
final int? number = tryInt('123');        // 123
final bool? flag = tryBool('invalid');    // null

// Direct conversions with exception on failure  
final String text = asString(123);        // "123"
final double price = asDouble('99.99');   // 99.99

// Extension methods for fluent API
final int count = "42".asInt();           // 42
final bool isActive = "true".asBool();    // true
```

### Collections & Complex Types

```dart
// Lists from various sources
final numbers = asList<int>('[1,2,3]');           // [1, 2, 3]
final items = "a,b,c".asList<String>();           // ["a", "b", "c"]

// Sets (unique values)
final tags = asSet<String>('red,blue,red');       // {"red", "blue"}

// Maps from JSON strings
final user = asMap<String, dynamic>('{"name":"John","age":30}');

// DateTime with custom patterns
final date = asDateTime('2023-10-15');
final custom = asDateTime('15/10/2023', pattern: 'dd/MM/yyyy');
```

### Error Handling

```dart
try {
  final result = asBool('invalid');
} catch (e) {
  print(e); 
  // Cannot cast String to bool | Message: String value must be either "true" or "false" | Source: "invalid"
}

// Safe with fallback
final flag = asBool('invalid', orElse: () => false);  // false
```

### Custom Types

Register casters for your own classes:

```dart
class User {
  final String name;
  final int age;
  User({required this.name, required this.age});
  factory User.fromJson(Map<String, dynamic> json) => User(
    name: asString(json['name']),
    age: asInt(json['age']),
  );
}

// Register the caster
TypeCasterRegistry.instance.register<User>((value, {orElse}) {
  if (value is Map<String, dynamic>) return User.fromJson(value);
  if (value is String) return User.fromJson(json.decode(value));
  throw CastException(value, 'User');
});

// Now use it anywhere
final user = tryAs<User>('{"name": "John", "age": 30}');
```

## API Reference

### Core Functions

**Basic Types**
- `asString()`, `tryString()` - String conversion
- `asInt()`, `tryInt()` - Integer conversion  
- `asDouble()`, `tryDouble()` - Double conversion
- `asBool()`, `tryBool()` - Boolean conversion
- `asDateTime()`, `tryDateTime()` - DateTime conversion

**Collections**
- `asList<T>()`, `tryList<T>()` - List conversion
- `asSet<T>()`, `trySet<T>()` - Set conversion
- `asMap<K,V>()`, `tryMap<K,V>()` - Map conversion

**Advanced**
- `tryAs<T>()` - Generic type casting

### Extension Methods

**String Extensions**
```dart
"123".asInt()                    // 123
"true".asBool()                  // true  
"a,b,c".asList<String>()         // ["a", "b", "c"]
"2023-01-01".asDateTime()        // DateTime object
```

**Collection Extensions**
```dart
map.get("key")                   // Safe access
list.firstWhereOrNull(test)      // Safe search
set.mapCast((e) => e.toString()) // Transform Set elements
```



## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Support

If you find this package useful, please consider giving it a star on [GitHub](https://github.com/venhdev/type_caster_dart).

For issues and feature requests, please use the [issue tracker](https://github.com/venhdev/type_caster_dart/issues).
