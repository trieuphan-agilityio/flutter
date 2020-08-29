import 'package:ad_stream/src/models/targeting_value.dart';
import 'package:ad_stream/src/modules/gps/gps_controller.dart';
import 'package:ad_stream/src/modules/gps/gps_options.dart';
import 'package:ad_stream/src/modules/permission/permission_controller.dart';
import 'package:ad_stream/src/modules/permission/permission_state.dart';
import 'package:ad_stream/src/modules/power/power_provider.dart';
import 'package:ad_stream/src/modules/service_manager/service.dart';
import 'package:ad_stream/src/modules/storage/pref_storage.dart';
import 'package:mockito/mockito.dart';
import 'package:permission_handler_platform_interface/permission_handler_platform_interface.dart';

class MockPrefStoreWriting extends Mock implements PrefStoreWriting {}

class MockGpsAdapter implements GpsAdapter {
  List<GpsOptions> calledArgs = [];

  final Stream<LatLng> latLng$;

  MockGpsAdapter(this.latLng$);

  @override
  Stream<LatLng> buildStream(GpsOptions options) {
    return this.latLng$;
  }
}

class MockPowerProvider implements PowerProvider {
  final Stream<PowerState> _state$;

  MockPowerProvider(this._state$);

  Stream<PowerState> get state$ => _state$;
}

class MockPermissionController
    with ServiceMixin
    implements PermissionController {
  final Stream<PermissionState> _state$;

  MockPermissionController(this._state$);

  List<Permission> get permissions => [];

  Stream<PermissionState> get state$ => _state$;
}
