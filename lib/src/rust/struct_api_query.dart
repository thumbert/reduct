import 'package:reduct/reduct.dart';
import 'package:reduct/src/rust/rust_type.dart';

/// Generate the Rust struct for the API query parameters.
/// This struct is one argument of the Actix route.
///
/// Mostly needed for the `inList` filter clause, which needs to be
/// represented as a comma-separated string in the API, but as a vector in Rust.
///
String makeApiQueryStruct(List<Column> columns) {
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

String makeApiQueryImpl(List<Column> columns) {
  final buffer = StringBuffer();
  buffer.writeln('impl ApiQuery {');
  buffer.writeln('    pub fn to_query_filter(&self) -> QueryFilter {');
  // buffer.writeln('        let mut filter = QueryFilter::default();');
  buffer.writeln('        QueryFilter {');
  for (var column in columns) {
    var clone = '';
    if (column.type == ColumnTypeDuckDB.timestamptz ||
        column.type == ColumnTypeDuckDB.varchar ||
        column.type == ColumnTypeDuckDB.enumType) {
      clone = '.clone()';
    }
    for (var filterClause in column.filterClauses) {
      switch (filterClause) {
        case FilterClause.equal:
          buffer.writeln(
            '        ${column.name}: self.${column.name}$clone,',
          );
          break;
        case FilterClause.greaterThanOrEqual:
          buffer.writeln(
            '        ${column.name}_gte: self.${column.name}_gte$clone,',
          );
          break;
        case FilterClause.lessThan:
          buffer.writeln(
            '        ${column.name}_lt: self.${column.name}_lt$clone,',
          );
          break;
        case FilterClause.lessThanOrEqual:
          buffer.writeln(
            '        ${column.name}_lte: self.${column.name}_lte$clone,',
          );
          break;
        case FilterClause.like:
          buffer.writeln(
            '        ${column.name}_like: self.${column.name}_like$clone,',
          );
          break;
        case FilterClause.inList:
          buffer.writeln(
            '        ${column.name}_in: self.${column.name}_in.as_ref().map(|s| s.split(\',\').map(|v| v.trim().parse().unwrap()).collect()),',
          );
          break;
      }
    }
  }
  buffer.writeln('    }');
  buffer.writeln('}');

  return buffer.toString();
}
