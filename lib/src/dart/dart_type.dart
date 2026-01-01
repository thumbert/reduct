import 'package:reduct/reduct.dart';
import 'package:reduct/src/utils/string_extensions.dart';

/// Get the Dart type corresponding to a DuckDB column type.
/// Need the [columnName] for an enumerated type.
String getDartType({
  required ColumnTypeDuckDB type,
  required String columnName,
  required bool isNullable,
}) {
  switch (type) {
    case ColumnTypeDuckDB.boolean:
      return isNullable ? 'bool?' : 'bool';
    case ColumnTypeDuckDB.date:
      return isNullable ? 'Date?' : 'Date';
    case ColumnTypeDuckDB.decimal:
      return isNullable ? 'Decimal?' : 'Decimal';
    case ColumnTypeDuckDB.tinyint:
      return isNullable ? 'int?' : 'int';
    case ColumnTypeDuckDB.int16:
      return isNullable ? 'int?' : 'int';
    case ColumnTypeDuckDB.int32:
      return isNullable ? 'int?' : 'int';
    case ColumnTypeDuckDB.int64:
      return isNullable ? 'int?' : 'int';
    case ColumnTypeDuckDB.float:
      return isNullable ? 'double?' : 'double';
    case ColumnTypeDuckDB.double:
      return isNullable ? 'double?' : 'double';
    case ColumnTypeDuckDB.varchar:
      return isNullable ? 'String?' : 'String';
    case ColumnTypeDuckDB.time:
      return isNullable ? 'Time?' : 'Time'; // not supported yet
    case ColumnTypeDuckDB.timestamp:
      return isNullable ? 'DateTime?' : 'DateTime';
    case ColumnTypeDuckDB.enumType:
      return isNullable
          ? '${columnName.toPascalCase()}?'
          : columnName.toPascalCase();
    case ColumnTypeDuckDB.uint8:
      return isNullable ? 'int?' : 'int';
    case ColumnTypeDuckDB.uint16:
      return isNullable ? 'int?' : 'int';
    case ColumnTypeDuckDB.uint32:
      return isNullable ? 'int?' : 'int';
    case ColumnTypeDuckDB.uint64:
      return isNullable ? 'int?' : 'int';
    case ColumnTypeDuckDB.timestamptz:
      return isNullable ? 'TZDateTime?' : 'TZDateTime';
    case ColumnTypeDuckDB.uint128:
      return isNullable ? 'int?' : 'int';
  }
}
