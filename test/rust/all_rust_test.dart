import 'parse_input_test.dart' as parse_input_test;
import 'sql_query_test.dart' as sql_query_test;
import 'enum_test.dart' as enum_test;
import 'query_data_test.dart' as query_data_test;
import 'query_filter_test.dart' as query_filter_test;

void main() {
  enum_test.tests();
  parse_input_test.tests();
  query_data_test.tests();
  query_filter_test.tests();
  sql_query_test.tests();
}
