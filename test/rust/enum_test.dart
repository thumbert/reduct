import 'dart:io';

import 'package:reduct/src/rust/enums.dart';
import 'package:test/test.dart';

void tests() {
  group('make SQL query', () {
        test('make Rust enum', () {
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
            'Market Participant'
          ],
          isNullable: false);
      // print(actual);
      var expected =
          File('test/_golden/enum_sector.rs.gold').readAsStringSync();
      expect(actual, expected);
    });

  });
}

void main() {
  tests();
}
