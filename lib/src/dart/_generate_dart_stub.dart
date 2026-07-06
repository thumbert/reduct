import 'package:reduct/reduct.dart';

import 'class_query_filter.dart';
import 'class_record.dart';
import 'enums.dart';
import 'imports.dart';
import 'query_records_function.dart';
import 'test_client.dart';

String generateDartStub(CodeGenerator generator) {
  final tableName = generator.tableName;
  final columns = generator.columns;

  final buffer = StringBuffer();
  buffer.writeln('// Auto-generated Dart stub for DuckDB table: $tableName');
  buffer.writeln(
    '// Created on ${DateTime.now().toIso8601String().substring(0, 10)} '
    'with Dart package reduct\n',
  );
  buffer.write(addImports(columns));

  buffer.write('\n');
  if (generator.onlyColumns.isEmpty) {
    buffer.write(makeQueryNoFiltersFunction(generator));
  } else {
    buffer.write(makeQueryRecordsFunction(generator));
  }

  buffer.write('\n');
  buffer.write(makeRecordClass(columns));

  for (var column in columns) {
    if (column.type == ColumnTypeDuckDB.enumType) {
      final variants = getEnumVariants(column.input);
      variants.sort();
      buffer.write('\n');
      buffer.write(makeEnum(columnName: column.name, values: variants));
    }
  }

  buffer.write('\n');
  if (generator.onlyColumns.isNotEmpty) {
    buffer.write(makeQueryFilterClass(generator.onlyColumns));
  }

  buffer.write('\n\n');
  buffer.write(makeClientTest(generator));

  return buffer.toString();
}
