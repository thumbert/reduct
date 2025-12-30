import 'package:reduct/reduct.dart';
import 'package:reduct/src/rust/struct_query_filter.dart';
import 'package:reduct/src/rust/struct_query_filter_builder.dart';
import 'package:test/test.dart';

void tests() {
  group('QueryFilter tests', () {
    test('make the QueryFilter structure for date and int', () {
      var columns = <Column>[
        Column(name: 'as_of', type: ColumnTypeDuckDB.date, isNullable: false),
        Column(name: 'id', type: ColumnTypeDuckDB.int64, isNullable: false),
      ];
      final queryStruct = makeQueryFilterStruct(columns);
      final expected = '''#[derive(Debug, Default, Deserialize)]
pub struct QueryFilter {
    pub as_of: Option<Date>,
    pub as_of_in: Option<Vec<Date>>,
    pub as_of_gte: Option<Date>,
    pub as_of_lte: Option<Date>,
    pub id: Option<i64>,
    pub id_in: Option<Vec<i64>>,
    pub id_gte: Option<i64>,
    pub id_lte: Option<i64>,
}
''';
      expect(queryStruct, expected);
    });

    test('make the QueryFilter structure for hour_beginning', () {
      var columns = <Column>[
        Column(
          name: 'hour_beginning',
          type: ColumnTypeDuckDB.timestamptz,
          isNullable: false,
          timezoneName: 'America/New_York',
        ),
      ];
      final queryStruct = makeQueryFilterStruct(columns);
      final expected = '''#[derive(Debug, Default, Deserialize)]
pub struct QueryFilter {
    pub hour_beginning: Option<Zoned>,
    pub hour_beginning_gte: Option<Zoned>,
    pub hour_beginning_lt: Option<Zoned>,
}
''';
      expect(queryStruct, expected);
    });

    test('make the QueryFilter structure for f64', () {
      var columns = <Column>[
        Column(name: 'lmp', type: ColumnTypeDuckDB.double, isNullable: false),
      ];
      final queryStruct = makeQueryFilterStruct(columns);
      final expected = '''#[derive(Debug, Default, Deserialize)]
pub struct QueryFilter {
    pub lmp_gte: Option<f64>,
    pub lmp_lt: Option<f64>,
}
''';
      expect(queryStruct, expected);
    });

    test('make the QueryFilter structure for decimal', () {
      var columns = <Column>[Column.from('    mcc DECIMAL(18,5) NOT NULL,')];
      final queryStruct = makeQueryFilterStruct(columns);
      final expected = '''#[derive(Debug, Default, Deserialize)]
pub struct QueryFilter {
    pub mcc: Option<Decimal>,
    pub mcc_in: Option<Vec<Decimal>>,
    pub mcc_gte: Option<Decimal>,
    pub mcc_lte: Option<Decimal>,
}
''';
      expect(queryStruct, expected);
    });

    test('make the QueryFilterBuilder structure for a date and int', () {
      var columns = <Column>[
        Column(name: 'as_of', type: ColumnTypeDuckDB.date, isNullable: false),
        Column(name: 'id', type: ColumnTypeDuckDB.int64, isNullable: false),
      ];
      final queryStruct = makeQueryFilterBuilder(columns);
      final expected = '''#[derive(Default)]
pub struct QueryFilterBuilder {
    inner: QueryFilter,
}

impl QueryFilterBuilder {
    pub fn new() -> Self {
        Self {
            inner: QueryFilter::default(),
        }
    }

    pub fn build(self) -> QueryFilter {
        self.inner
    }

    pub fn as_of(mut self, value: Date) -> Self {
        self.inner.as_of = Some(value);
        self
    }

    pub fn as_of_in(mut self, values_in: Vec<Date>) -> Self {
        self.inner.as_of_in = Some(values_in);
        self
    }

    pub fn as_of_gte(mut self, value: Date) -> Self {
        self.inner.as_of_gte = Some(value);
        self
    }

    pub fn as_of_lte(mut self, value: Date) -> Self {
        self.inner.as_of_lte = Some(value);
        self
    }

    pub fn id(mut self, value: i64) -> Self {
        self.inner.id = Some(value);
        self
    }

    pub fn id_in(mut self, values_in: Vec<i64>) -> Self {
        self.inner.id_in = Some(values_in);
        self
    }

    pub fn id_gte(mut self, value: i64) -> Self {
        self.inner.id_gte = Some(value);
        self
    }

    pub fn id_lte(mut self, value: i64) -> Self {
        self.inner.id_lte = Some(value);
        self
    }
}
''';
      expect(queryStruct, expected);
    });

    test('make the QueryFilterBuilder structure for a zoned', () {
      var columns = <Column>[
        Column(
          name: 'hour_beginning',
          type: ColumnTypeDuckDB.timestamptz,
          isNullable: false,
          timezoneName: 'America/New_York',
        ),
      ];
      final queryStruct = makeQueryFilterBuilder(columns);
      print(queryStruct);
      final expected = '''#[derive(Default)]
pub struct QueryFilterBuilder {
    inner: QueryFilter,
}

impl QueryFilterBuilder {
    pub fn new() -> Self {
        Self {
            inner: QueryFilter::default(),
        }
    }

    pub fn build(self) -> QueryFilter {
        self.inner
    }

    pub fn hour_beginning(mut self, value: Zoned) -> Self {
        self.inner.hour_beginning = Some(value);
        self
    }

    pub fn hour_beginning_gte(mut self, value: Zoned) -> Self {
        self.inner.hour_beginning_gte = Some(value);
        self
    }

    pub fn hour_beginning_lt(mut self, value: Zoned) -> Self {
        self.inner.hour_beginning_lt = Some(value);
        self
    }
}
''';
      expect(queryStruct, expected);
    });
  });
}

void main() {
  tests();
}
