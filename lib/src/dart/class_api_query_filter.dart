import 'package:reduct/src/dart/dart_type.dart';
import 'package:reduct/src/reduct_base.dart';
import 'package:reduct/src/utils/string_extensions.dart';

/// Generates the Dart class representing the API query filter.
/// The Api prefix makes it clear it's for API queries.
/// 
String makeApiQueryFilterClass(List<Column> columns) {
  final buffer = StringBuffer();

  // Constructor
  buffer.writeln('class ApiQueryFilter ({');
  for (final column in columns) {
    final fieldName = column.name.toCamelCase();
    buffer.write('required this.$fieldName, ');
  }
  buffer.writeln('});');
  buffer.writeln();

  // Fields
  for (final column in columns) {
    final dartType = getDartType(
      type: column.type,
      columnName: column.name,
      isNullable: column.isNullable,
    );
    final fieldName = column.name.toCamelCase();
    buffer.writeln('  final $dartType $fieldName;');
  }
  buffer.writeln();

  // toUriParams method
  buffer.writeln('  Map<String, String> toUriParams() {');
  buffer.writeln('    final params = <String, String>{};');
  for (final column in columns) {
    final fieldName = column.name.toCamelCase();
    switch (column.type) {
      case ColumnTypeDuckDB.date:
        buffer.writeln(
          '    if ($fieldName != null) { params[\'${column.name}\'] = $fieldName.toString(); }',
        );
        continue;
      case ColumnTypeDuckDB.timestamptz:
        buffer.writeln(
          '    if ($fieldName != null) { params[\'${column.name}\'] = $fieldName.toIso8601String(); }',
        );
        continue;
      case ColumnTypeDuckDB.enumType:
        buffer.writeln(
          '    if ($fieldName != null) { params[\'${column.name}\'] = $fieldName.toString(); }',
        );
        continue;
      case _:
        buffer.writeln(
          '    if ($fieldName != null) { params[\'${column.name}\'] = $fieldName.toString(); }',
        );
        continue;
    }
  }
  buffer.writeln('    return params;'); 
  buffer.writeln('  }');
  


  buffer.writeln('}');
  return buffer.toString();
}
