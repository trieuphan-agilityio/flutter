import 'package:ad_stream/models.dart';
import 'package:meta/meta.dart';

class AreaConfig {
  /// Time in seconds must elapse before [AreaDetector] updating with latest
  /// [LatLng] value.
  final int refreshInterval;

  AreaConfig({@required this.refreshInterval});
}

abstract class AreaConfigProvider {
  AreaConfig get areaConfig;
  Stream<AreaConfig> get areaConfig$;
}
