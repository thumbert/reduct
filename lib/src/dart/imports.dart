import 'package:reduct/reduct.dart';

String addImports(List<Column> columns) {
  final buffer = StringBuffer();

  bool hasDecimal = false;
  bool hasDate = false;
  bool hasTimestamptz = false;
  for (var column in columns) {
    switch (column.type) {
      case ColumnTypeDuckDB.date:
        hasDate = true;
        break;
      case ColumnTypeDuckDB.decimal:
        hasDecimal = true;
        break;
      case ColumnTypeDuckDB.timestamptz:
        hasTimestamptz = true;
        break;
      default:
        break;
    }
  }

  buffer.writeln("import 'package:http/http.dart' as http;");
  if (hasDate) {
    buffer.writeln("import 'package:date/date.dart';");
  }
  if (hasDecimal) {
    buffer.writeln("import 'package:decimal/decimal.dart';");
  }
  if (hasTimestamptz) {
    buffer.writeln("import 'package:timezone/timezone.dart';");
  }
  buffer.writeln();
  return buffer.toString();
}

