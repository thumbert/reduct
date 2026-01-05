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
      var expected = File('test/_golden/api_query.rs.gold').readAsStringSync();
      expect(actual, expected);
    });
  });

  test('test impl ApiQuery for date column', () {
    final sql = '''
CREATE TABLE IF NOT EXISTS tbl (
    as_of DATE NOT NULL,
);
''';
    final columns = getColumns(sql);
    final actual = makeApiQueryImpl(columns);
    // print(actual);
    final expected = '''impl ApiQuery {
    pub fn to_query_filter(&self) -> QueryFilter {
        QueryFilter {
            as_of: self.as_of,
            as_of_in: self.as_of_in.as_ref().map(|s| {s.split(',').map(|v| v.trim().parse::<Date>().unwrap()).collect()}),
            as_of_gte: self.as_of_gte,
            as_of_lte: self.as_of_lte,
        }
    }
}
''';
    expect(actual, expected);
  });


  test('test impl ApiQuery for timestamptz column', () {
    final sql = '''
CREATE TABLE IF NOT EXISTS tbl (
    hour_beginning TIMESTAMPTZ NOT NULL,
);
''';
    final columns = getColumns(sql, timezoneName: 'America/New_York');
    final actual = makeApiQueryImpl(columns);
    // print(actual);
    final expected = '''impl ApiQuery {
    pub fn to_query_filter(&self) -> QueryFilter {
        QueryFilter {
            hour_beginning: self.hour_beginning.clone(),
            hour_beginning_gte: self.hour_beginning_gte.clone(),
            hour_beginning_lt: self.hour_beginning_lt.clone(),
        }
    }
}
''';
    expect(actual, expected);
  });


  test('test impl ApiQuery for enum column', () {
    final sql = '''
CREATE TABLE IF NOT EXISTS tbl (
    resource_type ENUM('GENERATOR','INTERTIE', 'LOAD') NOT NULL,
);
''';
    final columns = getColumns(sql, timezoneName: 'America/New_York');
    final actual = makeApiQueryImpl(columns);
    // print(actual);
    final expected = '''impl ApiQuery {
    pub fn to_query_filter(&self) -> QueryFilter {
        QueryFilter {
            resource_type: self.resource_type,
            resource_type_in: self.resource_type_in.as_ref().map(|s| s.split(',').map(|v| v.trim().to_string()).collect()),
        }
    }
}
''';
    expect(actual, expected);
  });

}

void main() {
  tests();
}


