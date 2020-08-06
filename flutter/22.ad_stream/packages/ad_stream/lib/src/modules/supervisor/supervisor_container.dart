import 'package:ad_stream/base.dart';
import 'package:ad_stream/src/modules/di/di.dart';

import 'supervisor.dart';

class SupervisorContainer extends StatelessWidget {
  final Widget child;

  const SupervisorContainer({Key key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _SupervisorLifecycle(
      supervisor: DI.of(context).supervisor,
      child: child,
    );
  }
}

class _SupervisorLifecycle extends StatefulWidget {
  final Supervisor supervisor;
  final Widget child;

  const _SupervisorLifecycle({Key key, this.child, this.supervisor})
      : super(key: key);

  @override
  __SupervisorLifecycleState createState() => __SupervisorLifecycleState();
}

class __SupervisorLifecycleState extends State<_SupervisorLifecycle> {
  @override
  void initState() {
    super.initState();
    widget.supervisor.start();
  }

  @override
  void dispose() {
    widget.supervisor.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
