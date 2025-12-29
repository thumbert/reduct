import 'package:reduct/reduct.dart';
import 'package:reduct/src/rust/rust_type.dart';

/// Generate the Rust struct for the API query parameters.
/// This struct is one argument of the Actix route. 
/// 
/// Mostly needed for the `inList` filter clause, which needs to be
/// represented as a comma-separated string in the API, but as a vector in Rust.
///
String makeApiQueryStruct(List<Column> columns,
    {required List<String> requiredFilters}) {
  final buffer = StringBuffer();
  buffer.writeln('#[derive(Debug, Deserialize)]');
  buffer.writeln('pub struct ApiQuery {');
  for (var column in columns) {
    final rustType = getRustType(
      type: column.type,
      columnName: column.name,
      isNullable: false,
    );
    for (var filterClause in column.filterClauses) {
      switch (filterClause) {
        case FilterClause.equal:
          buffer.writeln('    pub ${column.name}: Option<$rustType>,');
          break;
        case FilterClause.greaterThanOrEqual:
          buffer.writeln('    pub ${column.name}_gte: Option<$rustType>,');
          break;
        case FilterClause.lessThan:
          buffer.writeln('    pub ${column.name}_lt: Option<$rustType>,');
          break;
        case FilterClause.lessThanOrEqual:
          buffer.writeln('    pub ${column.name}_lte: Option<$rustType>,');
          break;
        case FilterClause.like:
          buffer.writeln('    pub ${column.name}_like: Option<String>,');
          break;
        case FilterClause.inList:
          buffer.writeln('    pub ${column.name}_in: Option<String>,');
          break;
      }
    }
  }
  buffer.writeln('}');

  return buffer.toString();
}
