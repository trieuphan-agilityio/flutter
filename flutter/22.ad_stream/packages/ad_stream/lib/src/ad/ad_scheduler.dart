import 'package:ad_stream/src/ad/ad_repository.dart';
import 'package:ad_stream/src/ad/targeting_value.dart';

import 'ad.dart';

abstract class AdScheduler {
  AdRepository get adRepository;

  Stream<List<Ad>> get _ads;

  TargetingValues _targetingValues;

  /// Push ad to creative stream
  _getAds() {
    final ads = adRepository.getReadyList(_targetingValues);
  }

  Ad getAdForDisplay();

  setGender(PassengerGender gender);
  setAgeRange(PassengerAgeRange ageRange);
  setKeywords(Keywords keywords);
  setArea(Area area);
  setLatLng(LatLng latLng);
  setCollectTargetValuesInterval(Duration duration);
}

class AdSchedulerImpl implements AdScheduler {
  final AdRepository adRepository;

  @override
  TargetingValues _targetingValues;

  AdSchedulerImpl(this.adRepository);

  @override
  Stream<List<Ad>> get _ads => throw UnimplementedError();

  @override
  _getAds() {
    // TODO: implement _getAds
    throw UnimplementedError();
  }

  @override
  Ad getAdForDisplay() {
    // TODO: implement getAdForDisplay
    throw UnimplementedError();
  }

  @override
  setAgeRange(PassengerAgeRange ageRange) {
    // TODO: implement setAgeRange
    throw UnimplementedError();
  }

  @override
  setArea(Area area) {
    // TODO: implement setArea
    throw UnimplementedError();
  }

  @override
  setCollectTargetValuesInterval(Duration duration) {
    // TODO: implement setCollectTargetValuesInterval
    throw UnimplementedError();
  }

  @override
  setGender(PassengerGender gender) {
    // TODO: implement setGender
    throw UnimplementedError();
  }

  @override
  setKeywords(Keywords keywords) {
    // TODO: implement setKeywords
    throw UnimplementedError();
  }

  @override
  setLatLng(LatLng latLng) {
    // TODO: implement setLatLng
    throw UnimplementedError();
  }
}
