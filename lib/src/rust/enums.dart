import 'package:reduct/src/utils/string_extensions.dart';

/// Generate a Rust enum from a DuckDB ENUM column.
/// Make sure that the variant name is in Pascal case.
/// Have a custom serializer that serializes back to the original data.
/// Have a custom deserializer that is a bit more liberal with the input
/// (accepts different casing).
///
/// * [columnName] the DuckDB column name,
/// * [values] the list of ENUM values in DuckDB in UPPER_SNAKE_CASE,
/// * [isNullable] whether the column is nullable.
String makeEnum(
    {required String columnName,
    required List<String> values,
    required bool isNullable}) {
  final enumNameRust = columnName.toPascalCase();
  final buffer = StringBuffer();
  buffer.writeln('#[derive(Clone, Copy, Debug, PartialEq)]');
  buffer.writeln('pub enum $enumNameRust {');
  for (var value in values) {
    final variantNameRust = value.toPascalCase();
    buffer.writeln('    $variantNameRust,');
  }
  buffer.writeln('}');

  // Implement FromStr for the enum to parse from string.  Be case insensitive.
  buffer.writeln('\nimpl std::str::FromStr for $enumNameRust {');
  buffer.writeln('    type Err = String;');
  buffer.writeln('    fn from_str(s: &str) -> Result<Self, Self::Err> {');
  buffer.writeln('        match s.to_case(Case::UpperSnake).as_str() {');
  for (var value in values) {
    final variantNameRust = value.toPascalCase();
    buffer.writeln(
        '            "${value.toUpperSnakeCase()}" => Ok($enumNameRust::$variantNameRust),');
  }
  buffer.writeln(
      '            _ => Err(format!("Invalid value for $enumNameRust: {}", s)),');
  buffer.writeln('        }');
  buffer.writeln('    }');
  buffer.writeln('}');

  // Implement Display so that the Serde serializer prints the correct output
  buffer.writeln('\nimpl std::fmt::Display for $enumNameRust {');
  buffer.writeln(
      '    fn fmt(&self, f: &mut std::fmt::Formatter) -> std::fmt::Result {');
  buffer.writeln('        match self {');
  for (var value in values) {
    final variantNameRust = value.toPascalCase();
    buffer.writeln(
        '            $enumNameRust::$variantNameRust => write!(f, "$value"),');
  }
  buffer.writeln('        }');
  buffer.writeln('    }');
  buffer.writeln('}');

  // Implement a custom Serializer
  buffer.writeln("\nimpl serde::Serialize for $enumNameRust {");
  buffer.writeln(
      '    fn serialize<S>(&self, serializer: S) -> Result<S::Ok, S::Error>');
  buffer.writeln('    where');
  buffer.writeln("        S: serde::Serializer,");
  buffer.writeln('    {');
  buffer.writeln('        let s = match self {');
  for (var value in values) {
    final variantNameRust = value.toPascalCase();
    buffer.writeln('            $enumNameRust::$variantNameRust => "$value",');
  }
  buffer.writeln('        };');
  buffer.writeln('        serializer.serialize_str(s)');
  buffer.writeln('    }');
  buffer.writeln('}');

  // Implement a custom Deserializer so that the Actix path can parse different
  // casing
  buffer.writeln("\nimpl<'de> serde::Deserialize<'de> for $enumNameRust {");
  buffer.writeln(
      '    fn deserialize<D>(deserializer: D) -> Result<Self, D::Error>');
  buffer.writeln('    where');
  buffer.writeln("        D: serde::Deserializer<'de>,");
  buffer.writeln('    {');
  buffer.writeln('        let s = String::deserialize(deserializer)?;');
  buffer.writeln(
      '        $enumNameRust::from_str(&s).map_err(serde::de::Error::custom)');
  buffer.writeln('    }');
  buffer.writeln('}');

  return buffer.toString();
}

