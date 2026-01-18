import 'dart:io';

import 'package:reduct/src/rust/enums.dart';
import 'package:test/test.dart';

void tests() {
  group('Enum Rust tests', () {
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
        isNullable: false,
      );
      // print(actual);
      var expected = File(
        'test/_golden/enum_sector.rs.gold',
      ).readAsStringSync();
      expect(actual, expected);
    });
    test('make enum 2', () {
      final actual = makeEnum(
        columnName: 'type',
        values: [
          'ARA1',
          'ARA2',
          'ARA3',
        ],
        isNullable: false,
      );
      // print(actual);
      var expected = File(
        'test/_golden/enum_type.rs.gold',
      ).readAsStringSync();
      expect(actual, expected);
    });
  });
}

void main() {
  tests();
}
