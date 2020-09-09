import 'package:ad_stream/config.dart';
import 'package:flutter_driver/driver_extension.dart';
import 'package:ad_stream/main.dart' as app;

void main() {
  enableFlutterDriverExtension();

  final testConfig = Config(
    defaultAd: null,
    creativeBaseUrl: 'http://localhost:8080/public/creatives/',
    gpsAccuracy: 4,
    defaultAdRepositoryRefreshInterval: 1,
    defaultAdSchedulerRefreshInterval: 1,
    defaultAdPresenterHealthCheckInterval: 1,
  );

  app.mainInjectConfig(testConfig);
}
