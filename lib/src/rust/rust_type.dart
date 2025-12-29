import 'package:reduct/reduct.dart';
import 'package:reduct/src/utils/string_extensions.dart';

/// Get the Rust type corresponding to the DuckDB column type.
/// Need the [columnName] for an enumerated type.
String getRustType({
  required ColumnTypeDuckDB type,
  required String columnName,
  required bool isNullable,
}) {
  switch (type) {
    case ColumnTypeDuckDB.boolean:
      return isNullable ? 'Option<bool>' : 'bool';
    case ColumnTypeDuckDB.date:
      return isNullable ? 'Option<Date>' : 'Date';
    case ColumnTypeDuckDB.decimal:
      return isNullable ? 'Option<Decimal>' : 'Decimal';
    case ColumnTypeDuckDB.tinyint:
      return isNullable ? 'Option<i8>' : 'i8';
    case ColumnTypeDuckDB.int16:
      return isNullable ? 'Option<i16>' : 'i16';
    case ColumnTypeDuckDB.int32:
      return isNullable ? 'Option<i32>' : 'i32';
    case ColumnTypeDuckDB.int64:
      return isNullable ? 'Option<i64>' : 'i64';
    case ColumnTypeDuckDB.float:
      return isNullable ? 'Option<f32>' : 'f32';
    case ColumnTypeDuckDB.double:
      return isNullable ? 'Option<f64>' : 'f64';
    case ColumnTypeDuckDB.varchar:
      return isNullable ? 'Option<String>' : 'String';
    case ColumnTypeDuckDB.time:
      return isNullable ? 'Option<Time>' : 'Time';
    case ColumnTypeDuckDB.timestamp:
      return isNullable ? 'Option<Timestamp>' : 'Timestamp';
    case ColumnTypeDuckDB.enumType:
      return isNullable
          ? 'Option<${columnName.toPascalCase()}>'
          : columnName.toPascalCase();
    case ColumnTypeDuckDB.uint8:
      return isNullable ? 'Option<u8>' : 'u8';
    case ColumnTypeDuckDB.uint16:
      return isNullable ? 'Option<u16>' : 'u16';
    case ColumnTypeDuckDB.uint32:
      return isNullable ? 'Option<u32>' : 'u32';
    case ColumnTypeDuckDB.uint64:
      return isNullable ? 'Option<u64>' : 'u64';
    case ColumnTypeDuckDB.timestamptz:
      return isNullable ? 'Option<Zoned>' : 'Zoned';
    case ColumnTypeDuckDB.uint128:
      return isNullable ? 'Option<u128>' : 'u128';
  }
}

