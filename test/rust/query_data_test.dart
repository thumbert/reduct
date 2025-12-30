import 'package:reduct/reduct.dart';
import 'package:reduct/src/rust/query_function.dart';
import 'package:test/test.dart';

void tests() {
  group('get_data tests', () {
    test('makeQueryFunction to query data, with zoned', () {
      var columns = <Column>[
        Column(
          name: 'hour_beginning',
          type: ColumnTypeDuckDB.timestamptz,
          isNullable: false,
          timezoneName: 'America/New_York',
        ),
      ];
      final queryFn = makeQueryFunction('lmp', columns);
      print(queryFn);
      final expected =
          '''pub fn get_data(conn: &Connection, query_filter: &QueryFilter) -> Result<Vec<Record>, Box<dyn std::error::Error>> {
   let mut query = String::from(r#"
SELECT
    hour_beginning
FROM lmp WHERE 1=1
   "#);
    if let Some(hour_beginning) = &query_filter.hour_beginning {
        query.push_str(&format!("AND hour_beginning = '{}'", hour_beginning));
    }
    if let Some(hour_beginning_gte) = &query_filter.hour_beginning_gte {
        query.push_str(&format!("AND hour_beginning_gte >= '{}'", hour_beginning_gte));
    }
    if let Some(hour_beginning_lt) = &query_filter.hour_beginning_lt {
        query.push_str(&format!("AND hour_beginning_lt < '{}'", hour_beginning_lt));
    }
    query.push(';');
    let mut stmt = conn.prepare(&query)?;
    let rows = stmt.query_map([], |row| {
        let _micros0: i64 = row.get::<usize, i64>(0)?;
        let hour_beginning = Zoned::new(
                 Timestamp::from_microsecond(_micros0).unwrap(),
                 TimeZone::get("America/New_York").unwrap()
        );
        Ok(Record {
            hour_beginning,
        })
    })?;
    let results: Vec<Record> = rows.collect::<Result<_, _>>()?;
    Ok(results)
}
''';
      expect(queryFn, expected);
    });

    test('makeQueryFunction to query data, with f64', () {
      var columns = <Column>[
        Column(name: 'lmp', type: ColumnTypeDuckDB.double, isNullable: false),
      ];
      final queryFn = makeQueryFunction('lmp', columns);
      // print(queryFn);
      final expected =
          '''pub fn get_data(conn: &Connection, query_filter: &QueryFilter) -> Result<Vec<Record>, Box<dyn std::error::Error>> {
   let mut query = String::from(r#"
SELECT
    lmp
FROM lmp WHERE 1=1
   "#);
    if let Some(lmp_gte) = query_filter.lmp_gte {
        query.push_str(&format!("AND lmp_gte >= {}", lmp_gte));
    }
    if let Some(lmp_lt) = query_filter.lmp_lt {
        query.push_str(&format!("AND lmp_lt < {}", lmp_lt));
    }
    query.push(';');
    let mut stmt = conn.prepare(&query)?;
    let rows = stmt.query_map([], |row| {
        let lmp: f64 = row.get::<usize, f64>(0)?;
        Ok(Record {
            lmp,
        })
    })?;
    let results: Vec<Record> = rows.collect::<Result<_, _>>()?;
    Ok(results)
}
''';
      expect(queryFn, expected);
    });

    test('makeQueryFunction to query data, with enum', () {
      var columns = <Column>[
        Column(
          name: 'status',
          type: ColumnTypeDuckDB.enumType,
          isNullable: false,
        ),
        Column(name: 'id', type: ColumnTypeDuckDB.int64, isNullable: false),
      ];
      final queryFn = makeQueryFunction('participants', columns);
      print(queryFn);
      final expected =
          '''pub fn get_data(conn: &Connection, query_filter: &QueryFilter) -> Result<Vec<Record>, Box<dyn std::error::Error>> {
   let mut query = String::from(r#"
SELECT
    status,
    id
FROM participants WHERE 1=1
   "#);
    if let Some(status) = query_filter.status {
        query.push_str(&format!("AND status = '{}'", status));
    }
    if let Some(id) = query_filter.id {
        query.push_str(&format!("AND id = '{}'", id));
    }
    if let Some(id_in) = query_filter.id_in {
        query.push_str(&format!("AND id_in IN ({})", id_in));
    }
    query.push(';');
    let mut stmt = conn.prepare(&query)?;
    let rows = stmt.query_map([], |row| {
        let _n0: Status = match row.get_ref_unwrap(0) {
            duckdb::types::ValueRef::Enum(v) => v,
            _ => panic!("Unexpected value type for enum"),
        };
        let id: i64 = row.get::<usize, i64>(1)?;
        Ok(Record {
            status,
            id,
        })
    })?;
    let results: Vec<Record> = rows.collect::<Result<_, _>>()?;
    Ok(results)
}
''';
      expect(queryFn, expected);
    });
  });
}

void main() {
  tests();
}
