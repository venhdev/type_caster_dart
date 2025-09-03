import 'package:type_caster/type_caster.dart';
import 'dart:convert';

void main() {
  print('🎯 Type Caster Example\n');

  // Basic Type Casting
  basicTypeCasting();

  // Extension Methods
  extensionMethods();

  // Collections
  collectionCasting();

  // DateTime Casting
  dateTimeCasting();

  // Error Handling
  errorHandling();

  // Custom Types
  customTypeCasting();
}

void basicTypeCasting() {
  print('📝 Basic Type Casting:');

  // Safe conversions (return null on failure)
  final safeInt = tryInt('123');
  final safeBool = tryBool('invalid');

  print('  tryInt("123") = $safeInt'); // 123
  print('  tryBool("invalid") = $safeBool'); // null

  // Direct conversions (throw on failure)
  final directString = asString(42);
  final directDouble = asDouble('99.99');

  print('  asString(42) = "$directString"'); // "42"
  print('  asDouble("99.99") = $directDouble'); // 99.99

  // With fallback values
  final withFallback = asBool('invalid', orElse: () => false);
  print('  asBool("invalid", orElse: false) = $withFallback\n'); // false
}

void extensionMethods() {
  print('🔧 Extension Methods:');

  // String extensions for fluent API
  final count = "42".asInt();
  final isActive = "true".asBool();
  final price = "19.99".asDouble();

  print('  "42".asInt() = $count');
  print('  "true".asBool() = $isActive');
  print('  "19.99".asDouble() = $price');

  // Safe extensions
  final safeConversion = "invalid".tryInt();
  print('  "invalid".tryInt() = $safeConversion\n'); // null
}

void collectionCasting() {
  print('📋 Collection Casting:');

  // Lists from various sources
  final csvList = asList<String>('apple,banana,cherry');
  final jsonList = asList<int>('[1,2,3,4,5]');

  print('  CSV to List: $csvList');
  print('  JSON to List: $jsonList');

  // Sets (automatically removes duplicates)
  final tags = asSet<String>('red,blue,red,green');
  print('  Tags Set: $tags');

  // Maps from JSON
  final userMap =
      asMap<String, dynamic>('{"name":"John","age":30,"active":true}');
  print('  User Map: $userMap');

  // Collection extensions
  final fruits = {'apple', 'banana', 'cherry'};
  final firstFruit = fruits.firstWhereOrNull((f) => f.startsWith('b'));
  print('  First fruit starting with "b": $firstFruit\n');
}

void dateTimeCasting() {
  print('📅 DateTime Casting:');

  // Standard ISO format
  final isoDate = asDateTime('2023-12-25T10:30:00Z');
  print('  ISO Date: $isoDate');

  // Custom pattern
  final customDate = asDateTime('25/12/2023', pattern: 'dd/MM/yyyy');
  print('  Custom Pattern: $customDate');

  // From milliseconds
  final now = DateTime.now();
  final fromMillis = asDateTime(now.millisecondsSinceEpoch);
  print('  From Milliseconds: $fromMillis');

  // Using extension
  final birthday = "1990-05-15".asDateTime();
  print('  Birthday: $birthday\n');
}

void errorHandling() {
  print('❌ Error Handling:');

  try {
    // This will throw a detailed CastException
    final result = asBool('not-a-boolean');
    print('  Should not reach here: $result');
  } catch (e) {
    print(
        '  Caught error: ${e.toString().split('|')[0]}'); // Just the main message
  }

  // Safe alternative
  final safeResult = tryBool('not-a-boolean');
  print('  Safe result: $safeResult'); // null

  // With fallback
  final withDefault = asBool('not-a-boolean', orElse: () => false);
  print('  With default: $withDefault\n'); // false
}

void customTypeCasting() {
  print('🔧 Custom Type Casting:');

  // Define a simple class
  final user = User(name: 'Alice', age: 28, email: 'alice@example.com');

  // Register custom caster
  TypeCasterRegistry.instance.register<User>((value, {orElse}) {
    if (value is Map<String, dynamic>) {
      return User.fromJson(value);
    }
    if (value is String) {
      try {
        final map = json.decode(value) as Map<String, dynamic>;
        return User.fromJson(map);
      } catch (_) {
        // Fall through
      }
    }
    if (orElse != null) return orElse();
    throw CastException(value, 'User', message: 'Cannot convert to User');
  });

  // Now you can use tryAs<User> anywhere
  final jsonUser = '{"name":"Bob","age":35,"email":"bob@example.com"}';
  final parsedUser = tryAs<User>(jsonUser);

  print('  Original: $user');
  print('  From JSON: $parsedUser');

  // Test with invalid data
  final invalidUser = tryAs<User>('invalid json');
  print('  Invalid conversion: $invalidUser'); // null

  // Clean up
  TypeCasterRegistry.instance.unregister<User>();
  print('  ✅ Custom caster cleaned up\n');
}

// Simple User class for demonstration
class User {
  final String name;
  final int age;
  final String email;

  User({required this.name, required this.age, required this.email});

  factory User.fromJson(Map<String, dynamic> json) => User(
        name: asString(json['name']),
        age: asInt(json['age']),
        email: asString(json['email']),
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'age': age,
        'email': email,
      };

  @override
  String toString() => 'User(name: $name, age: $age, email: $email)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is User &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          age == other.age &&
          email == other.email;

  @override
  int get hashCode => name.hashCode ^ age.hashCode ^ email.hashCode;
}
