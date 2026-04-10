import 'package:reduct/reduct.dart';

String makeQueryRecordsFunction(CodeGenerator generator) {
  final buffer = StringBuffer();

  buffer.writeln(
    '/// Function to query records from the DuckDB table via REST API',
  );
  buffer.writeln('/// Use the [QueryFilter] to specify filtering criteria.  Note: ');
  buffer.writeln('/// an empty filter will return all records if [limit] is not specified.');
  buffer.writeln('/// [rootUrl] is the base URL of the API endpoint.');
  buffer.writeln('/// Optional [limit] can be provided to limit the number of records.');
  buffer.writeln('///');
  buffer.writeln(
    'Future<List<Record>> queryRecords({'
    ' required QueryFilter filter, '
    ' required String rootUrl, '
    ' int? limit, '
    ' http.Client? client, '
    '}) async {',
  );
  buffer.writeln('  client ??= http.Client();');
  buffer.writeln('  final queryParams = filter.toUriParams();');
  buffer.writeln('  if (limit != null) {');
  buffer.writeln('    queryParams[\'_limit\'] = limit.toString();');
  buffer.writeln('  }');
  buffer.writeln('  final uri = Uri.parse(rootUrl).replace(');
  buffer.writeln('    path: \'${generator.apiRoute}\',');
  buffer.writeln('    queryParameters: queryParams,');
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
