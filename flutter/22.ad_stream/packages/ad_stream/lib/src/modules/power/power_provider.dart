enum PowerStatus { WEAK, STRONG }

abstract class PowerProvider {
  Stream<PowerStatus> get status;
}
