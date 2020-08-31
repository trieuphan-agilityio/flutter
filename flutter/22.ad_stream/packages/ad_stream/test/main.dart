import 'ad/ad_test.dart' as ad_test;
import 'csv_replayer_test.dart' as csv_replayer_test;
import 'modules/gps_controller_test.dart' as gps_controller_test;
import 'modules/gps_options_test.dart' as gps_options_test;
import 'modules/movement_detector_test.dart' as movement_detector_test;
import 'modules/permission_controller_test.dart' as permission_controller_test;
import 'modules/service_manager_test.dart' as service_manager_test;
import 'modules/service_test.dart' as service_test;
import 'modules/trip_detector_test.dart' as trip_detector_test;

main() {
  ad_test.main();
  csv_replayer_test.main();
  gps_controller_test.main();
  gps_options_test.main();
  movement_detector_test.main();
  permission_controller_test.main();
  service_manager_test.main();
  service_test.main();
  trip_detector_test.main();
}
