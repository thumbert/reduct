import 'package:reduct/src/dart/dart_type.dart';
import 'package:reduct/src/reduct_base.dart';
import 'package:reduct/src/utils/string_extensions.dart';

/// Generates the Dart class representing a record with the given columns.
String makeRecord(List<Column> columns, {String className = 'Record'}) {
  final buffer = StringBuffer();
  buffer.writeln('class $className {');

  // Constructor
  buffer.write('  $className({');
  for (final column in columns) {
    final fieldName = column.name.toCamelCase();
    buffer.write('required this.$fieldName, ');
  }
  buffer.writeln(')};');
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
  buffer.writeln('  factory $className.fromJson(Map<String, dynamic> json) {');
  buffer.writeln('    return $className(');
  for (final column in columns) {
    final fieldName = column.name.toCamelCase();
    final dartType = getDartType(
      type: column.type,
      columnName: column.name,
      isNullable: column.isNullable,
    );
    buffer.writeln('      $fieldName: json[\'${column.name}\'] as $dartType,');
  }
  buffer.writeln('    );');
  buffer.writeln('  }');
  buffer.writeln();

  // toJson method
  buffer.writeln('  Map<String, dynamic> toJson() {');
  buffer.writeln('    return {');
  for (final column in columns) {
    final fieldName = column.name.toCamelCase();
    buffer.writeln('      \'${column.name}\': $fieldName,');
  }
  buffer.writeln('    };');
  buffer.writeln('  }');
  buffer.writeln(); 

  // toString method
  buffer.writeln('  @override');
  buffer.writeln('  String toString() {');
  buffer.writeln('}');

  return buffer.toString();
}
