import 'package:ad_stream/base.dart';
import 'package:ad_stream/src/modules/on_trip/trip_state.dart';
import 'package:bloc/bloc.dart';

import 'app_event.dart';
import 'app_state.dart';

class AdStreamBloc extends Bloc<AppEvent, AppState> {
  AdStreamBloc(AppState initialState) : super(initialState);

  @override
  Stream<AppState> mapEventToState(AppEvent evt) async* {
    if (evt is Permitted) {
      yield state.copyWith(isPermitted: evt.isAllowed);
      yield* _manageService();
    }

    if (evt is PowerChanged) {
      yield state.copyWith(isPowerStrong: evt.isStrong);
    }

    if (evt is Located) {
      yield state.copyWith(latLng: evt.latLng);
    }

    if (evt is Moved) {
      yield state.copyWith(isMoving: evt.isMoving);
      yield* _detectTrip();
      yield* _detectFaces();
    }

    if (evt is GendersDetected) {
      yield state.copyWith(genders: evt.genders);
    }

    if (evt is AgeRangesDetected)
      yield state.copyWith(ageRanges: evt.ageRanges);

    if (evt is KeywordsExtracted) {
      yield state.copyWith(keywords: evt.keywords);
    }

    if (evt is FacesDetected) {
      yield state.copyWith(faces: evt.faces);
      yield* _detectTrip();
      yield* _detectFaces();
    }
  }

  Stream<AppState> _manageService() async* {
    if (state.isPermitted && state.isPowerStrong) {
      // services should start
      yield state.copyWith(
        isTrackingLocation: true,
      );
    }

    if (state.isNotPermitted || state.isPowerWeak) {
      // services should stop
      yield state.copyWith(
        isTrackingLocation: false,
      );
    }
  }

  Stream<AppState> _detectTrip() async* {
    if (state.isMoving && state.faces.isNotEmpty) {
      yield state.copyWith(
        tripState: TripState.onTrip(state.faces),
      );
    }

    if (state.isNotMoving && state.faces.isEmpty) {
      yield state.copyWith(
        tripState: TripState.offTrip(),
      );
    }
  }

  Stream<AppState> _detectFaces() async* {
    if (state.tripState.isOnTrip) {
      yield state.copyWith(isDetectingFaces: false);
    }

    if (state.isNotMoving) {
      yield state.copyWith(isDetectingFaces: false);
    }

    yield state.copyWith(isDetectingFaces: true);
  }
}
