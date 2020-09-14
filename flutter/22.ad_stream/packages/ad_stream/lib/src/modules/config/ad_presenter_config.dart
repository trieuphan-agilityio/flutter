class AdPresenterConfig {
  AdPresenterConfig();
}

abstract class AdPresenterConfigProvider {
  AdPresenterConfig get adPresenterConfig;
  Stream<AdPresenterConfig> get adPresenterConfig$;
}
