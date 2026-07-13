import 'package:reduct/src/dart/dart_type.dart';
import 'package:reduct/src/reduct_base.dart';
import 'package:reduct/src/utils/string_extensions.dart';

/// Generates the Dart class representing a record from the given columns.
String makeRecordClass(List<Column> columns, {String className = 'Record'}) {
  final buffer = StringBuffer();
  buffer.writeln('class $className {');

  // Constructor
  buffer.write('  $className({');
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

  // fromJson method
  buffer.writeln('  static $className fromJson(Map<String, dynamic> json) {');
  buffer.writeln('    return $className(');
  for (final column in columns) {
    final fieldName = column.name.toCamelCase();
    final dartType = getDartType(
      type: column.type,
      columnName: column.name,
      isNullable: column.isNullable,
    );
    switch (column.type) {
      case ColumnTypeDuckDB.date:
        if (column.isNullable) {
          buffer.writeln(
            '      $fieldName: json[\'${column.name}\'] == null ? null : Date.parse(json[\'${column.name}\'] as String),',
          );
        } else {
          buffer.writeln(
            '      $fieldName: Date.parse(json[\'${column.name}\'] as String),',
          );
        }
        continue;
      case ColumnTypeDuckDB.time:
        if (column.isNullable) {
          buffer.writeln(
            '      $fieldName: json[\'${column.name}\'] == null ? null : Time.parse(json[\'${column.name}\'] as String),',
          );
        } else {
          buffer.writeln(
            '      $fieldName: Time.parse(json[\'${column.name}\'] as String),',
          );
        }
        continue;
      case ColumnTypeDuckDB.timestamp:
        if (column.isNullable) {
          buffer.writeln(
            '      $fieldName: json[\'${column.name}\'] == null ? null : DateTime.parse(json[\'${column.name}\'] as String),',
          );
        } else {
          buffer.writeln(
            '      $fieldName: DateTime.parse(json[\'${column.name}\'] as String),',
          );
        }
        continue;
      case ColumnTypeDuckDB.timestamptz:
        if (column.isNullable) {
          buffer.writeln(
            '      $fieldName: json[\'${column.name}\'] == null ? null : TZDateTime.parse(getLocation(\'${column.timezoneName!}\'), json[\'${column.name}\'] as String),',
          );
        } else {
          buffer.writeln(
            '      $fieldName: TZDateTime.parse(getLocation(\'${column.timezoneName!}\'), json[\'${column.name}\'] as String),',
          );
        }
        continue;
      case ColumnTypeDuckDB.enumType:
        if (column.isNullable) {
          buffer.writeln(
            '      $fieldName: json[\'${column.name}\'] == null ? null : ${column.name.toPascalCase()}.parse(json[\'${column.name}\'] as String),',
          );
        } else {
          buffer.writeln(
            '      $fieldName: ${column.name.toPascalCase()}.parse(json[\'${column.name}\'] as String),',
          );
        }
        continue;
      case _:
        buffer.writeln(
          '      $fieldName: json[\'${column.name}\'] as $dartType,',
        );
        continue;
    }
  }
  buffer.writeln('    );');
  buffer.writeln('  }');
  buffer.writeln();

  // toJson method
  buffer.writeln('  Map<String, dynamic> toJson() {');
  buffer.writeln('    return {');
  for (final column in columns) {
    final fieldName = column.name.toCamelCase();
    final nullAware = column.isNullable ? '?' : '';
    switch (column.type) {
      case ColumnTypeDuckDB.enumType || ColumnTypeDuckDB.time:
        buffer.writeln(
          '      \'${column.name}\': $fieldName$nullAware.toString(),',
        );
        continue;
      case ColumnTypeDuckDB.timestamptz ||
          ColumnTypeDuckDB.timestamp ||
          ColumnTypeDuckDB.date:
        buffer.writeln(
          '      \'${column.name}\': $fieldName$nullAware.toIso8601String(),',
        );
        continue;
      case _:
        buffer.writeln('      \'${column.name}\': $fieldName,');
        continue;
    }
  }
  buffer.writeln('    };');
  buffer.writeln('  }');
  buffer.writeln();

  // toString method
  buffer.writeln('  @override');
  buffer.writeln('  String toString() {');
  buffer.writeln('    return toJson().toString();');
  buffer.writeln('  }');

  // Equality method
  buffer.writeln('  @override');
  buffer.writeln('  bool operator ==(Object other) {');
  buffer.writeln('    if (identical(this, other)) return true;');
  buffer.writeln('    return other is $className &&');
  for (final column in columns) {
    final fieldName = column.name.toCamelCase();
    buffer.writeln('        other.$fieldName == $fieldName &&');
  }
  buffer.writeln('        true;');
  buffer.writeln('  }');
  buffer.writeln();

  // hashCode method
  buffer.writeln('  @override');
  buffer.writeln('  int get hashCode {');
  buffer.writeln('    return Object.hashAll([');
  for (final column in columns) {
    final fieldName = column.name.toCamelCase();
    buffer.writeln('      $fieldName,');
  }
  buffer.writeln('    ]);');
  buffer.writeln('  }');

  buffer.writeln('}');
  return buffer.toString();
}
