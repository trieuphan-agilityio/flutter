import 'package:ad_bloc/base.dart';
import 'package:flutter/widgets.dart';

abstract class DebuggerFactory {
  static DebuggerFactory of(BuildContext context) {
    return Provider.of<DebuggerFactory>(context);
  }

  PermissionDebugger get permissionDebugger;
  PowerDebugger get powerDebugger;

  driverOnboarded();
}

class PermissionDebugger extends Equatable {
  final bool isAllowed;

  PermissionDebugger(this.isAllowed);

  @override
  List<Object> get props => [isAllowed];
}

class PowerDebugger extends Equatable {
  final bool isStrong;

  PowerDebugger(this.isStrong);

  @override
  List<Object> get props => [isStrong];
}

class DebuggerFactoryImpl implements DebuggerFactory {
  PermissionDebugger get permissionDebugger => _permissionDebugger;
  PermissionDebugger _permissionDebugger;

  enablePermissionDebugger(bool isAllowed) {
    _permissionDebugger = PermissionDebugger(isAllowed);
  }

  disablePermissionDebugger() {
    _permissionDebugger = null;
  }

  PowerDebugger get powerDebugger => _powerDebugger;
  PowerDebugger _powerDebugger;

  enablePowerDebugger(bool isStrong) {
    _powerDebugger = PowerDebugger(isStrong);
  }

  disablePowerDebugger() {
    _powerDebugger = null;
  }

  driverOnboarded() {
    enablePermissionDebugger(true);
    enablePowerDebugger(true);
  }
}
