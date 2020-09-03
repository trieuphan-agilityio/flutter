import 'package:ad_stream/di.dart';
import 'package:ad_stream/src/modules/storage/pref_storage.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockStorageModule extends StorageModule {
  @override
  PrefStoreReading prefStoreReading(PrefStoreWriting prefStore) {
    return prefStore;
  }

  @override
  PrefStoreWriting prefStoreWriting(SharedPreferences sharedPreferences) {
    return MockPrefStoreWriting();
  }

  @override
  Future<SharedPreferences> sharedPreferences() async {
    return MockSharedPreference();
  }
}

class MockSharedPreference extends Mock implements SharedPreferences {}

class MockPrefStoreWriting extends Mock implements PrefStoreWriting {}
