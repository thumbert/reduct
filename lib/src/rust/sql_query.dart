import 'package:reduct/reduct.dart';

String makeSqlQuery(CodeGenerator generator, {int? limit}) {
  final buffer = StringBuffer();
  var query = 'SELECT\n    ';
  query += generator.columns
      .map((c) => c.needsQuotes ? '"${c.name}"' : c.name)
      .join(',\n    ');
  query += '\nFROM ${generator.tableName} WHERE 1=1';
  buffer.writeln('   let mut query = String::from(r#"\n$query"#);');

  // Add the SQL filter statements from the query parameters
  for (var column in generator.onlyColumns) {
    for (var filterClause in column.filterClauses) {
      var name = getQueryFilterVariableName(
        column,
        clause: filterClause,
        language: Language.rust,
      );
      var borrow = '&';
      buffer.writeln('    if let Some($name) = ${borrow}query_filter.$name {');
      if (filterClause == FilterClause.inList) {
        if (column.type == ColumnTypeDuckDB.varchar ||
            column.type == ColumnTypeDuckDB.enumType ||
            column.type == ColumnTypeDuckDB.date) {
          // quoted values
          buffer.writeln(
            "        query.push_str(&format!(\"\n    ${filterClause.makeFilter(column)}\", $name.iter().map(|v| v.to_string()).collect::<Vec<_>>().join(\"','\")));",
          );
        } else {
          // unquoted values
          buffer.writeln(
            "        query.push_str(&format!(\"\n    ${filterClause.makeFilter(column)}\", $name.iter().map(|v| v.to_string()).collect::<Vec<_>>().join(\",\")));",
          );
        }
      } else {
        var adder = '';
        if (column.type == ColumnTypeDuckDB.timestamptz) {
          adder = '.strftime("%Y-%m-%d %H:%M:%S.000%:z")';
        }
        buffer.writeln(
          "        query.push_str(&format!(\"\n    ${filterClause.makeFilter(column)}\", $name$adder));",
        );
      }
      buffer.writeln('    }');
    }
  }
  buffer.writeln("    match limit {");
  buffer.writeln("        Some(l) => {");
  buffer.writeln('            query.push_str(&format!("\nLIMIT {};", l));');
  buffer.writeln("        },");
  buffer.writeln("        None => {");
  buffer.writeln('            query.push(\';\');');
  buffer.writeln("        },");
  buffer.writeln("    }");
  return buffer.toString();
}
