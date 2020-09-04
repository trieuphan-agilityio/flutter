import 'package:meta/meta.dart';

class MicConfig {
  /// Time in seconds indicates how frequently [MicController] records the
  /// conversation of passenger on the trip.
  final int recordInterval;

  MicConfig({@required this.recordInterval});
}

abstract class MicConfigProvider {
  MicConfig get micConfig;
  Stream<MicConfig> get micConfig$;
}
