

String makeApiRouteTest() {
  final buffer = StringBuffer();

  buffer.writeln('#[cfg(test)]');
  buffer.writeln('mod tests {');
  buffer.writeln('    use super::*;');
  buffer.writeln('    use actix_web::{test, App};');
  buffer.writeln('');
  buffer.writeln('    #[actix_rt::test]');
  buffer.writeln(
      '    async fn test_get_records_api_route() {');
  buffer.writeln('        let app = test::init_service(');
  buffer.writeln('            App::new().service(get_records),');
  buffer.writeln('        )');
  buffer.writeln('        .await;');
  buffer.writeln('');
  buffer.writeln(
      '        let req = test::TestRequest::get()');
  buffer.writeln('            .uri("/records?limit=10")');
  buffer.writeln('            .to_request();');
  buffer.writeln('');
  buffer.writeln('        let resp = test::call_service(&app, req).await;');
  buffer.writeln('        assert!(resp.status().is_success());');
  buffer.writeln('    }');
  buffer.writeln('}');

  return buffer.toString();
}