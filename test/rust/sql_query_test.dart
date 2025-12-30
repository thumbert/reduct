import 'package:reduct/reduct.dart';
import 'package:reduct/src/rust/sql_query.dart';
import 'package:test/test.dart';

void tests() {
  group('make SQL query', () {
    test('for simple columns', () {
      var columns = <Column>[
        Column(name: 'as_of', type: ColumnTypeDuckDB.date, isNullable: false),
        Column(name: 'id', type: ColumnTypeDuckDB.int64, isNullable: false),
        Column(name: 'name', type: ColumnTypeDuckDB.varchar, isNullable: false),
        Column(
          name: 'resource_type',
          type: ColumnTypeDuckDB.enumType,
          isNullable: false,
        ),
      ];
      final sqlQuery = makeSqlQuery('participants', columns);
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
      var columns = <Column>[
        Column(
          name: 'time_start',
          type: ColumnTypeDuckDB.timestamptz,
          isNullable: true,
          timezoneName: 'America/New_York',
        ),
      ];
      final sqlQuery = makeSqlQuery('participants', columns);
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
