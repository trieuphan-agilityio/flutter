import 'package:equatable/equatable.dart';

abstract class TimerState extends Equatable {
  final int duration;

  const TimerState(this.duration);

  @override
  List<Object> get props => [duration];
}

/// Ready -- ready to start counting down from the specified duration.
class Ready extends TimerState {
  const Ready(int duration) : super(duration);

  @override
  String toString() => 'Ready { duration: $duration }';
}

/// Paused -- paused at some remaining duration.
class Paused extends TimerState {
  const Paused(int duration) : super(duration);

  @override
  String toString() => 'Paused { duration: $duration }';
}

/// Running -- actively counting down from the specified duration.
class Running extends TimerState {
  const Running(int duration) : super(duration);

  @override
  String toString() => 'Running { duration: $duration }';
}

/// Finished -- completed with a remaining duration of 0.
class Finished extends TimerState {
  const Finished() : super(0);
}
