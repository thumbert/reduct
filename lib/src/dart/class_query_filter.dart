import 'package:reduct/src/dart/dart_type.dart';
import 'package:reduct/src/reduct_base.dart';
import 'package:reduct/src/utils/string_extensions.dart';

/// Generates the Dart class representing the API query filter.
/// The Api prefix makes it clear it's for API queries.
///
String makeQueryFilterClass(List<Column> columns) {
  final buffer = StringBuffer();

  // Constructor
  buffer.writeln('class QueryFilter {');
  buffer.write('  QueryFilter({');
  for (final column in columns) {
    final fieldName = column.name.toCamelCase();
    for (var filterClause in column.filterClauses) {
      final ext = switch (filterClause) {
        FilterClause.equal => '',
        FilterClause.greaterThanOrEqual => 'Gte',
        FilterClause.inList => 'In',
        FilterClause.lessThan => 'Lt',
        FilterClause.lessThanOrEqual => 'Lte',
        FilterClause.like => 'Like',
      };
      buffer.write('this.$fieldName$ext, ');
    }
  }
  buffer.writeln('});');
  buffer.writeln();

  // Fields
  for (final column in columns) {
    final dartType = getDartType(
      type: column.type,
      columnName: column.name,
      isNullable: true,
    );
    final fieldName = column.name.toCamelCase();
    for (var filterClause in column.filterClauses) {
      final ext = switch (filterClause) {
        FilterClause.equal => '',
        FilterClause.greaterThanOrEqual => 'Gte',
        FilterClause.inList => 'In',
        FilterClause.lessThan => 'Lt',
        FilterClause.lessThanOrEqual => 'Lte',
        FilterClause.like => 'Like',
      };
      if (filterClause == FilterClause.inList) {
        buffer.writeln(
          '  List<${dartType.replaceAll('?', '')}>? $fieldName$ext; ',
        );
      } else {
        buffer.writeln('  $dartType $fieldName$ext;');
      }
    }
  }
  buffer.writeln();

  // toUriParams method
  buffer.writeln('  Map<String, String> toUriParams() {');
  buffer.writeln('    final params = <String, String>{};');
  for (final column in columns) {
    final fieldName = column.name.toCamelCase();
    for (var filterClause in column.filterClauses) {
      final ext = switch (filterClause) {
        FilterClause.greaterThanOrEqual => '_gte',
        FilterClause.lessThan => '_lt',
        FilterClause.lessThanOrEqual => '_lte',
        FilterClause.like => '_like',
        FilterClause.equal => '',
        FilterClause.inList => '_in',
      };
      final dartExt = switch (filterClause) {
        FilterClause.greaterThanOrEqual => 'Gte',
        FilterClause.lessThan => 'Lt',
        FilterClause.lessThanOrEqual => 'Lte',
        FilterClause.like => 'Like',
        FilterClause.equal => '',
        FilterClause.inList => 'In',
      };
      if (filterClause == FilterClause.inList) {
        switch (column.type) {
          case ColumnTypeDuckDB.date:
            buffer.writeln(
              '    if ($fieldName$dartExt != null) { params[\'${column.name}$ext\'] = $fieldName$dartExt!.map((e) => e.toIso8601String()).join(\',\');}',
            );
            continue;
          case _:
            buffer.writeln(
              '    if ($fieldName$dartExt != null) { params[\'${column.name}$ext\'] = $fieldName$dartExt!.map((e) => e.toString()).join(\',\');}',
            );
            continue;
        }
        //
        //
      } else {
        switch (column.type) {
          case ColumnTypeDuckDB.date:
            buffer.writeln(
              '    if ($fieldName$dartExt != null) { params[\'${column.name}$ext\'] = $fieldName$dartExt!.toIso8601String();}',
            );
            continue;
          case ColumnTypeDuckDB.timestamptz:
            buffer.writeln(
              '    if ($fieldName$dartExt != null) { params[\'${column.name}$ext\'] = \'\${$fieldName$dartExt!.toIso8601String()}[\${$fieldName$dartExt!.location.name}]\';}',
            );
            continue;
          case _:
            buffer.writeln(
              '    if ($fieldName$dartExt != null) { params[\'${column.name}$ext\'] = ($fieldName$dartExt).toString();}',
            );
            continue;
        }
      }
    }
  }
  buffer.writeln('    return params;');
  buffer.writeln('  }');

  // toString method
  buffer.writeln();
  buffer.writeln('  @override');
  buffer.writeln('  String toString() {');
  buffer.writeln('    var buffer = StringBuffer();');
  buffer.writeln('    buffer.writeln(\'QueryFilter:\');');
  for (final column in columns) {
    final fieldName = column.name.toCamelCase();
    for (var filterClause in column.filterClauses) {
      final ext = switch (filterClause) {
        FilterClause.greaterThanOrEqual => 'Gte',
        FilterClause.lessThan => 'Lt',
        FilterClause.lessThanOrEqual => 'Lte',
        FilterClause.like => 'Like',
        FilterClause.equal => '',
        FilterClause.inList => 'In',
      };
      buffer.writeln(
        '    buffer.writeln(\'  $fieldName$ext: \$$fieldName$ext\');',
      );
    }
  }
  buffer.writeln('    return buffer.toString();');
  buffer.writeln('  }');
  buffer.writeln('}');

  return buffer.toString();
}
