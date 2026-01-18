import 'dart:io';

import 'package:reduct/src/dart/enums.dart';
import 'package:test/test.dart';

void tests() {
  group('Dart enum tests', () {
    test('make enum 1', () {
      final actual = makeEnum(
        columnName: 'sector',
        values: [
          'Supplier',
          'Not applicable',
          'Alternative Resources',
          'Generation',
          'End User',
          'Publicly-Owned Entity',
          'Transmission',
          'Market Participant',
        ],
      );
      // print(actual);
      var expected = File(
        'test/_golden/enum_sector.dart.gold',
      ).readAsStringSync();
      expect(actual, expected);
    });

    test('make enum 2', () {
      final actual = makeEnum(
        columnName: 'type',
        values: ['ARA1', 'ARA2', 'ARA3'],
      );
      // print(actual);
      var expected = File(
        'test/_golden/enum_type.dart.gold',
      ).readAsStringSync();
      expect(actual, expected);
    });
  });
}

void main() {
  tests();
}
