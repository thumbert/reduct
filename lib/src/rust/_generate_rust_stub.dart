import 'package:reduct/reduct.dart';

import 'enums.dart';
import 'imports.dart';
import 'query_function.dart';
import 'struct_api_query.dart';
import 'struct_query_filter.dart';
import 'struct_query_filter_builder.dart';
import 'struct_record.dart';
import 'test_archive.dart';

/// It gets really tedious to manually write Rust structs that correspond to
/// a DuckDB table schema.  The entire info is already available, so why
/// not generate the Rust code automatically?
///
/// [sql] is the entire DuckDB CREATE TABLE statement.
///
/// Given a the [sql], create:
///   1. a Rust struct with the appropriate types
///   2. the enums for all DuckDB ENUM columns
///   3. a function to query the database and return a Vec of the struct
///   4. a test stub
///
///
/// See the test folder for examples.
String generateRustStub(
  List<Column> columns, {
  required String tableName,
  required List<String> requiredFilters,
}) {
  final buffer = StringBuffer();
  buffer.writeln('// Auto-generated Rust stub for DuckDB table: $tableName');
  buffer.writeln(
    '// Created on ${DateTime.now().toIso8601String().substring(0, 10)} '
    'with Dart package reduct\n',
  );
  buffer.write(addImports(columns));

  buffer.write('\n');
  buffer.write(makeStruct(columns));

  for (var column in columns) {
    if (column.type == ColumnTypeDuckDB.enumType) {
      final variants = getEnumVariants(column.input);
      variants.sort();
      buffer.write('\n');
      buffer.write(
        makeEnum(
          columnName: column.name,
          values: variants,
          isNullable: column.isNullable,
        ),
      );
    }
  }

  buffer.write('\n');
  buffer.write(makeQueryFunction(tableName, columns));

  buffer.write('\n');
  buffer.write(makeQueryFilterStruct(columns));

  buffer.write('\n');
  buffer.write(makeQueryFilterBuilder(columns));

  buffer.write('\n\n');
  buffer.write(makeArchiveTest());

  buffer.write('\n\n');
  buffer.write(makeApiQueryStruct(columns, requiredFilters: requiredFilters));

  return buffer.toString();
}
