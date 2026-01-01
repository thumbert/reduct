import 'dart:io';

import 'package:reduct/src/dart/enums.dart';
import 'package:test/test.dart';

void tests() {
  group('Dart enum tests', () {
        test('make Dart enum', () {
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
          ]);
      // print(actual);
      var expected =
          File('test/_golden/enum_sector.dart.gold').readAsStringSync();
      expect(actual, expected);
    });

  });
}

void main() {
  tests();
}
