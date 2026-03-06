import 'package:reduct/reduct.dart';

String makeClientTest(CodeGenerator generator) {
  final columns = generator.columns;

  final buffer = StringBuffer();
  buffer.write('\n\n');
  buffer.writeln('//=========================================================');
  buffer.writeln('// Dart client test file');
  buffer.writeln('//=========================================================');
  bool hasDate = false;
  bool hasTimestamptz = false;
  for (var column in columns) {
    switch (column.type) {
      case ColumnTypeDuckDB.date:
        hasDate = true;
        break;
      case ColumnTypeDuckDB.timestamptz:
        hasTimestamptz = true;
        break;
      default:
        break;
    }
  }

  buffer.writeln("import 'package:test/test.dart';");
  buffer.writeln("import 'package:dotenv/dotenv.dart' as dotenv;");
  buffer.writeln();
  if (hasDate) {
    buffer.writeln("import 'package:date/date.dart';");
  }
  if (hasTimestamptz) {
    buffer.writeln("import 'package:timezone/timezone.dart';");
    buffer.writeln("import 'package:timezone/data/latest.dart';");
  }
  buffer.writeln(
    "import 'client/${generator.apiRoute}/${generator.tableName}.dart' as client;",
  );
  buffer.writeln();

  buffer.writeln("Future<void> tests(String rootUrl) async {");
  buffer.writeln("  group('Client tests for ${generator.apiRoute}', () {");
  buffer.writeln("    test('Query records test', () async {");
  buffer.writeln("      final records = await client.queryRecords(");
  buffer.writeln("        filter: client.QueryFilter(),");
  buffer.writeln("        limit: 5,");
  buffer.writeln("        rootUrl: rootUrl,");
  buffer.writeln("      );");
  buffer.writeln("      expect(records.length, 5);");
  buffer.writeln("    });");
  buffer.writeln("  });");
  buffer.writeln("}");

  buffer.writeln();
  buffer.writeln("void main() async {");
  buffer.writeln("  dotenv.load('.env/prod.env');");
  if (hasTimestamptz) {
    buffer.writeln("  initializeTimeZones();");
  }
  buffer.writeln("final rootUrl = dotenv.env['RUST_SERVER'];");
  buffer.writeln(" await tests(rootUrl);");
  buffer.writeln("}");

  return buffer.toString();
}
