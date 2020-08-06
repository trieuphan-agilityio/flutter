import 'package:ad_stream/base.dart';
import 'package:ad_stream/src/modules/di/di.dart';

import 'service_manager.dart';

class SupervisorContainer extends StatelessWidget {
  final Widget child;

  const SupervisorContainer({Key key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _ServiceManagerLifecycle(
      supervisor: DI.of(context).serviceManager,
      child: child,
    );
  }
}

class _ServiceManagerLifecycle extends StatefulWidget {
  final ServiceManager supervisor;
  final Widget child;

  const _ServiceManagerLifecycle({Key key, this.child, this.supervisor})
      : super(key: key);

  @override
  __ServiceManagerLifecycleState createState() =>
      __ServiceManagerLifecycleState();
}

class __ServiceManagerLifecycleState extends State<_ServiceManagerLifecycle> {
  @override
  void initState() {
    super.initState();
    widget.supervisor.init();
  }

  @override
  void dispose() {
    widget.supervisor.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
