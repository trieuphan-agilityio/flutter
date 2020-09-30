import 'package:ad_bloc/base.dart';
import 'package:ad_bloc/model.dart';

@immutable
class AppState extends Equatable {
  factory AppState.init() {
    return _init ??= const AppState(
      readyAds: const [],
      newAds: const [],
      isPermitted: false,
      isPowerStrong: false,
      isStarted: false,
      isTrackingLocation: false,
      gpsOptions: const GpsOptions(accuracy: GpsAccuracy.high),
      latLng: null,
      isFetchingAds: false,
      isMoving: false,
      capturedPhoto: null,
      genders: const [],
      ageRanges: const [],
      keywords: const [],
      faces: const [],
      trip: const Trip.offTrip(),
      isDetectingFaces: false,
    );
  }
  static AppState _init;

  final Iterable<Ad> readyAds;

  final Iterable<Ad> newAds;

  final bool isPermitted;
  bool get isNotPermitted => !isPermitted;

  final bool isPowerStrong;
  bool get isPowerWeak => !isPowerStrong;

  final bool isStarted;
  bool get isStopped => !isStarted;

  final GpsOptions gpsOptions;

  final LatLng latLng;

  final bool isTrackingLocation;

  final bool isFetchingAds;

  final bool isMoving;
  bool get isNotMoving => !isMoving;

  /// Captured photo that is used for detecting passenger info
  final Photo capturedPhoto;

  /// Genders of Passengers
  final Iterable<PassengerGender> genders;

  /// Age Range of Passengers
  final Iterable<PassengerAgeRange> ageRanges;

  /// Keywords that extracted from the conversation of passengers when on trip.
  final Iterable<Keyword> keywords;

  /// All faces that have been detected on a trip
  final Iterable<Face> faces;

  final Trip trip;

  final bool isDetectingFaces;

  const AppState({
    @required this.readyAds,
    @required this.newAds,
    @required this.isPermitted,
    @required this.isPowerStrong,
    @required this.isStarted,
    @required this.gpsOptions,
    @required this.latLng,
    @required this.isTrackingLocation,
    @required this.isFetchingAds,
    @required this.isMoving,
    @required this.capturedPhoto,
    @required this.genders,
    @required this.ageRanges,
    @required this.keywords,
    @required this.faces,
    @required this.trip,
    @required this.isDetectingFaces,
  })  : assert(readyAds != null),
        assert(newAds != null),
        assert(gpsOptions != null),
        assert(genders != null),
        assert(ageRanges != null),
        assert(keywords != null),
        assert(faces != null),
        assert(trip != null);

  AppState copyWith({
    Iterable<Ad> readyAds,
    Iterable<Ad> newAds,
    bool isPermissionAllowed,
    bool isPowerStrong,
    bool isStarted,
    GpsOptions gpsOptions,
    LatLng latLng,
    bool isTrackingLocation,
    bool isFetchingAds,
    bool isMoving,
    Photo capturedPhoto,
    Iterable<PassengerGender> genders,
    Iterable<PassengerAgeRange> ageRanges,
    Iterable<Keyword> keywords,
    Iterable<Face> faces,
    Trip trip,
    bool isDetectingFaces,
  }) {
    return AppState(
      readyAds: readyAds ?? this.readyAds,
      newAds: newAds ?? this.newAds,
      isPermitted: isPermissionAllowed ?? this.isPermitted,
      isPowerStrong: isPowerStrong ?? this.isPowerStrong,
      isStarted: isStarted ?? this.isStarted,
      gpsOptions: gpsOptions ?? this.gpsOptions,
      latLng: latLng ?? this.latLng,
      isTrackingLocation: isTrackingLocation ?? this.isTrackingLocation,
      isFetchingAds: isFetchingAds ?? this.isFetchingAds,
      isMoving: isMoving ?? this.isMoving,
      capturedPhoto: capturedPhoto ?? this.capturedPhoto,
      genders: genders ?? this.genders,
      ageRanges: ageRanges ?? this.ageRanges,
      keywords: keywords ?? this.keywords,
      faces: faces ?? this.faces,
      trip: trip ?? this.trip,
      isDetectingFaces: isDetectingFaces ?? this.isDetectingFaces,
    );
  }

  @override
  List<Object> get props => [
        readyAds,
        newAds,
        isPermitted,
        isPowerStrong,
        isStarted,
        gpsOptions,
        latLng,
        isTrackingLocation,
        isFetchingAds,
        isMoving,
        capturedPhoto,
        genders,
        ageRanges,
        keywords,
        faces,
        trip,
        isDetectingFaces,
      ];

  @override
  String toString() {
    return 'Ad{readyAds: $readyAds'
        ', newAds: $newAds'
        ', isPermitted: $isPermitted'
        ', isPowerStrong: $isPowerStrong'
        ', isStarted: $isStarted'
        ', gpsOptions: $gpsOptions'
        ', latLng: $latLng'
        ', isTrackingLocation: $isTrackingLocation'
        ', isFetchingAds: $isFetchingAds'
        ', isMoving: $isMoving'
        ', genders: $genders'
        ', ageRanges: $ageRanges'
        ', keywords: $keywords'
        ', faces: $faces'
        ', trip: $trip'
        ', isDetectingFaces: $isDetectingFaces}';
  }
}
