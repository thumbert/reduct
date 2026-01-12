import 'package:reduct/src/utils/string_extensions.dart';

/// Generate a Dart enum from a DuckDB ENUM column.
/// Make sure that the variant name is in Pascal case.
///
/// * [columnName] the DuckDB column name,
/// * [values] the list of ENUM values in DuckDB in UPPER_SNAKE_CASE,
String makeEnum({
  required String columnName,
  required List<String> values,
}) {
  assert(values.isNotEmpty);
  final enumNameDart = columnName.toPascalCase();
  final buffer = StringBuffer();
  buffer.writeln('enum $enumNameDart {');

  for (var i = 0; i < values.length; i++) {
    var terminator = (i == values.length - 1) ? ';' : ',';
    final variantNameDart = values[i].toCamelCase();
    buffer.writeln('    $variantNameDart$terminator');
  }
  buffer.writeln();

  // parse method
  buffer.writeln('  static $enumNameDart parse(String value) {');
  buffer.writeln('    return switch (value.toLowerCase()) {');
  for (var value in values) {
    final variantNameDart = value.toCamelCase();
    buffer.writeln("      '${value.toLowerCase()}' => $enumNameDart.$variantNameDart,");
  }
  buffer.writeln('      _ => throw ArgumentError("Invalid value for $enumNameDart: \$value"),');
  buffer.writeln('    };');
  buffer.writeln('  }');

  // toString method
  buffer.writeln();
  buffer.writeln('  @override');
  buffer.writeln('  String toString() {');
  buffer.writeln('    return switch (this) {');
  for (var value in values) {
    final variantNameDart = value.toCamelCase();
    buffer.writeln('      $enumNameDart.$variantNameDart => \'$value\',');
  }
  buffer.writeln('    };');
  buffer.writeln('  }');
  buffer.writeln('}');

  return buffer.toString();
}
