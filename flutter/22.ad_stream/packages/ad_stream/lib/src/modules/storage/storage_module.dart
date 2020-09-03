import 'package:ad_stream/base.dart';
import 'package:ad_stream/src/modules/storage/pref_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Declare public interface that an StorageModule should expose
abstract class StorageModuleLocator {
  @provide
  PrefStoreReading get prefStoreReading;

  @provide
  PrefStoreWriting get prefStoreWriting;
}

/// A source of dependency provider for the injector.
/// It contains Storage related services, such as Battery.
@module
class StorageModule {
  @provide
  @singleton
  PrefStoreReading prefStoreReading(PrefStoreWriting prefStore) {
    return prefStore;
  }

  @provide
  @singleton
  PrefStoreWriting prefStoreWriting(SharedPreferences sharedPreferences) {
    return PrefStoreImpl(sharedPreferences);
  }

  /// [SharedPreferences] instance would not be shared, instead, you can access
  /// via high abstraction [PrefStoreImpl].
  @provide
  @singleton
  @asynchronous
  Future<SharedPreferences> sharedPreferences() async {
    return SharedPreferences.getInstance();
  }
}
