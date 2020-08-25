import 'ad/ad_test.dart' as ad_test;
import 'csv_replayer_test.dart' as csv_replayer_test;
import 'modules/gps_controller_test.dart' as gps_controller_test;
import 'modules/permission_controller_test.dart' as permission_controller_test;
import 'modules/service_manager_test.dart' as service_manager_test;

main() {
  ad_test.main();
  gps_controller_test.main();
  service_manager_test.main();
  permission_controller_test.main();
  csv_replayer_test.main();
}
