import 'package:ad_bloc/model.dart';
import 'package:meta/meta.dart';

class AdConfig {
  /// Indicates how long a time block take. Duration in seconds.
  final int timeBlockToSecs;

  /// User must want the ad before he/she can skip ad. Duration in seconds.
  final int defaultCanSkipAfter;

  /// Ad that should be displayed when the app is fetching from Ad Server.
  final Ad defaultAd;

  /// Whether default is enabled or not.
  final bool defaultAdEnabled;

  /// Base URL that is used for constructing Creative download URL.
  /// e.g: https://s3.awscloud.com/stag/creative/
  final String creativeBaseUrl;

  AdConfig({
    @required this.timeBlockToSecs,
    @required this.defaultCanSkipAfter,
    @required this.defaultAd,
    @required this.defaultAdEnabled,
    @required this.creativeBaseUrl,
  });
}

abstract class AdConfigProvider {
  AdConfig get adConfig;
  Stream<AdConfig> get adConfig$;
}
