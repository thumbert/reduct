import 'dart:io';

import 'package:reduct/reduct.dart';
import 'package:reduct/src/dart/class_record.dart';
import 'package:test/test.dart';

void tests() {
  group('Dart class record tests', () {
    test('make Dart record', () {
      final columns = [
        Column(name: 'id', type: ColumnTypeDuckDB.uint64, isNullable: false),
        Column(name: 'name', type: ColumnTypeDuckDB.varchar, isNullable: false),
        Column(
          name: 'created_at',
          type: ColumnTypeDuckDB.timestamptz,
          isNullable: true,
          timezoneName: 'America/New_York',
        ),
      ];
      final actual = makeRecordClass(columns);

      print(actual);
      var expected = File(
        'test/_golden/class_record.dart.gold',
      ).readAsStringSync();
      expect(actual, expected);
    });
  });
}

void main() {
  tests();
}
