import 'dart:convert';
import 'dart:io';
import 'package:test/test.dart';
import 'package:type_caster/type_caster.dart';

void main() {
  group('Fixtures Tests', () {
    late Map<String, dynamic> tempJsonData;

    setUpAll(() {
      // Load the temp.json fixture
      final tempFile = File('test/fixtures/temp2.json');
      final tempJsonString = tempFile.readAsStringSync();
      tempJsonData = json.decode(tempJsonString) as Map<String, dynamic>;
    });

    group('Generic JSON Fixture Tests', () {
      test('should load JSON fixture successfully', () {
        expect(tempJsonData, isNotNull);
        expect(tempJsonData, isA<Map<String, dynamic>>());
      });

      test('should validate JSON structure and types', () {
        // Test temp.json structure
        expect(tempJsonData.containsKey('ok'), isTrue);
        expect(tempJsonData.containsKey('result'), isTrue);
      });

      test('should cast top-level boolean field', () {
        final ok = asBool(tempJsonData['ok']);
        expect(ok, isTrue);
        expect(ok, isA<bool>());
      });

      test('should cast result object to Map', () {
        final result = asMap<String, dynamic>(tempJsonData['result']);
        expect(result, isA<Map<String, dynamic>>());
        expect(result.containsKey('message_id'), isTrue);
        expect(result.containsKey('from'), isTrue);
        expect(result.containsKey('chat'), isTrue);
        expect(result.containsKey('date'), isTrue);
        expect(result.containsKey('text'), isTrue);
      });

      test('should cast message_id to int', () {
        final result = asMap<String, dynamic>(tempJsonData['result']);
        final messageId = asInt(result['message_id']);
        expect(messageId, equals(6));
        expect(messageId, isA<int>());
      });

      test('should cast from object with nested fields', () {
        final result = asMap<String, dynamic>(tempJsonData['result']);
        final from = asMap<String, dynamic>(result['from']);

        expect(from, isA<Map<String, dynamic>>());
        expect(from['id'], equals(8337409194));
        expect(from['is_bot'], isTrue);
        expect(from['first_name'], equals('CDS Inspector Bot'));
        expect(from['username'], equals('cds_inspector_bot'));
      });

      test('should cast from.id to int', () {
        final result = asMap<String, dynamic>(tempJsonData['result']);
        final from = asMap<String, dynamic>(result['from']);
        final id = asInt(from['id']);

        expect(id, equals(8337409194));
        expect(id, isA<int>());
      });

      test('should cast from.is_bot to bool', () {
        final result = asMap<String, dynamic>(tempJsonData['result']);
        final from = asMap<String, dynamic>(result['from']);
        final isBot = asBool(from['is_bot']);

        expect(isBot, isTrue);
        expect(isBot, isA<bool>());
      });

      test('should cast from.first_name to string', () {
        final result = asMap<String, dynamic>(tempJsonData['result']);
        final from = asMap<String, dynamic>(result['from']);
        final firstName = asString(from['first_name']);

        expect(firstName, equals('CDS Inspector Bot'));
        expect(firstName, isA<String>());
      });

      test('should cast chat object with nested structure', () {
        final result = asMap<String, dynamic>(tempJsonData['result']);
        final chat = asMap<String, dynamic>(result['chat']);

        expect(chat, isA<Map<String, dynamic>>());
        expect(chat['id'], equals(-4862685206));
        expect(chat['title'], equals('CDS API Report'));
        expect(chat['type'], equals('group'));
        expect(chat['all_members_are_administrators'], isTrue);
        expect(chat.containsKey('accepted_gift_types'), isTrue);
      });

      test('should cast chat.id to int (negative number)', () {
        final result = asMap<String, dynamic>(tempJsonData['result']);
        final chat = asMap<String, dynamic>(result['chat']);
        final chatId = asInt(chat['id']);

        expect(chatId, equals(-4862685206));
        expect(chatId, isA<int>());
      });

      test('should cast accepted_gift_types nested object', () {
        final result = asMap<String, dynamic>(tempJsonData['result']);
        final chat = asMap<String, dynamic>(result['chat']);
        final giftTypes = asMap<String, dynamic>(chat['accepted_gift_types']);

        expect(giftTypes, isA<Map<String, dynamic>>());
        expect(giftTypes['unlimited_gifts'], isFalse);
        expect(giftTypes['limited_gifts'], isFalse);
        expect(giftTypes['unique_gifts'], isFalse);
        expect(giftTypes['premium_subscription'], isFalse);
      });

      test('should cast all gift type booleans', () {
        final result = asMap<String, dynamic>(tempJsonData['result']);
        final chat = asMap<String, dynamic>(result['chat']);
        final giftTypes = asMap<String, dynamic>(chat['accepted_gift_types']);

        final unlimitedGifts = asBool(giftTypes['unlimited_gifts']);
        final limitedGifts = asBool(giftTypes['limited_gifts']);
        final uniqueGifts = asBool(giftTypes['unique_gifts']);
        final premiumSubscription = asBool(giftTypes['premium_subscription']);

        expect(unlimitedGifts, isFalse);
        expect(limitedGifts, isFalse);
        expect(uniqueGifts, isFalse);
        expect(premiumSubscription, isFalse);
      });

      test('should cast date to int (Unix timestamp)', () {
        final result = asMap<String, dynamic>(tempJsonData['result']);
        final date = asInt(result['date']);

        expect(date, equals(1757345933));
        expect(date, isA<int>());
      });

      test('should cast date to DateTime from Unix timestamp', () {
        final result = asMap<String, dynamic>(tempJsonData['result']);
        final date = asInt(result['date']);
        final dateTime = asDateTime(date);

        expect(dateTime, isA<DateTime>());
        expect(dateTime.millisecondsSinceEpoch ~/ 1000, equals(1757345));
      });

      test('should cast text to string', () {
        final result = asMap<String, dynamic>(tempJsonData['result']);
        final text = asString(result['text']);

        expect(text, equals('Congratulations!!!'));
        expect(text, isA<String>());
      });

      test('should handle safe casting with try functions', () {
        final result = asMap<String, dynamic>(tempJsonData['result']);

        // Safe casting that should succeed
        final messageId = tryInt(result['message_id']);
        final isBot = tryBool(result['from']['is_bot']);
        final text = tryString(result['text']);

        expect(messageId, equals(6));
        expect(isBot, isTrue);
        expect(text, equals('Congratulations!!!'));
      });

      test('should handle safe casting with fallback values', () {
        final result = asMap<String, dynamic>(tempJsonData['result']);

        // Using orElse for safe casting
        final messageId = asInt(result['message_id'], orElse: () => -1);
        final isBot = asBool(result['from']['is_bot'], orElse: () => false);
        final text = asString(result['text'], orElse: () => 'No text');

        expect(messageId, equals(6));
        expect(isBot, isTrue);
        expect(text, equals('Congratulations!!!'));
      });

      test('should handle missing fields gracefully with try functions', () {
        final result = asMap<String, dynamic>(tempJsonData['result']);

        // Try to access non-existent fields
        final missingInt = tryInt(result['missing_int']);
        final missingBool = tryBool(result['missing_bool']);
        final missingString = tryString(result['missing_string']);

        expect(missingInt, isNull);
        expect(missingBool, isNull);
        expect(missingString, isNull);
      });

      test('should handle missing fields with orElse fallback', () {
        final result = asMap<String, dynamic>(tempJsonData['result']);

        // Access non-existent fields with fallback
        final missingInt = asInt(result['missing_int'], orElse: () => 0);
        final missingBool = asBool(result['missing_bool'], orElse: () => false);
        final missingString =
            asString(result['missing_string'], orElse: () => 'default');

        expect(missingInt, equals(0));
        expect(missingBool, isFalse);
        expect(missingString, equals('default'));
      });

      test('should convert entire JSON to string using stringify', () {
        final jsonString = stringify(tempJsonData);
        expect(jsonString, isA<String>());
        expect(jsonString, contains('"ok":true'));
        expect(jsonString, contains('"message_id":6'));
        expect(jsonString, contains('"first_name":"CDS Inspector Bot"'));
      });

      test('should format JSON with indentation using StringUtils.indentJson',
          () {
        final indentedJson = indentJson(tempJsonData, indent: '  ');
        expect(indentedJson, isA<String>());
        expect(indentedJson, contains('  "ok": true'));
        expect(indentedJson, contains('    "message_id": 6'));

        // Test with different indentation levels
        final indentedJson2 = indentJson(tempJsonData, indent: '    ');
        expect(indentedJson2, isA<String>());
        expect(indentedJson2, contains('    "ok": true'));
        expect(indentedJson2, contains('        "message_id": 6'));
      });

      test('should truncate long strings in JSON output', () {
        final truncatedJson = stringify(tempJsonData, maxStringLength: 10);
        expect(truncatedJson, isA<String>());
        // The first_name field should be truncated
        expect(truncatedJson, contains('"CDS Inspec"'));

        // Test with indentJson truncation
        final truncatedIndentedJson =
            indentJson(tempJsonData, maxStringLength: 5);
        expect(truncatedIndentedJson, isA<String>());
        expect(truncatedIndentedJson, contains('"CDS I"'));
      });

      test('should demonstrate comprehensive StringUtils functionality', () {
        // Test stringify with various options
        final basicStringify = stringify(tempJsonData);
        expect(basicStringify, isA<String>());

        // Test with indentation
        final indentedStringify = stringify(tempJsonData, indent: '  ');
        expect(indentedStringify, isA<String>());
        expect(indentedStringify, contains('  "ok": true'));

        // Test with string length truncation
        final truncatedStringify = stringify(tempJsonData, maxStringLength: 8);
        expect(truncatedStringify, isA<String>());
        expect(truncatedStringify, contains('"CDS Insp"'));

        // Test with overall length truncation
        final maxLenStringify = stringify(tempJsonData, maxLen: 100);
        expect(maxLenStringify, isA<String>());
        expect(maxLenStringify.length, lessThanOrEqualTo(100));

        // Test with replacements
        final replacedStringify = stringify(tempJsonData, replacements: {
          'CDS Inspector Bot': 'Test Bot',
          'Congratulations': 'Success'
        });
        expect(replacedStringify, contains('"Test Bot"'));
        expect(replacedStringify, contains('"Success!!!"'));

        // Test indentJson with various options
        final basicIndent = indentJson(tempJsonData);
        expect(basicIndent, isA<String>());

        // Test indentJson with custom indentation
        final customIndent = indentJson(tempJsonData, indent: '    ');
        expect(customIndent, isA<String>());
        expect(customIndent, contains('    "ok": true'));

        // Test indentJson with string truncation
        final truncatedIndent = indentJson(tempJsonData, maxStringLength: 10);
        expect(truncatedIndent, isA<String>());
        expect(truncatedIndent, contains('"CDS Inspec"'));
      });

      test('should handle complex nested structure casting', () {
        // Test casting the entire nested structure
        final result = asMap<String, dynamic>(tempJsonData['result']);
        final from = asMap<String, dynamic>(result['from']);
        final chat = asMap<String, dynamic>(result['chat']);
        final giftTypes = asMap<String, dynamic>(chat['accepted_gift_types']);

        // Verify the complete structure
        expect(result['message_id'], equals(6));
        expect(from['id'], equals(8337409194));
        expect(from['first_name'], equals('CDS Inspector Bot'));
        expect(chat['title'], equals('CDS API Report'));
        expect(giftTypes['unlimited_gifts'], isFalse);
        expect(result['text'], equals('Congratulations!!!'));
      });

      test('should demonstrate comprehensive type casting capabilities', () {
        // Test all available type casting functions with temp.json

        // String casting
        final text = asString(tempJsonData['result']['text']);
        final firstName =
            asString(tempJsonData['result']['from']['first_name']);
        expect(text, equals('Congratulations!!!'));
        expect(firstName, equals('CDS Inspector Bot'));

        // Integer casting
        final messageId = asInt(tempJsonData['result']['message_id']);
        final userId = asInt(tempJsonData['result']['from']['id']);
        expect(messageId, equals(6));
        expect(userId, equals(8337409194));

        // Double casting (from int)
        final messageIdDouble = asDouble(tempJsonData['result']['message_id']);
        final userIdDouble = asDouble(tempJsonData['result']['from']['id']);
        expect(messageIdDouble, equals(6.0));
        expect(userIdDouble, equals(8337409194.0));

        // Boolean casting
        final ok = asBool(tempJsonData['ok']);
        final isBot = asBool(tempJsonData['result']['from']['is_bot']);
        expect(ok, isTrue);
        expect(isBot, isTrue);

        // DateTime casting from Unix timestamp
        final date = asInt(tempJsonData['result']['date']);
        final dateTime = asDateTime(date);
        expect(dateTime, isA<DateTime>());
        expect(dateTime.millisecondsSinceEpoch ~/ 1000, equals(1757345));

        // Map casting
        final result = asMap<String, dynamic>(tempJsonData['result']);
        final from = asMap<String, dynamic>(tempJsonData['result']['from']);
        expect(result, isA<Map<String, dynamic>>());
        expect(from, isA<Map<String, dynamic>>());

        // List casting (create a test list)
        final testList = ['item1', 'item2', 'item3'];
        final dataList = asList<String>(testList);
        expect(dataList, isA<List<String>>());
        expect(dataList.length, equals(3));

        // Set casting (convert list to set)
        final dataSet = asSet<String>(
            ['check-in-des', 'number-image-ckn', 'time-min-checkin']);
        expect(dataSet, isA<Set<String>>());
        expect(dataSet.length, equals(3));
      });

      test('should handle JSON string input for Map casting', () {
        final jsonString = json.encode(tempJsonData);
        final parsedData = asMap<String, dynamic>(jsonString);

        expect(parsedData, isA<Map<String, dynamic>>());
        expect(parsedData['ok'], isTrue);
        expect(parsedData['result']['message_id'], equals(6));
      });

      test('should handle type casting errors gracefully', () {
        final result = asMap<String, dynamic>(tempJsonData['result']);

        // Try to cast string to int (should fail)
        expect(() => asInt(result['text']), throwsA(isA<FormatException>()));

        // Try to cast int to bool (should fail)
        expect(
            () => asBool(result['message_id']), throwsA(isA<CastException>()));

        // Try to cast string to DateTime (should fail)
        expect(() => asDateTime(result['text']), throwsA(isA<Exception>()));
      });

      test(
          'should handle safe type casting with try functions for invalid conversions',
          () {
        final result = asMap<String, dynamic>(tempJsonData['result']);

        // These should return null instead of throwing
        final invalidInt = tryInt(result['text']);
        final invalidBool = tryBool(result['message_id']);
        final invalidDateTime = tryDateTime(result['text']);

        expect(invalidInt, isNull);
        expect(invalidBool, isNull);
        expect(invalidDateTime, isNull);
      });
    });

    group('Comprehensive indentJson Tests', () {
      test('should test indentJson with various indentation styles', () {
        // Test with no indentation (default)
        final noIndent = indentJson(tempJsonData);
        expect(noIndent, isA<String>());
        expect(noIndent, contains('"ok":true'));
        expect(noIndent, contains('"message_id":6'));

        // Test with 2-space indentation
        final twoSpaceIndent = indentJson(tempJsonData, indent: '  ');
        expect(twoSpaceIndent, isA<String>());
        expect(twoSpaceIndent, contains('  "ok": true'));
        expect(twoSpaceIndent, contains('    "message_id": 6'));
        expect(twoSpaceIndent, contains('    "from": {'));

        // Test with 4-space indentation
        final fourSpaceIndent = indentJson(tempJsonData, indent: '    ');
        expect(fourSpaceIndent, isA<String>());
        expect(fourSpaceIndent, contains('    "ok": true'));
        expect(fourSpaceIndent, contains('        "message_id": 6'));
        expect(fourSpaceIndent, contains('        "from": {'));

        // Test with tab indentation
        final tabIndent = indentJson(tempJsonData, indent: '\t');
        expect(tabIndent, isA<String>());
        expect(tabIndent, contains('\t"ok": true'));
        expect(tabIndent, contains('\t\t"message_id": 6'));

        // Test with custom indentation string
        final customIndent = indentJson(tempJsonData, indent: '--');
        expect(customIndent, isA<String>());
        expect(customIndent, contains('--"ok": true'));
        expect(customIndent, contains('----"message_id": 6'));
      });

      test('should test indentJson with string truncation', () {
        // Test with no truncation
        final noTruncation = indentJson(tempJsonData);
        expect(noTruncation, contains('"CDS Inspector Bot"'));
        expect(noTruncation, contains('"Congratulations!!!"'));

        // Test with moderate truncation
        final moderateTruncation =
            indentJson(tempJsonData, maxStringLength: 15);
        expect(moderateTruncation, contains('"CDS Inspector B"'));
        expect(moderateTruncation, contains('"Congratulations"'));

        // Test with aggressive truncation
        final aggressiveTruncation =
            indentJson(tempJsonData, maxStringLength: 5);
        expect(aggressiveTruncation, contains('"CDS I"'));
        expect(aggressiveTruncation, contains('"Congr"'));

        // Test with very small truncation
        final smallTruncation = indentJson(tempJsonData, maxStringLength: 2);
        expect(smallTruncation, contains('"CD"'));
        expect(smallTruncation, contains('"Co"'));
      });

      test('should test indentJson with combined options', () {
        // Test indentation + truncation
        final combined =
            indentJson(tempJsonData, indent: '  ', maxStringLength: 8);
        expect(combined, contains('  "ok": true'));
        expect(combined, contains('    "message_id": 6'));
        expect(combined, contains('"CDS Insp"'));

        // Test different indentation levels with truncation
        final deepIndentTruncated =
            indentJson(tempJsonData, indent: '    ', maxStringLength: 6);
        expect(deepIndentTruncated, contains('    "ok": true'));
        expect(deepIndentTruncated, contains('        "message_id": 6'));
        expect(deepIndentTruncated, contains('"CDS In"'));
      });

      test('should test indentJson with nested structures', () {
        // Test with nested objects
        final nested = indentJson(tempJsonData, indent: '  ');
        expect(nested, contains('  "result": {'));
        expect(nested, contains('    "from": {'));
        expect(nested, contains('      "id": 8337409194'));
        expect(nested, contains('    "chat": {'));
        expect(nested, contains('      "accepted_gift_types": {'));
        expect(nested, contains('        "unlimited_gifts": false'));

        // Test deep nesting with different indentation
        final deepNested = indentJson(tempJsonData, indent: '    ');
        expect(deepNested, contains('    "result": {'));
        expect(deepNested, contains('        "from": {'));
        expect(deepNested, contains('            "id": 8337409194'));
        expect(deepNested, contains('        "chat": {'));
        expect(deepNested, contains('            "accepted_gift_types": {'));
        expect(
            deepNested, contains('                "unlimited_gifts": false'));
      });

      test('should test indentJson with different data types', () {
        // Test with various data types in the JSON
        final typed = indentJson(tempJsonData, indent: '  ');

        // Test boolean formatting
        expect(typed, contains('  "ok": true'));
        expect(typed, contains('      "is_bot": true'));
        expect(typed, contains('      "all_members_are_administrators": true'));
        expect(typed, contains('        "unlimited_gifts": false'));

        // Test number formatting
        expect(typed, contains('    "message_id": 6'));
        expect(typed, contains('      "id": 8337409194'));
        expect(typed, contains('      "id": -4862685206'));
        expect(typed, contains('    "date": 1757345933'));

        // Test string formatting
        expect(typed, contains('      "first_name": "CDS Inspector Bot"'));
        expect(typed, contains('      "username": "cds_inspector_bot"'));
        expect(typed, contains('      "title": "CDS API Report"'));
        expect(typed, contains('      "type": "group"'));
        expect(typed, contains('    "text": "Congratulations!!!"'));
      });

      test('should test indentJson edge cases', () {
        // Test with empty object
        final emptyObject = indentJson({}, indent: '  ');
        expect(emptyObject, equals('{}'));

        // Test with simple values
        final simpleString = indentJson('test', indent: '  ');
        expect(simpleString, equals('"test"'));

        final simpleNumber = indentJson(42, indent: '  ');
        expect(simpleNumber, equals('42'));

        final simpleBool = indentJson(true, indent: '  ');
        expect(simpleBool, equals('true'));

        // Test with null
        final nullValue = indentJson(null, indent: '  ');
        expect(nullValue, equals('null'));

        // Test with array
        final array = indentJson([1, 2, 3], indent: '  ');
        expect(array, contains('[\n  1,\n  2,\n  3\n]'));

        // Test with mixed array
        final mixedArray = indentJson([1, 'test', true, null], indent: '  ');
        expect(mixedArray, contains('[\n  1,\n  "test",\n  true,\n  null\n]'));
      });

      test('should test indentJson performance with large data', () {
        // Create a larger test object
        final largeData = {
          'users': List.generate(
              10,
              (i) => {
                    'id': i,
                    'name': 'User $i',
                    'email': 'user$i@example.com',
                    'profile': {
                      'age': 20 + i,
                      'city': 'City $i',
                      'preferences': {
                        'theme': 'dark',
                        'notifications': true,
                        'language': 'en'
                      }
                    }
                  })
        };

        // Test with different indentation levels
        final twoSpace = indentJson(largeData, indent: '  ');
        expect(twoSpace, isA<String>());
        expect(twoSpace, contains('  "users": ['));
        expect(twoSpace, contains('    "id": 0'));
        expect(twoSpace, contains('      "profile": {'));

        final fourSpace = indentJson(largeData, indent: '    ');
        expect(fourSpace, isA<String>());
        expect(fourSpace, contains('    "users": ['));
        expect(fourSpace, contains('        "id": 0'));
        expect(fourSpace, contains('            "profile": {'));

        // Test with truncation on large data
        final truncated =
            indentJson(largeData, indent: '  ', maxStringLength: 5);
        expect(truncated, isA<String>());
        expect(truncated, contains('"User 0"'));
        expect(truncated, contains('"user0@example.com"'));
      });
    });

    group('JSON Structure Validation', () {
      test('should validate required fields exist', () {
        expect(tempJsonData.containsKey('ok'), isTrue);
        expect(tempJsonData.containsKey('result'), isTrue);

        final result = tempJsonData['result'] as Map<String, dynamic>;
        expect(result.containsKey('message_id'), isTrue);
        expect(result.containsKey('from'), isTrue);
        expect(result.containsKey('chat'), isTrue);
        expect(result.containsKey('date'), isTrue);
        expect(result.containsKey('text'), isTrue);
      });

      test('should validate data types of required fields', () {
        expect(tempJsonData['ok'], isA<bool>());
        expect(tempJsonData['result'], isA<Map>());

        final result = tempJsonData['result'] as Map<String, dynamic>;
        expect(result['message_id'], isA<int>());
        expect(result['from'], isA<Map>());
        expect(result['chat'], isA<Map>());
        expect(result['date'], isA<int>());
        expect(result['text'], isA<String>());
      });

      test('should validate nested object structures', () {
        final result = tempJsonData['result'] as Map<String, dynamic>;
        final from = result['from'] as Map<String, dynamic>;
        final chat = result['chat'] as Map<String, dynamic>;
        final giftTypes = chat['accepted_gift_types'] as Map<String, dynamic>;

        // Validate from object structure
        expect(from.containsKey('id'), isTrue);
        expect(from.containsKey('is_bot'), isTrue);
        expect(from.containsKey('first_name'), isTrue);
        expect(from.containsKey('username'), isTrue);

        // Validate chat object structure
        expect(chat.containsKey('id'), isTrue);
        expect(chat.containsKey('title'), isTrue);
        expect(chat.containsKey('type'), isTrue);
        expect(chat.containsKey('all_members_are_administrators'), isTrue);
        expect(chat.containsKey('accepted_gift_types'), isTrue);

        // Validate gift types structure
        expect(giftTypes.containsKey('unlimited_gifts'), isTrue);
        expect(giftTypes.containsKey('limited_gifts'), isTrue);
        expect(giftTypes.containsKey('unique_gifts'), isTrue);
        expect(giftTypes.containsKey('premium_subscription'), isTrue);
      });
    });

    group('Comprehensive Type Casting Summary', () {
      test('should demonstrate complete type casting system capabilities', () {
        // This test serves as a comprehensive summary of all type casting capabilities

        print('\n=== TYPE CASTER COMPREHENSIVE SUMMARY ===');

        // 1. Basic Type Casting
        print('\n1. Basic Type Casting:');
        final stringValue = asString(tempJsonData['result']['text']);
        final intValue = asInt(tempJsonData['result']['message_id']);
        final doubleValue = asDouble(tempJsonData['result']['message_id']);
        final boolValue = asBool(tempJsonData['ok']);
        final dateTimeValue = asDateTime(tempJsonData['result']['date']);

        print('  String: "$stringValue" (${stringValue.runtimeType})');
        print('  Int: $intValue (${intValue.runtimeType})');
        print('  Double: $doubleValue (${doubleValue.runtimeType})');
        print('  Bool: $boolValue (${boolValue.runtimeType})');
        print('  DateTime: $dateTimeValue (${dateTimeValue.runtimeType})');

        // 2. Collection Type Casting
        print('\n2. Collection Type Casting:');
        final mapValue = asMap<String, dynamic>(tempJsonData['result']);
        final testList = [
          {'id': 1, 'name': 'test'},
          {'id': 2, 'name': 'test2'}
        ];
        final listValue = asList<Map<String, dynamic>>(testList);
        final setValue = asSet<String>(['item1', 'item2', 'item3']);

        print('  Map: ${mapValue.runtimeType} with ${mapValue.length} keys');
        print(
            '  List: ${listValue.runtimeType} with ${listValue.length} items');
        print('  Set: ${setValue.runtimeType} with ${setValue.length} items');

        // 3. Safe Type Casting (try functions)
        print('\n3. Safe Type Casting (try functions):');
        final safeString = tryString(tempJsonData['result']['text']);
        final safeInt = tryInt(tempJsonData['result']['message_id']);
        final safeBool = tryBool(tempJsonData['ok']);
        final safeDateTime = tryDateTime(tempJsonData['result']['date']);

        print('  Safe String: $safeString');
        print('  Safe Int: $safeInt');
        print('  Safe Bool: $safeBool');
        print('  Safe DateTime: $safeDateTime');

        // 4. Fallback Value Handling
        print('\n4. Fallback Value Handling:');
        final fallbackString =
            asString(tempJsonData['missing_field'], orElse: () => 'default');
        final fallbackInt =
            asInt(tempJsonData['missing_field'], orElse: () => -1);
        final fallbackBool =
            asBool(tempJsonData['missing_field'], orElse: () => false);

        print('  Fallback String: $fallbackString');
        print('  Fallback Int: $fallbackInt');
        print('  Fallback Bool: $fallbackBool');

        // 5. String Utilities
        print('\n5. String Utilities:');
        final basicStringify = stringify(tempJsonData);
        final indentedStringify = indentJson(tempJsonData, indent: '  ');
        final truncatedStringify = stringify(tempJsonData, maxStringLength: 20);

        print('  Basic stringify length: ${basicStringify.length}');
        print('  Indented stringify length: ${indentedStringify.length}');
        print('  Truncated stringify length: ${truncatedStringify.length}');

        // 6. Error Handling
        print('\n6. Error Handling:');
        try {
          asInt(tempJsonData['result']['text']); // This should throw
        } catch (e) {
          print('  Expected error caught: ${e.runtimeType}');
        }

        final safeInvalidCast = tryInt(tempJsonData['result']['text']);
        print('  Safe invalid cast result: $safeInvalidCast');

        // 7. Complex Nested Structure Handling
        print('\n7. Complex Nested Structure Handling:');
        final nestedResult = asMap<String, dynamic>(tempJsonData['result']);
        final nestedFrom = asMap<String, dynamic>(nestedResult['from']);
        final nestedChat = asMap<String, dynamic>(nestedResult['chat']);
        final nestedGiftTypes =
            asMap<String, dynamic>(nestedChat['accepted_gift_types']);

        print('  Nested levels: 4 levels deep');
        print('  From ID: ${asInt(nestedFrom['id'])}');
        print('  Chat Title: ${asString(nestedChat['title'])}');
        print('  Gift Types Count: ${nestedGiftTypes.length}');

        // 8. JSON String Input Handling
        print('\n8. JSON String Input Handling:');
        final jsonString = json.encode(tempJsonData);
        final parsedFromString = asMap<String, dynamic>(jsonString);
        print('  JSON string length: ${jsonString.length}');
        print('  Parsed from string: ${parsedFromString.containsKey('ok')}');

        print('\n=== SUMMARY COMPLETE ===\n');

        // Assertions to ensure everything works
        expect(stringValue, isA<String>());
        expect(intValue, isA<int>());
        expect(doubleValue, isA<double>());
        expect(boolValue, isA<bool>());
        expect(dateTimeValue, isA<DateTime>());
        expect(mapValue, isA<Map<String, dynamic>>());
        expect(listValue, isA<List<Map<String, dynamic>>>());
        expect(setValue, isA<Set<String>>());
        expect(safeString, isA<String>());
        expect(safeInt, isA<int>());
        expect(safeBool, isA<bool>());
        expect(safeDateTime, isA<DateTime>());
        expect(fallbackString, equals('default'));
        expect(fallbackInt, equals(-1));
        expect(fallbackBool, isFalse);
        expect(safeInvalidCast, isNull);
        expect(parsedFromString, isA<Map<String, dynamic>>());
      });
    });
  });
}
