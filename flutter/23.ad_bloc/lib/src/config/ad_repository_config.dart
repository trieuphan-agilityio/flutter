import 'package:meta/meta.dart';

class AdRepositoryConfig {
  /// Time in seconds must elapse before [AdRepository] repeatedly
  /// refresh its content.
  final int refreshInterval;

  AdRepositoryConfig({@required this.refreshInterval});
}

abstract class AdRepositoryConfigProvider {
  AdRepositoryConfig get adRepositoryConfig;
  Stream<AdRepositoryConfig> get adRepositoryConfig$;
}
