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

/// Generate the implementation of a to_query_url method for the QueryFilter struct.
String makeQueryFilterImpl(List<Column> columns) {
  final buffer = StringBuffer();
  buffer.writeln('impl QueryFilter {');
  buffer.writeln('    pub fn to_query_url(&self) -> String {');
  buffer.writeln('        let mut params = HashMap::new();');
  for (var column in columns) {
    for (var filterClause in column.filterClauses) {
      final fieldName = switch (filterClause) {
        FilterClause.equal => column.name,
        FilterClause.greaterThanOrEqual => '${column.name}_gte',
        FilterClause.lessThan => '${column.name}_lt',
        FilterClause.lessThanOrEqual => '${column.name}_lte',
        FilterClause.like => '${column.name}_like',
        FilterClause.inList => '${column.name}_in',
      };    
      buffer.writeln('        if let Some(value) = &self.$fieldName {');
      if (filterClause == FilterClause.inList) {
        buffer.writeln(
          '            let joined = value.iter().map(|v| v.to_string()).collect::<Vec<_>>().join(",");',
        );
        buffer.writeln(
          '            params.insert("$fieldName", joined);',
        );
      } else {
        buffer.writeln(
          '            params.insert("$fieldName", value.to_string());',
        );
      }
      buffer.writeln('        }');
    }
  }
  buffer.writeln('        form_urlencoded::Serializer::new(String::new())');
  buffer.writeln('            .extend_pairs(&params)');
  buffer.writeln('            .finish()');
  buffer.writeln('    }');
  buffer.writeln('}');  
  return buffer.toString();
}