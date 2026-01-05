

String makeApiTest() {
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
  buffer.writeln(
    '        let req = test::TestRequest::get().uri("/api/data").to_request();',
  );
  buffer.writeln('        let resp = test::call_service(&app, req).await;');
  buffer.writeln('        assert!(resp.status().is_success());');
  buffer.writeln('    }');
  buffer.writeln('}');

  return buffer.toString();
}
