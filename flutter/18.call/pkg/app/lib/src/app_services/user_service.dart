import 'package:app/src/stores/user/user_store.dart';

abstract class UserServiceLocator {
  UserStoreReading get userStore;
}

class UserService {
  UserStoreReading userStore() => new UserStore();
}
