import 'package:reduct/reduct.dart';
import 'package:reduct/src/rust/rust_type.dart';

String addApiImports(List<Column> columns, {required String apiRoute}) {
  final buffer = StringBuffer();
  buffer.writeln('use std::time::Duration;');
  buffer.writeln('use actix_web::{get, web, HttpResponse, Responder};');

  buffer.writeln('use serde::{Serialize, Deserialize};');
  buffer.writeln('use duckdb::AccessMode;');
  buffer.writeln('');

  bool hasDecimal = false;
  bool hasDate = false;
  // bool hasEnum = false;
  bool hasTime = false;
  bool hasTimestamp = false;
  bool hasTimestamptz = false;
  for (var column in columns) {
    switch (column.type) {
      case ColumnTypeDuckDB.date:
        hasDate = true;
        break;
      case ColumnTypeDuckDB.decimal:
        hasDecimal = true;
        break;
      // case ColumnTypeDuckDB.enumType:
      //   hasEnum = true;
      case ColumnTypeDuckDB.time:
        hasTime = true;
        break;
      case ColumnTypeDuckDB.timestamp:
        hasTimestamp = true;
        break;
      case ColumnTypeDuckDB.timestamptz:
        hasTimestamptz = true;
        hasTimestamp = true;
        break;
      default:
        break;
    }
  }

  if (hasDate) {
    buffer.writeln('use jiff::{civil::Date, ToSpan};');
  }
  if (hasDecimal) {
    buffer.writeln('use rust_decimal::Decimal;');
  }
  // if (hasEnum) {
  //   buffer.writeln('use std::str::FromStr;');
  //   buffer.writeln('use convert_case::{Case, Casing};');
  // }
  if (hasTime) {
    buffer.writeln('use jiff::civil::Time;');
  }
  if (hasTimestamp) {
    buffer.writeln('use jiff::Timestamp;');
  }
  if (hasTimestamptz) {
    buffer.writeln('use jiff::{Zoned, tz::TimeZone};');
  }

  buffer.writeln();
  buffer.writeln('use crate::utils::lib_duckdb::open_with_retry;');
  buffer.writeln('use crate::db::${apiRoute.replaceAll('/', '::')}::*;');

  buffer.writeln();
  return buffer.toString();
}

String makeApiEndpoint(CodeGenerator generator) {
  final buffer = StringBuffer();
  buffer.writeln('#[get("${generator.apiRoute}")]');
  buffer.writeln(
    'pub async fn get_data_api(query: web::Query<ApiQuery>, data: web::Data<XxxxArchive>) -> impl Responder {',
  );
  buffer.writeln('    let conn = open_with_retry(');
  buffer.writeln('        &data.duckdb_path,');
  buffer.writeln('        8,');
  buffer.writeln('        Duration::from_millis(25),');
  buffer.writeln('        AccessMode::ReadOnly,');
  buffer.writeln('    );');
  buffer.writeln('    if conn.is_err() {');
  buffer.writeln(
    '        return HttpResponse::InternalServerError().body(format!(',
  );
  buffer.writeln('            "Error opening DuckDB database at {}: {}",');
  buffer.writeln('            &data.duckdb_path,');
  buffer.writeln('            conn.err().unwrap(),');
  buffer.writeln('        ));');
  buffer.writeln('    }');
  buffer.writeln('    let conn = conn.unwrap();');
  buffer.writeln();
  buffer.writeln('    let query_filter = query.to_query_filter();');
  buffer.writeln('    match get_data(&conn, &query_filter, query._limit) {');
  buffer.writeln('        Ok(records) => {');
  buffer.writeln('            if records.len() > 100_000 {');
  buffer.writeln('                HttpResponse::BadRequest()');
  buffer.writeln(
    '                    .body(format!("Query returned {} records, only a max of 100,000 are allowed.  Please narrow your query.", records.len()))',
  );
  buffer.writeln('            } else {');
  buffer.writeln('                HttpResponse::Ok().json(records)');
  buffer.writeln('            }');
  buffer.writeln('        }');
  buffer.writeln(
    '        Err(e) => HttpResponse::InternalServerError().body(format!("Error querying data: {}", e)),',
  );
  buffer.writeln('    }');
  buffer.writeln('}');
  buffer.writeln();

  return buffer.toString();
}

/// Generate the Rust struct for the API query parameters.
/// This struct is one argument of the Actix route.
///
/// Mostly needed for the `inList` filter clause, which needs to be
/// represented as a comma-separated string in the API, but as a vector in Rust.
///
String makeApiQueryStruct(List<Column> columns) {
  final buffer = StringBuffer();
  buffer.writeln('#[derive(Debug, Deserialize)]');
  buffer.writeln('struct ApiQuery {');
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
  // add a limit field
  buffer.writeln('    pub _limit: Option<usize>,');
  buffer.writeln('}');

  return buffer.toString();
}

String makeApiQueryImpl(List<Column> columns) {
  final buffer = StringBuffer();
  buffer.writeln('impl ApiQuery {');
  buffer.writeln('    pub fn to_query_filter(&self) -> QueryFilter {');
  buffer.writeln('        QueryFilter {');
  for (var column in columns) {
    var clone = '';
    if (column.type == ColumnTypeDuckDB.timestamptz ||
        column.type == ColumnTypeDuckDB.varchar) {
      clone = '.clone()';
    }
    for (var filterClause in column.filterClauses) {
      switch (filterClause) {
        case FilterClause.equal:
          buffer.writeln(
            '            ${column.name}: self.${column.name}$clone,',
          );
          break;
        case FilterClause.greaterThanOrEqual:
          buffer.writeln(
            '            ${column.name}_gte: self.${column.name}_gte$clone,',
          );
          break;
        case FilterClause.lessThan:
          buffer.writeln(
            '            ${column.name}_lt: self.${column.name}_lt$clone,',
          );
          break;
        case FilterClause.lessThanOrEqual:
          buffer.writeln(
            '            ${column.name}_lte: self.${column.name}_lte$clone,',
          );
          break;
        case FilterClause.like:
          buffer.writeln(
            '            ${column.name}_like: self.${column.name}_like$clone,',
          );
          break;
        case FilterClause.inList:
          switch (column.type) {
            case ColumnTypeDuckDB.date:
              buffer.writeln(
                '            ${column.name}_in: self.${column.name}_in.as_ref().map(|s| {s.split(\',\').map(|v| v.trim().parse::<Date>().unwrap()).collect()}),',
              );
              break;
            case ColumnTypeDuckDB.enumType:
              final rustType = getRustType(
                type: column.type,
                columnName: column.name,
                isNullable: false,
              );
              buffer.writeln(
                '            ${column.name}_in: self.${column.name}_in.as_ref().map(|s| s.split(\',\').map(|v| v.trim().parse::<$rustType>().unwrap()).collect()),',
              );
              break;
            default:
              buffer.writeln(
                '            ${column.name}_in: self.${column.name}_in.as_ref().map(|s| s.split(\',\').map(|v| v.trim().parse().unwrap()).collect()),',
              );
              break;
          }
      }
    }
  }
  buffer.writeln('        }');
  buffer.writeln('    }');
  buffer.writeln('}');

  return buffer.toString();
}
