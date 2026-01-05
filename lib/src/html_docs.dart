import 'package:reduct/reduct.dart';

/// Generate HTML documentation for the query.
/// HTML query parameters use the Rust variable naming convention.
String generateDocs(List<Column> columns) {
  final buffer = StringBuffer();
  buffer.writeln('<p>The url query string supports the following filters:</p>');
  buffer.writeln(
    '<p>All filters are optional unless otherwise noted.  '
    'If your query does not include any filters, all rows will be returned.  '
    'If no data matches your filters, an empty result set will be returned.  '
    'If the amount of data returned is too large, the server will return '
    'an error.</p>',
  );
  buffer.writeln('<ul style="list-style-type: circle;">');
  for (var column in columns) {
    var comments = '';
    if (column.type == ColumnTypeDuckDB.enumType) {
      final variants = getEnumVariants(column.input);
      comments =
          '  Possible values: <span style="font-family: monospace">${variants.map((e) => '"$e"').join(', ')}</span>.';
    } else if (column.type == ColumnTypeDuckDB.timestamptz) {
      comments =
          '  Only timezone aware timestamps are accepted, in the format '
          '<span style="font-family: monospace">%Y-%m-%dT%H:%M:%S%:z[%Q]</span> '
          'for example: <span style="font-family: monospace">2023-01-01T00:00:00-08:00[America/Los_Angeles]</span>. ';
    } else if (column.type == ColumnTypeDuckDB.date) {
      comments =
          '  Dates are accepted in the format <span style="font-family: monospace">%Y-%m-%d</span>, '
          'for example: <span style="font-family: monospace">2025-11-11</span>. ';
    }

    if (column.isNullable) {
      comments +=
          '  An explicit value of <span style="font-family: monospace">NULL</span> is accepted.';
    }
    for (var filterClause in column.filterClauses) {
      switch (filterClause) {
        case FilterClause.equal:
          buffer.writeln(
            '  <li><b>${column.name}</b> A filter for matching '
            'exactly one value in column ${column.name}.$comments',
          );
          break;
        case FilterClause.greaterThanOrEqual:
          buffer.writeln(
            '  <li><b>${column.name}_gte</b> A filter for values '
            'greater than or equal to a given value in column ${column.name}.'
            '$comments',
          );
          break;
        case FilterClause.lessThan:
          buffer.writeln(
            '  <li><b>${column.name}_lt</b> A filter for values '
            'less than a given value in column ${column.name}.$comments',
          );
          break;
        case FilterClause.lessThanOrEqual:
          buffer.writeln(
            '  <li><b>${column.name}_lte</b> A filter for values '
            'less than or equal to a given value in column ${column.name}.'
            '$comments',
          );
          break;
        case FilterClause.like:
          buffer.writeln(
            '  <li><b>${column.name}_like</b> A string pattern '
            'to be used as a SQL like filter for the values in column '
            '${column.name}.',
          );
          break;
        case FilterClause.inList:
          buffer.writeln(
            '  <li><b>${column.name}_in</b> A list of valid values '
            'separated by commas.  If the values themselves contain commas, '
            'they should be enclosed in double quotes.',
          );
          break;
      }
    }
  }
  buffer.writeln('</ul>');

  return buffer.toString();
}
