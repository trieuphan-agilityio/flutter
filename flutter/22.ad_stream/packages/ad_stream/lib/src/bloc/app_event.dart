import 'package:ad_stream/models.dart';
import 'package:ad_stream/src/modules/on_trip/face.dart';
import 'package:ad_stream/src/modules/on_trip/trip_state.dart';
import 'package:equatable/equatable.dart';

class AppEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class Permitted extends AppEvent {
  final bool isAllowed;

  Permitted(this.isAllowed);

  @override
  List<Object> get props => [isAllowed];
}

class PowerChanged extends AppEvent {
  final bool isStrong;

  PowerChanged(this.isStrong);

  @override
  List<Object> get props => [isStrong];
}

class Located extends AppEvent {
  final LatLng latLng;

  Located(this.latLng);

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

  GendersDetected(this.genders);

  @override
  List<Object> get props => [genders];
}

class AgeRangesDetected extends AppEvent {
  final Iterable<PassengerAgeRange> ageRanges;

  AgeRangesDetected(this.ageRanges);

  @override
  List<Object> get props => [ageRanges];
}

class KeywordsExtracted extends AppEvent {
  final Iterable<Keyword> keywords;

  KeywordsExtracted(this.keywords);

  @override
  List<Object> get props => [keywords];
}

class FacesDetected extends AppEvent {
  final Iterable<Face> faces;

  FacesDetected(this.faces);

  @override
  List<Object> get props => [faces];
}

class TripStateChanged extends AppEvent {
  final TripState tripState;

  TripStateChanged(this.tripState);

  @override
  List<Object> get props => [tripState];
}
