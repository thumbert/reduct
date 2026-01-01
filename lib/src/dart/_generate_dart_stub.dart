import 'package:reduct/reduct.dart';
import 'package:reduct/src/dart/class_api_query_filter.dart';

import 'class_record.dart';
import 'enums.dart';
import 'imports.dart';
import 'test_client.dart';

String generateDartStub(
  List<Column> columns, {
  required String tableName,
  required List<String> requiredFilters,
}) {
  final buffer = StringBuffer();
  buffer.writeln('// Auto-generated Dart stub for DuckDB table: $tableName');
  buffer.writeln(
    '// Created on ${DateTime.now().toIso8601String().substring(0, 10)} '
    'with Dart package reduct\n',
  );
  buffer.write(addImports(columns));

  buffer.write('\n');
  buffer.write(makeRecord(columns));

  for (var column in columns) {
    if (column.type == ColumnTypeDuckDB.enumType) {
      final variants = getEnumVariants(column.input);
      variants.sort();
      buffer.write('\n');
      buffer.write(
        makeEnum(
          columnName: column.name,
          values: variants,
        ),
      );
    }
  }

  // buffer.write('\n');
  // buffer.write(makeQueryFunction(tableName, columns));

  buffer.write('\n\n');
  buffer.write(makeClientTest());

  buffer.write('\n\n');
  buffer.write(makeApiQueryFilterClass(columns));

  return buffer.toString();
}
