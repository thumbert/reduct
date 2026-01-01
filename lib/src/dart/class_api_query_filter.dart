import 'package:reduct/src/reduct_base.dart';

/// Generates the Dart class representing a record with the given columns.
String makeApiQueryFilterClass(List<Column> columns) {
  final buffer = StringBuffer();

  buffer.writeln('class ApiQueryFilter {');

  // // Fields
  // for (final column in columns) {
  //   buffer.writeln('  final ${column.dartType} ${column.fieldName};');
  // }
  // buffer.writeln();

  // // Constructor
  // buffer.write('  $className({');
  // for (final column in columns) {
  //   buffer.write('required this.${column.fieldName}, ');
  // }
  // buffer.writeln('});');

  buffer.writeln('}');

  return buffer.toString();
}
