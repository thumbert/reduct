import 'package:reduct/reduct.dart';
import 'package:reduct/src/rust/rust_type.dart';

String makeQueryFilterBuilder(List<Column> columns) {
  final buffer = StringBuffer();

  buffer.writeln('#[derive(Default)]');
  buffer.writeln('pub struct QueryFilterBuilder {');
  buffer.writeln('    inner: QueryFilter,');
  buffer.writeln('}');

  buffer.writeln('\nimpl QueryFilterBuilder {');
  buffer.writeln('''
    pub fn new() -> Self {
        Self {
            inner: QueryFilter::default(),
        }
    }

    pub fn build(self) -> QueryFilter {
        self.inner
    }''');

  for (var column in columns) {
    final rustType = getRustType(
      type: column.type,
      columnName: column.name,
      isNullable: false,
    );
    final name = column.name;
    for (var filterClause in column.filterClauses) {
      var withInto = '';
      switch (filterClause) {
        case FilterClause.equal:
          if (column.type == ColumnTypeDuckDB.varchar) {
            withInto = '.into()';
            buffer.writeln(
                '\n    pub fn $name<S: Into<String>>(mut self, value: S) -> Self {');
          } else {
            buffer.writeln(
                '\n    pub fn $name(mut self, value: $rustType) -> Self {');
          }
          buffer.writeln('        self.inner.$name = Some(value$withInto);');
          buffer.writeln('        self');
          buffer.writeln('    }');
          break;
        case FilterClause.greaterThanOrEqual:
          buffer.writeln(
              '\n    pub fn ${name}_gte(mut self, value: $rustType) -> Self {');
          buffer.writeln('        self.inner.${name}_gte = Some(value);');
          buffer.writeln('        self');
          buffer.writeln('    }');
          break;
        case FilterClause.lessThan:
          buffer.writeln(
              '\n    pub fn ${name}_lt(mut self, value: $rustType) -> Self {');
          buffer.writeln('        self.inner.${name}_lt = Some(value);');
          buffer.writeln('        self');
          buffer.writeln('    }');
          break;
        case FilterClause.lessThanOrEqual:
          buffer.writeln(
              '\n    pub fn ${name}_lte(mut self, value: $rustType) -> Self {');
          buffer.writeln('        self.inner.${name}_lte = Some(value);');
          buffer.writeln('        self');
          buffer.writeln('    }');
          break;
        case FilterClause.like:
          buffer.writeln(
              '\n    pub fn ${column.name}_like(mut self, value_like: String) -> Self {');
          buffer.writeln(
              '        self.inner.${column.name}_like = Some(value_like);');
          buffer.writeln('        self');
          buffer.writeln('    }');
          break;
        case FilterClause.inList:
          buffer.writeln(
              '\n    pub fn ${column.name}_in(mut self, values_in: Vec<$rustType>) -> Self {');
          buffer.writeln(
              '        self.inner.${column.name}_in = Some(values_in);');
          buffer.writeln('        self');
          buffer.writeln('    }');
          break;
      }
    }
  }
  buffer.writeln('}');

  return buffer.toString();
}
