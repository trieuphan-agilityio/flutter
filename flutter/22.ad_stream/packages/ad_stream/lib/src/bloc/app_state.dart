import 'package:ad_stream/base.dart';
import 'package:ad_stream/models.dart';
import 'package:ad_stream/src/modules/on_trip/face.dart';
import 'package:ad_stream/src/modules/on_trip/trip_state.dart';
import 'package:equatable/equatable.dart';

@immutable
class AppState extends Equatable {
  factory AppState.init() {
    if (_init == null)
      _init = const AppState(
        ads: const [],
        isPermitted: false,
        isPowerStrong: false,
        latLng: null,
        isMoving: false,
        genders: const [],
        ageRanges: const [],
        keywords: const [],
        faces: const [],
        tripState: const TripState.offTrip(),
        faceId: null,
        isTrackingLocation: false,
        isDetectingFaces: false,
      );

    return _init;
  }

  static AppState _init;

  final Iterable<Ad> ads;

  final bool isPermitted;
  bool get isNotPermitted => !isPermitted;

  final bool isPowerStrong;
  bool get isPowerWeak => !isPowerStrong;

  final LatLng latLng;

  final bool isMoving;
  bool get isNotMoving => !isMoving;

  /// Genders of Passengers
  final Iterable<PassengerGender> genders;

  /// Age Range of Passengers
  final Iterable<PassengerAgeRange> ageRanges;

  /// Keywords that extracted from the conversation of passengers when on trip.
  final Iterable<Keyword> keywords;

  /// All faces that have been detected on a trip
  final Iterable<Face> faces;

  final TripState tripState;

  /// An identity that represents for passengers on a trip.
  /// On trip, the first Face Id will be used until the trip is end.
  /// There is no further face detection once Face Id is set.
  final Iterable<Face> faceId;

  final bool isTrackingLocation;

  final bool isDetectingFaces;

  const AppState({
    @required this.ads,
    @required this.isPermitted,
    @required this.isPowerStrong,
    @required this.latLng,
    @required this.isMoving,
    @required this.genders,
    @required this.ageRanges,
    @required this.keywords,
    @required this.faces,
    @required this.tripState,
    @required this.faceId,
    @required this.isTrackingLocation,
    @required this.isDetectingFaces,
  })  : assert(ads != null),
        assert(genders != null),
        assert(ageRanges != null),
        assert(keywords != null),
        assert(faces != null);

  AppState copyWith({
    Iterable<Ad> ads,
    bool isPermitted,
    bool isPowerStrong,
    LatLng latLng,
    bool isMoving,
    Iterable<PassengerGender> genders,
    Iterable<PassengerAgeRange> ageRanges,
    Iterable<Keyword> keywords,
    Iterable<Face> faces,
    TripState tripState,
    Face faceId,
    bool isTrackingLocation,
    bool isDetectingFaces,
  }) {
    return AppState(
      ads: ads ?? this.ads,
      isPermitted: isPermitted ?? this.isPermitted,
      isPowerStrong: isPowerStrong ?? this.isPowerStrong,
      latLng: latLng ?? this.latLng,
      isMoving: isMoving ?? this.isMoving,
      genders: genders ?? this.genders,
      ageRanges: ageRanges ?? this.ageRanges,
      keywords: keywords ?? this.keywords,
      faces: faces ?? this.faces,
      tripState: tripState ?? this.tripState,
      faceId: faceId ?? this.faceId,
      isTrackingLocation: isTrackingLocation ?? this.isTrackingLocation,
      isDetectingFaces: isDetectingFaces ?? this.isDetectingFaces,
    );
  }

  @override
  List<Object> get props => [
        isPermitted,
        isPowerStrong,
        latLng,
        isMoving,
        genders,
        ageRanges,
        keywords,
        faces,
        tripState,
        faceId,
        isTrackingLocation,
        isDetectingFaces,
      ];
}
