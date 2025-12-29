import 'package:reduct/reduct.dart';
import 'package:test/test.dart';

void tests() {
  group('parse input tests', () {
    test('make decimal Column from input', () {
      final input = '    mcc DECIMAL(18,5) NOT NULL,';
      final column = Column.from(input);
      expect(column.name, 'mcc');
      expect(column.type, ColumnTypeDuckDB.decimal);
      expect(column.isNullable, false);
    });

    test('make enum Column from input', () {
      final input = "    status ENUM('ACTIVE', 'SUSPENDED') not null,";
      final column = Column.from(input);
      expect(column.name, 'status');
      expect(column.type, ColumnTypeDuckDB.enumType);
      expect(column.isNullable, false);
    });
  });
}

void main() {
  tests();
}
