import 'package:app/core.dart';
import 'package:app/src/stores/app_settings/app_settings_store.dart';

abstract class SettingsServiceLocator {
  SharedPreferences get prefs;
  AppSettingsStore get appSettingsStore;
}

class SettingsService {
  SharedPreferences _prefs;

  init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  SharedPreferences prefs() => _prefs;

  AppSettingsStore appSettingsStore(SharedPreferences prefs) {
    return AppSettingsStore(prefs);
  }
}
