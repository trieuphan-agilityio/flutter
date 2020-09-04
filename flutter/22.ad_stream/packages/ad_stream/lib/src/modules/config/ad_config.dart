import 'package:ad_stream/models.dart';
import 'package:meta/meta.dart';

class AdConfig {
  /// Indicates how long a time block take. Duration in seconds.
  final int timeBlockToSecs;

  /// User must want the ad before he/she can skip ad. Duration in seconds.
  final int defaultCanSkipAfter;

  /// Ad that should be displayed when the app is fetching from Ad Server.
  final Ad defaultAd;

  /// Base URL that is used for constructing Creative download URL.
  /// e.g: https://s3.awscloud.com/stag/creative/
  final String creativeBaseUrl;

  AdConfig({
    @required this.timeBlockToSecs,
    @required this.defaultCanSkipAfter,
    @required this.defaultAd,
    @required this.creativeBaseUrl,
  });
}

abstract class AdConfigProvider {
  AdConfig get adConfig;
  Stream<AdConfig> get adConfig$;
}
