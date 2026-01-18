import 'package:reduct/src/utils/string_extensions.dart';
import 'package:test/test.dart';

void tests() {
  group('string extensions test', () {
    test('toUpperSnakeCase', () {
      expect('hello World'.toUpperSnakeCase(), 'HELLO_WORLD');
      expect('helloWorld'.toUpperSnakeCase(), 'HELLO_WORLD');
      expect('HelloWorld'.toUpperSnakeCase(), 'HELLO_WORLD');
      expect('hello_world'.toUpperSnakeCase(), 'HELLO_WORLD');
      expect('ARA1'.toUpperSnakeCase(), 'ARA_1');
    });

  });
}

void main() {
  tests();
}
