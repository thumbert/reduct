import 'dart:io';

import 'package:reduct/reduct.dart';
import 'package:reduct/src/rust/struct_api_query.dart';
import 'package:test/test.dart';

void tests() {
  group('API query tests', () {
    test('make struct for ApiQuery', () {
      final sql = '''
CREATE TABLE IF NOT EXISTS tbl (
    hour_beginning TIMESTAMPTZ NOT NULL,
    resource_type ENUM('GENERATOR','INTERTIE', 'LOAD') NOT NULL,
    id UINTEGER NOT NULL,
    location VARCHAR,
    price DECIMAL(9,4),
);
''';
      final columns = getColumns(sql, timezoneName: 'America/Los_Angeles');

      final actual = makeApiQueryStruct(columns);
      // print(actual);
      var expected = File(
        'test/_golden/api_query.rs.gold',
      ).readAsStringSync();
      expect(actual, expected);
    });
  });
}

void main() {
  tests();
}
