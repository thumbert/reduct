

import 'package:reduct/src/reduct_base.dart';

String makeApiTest(CodeGenerator generator) {
  final buffer = StringBuffer();
  buffer.writeln('#[cfg(test)]');
  buffer.writeln('mod api_tests {');
  buffer.writeln('    use super::*;');
  buffer.writeln('    use actix_web::{test, web, App};');
  buffer.writeln();
  buffer.writeln('    #[actix_web::test]');
  buffer.writeln('    async fn test_get_data_api() {');
  buffer.writeln('        let data = web::Data::new(ProdDb::scratch());');
  buffer.writeln(
    '        let app = test::init_service(App::new().app_data(data.clone()).service(get_data_api)).await;',
  );
  buffer.writeln('        let params = QueryFilterBuilder::new().build().to_query_url();');
  buffer.writeln('        let uri = format!("${generator.apiRoute}?{}&_limit=5", params);');
  buffer.writeln(
    '        let req = test::TestRequest::get().uri(&uri).to_request();',
  );
  buffer.writeln('        let resp = test::call_service(&app, req).await;');
  buffer.writeln('        assert!(resp.status().is_success());');
  buffer.writeln('        let rs: Vec<Record> = test::read_body_json(resp).await;');
  buffer.writeln('        assert_eq!(rs.len(), 5);');
  buffer.writeln('    }');
  buffer.writeln('}');

  return buffer.toString();
}
