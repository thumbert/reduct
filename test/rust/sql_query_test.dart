import 'package:reduct/reduct.dart';
import 'package:reduct/src/rust/sql_query.dart';
import 'package:test/test.dart';

void tests() {
  group('make SQL query', () {
    test('for simple columns', () {
      final generator = CodeGenerator(
        '''
CREATE TABLE basic (
    hour_beginning TIMESTAMPTZ NOT NULL,
    as_of DATE NOT NULL,
    resource_type ENUM('solar', 'wind', 'hydro', 'storage') NOT NULL,
    resource_id INTEGER NOT NULL,
    location VARCHAR,
    price DECIMAL(9,4),
    start_time TIME NOT NULL,
);
''',
        apiRoute: '/participants',
        onlyFilters: ['as_of', 'id', 'name', 'resource_type'],
      );
      final sqlQuery = makeSqlQuery(generator);
      print(sqlQuery);
      expect(
        sqlQuery.contains(
          "    AND as_of IN ('{}')\", as_of_in.iter().map(|v| v.to_string()).collect::<Vec<_>>().join(\"','\")));",
        ),
        true,
      );
      expect(
        sqlQuery.contains(
          "    AND id IN ({})\", id_in.iter().map(|v| v.to_string()).collect::<Vec<_>>().join(\",\")));",
        ),
        true,
      );
      expect(
        sqlQuery.contains(
          "    AND name IN ('{}')\", name_in.iter().map(|v| v.to_string()).collect::<Vec<_>>().join(\"','\")));",
        ),
        true,
      );
      expect(
        sqlQuery.contains(
          "    AND resource_type IN ('{}')\", resource_type_in.iter().map(|v| v.to_string()).collect::<Vec<_>>().join(\"','\")));",
        ),
        true,
      );
    });

    test('for timestamptz', () {
      final generator = CodeGenerator(
        '''
CREATE TABLE participants (
    time_start TIMESTAMPTZ,
);
''',
        apiRoute: '/participants',
        onlyFilters: ['time_start'],
        timezoneName: 'America/New_York',
      );
      final sqlQuery = makeSqlQuery(generator);
      expect(
        sqlQuery.contains(
          "    if let Some(time_start) = &query_filter.time_start {",
        ),
        true,
      );
    });
  });
}

void main() {
  tests();
}
