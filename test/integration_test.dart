

import 'package:reduct/reduct.dart';

void generateCode() {
  final sql = '''
CREATE TABLE IF NOT EXISTS capacity_seasons (
    id INT64 NOT NULL,
    description VARCHAR NOT NULL
);
''';
  final generator = CodeGenerator(
    sql,
    timezoneName: 'America/New_York',
    apiRoute: '/nyiso/capacity_seasons',
    onlyFilters: [],
  );
  print(generator.generateCode(Language.rust));
  print(generator.generateHtmlDocs());
  print(generator.generateCode(Language.dart));
}

Future<void> main() async {
  generateCode();
}
