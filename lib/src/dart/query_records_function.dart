import 'package:reduct/reduct.dart';

String makeQueryRecordsFunction(List<Column> columns, String tableName) {
  final buffer = StringBuffer();

  buffer.writeln(
    'Future<List<Record>> queryRecords({'
    ' required ApiQueryFilter filter, '
    ' required http.Client client, '
    ' required String baseUrl, '
    '}) async {',
  );
  buffer.writeln('  final uri = Uri.parse(baseUrl).replace(');
  buffer.writeln('    path: \'$tableName\',');
  buffer.writeln('    queryParameters: filter?.toUriParams(),');
  buffer.writeln('  );');
  buffer.writeln('  final response = await client.get(uri);');
  buffer.writeln('  if (response.statusCode != 200) {');
  buffer.writeln(
    '    throw Exception(\'Failed to load records: \${response.statusCode}\');',
  );
  buffer.writeln('  }');
  buffer.writeln('  final List<dynamic> jsonList = jsonDecode(response.body);');
  buffer.writeln(
    '  return jsonList.map((json) => Record.fromJson(json)).toList();',
  );
  buffer.writeln('}');

  return buffer.toString();
}
