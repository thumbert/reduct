import 'dart:io';

import 'package:reduct/reduct.dart';

void main() {
  final lines = File('test/_setup/basic.sql').readAsLinesSync();
  final idx = lines.indexWhere(
    (line) => line.trim().toUpperCase().startsWith(');'),
  );
  final sql = lines.sublist(0, idx + 1).join('\n');
  final generator = CodeGenerator(
    sql,
    timezoneName: 'America/New_York',
    apiRoute: '/basic',
    onlyFilters: ['as_of', 'resource_type'],
  );
  print(generator.generateCode(Language.rust));
  print(generator.generateHtmlDocs());
  print(generator.generateCode(Language.dart));
}
