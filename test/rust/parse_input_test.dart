import 'package:reduct/reduct.dart';
import 'package:test/test.dart';

void tests() {
  group('parse input tests', () {
    test('get column types', () {
      final input = '''
CREATE TABLE IF NOT EXISTS participants (
    as_of DATE NOT NULL,
    id INT64 NOT NULL,
);
''';
      final columns = getColumns(input);
      expect(columns.map((c) => c.type).toList(), [
        ColumnTypeDuckDB.date,
        ColumnTypeDuckDB.int64,
      ]);
    });

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

  test('get enum variants', () {
    expect(
      getEnumVariants('''status ENUM('ACTIVE', 'SUSPENDED') NOT NULL,'''),
      ['ACTIVE', 'SUSPENDED'],
    );
    expect(
      getEnumVariants(
        "sector ENUM('Supplier', 'Not applicable', 'Alternative Resources', 'Generation', 'End User', 'Publicly-Owned Entity', 'Transmission', 'Market Participant') NOT NULL,",
      ),
      [
        'Supplier',
        'Not applicable',
        'Alternative Resources',
        'Generation',
        'End User',
        'Publicly-Owned Entity',
        'Transmission',
        'Market Participant',
      ],
    );
    expect(
      getEnumVariants(
        "participant_type ENUM('Participant', 'Non-Participant', 'Pool Operator') NOT NULL,",
      ),
      ['Participant', 'Non-Participant', 'Pool Operator'],
    );
  });
}

void main() {
  tests();
}
