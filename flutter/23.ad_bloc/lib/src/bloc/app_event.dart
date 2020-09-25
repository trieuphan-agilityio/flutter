import 'package:ad_bloc/base.dart';
import 'package:ad_bloc/model.dart';

class AppEvent extends Equatable {
  const AppEvent();

  @override
  List<Object> get props => [];
}

class Initialized extends AppEvent {
  const Initialized();
}

class Started extends AppEvent {
  const Started();
}

class Stopped extends AppEvent {
  const Stopped();
}

/// Indicates that the ads that have creatives were downloaded
/// have changed.
class ReadyAdsChanged extends AppEvent {
  final Iterable<Ad> ads;

  const ReadyAdsChanged(this.ads);

  @override
  List<Object> get props => [ads];
}

class Permitted extends AppEvent {
  final bool isAllowed;

  const Permitted(this.isAllowed);

  @override
  List<Object> get props => [isAllowed];

  @override
  String toString() {
    return 'Permitted{isAllowed: $isAllowed}';
  }
}

class PowerSupplied extends AppEvent {
  final bool isStrong;

  const PowerSupplied(this.isStrong);

  @override
  List<Object> get props => [isStrong];

  @override
  String toString() {
    return 'PowerSupplied{isStrong: $isStrong}';
  }
}

class Located extends AppEvent {
  final LatLng latLng;

  const Located(this.latLng);

  @override
  List<Object> get props => [latLng];

  @override
  String toString() {
    return 'Located{latLng: $latLng}';
  }
}

class Moved extends AppEvent {
  final bool isMoving;

  const Moved(this.isMoving);

  @override
  List<Object> get props => [isMoving];

  @override
  String toString() {
    return 'Moved{isMoving: $isMoving}';
  }
}

class PhotoCaptured extends AppEvent {
  final Photo photo;

  const PhotoCaptured(this.photo);

  @override
  List<Object> get props => [photo];
}

class GendersDetected extends AppEvent {
  final Iterable<PassengerGender> genders;

  const GendersDetected(this.genders);

  @override
  List<Object> get props => [genders];
}

class AgeRangesDetected extends AppEvent {
  final Iterable<PassengerAgeRange> ageRanges;

  const AgeRangesDetected(this.ageRanges);

  @override
  List<Object> get props => [ageRanges];
}

class KeywordsExtracted extends AppEvent {
  final Iterable<Keyword> keywords;

  const KeywordsExtracted(this.keywords);

  @override
  List<Object> get props => [keywords];
}

class DetectedNoFace extends AppEvent {
  const DetectedNoFace();
}

class FacesDetected extends AppEvent {
  final Iterable<Face> faces;

  const FacesDetected(this.faces);

  @override
  List<Object> get props => [faces];

  @override
  String toString() {
    return 'FacesDetected{faces: $faces}';
  }
}

class TripStarted extends AppEvent {
  const TripStarted();
}

class TripEnded extends AppEvent {
  const TripEnded();
}
