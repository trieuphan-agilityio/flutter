import 'package:app/core.dart';

abstract class AppSettingsStoreReading {
  String get myIdentity;
}

abstract class AppSettingsStoreWriting extends AppSettingsStoreReading {
  String get myIdentity;
  set myIdentity(String newValue);
}

const String _kMyIdentity = 'myIdentity';

class AppSettingsStore implements AppSettingsStoreWriting {
  final SharedPreferences prefs;

  AppSettingsStore({@required this.prefs});

  @override
  String get myIdentity => prefs.getString(_kMyIdentity) ?? "";

  @override
  set myIdentity(String newValue) => prefs.setString(_kMyIdentity, newValue);
}
