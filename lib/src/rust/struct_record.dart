import 'package:reduct/reduct.dart';

import 'rust_type.dart';

String makeStruct(List<Column> columns) {
  final buffer = StringBuffer();
  buffer.writeln('#[derive(Clone, Debug, PartialEq, Serialize, Deserialize)]');
  buffer.writeln('pub struct Record {');
  for (var column in columns) {
    final rustType = getRustType(
      type: column.type,
      columnName: column.name,
      isNullable: column.isNullable,
    );
    if (rustType == 'Decimal') {
      buffer.writeln('    #[serde(with = "rust_decimal::serde::float")]');
    } else if (rustType == 'Option<Decimal>') {
      buffer.writeln(
        '    #[serde(with = "rust_decimal::serde::float_option")]',
      );
    }
    buffer.writeln('    pub ${column.name}: $rustType,');
  }
  buffer.writeln('}');
  return buffer.toString();
}
