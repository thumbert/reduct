
/// Generate the Rust test module for the archive data retrieval function.
String makeArchiveTest() {
  final buffer = StringBuffer();

  buffer.writeln('#[cfg(test)]');
  buffer.writeln('mod tests {');
  buffer.writeln('    use std::error::Error;');
  buffer.writeln('    use duckdb::{AccessMode, Config, Connection};');
  buffer.writeln('    use crate::db::prod_db::ProdDb;');
  buffer.writeln('    use super::*;');

  buffer.writeln('\n    #[test]');
  buffer.writeln('    fn test_get_data() -> Result<(), Box<dyn Error>> {');
  buffer.writeln(
      '        let config = Config::default().access_mode(AccessMode::ReadOnly)?;');
  buffer.writeln(
      '        let conn = Connection::open_with_flags(ProdDb::scratch().duckdb_path, config).unwrap();');
  buffer.writeln('        let filter = QueryFilterBuilder::new().build();');
  buffer.writeln(
      '        let xs: Vec<Record> = get_data(&conn, &filter, Some(5)).unwrap();');
  buffer.writeln('        conn.close().unwrap();');
  buffer.writeln('        assert_eq!(xs.len(), 5);');
  buffer.writeln('        Ok(())');
  buffer.writeln('    }');
  buffer.writeln('}');
  return buffer.toString();
}
