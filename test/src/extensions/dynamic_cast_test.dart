import 'package:test/test.dart';
import 'package:type_caster/src/extensions/dynamic_cast.dart';
import 'package:type_caster/type_caster.dart';

void main() {
  group('DynamicCastExtension', () {
    group('String casting', () {
      test('asString converts various types to string', () {
        expect(123.asString(), '123');
        expect(123.45.asString(), '123.45');
        expect(true.asString(), 'true');
        expect(['a', 'b'].asString(), isA<String>());
        expect({'key': 'value'}.asString(), isA<String>());
      });

      test('stringify null', () {
        dynamic value;
        expect(stringify(value), 'null');
      });
    });

    // group('int casting', () {
    //   test('asInt converts string numbers to int', () {
    //     expect('123'.asInt(), 123);
    //     expect('123.45'.asInt(), 123);
    //     expect(true.asInt(), 1);
    //     expect(false.asInt(), 0);
    //   });

    //   test('asInt throws for invalid int conversion', () {
    //     expect(() => 'abc'.asInt(), throwsA(isA<TypeError>()));
    //   });

    //   test('tryInt returns null for invalid conversion', () {
    //     expect('abc'.tryInt(), isNull);
    //     dynamic value;
    //     expect(value.tryInt(), isNull);
    //   });
    // });

    // group('double casting', () {
    //   test('asDouble converts string numbers to double', () {
    //     expect('123.45'.asDouble(), 123.45);
    //     expect('123'.asDouble(), 123.0);
    //     expect(true.asDouble(), 1.0);
    //   });

    //   test('asDouble throws for invalid double conversion', () {
    //     expect(() => 'abc'.asDouble(), throwsA(isA<TypeError>()));
    //   });

    //   test('tryDouble returns null for invalid conversion', () {
    //     expect('abc'.tryDouble(), isNull);
    //     dynamic value;
    //     expect(value.tryDouble(), isNull);
    //   });
    // });

    // group('bool casting', () {
    //   test('asBool converts various types to bool', () {
    //     expect('true'.asBool(), isTrue);
    //     expect('false'.asBool(), isFalse);
    //     expect(1.asBool(), isTrue);
    //     expect(0.asBool(), isFalse);
    //     expect('1'.asBool(), isTrue);
    //     expect('0'.asBool(), isFalse);
    //   });

    //   test('asBool throws for invalid bool conversion', () {
    //     expect(() => 'abc'.asBool(), throwsA(isA<TypeError>()));
    //   });

    //   test('tryBool returns null for invalid conversion', () {
    //     expect('abc'.tryBool(), isNull);
    //     dynamic value;
    //     expect(value.tryBool(), isNull);
    //   });
    // });

    // group('List casting', () {
    //   test('asList converts compatible types to List', () {
    //     expect('[1, 2, 3]'.asList<int>(), equals([1, 2, 3]));
    //     expect('1,2,3'.asList<int>(separator: ','), equals([1, 2, 3]));
    //     expect(['1', '2', '3'].asList<int>(), equals([1, 2, 3]));
    //   });

    //   test('asList uses custom item decoder when provided', () {
    //     final result = '1,2,3'.asList<int>(
    //       itemDecoder: (e) => (int.tryParse(e) ?? 0) * 2,
    //       separator: ',',
    //     );
    //     expect(result, equals([2, 4, 6]));
    //   });

    //   test('asList uses orElse when conversion fails', () {
    //     final result = 'invalid'.asList<int>(
    //       orElse: () => [1, 2, 3],
    //     );
    //     expect(result, equals([1, 2, 3]));
    //   });

    //   test('tryList returns null for invalid conversion', () {
    //     dynamic value;
    //     expect(value.tryList<int>(), isNull);
    //     expect('invalid'.tryList<int>(), isNull);
    //   });

    //   test('tryList handles string to list conversion', () {
    //     final result = '1,2,3'.tryList<int>(
    //       separator: ',',
    //       itemDecoder: (e) => int.tryParse(e) ?? 0,
    //     );
    //     expect(result, equals([1, 2, 3]));
    //   });
    // });
  });
}
