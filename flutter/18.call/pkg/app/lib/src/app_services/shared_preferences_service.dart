import 'package:app/core.dart';

abstract class SharedPreferencesServiceLocator {
  SharedPreferences get prefs;
}

class SharedPreferencesService {
  SharedPreferences _prefs;

  init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  SharedPreferences prefs() => _prefs;
}
