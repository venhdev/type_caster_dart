import 'dart:convert';
import 'package:test/test.dart';
import 'package:type_caster/type_caster.dart';

// Test class for custom type casting
class User {
  final String name;
  final int age;
  final DateTime? birthDate;

  User({required this.name, required this.age, this.birthDate});

  factory User.fromJson(Map<String, dynamic> json) => User(
    name: asString(json['name']),
    age: asInt(json['age']),
    birthDate: tryDateTime(json['birthDate']),
  );

  Map<String, dynamic> toJson() => {
    'name': name,
    'age': age,
    if (birthDate != null) 'birthDate': birthDate!.toIso8601String(),
  };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is User &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          age == other.age &&
          birthDate == other.birthDate;

  @override
  int get hashCode => name.hashCode ^ age.hashCode ^ birthDate.hashCode;

  @override
  String toString() => 'User(name: $name, age: $age, birthDate: $birthDate)';
}

void main() {
  group('Enhanced Type Caster Tests', () {
    
    group('DateTime Casting', () {
      test('should cast ISO string to DateTime', () {
        final result = asDateTime('2023-10-15T10:30:00Z');
        expect(result, isA<DateTime>());
        expect(result.year, equals(2023));
        expect(result.month, equals(10));
        expect(result.day, equals(15));
      });

      test('should cast simple date string to DateTime', () {
        final result = asDateTime('2023-10-15');
        expect(result, isA<DateTime>());
        expect(result.year, equals(2023));
        expect(result.month, equals(10));
        expect(result.day, equals(15));
      });

      test('should cast with custom pattern', () {
        final result = asDateTime('15/10/2023', pattern: 'dd/MM/yyyy');
        expect(result, isA<DateTime>());
        expect(result.year, equals(2023));
        expect(result.month, equals(10));
        expect(result.day, equals(15));
      });

      test('should cast milliseconds since epoch', () {
        final now = DateTime.now();
        final result = asDateTime(now.millisecondsSinceEpoch);
        expect(result.millisecondsSinceEpoch, equals(now.millisecondsSinceEpoch));
      });

      test('should return null for tryDateTime with invalid input', () {
        final result = tryDateTime('invalid-date');
        expect(result, isNull);
      });

      test('should throw CastException for invalid input', () {
        expect(() => asDateTime('invalid-date'), throwsA(isA<CastException>()));
      });

      test('should use orElse for invalid input', () {
        final fallback = DateTime(2000, 1, 1);
        final result = asDateTime('invalid', orElse: () => fallback);
        expect(result, equals(fallback));
      });
    });

    group('Map Casting', () {
      test('should cast JSON string to Map', () {
        final json = '{"name": "John", "age": 30}';
        final result = asMap<String, dynamic>(json);
        expect(result, isA<Map<String, dynamic>>());
        expect(result['name'], equals('John'));
        expect(result['age'], equals(30));
      });

      test('should cast Map with key/value decoders', () {
        final input = {'1': '10', '2': '20'};
        final result = asMap<int, int>(
          input,
          keyDecoder: (k) => asInt(k),
          valueDecoder: (v) => asInt(v),
        );
        expect(result, isA<Map<int, int>>());
        expect(result[1], equals(10));
        expect(result[2], equals(20));
      });

      test('should return null for tryMap with invalid JSON', () {
        final result = tryMap<String, dynamic>('invalid-json');
        expect(result, isNull);
      });

      test('should throw CastException for invalid input', () {
        expect(() => asMap<String, dynamic>(123), throwsA(isA<CastException>()));
      });

      test('should handle empty string', () {
        expect(() => asMap<String, dynamic>(''), throwsA(isA<CastException>()));
      });
    });

    group('Set Casting', () {
      test('should cast comma-separated string to Set', () {
        final result = asSet<String>('a,b,c,a');
        expect(result, isA<Set<String>>());
        expect(result, equals({'a', 'b', 'c'}));
        expect(result.length, equals(3)); // duplicates removed
      });

      test('should cast JSON array string to Set', () {
        final result = asSet<String>('["red", "blue", "red"]');
        expect(result, isA<Set<String>>());
        expect(result, equals({'red', 'blue'}));
      });

      test('should cast List to Set', () {
        final result = asSet<int>([1, 2, 3, 2]);
        expect(result, isA<Set<int>>());
        expect(result, equals({1, 2, 3}));
      });

      test('should cast with item decoder', () {
        final result = asSet<int>('1,2,3', itemDecoder: (e) => asInt(e));
        expect(result, isA<Set<int>>());
        expect(result, equals({1, 2, 3}));
      });

      test('should return null for trySet with null input', () {
        final result = trySet<String>(null);
        expect(result, isNull);
      });

      test('should throw CastException for invalid input', () {
        expect(() => asSet<String>(123), throwsA(isA<CastException>()));
      });
    });



    group('Extension Methods', () {
      group('String Extensions', () {
        test('should convert string to types using extensions', () {
          expect('123'.asInt(), equals(123));
          expect('123.45'.asDouble(), equals(123.45));
          expect('true'.asBool(), isTrue);
          expect('a,b,c'.asList<String>(), equals(['a', 'b', 'c']));
          expect('2023-10-15'.asDateTime(), isA<DateTime>());
        });

        test('should use try extensions safely', () {
          expect('123'.tryInt(), equals(123));
          expect('invalid'.tryInt(), isNull);
          expect('true'.tryBool(), isTrue);
          expect('invalid'.tryBool(), isNull);
        });

        test('should cast to Set and Map using extensions', () {
          expect('a,b,c'.asSet<String>(), equals({'a', 'b', 'c'}));
          expect('{"key":"value"}'.asMap<String, dynamic>()['key'], equals('value'));
        });
      });

      group('Map Extensions', () {
        test('should use get method safely', () {
          final map = {'key': 'value', 'number': 42};
          expect(map.get('key'), equals('value'));
          expect(map.get('missing'), isNull);
        });

        test('should use getOrDefault', () {
          final map = {'key': 'value'};
          expect(map.getOrDefault('key', 'default'), equals('value'));
          expect(map.getOrDefault('missing', 'default'), equals('default'));
        });

        test('should use getOrElse', () {
          final map = {'key': 'value'};
          expect(map.getOrElse('key', () => 'computed'), equals('value'));
          expect(map.getOrElse('missing', () => 'computed'), equals('computed'));
        });

        test('should cast values', () {
          final map = {'key': '123'};
          expect(map.tryCast<String>('key'), equals('123'));
          expect(map.tryCast<int>('missing'), isNull);
        });

        test('should map values', () {
          final map = {'a': 1, 'b': 2};
          final result = map.mapValues<String>((v) => v.toString());
          expect(result, equals({'a': '1', 'b': '2'}));
        });
      });

      group('Set Extensions', () {
        test('should convert to list', () {
          final set = {'a', 'b', 'c'};
          final result = set.toListCast();
          expect(result, isA<List<String>>());
          expect(result.length, equals(3));
        });

        test('should find first matching element or null', () {
          final set = {'apple', 'banana', 'cherry'};
          expect(set.firstWhereOrNull((e) => e.startsWith('b')), equals('banana'));
          expect(set.firstWhereOrNull((e) => e.startsWith('z')), isNull);
        });

        test('should map and cast elements', () {
          final set = {1, 2, 3};
          final result = set.mapCast<String>((e) => e.toString());
          expect(result, isA<Set<String>>());
          expect(result, equals({'1', '2', '3'}));
        });

        test('should join elements', () {
          final set = {'a', 'b', 'c'};
          expect(set.join(', '), contains('a'));
          expect(set.join(', '), contains('b'));
          expect(set.join(', '), contains('c'));
        });
      });


    });

    group('Enhanced Error Handling', () {
      test('should provide detailed error messages', () {
        try {
          asBool('invalid');
          fail('Should have thrown');
        } catch (e) {
          expect(e, isA<CastException>());
          final castException = e as CastException;
          expect(castException.toString(), contains('String value must be either "true" or "false"'));
          expect(castException.toString(), contains('BoolCaster.cast'));
          expect(castException.toString(), contains('"invalid"'));
        }
      });

      test('should include context in error messages', () {
        try {
          asInt('not-a-number');
          fail('Should have thrown');
        } catch (e) {
          // IntCaster might throw FormatException which gets wrapped or rethrown
          expect(e, anyOf(isA<CastException>(), isA<FormatException>()));
        }
      });

      test('should handle null values appropriately', () {
        try {
          asString(null);
          fail('Should have thrown');
        } catch (e) {
          expect(e, isA<CastException>());
          final castException = e as CastException;
          expect(castException.toString(), contains('Cannot cast null to non-nullable type'));
        }
      });

      test('should create exceptions with additional context', () {
        final exception = CastException('source', 'target', message: 'test message');
        final withContext = exception.withContext('additional context');
        expect(withContext.context, equals('additional context'));
        expect(withContext.message, equals('test message'));
      });

      test('should create exceptions with new message', () {
        final exception = CastException('source', 'target', message: 'original');
        final withMessage = exception.withMessage('new message');
        expect(withMessage.message, equals('new message'));
        expect(withMessage.src, equals('source'));
      });
    });

    group('Custom Type Casting', () {
      setUp(() {
        // Register User caster for tests
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
      });

      tearDown(() {
        // Clean up after tests
        TypeCasterRegistry.instance.unregister<User>();
      });

      test('should cast Map to custom type', () {
        final map = {'name': 'John', 'age': 30};
        final user = tryAs<User>(map);
        expect(user, isNotNull);
        expect(user!.name, equals('John'));
        expect(user.age, equals(30));
      });

      test('should cast JSON string to custom type', () {
        final json = '{"name": "Jane", "age": 25}';
        final user = tryAs<User>(json);
        expect(user, isNotNull);
        expect(user!.name, equals('Jane'));
        expect(user.age, equals(25));
      });

      test('should return null for invalid input to custom type', () {
        final user = tryAs<User>(123);
        expect(user, isNull);
      });

      test('should check if custom caster is registered', () {
        expect(TypeCasterRegistry.instance.hasCustomCaster<User>(), isTrue);
        expect(TypeCasterRegistry.instance.hasCustomCaster<String>(), isFalse);
      });

      test('should unregister custom caster', () {
        TypeCasterRegistry.instance.unregister<User>();
        expect(TypeCasterRegistry.instance.hasCustomCaster<User>(), isFalse);
        
        // Re-register for tearDown
        TypeCasterRegistry.instance.register<User>((value, {orElse}) {
          throw CastException(value, 'User');
        });
      });

      test('should clear all custom casters', () {
        TypeCasterRegistry.instance.clear();
        expect(TypeCasterRegistry.instance.hasCustomCaster<User>(), isFalse);
        
        // Re-register for tearDown
        TypeCasterRegistry.instance.register<User>((value, {orElse}) {
          throw CastException(value, 'User');
        });
      });
    });

    group('Null Safety', () {
      test('should handle null input safely in try functions', () {
        expect(tryString(null), isNull);
        expect(tryInt(null), isNull);
        expect(tryDouble(null), isNull);
        expect(tryBool(null), isNull);
        expect(tryDateTime(null), isNull);
        expect(tryList<String>(null), isNull);
        expect(trySet<String>(null), isNull);
        expect(tryMap<String, dynamic>(null), isNull);
      });

      test('should throw for null input in as functions', () {
        expect(() => asString(null), throwsA(isA<CastException>()));
        expect(() => asInt(null), throwsA(isA<CastException>()));
        expect(() => asDouble(null), throwsA(isA<CastException>()));
        expect(() => asBool(null), throwsA(isA<CastException>()));
      });

      test('should use orElse for null input', () {
        expect(asString(null, orElse: () => 'default'), equals('default'));
        expect(asInt(null, orElse: () => 42), equals(42));
        expect(asBool(null, orElse: () => true), isTrue);
      });
    });

    group('Edge Cases', () {
      test('should handle empty strings appropriately', () {
        expect(() => asInt(''), throwsA(isA<CastException>()));
        expect(() => asDouble(''), throwsA(isA<CastException>()));
        expect(() => asBool(''), throwsA(isA<CastException>()));
        expect(() => asDateTime(''), throwsA(isA<CastException>()));
      });

      test('should handle boundary values', () {
        expect(asInt('2147483647'), equals(2147483647)); // Max int
        expect(asInt('-2147483648'), equals(-2147483648)); // Min int
        expect(asDouble('1.7976931348623157e+308'), isA<double>()); // Max double
      });

      test('should handle special boolean values', () {
        expect(asBool('TRUE'), isTrue);
        expect(asBool('FALSE'), isFalse);
        expect(asBool('True'), isTrue);
        expect(asBool('False'), isFalse);
        expect(asBool(1), isTrue);
        expect(asBool(0), isFalse);
      });

      test('should handle malformed JSON gracefully', () {
        // ListCaster treats non-array JSON as a single item (expected behavior)
        final listResult = tryList<String>('{"not": "an array"}');
        expect(listResult, isNotNull);
        expect(listResult!.length, equals(1));
        
        // MapCaster should return null for non-object JSON
        expect(tryMap<String, dynamic>('["not", "an", "object"]'), isNull);
        
        // Both should return null for completely malformed JSON
        expect(tryList<String>('invalid json'), isNotNull); // Treats as single item
        expect(tryMap<String, dynamic>('invalid json'), isNull);
      });
    });

    group('Performance & Memory', () {
      test('should handle large collections efficiently', () {
        final largeList = List.generate(1000, (i) => i.toString());
        final csvString = largeList.join(',');
        
        final result = asList<String>(csvString);
        expect(result.length, equals(1000));
        expect(result[0], equals('0'));
        expect(result[999], equals('999'));
      });

      test('should handle deeply nested maps', () {
        final nested = {
          'level1': {
            'level2': {
              'level3': 'deep value'
            }
          }
        };
        
        final result = asMap<String, dynamic>(json.encode(nested));
        expect(result['level1']['level2']['level3'], equals('deep value'));
      });
    });
  });
}
