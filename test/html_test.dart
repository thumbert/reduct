import 'package:reduct/reduct.dart';
import 'package:test/test.dart';

void tests() {
  group('html tests', () {
    test('generate Html for enum', () {
      final input = '''
CREATE TABLE IF NOT EXISTS tmp (
    resource_type ENUM('GENERATOR','INTERTIE', 'LOAD') NOT NULL,
    sch_bid_curve_type ENUM('BIDPRICE'),
);
''';
      final generator = CodeGenerator(
        input,
        timezoneName: 'America/Los_Angeles',
      );
      var generateHtmlDocs = generator.generateHtmlDocs();
      print(generateHtmlDocs);
      // print(generateHtmlDocs);
    });
  });
}

void main() {
  tests();
}
