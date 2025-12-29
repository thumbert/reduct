import 'package:reduct/reduct.dart';
import 'package:reduct/src/rust/rust_type.dart';

/// Construct the struct use to query the data.  It contains the filter fields
/// that closely match the ones of the Record struct.
///
/// All query fields are optional.
///
String makeQueryFilterStruct(List<Column> columns) {
  final buffer = StringBuffer();
  buffer.writeln('#[derive(Debug, Default, Deserialize)]');
  buffer.writeln('pub struct QueryFilter {');
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
          buffer.writeln('    pub ${column.name}_in: Option<Vec<$rustType>>,');
          break;
      }
    }
  }
  buffer.writeln('}');

  return buffer.toString();
}

