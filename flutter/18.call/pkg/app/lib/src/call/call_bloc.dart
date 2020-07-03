import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

class CallState extends Equatable {
  @override
  List<Object> get props => [];
}

class NoCall extends CallState {}

class Waiting extends CallState {}

class Calling extends CallState {
  // indicates time in seconds on the call
  final int durationSecs;

  // indicates maximum duration in seconds that the call can take
  final int limitSecs;

  Calling(this.durationSecs, this.limitSecs);

  bool get isCallEnded => durationSecs > limitSecs;

  List<Object> get props => [durationSecs, limitSecs];
}

abstract class CallEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class CallDialing extends CallEvent {}

class CallStarted extends CallEvent {}

class CallTimerTicked extends CallEvent {
  final int duration;
  CallTimerTicked(this.duration);

  @override
  List<Object> get props => [duration];
}

class CallEnded extends CallEvent {}

class CallBloc extends Bloc<CallEvent, CallState> {
  Timer _timer;

  CallBloc() : super(NoCall());

  @override
  Stream<CallState> mapEventToState(CallEvent event) async* {
    if (event is CallDialing) {
      yield Waiting();
    } else if (event is CallStarted) {
      yield Calling(0, 900);
      _timer?.cancel();
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        add(CallTimerTicked(timer.tick));
      });
    } else if (event is CallTimerTicked) {
      yield Calling(event.duration, (state as Calling).limitSecs);
    }
  }
}
