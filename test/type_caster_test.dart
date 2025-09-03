import 'package:test/test.dart';
import 'package:type_caster/type_caster.dart';

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

void main() {
  group('User', () {
    test('fromJson creates User object correctly', () {
      final Map<String, dynamic> json = {
        'name': 'John Doe',
        'age': 30,
      };

      final user = User.fromJson(json);

      expect(user.name, 'John Doe');
      expect(user.age, 30);
    });

    test('fromJson handles null values gracefully', () {
      final Map<String, dynamic> json = {
        'name': null,
        'age': null,
      };

      final user = User.fromJson(json);

      expect(user.name, isNull);
      expect(user.age, isNull);
    });

    test('fromJson handles missing keys gracefully', () {
      final Map<String, dynamic> json = {};

      final user = User.fromJson(json);

      expect(user.name, isNull);
      expect(user.age, isNull);
    });
  });

  test('simple', () {
    final Object value = '123';
    final Object emptyStr = '';

    // Cast to int using global function
    final int? number = tryInt(value);
    print(number); // 123

    // With default value (using orElse)
    final double doubleValue = asDouble(value, orElse: () => 0.0);
    print(doubleValue); // 123.0

    // Handle errors
    try {
      final rs = asBool(value);
      print(rs);
    } on CastException catch (e) {
      print('Failed to cast: ${e.message}');
    }

    // Tests with emptyStr
    final int? emptyInt = tryInt(emptyStr);
    print(emptyInt); // null
    expect(emptyInt, isNull);

    final double emptyDouble = asDouble(emptyStr, orElse: () => -1.0);
    print(emptyDouble); // -1.0
    expect(emptyDouble, -1.0);

    try {
      final bool emptyBool = asBool(emptyStr);
      print(emptyBool);
      fail('Expected CastException for emptyStr asBool');
    } on CastException catch (e) {
      print('Failed to cast emptyStr: ${e.message}');
    }
  });
}
