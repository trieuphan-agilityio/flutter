import 'package:ad_stream/models.dart';

abstract class AdDatabase {
  Future<Ad> saveCreative(Creative creative);

  Future<void> saveAds(List<Ad> ads);

  Future<List<Ad>> getAds();

  /// Remove ads, notice that Creative assets are still kept persisting on
  /// File Storage so that new up coming ads can reuse it.
  Future<void> removeAds(List<String> adIds);
}
