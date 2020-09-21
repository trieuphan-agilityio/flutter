import 'package:ad_bloc/base.dart';
import 'package:ad_bloc/model.dart';

class AppEvent extends Equatable {
  const AppEvent();

  @override
  List<Object> get props => [];
}

/// Indicates that the ads that have creatives were downloaded
/// have changed.
class ReadyAdsChanged extends AppEvent {
  final Iterable<Ad> ads;

  const ReadyAdsChanged(this.ads);

  @override
  List<Object> get props => [ads];
}

/// Indicates that the ads that have just fetched from Ad Server
/// have changed.
class NewAdsChanged extends AppEvent {
  final Iterable<Ad> ads;

  const NewAdsChanged(this.ads);

  @override
  List<Object> get props => [ads];
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

class Disposed extends AppEvent {
  const Disposed();
}

class FetchedAds extends AppEvent {}

class Permitted extends AppEvent {
  final bool isAllowed;

  const Permitted(this.isAllowed);

  @override
  List<Object> get props => [isAllowed];
}

class PowerSupplied extends AppEvent {
  final bool isStrong;

  const PowerSupplied(this.isStrong);

  @override
  List<Object> get props => [isStrong];
}

class Located extends AppEvent {
  final LatLng latLng;

  const Located(this.latLng);

  @override
  List<Object> get props => [latLng];
}

class Moved extends AppEvent {
  final bool isMoving;

  Moved(this.isMoving);

  @override
  List<Object> get props => [isMoving];
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

class FacesDetected extends AppEvent {
  final Iterable<Face> faces;

  FacesDetected(this.faces);

  @override
  List<Object> get props => [faces];
}

class TripChanged extends AppEvent {
  final Trip trip;

  const TripChanged(this.trip);

  @override
  List<Object> get props => [trip];
}
