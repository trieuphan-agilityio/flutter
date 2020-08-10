import 'package:ad_stream/models.dart';

abstract class CreativeStorage {
  download(Creative creative);
}

class CreativeStorageImpl implements CreativeStorage {
  CreativeStorageImpl();

  download(Creative creative) {}
}
