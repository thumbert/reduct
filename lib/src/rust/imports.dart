import 'package:reduct/reduct.dart';

String addImports(List<Column> columns) {
  final buffer = StringBuffer();
  // buffer.writeln('use std::error::Error;');
  // buffer.writeln('use log::{error, info};');
  buffer.writeln('use std::collections::HashMap;');
  buffer.writeln();
  buffer.writeln('use serde::{Serialize, Deserialize};');
  buffer.writeln('use duckdb::Connection;');
  buffer.writeln('use url::form_urlencoded;');
  buffer.writeln('');

  bool hasDecimal = false;
  bool hasDate = false;
  bool hasEnum = false;
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
      case ColumnTypeDuckDB.enumType:
        hasEnum = true;
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
  if (hasEnum) {
    buffer.writeln('use std::str::FromStr;');
    buffer.writeln('use convert_case::{Case, Casing};');
  }
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
  return buffer.toString();
}
