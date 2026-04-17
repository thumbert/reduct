import 'package:reduct/reduct.dart';
import 'package:reduct/src/utils/string_extensions.dart';

import 'rust_type.dart';
import 'sql_query.dart';

/// Write the Rust function that makes the query to DuckDB to extract the data.
///
/// Construct the SQL SELECT query to get the data from DuckDB.
/// The query uses all the fields of struct [QueryFilter] to add all the
/// supported AND filter clauses.
/// [limit] is an optional limit on the number of records to return.
///
String makeQueryFunction(CodeGenerator generator, {int? limit}) {
  final buffer = StringBuffer();

  // Function signature
  buffer.writeln(
    'pub fn get_data(conn: &Connection, query_filter: &QueryFilter, limit: Option<usize>) -> Result<Vec<Record>, Box<dyn std::error::Error>> {',
  );

  // Add the SQL query
  buffer.writeln(
    makeSqlQuery(generator, limit: limit),
  );

  // Prepare and execute the query
  buffer.writeln('    let mut stmt = conn.prepare(&query)?;');
  buffer.writeln('    let rows = stmt.query_map([], |row| {');
  for (var (i, column) in generator.columns.indexed) {
    final rustType = getRustType(
      type: column.type,
      columnName: column.name,
      isNullable: column.isNullable,
    );
    final name = column.name.toSnakeCase();
    switch (column.type) {
      case ColumnTypeDuckDB.date:
        if (column.isNullable) {
          buffer.writeln(
            '        let $name = row\n'
            '            .get::<usize, Option<i32>>($i)?\n'
            '            .map(|n| {Date::ZERO + (719528 + n).days() });',
          );
          break;
        } else {
          buffer.writeln(
            '        let _n$i = 719528 + row.get::<usize, i32>($i)?;',
          );
          buffer.writeln('        let $name = Date::ZERO + _n$i.days();');
        }
        break;
      case ColumnTypeDuckDB.decimal:
        if (column.isNullable) {
          buffer.writeln(
            '        let $name: $rustType = match row.get_ref_unwrap($i) {\n'
            '            duckdb::types::ValueRef::Decimal(v) => Some(v),\n'
            '            duckdb::types::ValueRef::Null => None,\n'
            '            _ => None,\n'
            '        };',
          );
        } else {
          buffer.writeln(
            '        let $name: $rustType = match row.get_ref_unwrap($i) {\n'
            '            duckdb::types::ValueRef::Decimal(v) => v,\n'
            '            _ => Decimal::MIN,\n'
            '        };',
          );
        }
        break;
      case ColumnTypeDuckDB.enumType:
        if (column.isNullable) {
          final baseRustType = rustType
              .replaceAll('Option<', '')
              .replaceAll('>', '');
          buffer.writeln(
            '        let _n$i = match row.get_ref_unwrap($i).to_owned() {\n'
            '            duckdb::types::Value::Enum(v) => Some(v),\n'
            '            duckdb::types::Value::Null => None,\n'
            '            v => panic!("Unexpected value type {v:?} for enum ${column.name}"),\n'
            '        };',
          );
          buffer.writeln(
            '        let $name = _n$i.map(|s| $baseRustType::from_str(&s).unwrap());',
          );
        } else {
          buffer.writeln(
            '        let _n$i = match row.get_ref_unwrap($i).to_owned() {\n'
            '            duckdb::types::Value::Enum(v) => v,\n'
            '            v => panic!("Unexpected value type {v:?} for enum ${column.name}"),\n'
            '        };',
          );
          buffer.writeln(
            '        let $name = $rustType::from_str(&_n$i).unwrap();',
          );
        }
        break;
      case ColumnTypeDuckDB.time:
        buffer.writeln(
          '        let _micros$i: i64 = row.get::<usize, i64>($i)?;',
        );
        buffer.writeln(
          '        let $name = Time::midnight() + _micros$i.microseconds();',
        );
        break;
      case ColumnTypeDuckDB.timestamp:
        if (column.isNullable) {
          buffer.writeln(
            '        let _micros$i: Option<i64> = row.get::<usize, Option<i64>>($i)?;',
          );
          buffer.writeln(
            '        let $name = _micros$i.map(|micros| '
            'Timestamp::from_microsecond(micros).unwrap());',
          );
        } else {
          buffer.writeln(
            '        let _micros$i: i64 = row.get::<usize, i64>($i)?;',
          );
          buffer.writeln(
            '        let $name = '
            'Timestamp::from_microsecond(_micros$i).unwrap();',
          );
        }
        break;
      case ColumnTypeDuckDB.timestamptz:
        if (column.isNullable) {
          buffer.writeln(
            '        let _micros$i: Option<i64> = row.get::<usize, Option<i64>>($i)?;',
          );
          buffer.writeln(
            '        let $name = _micros$i.map(|micros| Zoned::new(\n'
            '                 Timestamp::from_microsecond(micros).unwrap(),\n'
            '                 TimeZone::get("${column.timezoneName}").unwrap()\n'
            '        ));',
          );
        } else {
          buffer.writeln(
            '        let _micros$i: i64 = row.get::<usize, i64>($i)?;',
          );
          buffer.writeln(
            '        let $name = Zoned::new(\n'
            '                 Timestamp::from_microsecond(_micros$i).unwrap(),\n'
            '                 TimeZone::get("${column.timezoneName}").unwrap()\n'
            '        );',
          );
        }
        break;
      case ColumnTypeDuckDB.boolean:
      case ColumnTypeDuckDB.int16:
      case ColumnTypeDuckDB.int32:
      case ColumnTypeDuckDB.int64:
      case ColumnTypeDuckDB.tinyint:
      case ColumnTypeDuckDB.uint64:
      case ColumnTypeDuckDB.uint32:
      case ColumnTypeDuckDB.uint16:
      case ColumnTypeDuckDB.uint8:
      case ColumnTypeDuckDB.varchar:
      case ColumnTypeDuckDB.float:
      case ColumnTypeDuckDB.double:
        buffer.writeln(
          '        let $name: $rustType = row.get::<usize, $rustType>($i)?;',
        );
        break;
      default:
        throw UnimplementedError('Type $rustType not implemented in get_data');
    }
  }
  buffer.writeln('        Ok(Record {');
  for (var column in generator.columns) {
    final name = column.name.toSnakeCase();
    buffer.writeln('            $name,');
  }
  buffer.writeln('        })');
  buffer.writeln('    })?;');
  buffer.writeln(
    '    let results: Vec<Record> = rows.collect::<Result<_, _>>()?;',
  );
  buffer.writeln('    Ok(results)');
  buffer.writeln('}');

  return buffer.toString();
}
