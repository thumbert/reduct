import 'package:reduct/reduct.dart';

void main() {
  final sql = '''
CREATE TABLE IF NOT EXISTS public_bids_da (
    hour_beginning TIMESTAMPTZ NOT NULL,
    resource_type ENUM('GENERATOR','INTERTIE', 'LOAD') NOT NULL,
    scheduling_coordinator_seq UINTEGER NOT NULL,
    resource_bid_seq UINTEGER NOT NULL,
    time_interval_start TIMESTAMPTZ,
    time_interval_end TIMESTAMPTZ,
    product_bid_desc VARCHAR,
    product_bid_mrid VARCHAR,
    market_product_desc VARCHAR,
    market_product_type VARCHAR,
    self_sched_mw DECIMAL(9,4),
    sch_bid_time_interval_start TIMESTAMPTZ,
    sch_bid_time_interval_end TIMESTAMPTZ,
    sch_bid_xaxis_data DECIMAL(9,4),
    sch_bid_y1axis_data DECIMAL(9,4),
    sch_bid_y2axis_data DECIMAL(9,4),
    sch_bid_curve_type ENUM('BIDPRICE'),
    min_eoh_state_of_charge DECIMAL(9,4),
    max_eoh_state_of_charge DECIMAL(9,4),
);
''';
  final generator = CodeGenerator(
    sql,
    timezoneName: 'America/Los_Angeles',
    apiRoute: '/caiso/public_bids_da',
  );
  print(generator.generateCode(Language.rust));
  // print(generator.generateHtmlDocs());
  // print(generator.generateCode(Language.dart));
}
