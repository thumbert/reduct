
import 'rust/all_rust_test.dart' as all_rust_test;
import 'dart/all_dart_test.dart' as all_dart_test;
import 'utils/string_exensions_test.dart' as string_extensions_test;
import 'html_test.dart' as html_test;

void main() {
  all_rust_test.main();
  all_dart_test.main();
  html_test.tests();
  string_extensions_test.tests();
}
