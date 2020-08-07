import 'package:ad_stream/base.dart';
import 'package:ad_stream/src/modules/di/di.dart';

import 'service_manager.dart';

class ServiceManagerContainer extends StatelessWidget {
  final Widget child;

  const ServiceManagerContainer({Key key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _ServiceManagerLifecycle(
      serviceManager: DI.of(context).serviceManager,
      child: child,
    );
  }
}

class _ServiceManagerLifecycle extends StatefulWidget {
  final ServiceManager serviceManager;
  final Widget child;

  const _ServiceManagerLifecycle({Key key, this.child, this.serviceManager})
      : super(key: key);

  @override
  __ServiceManagerLifecycleState createState() =>
      __ServiceManagerLifecycleState();
}

class __ServiceManagerLifecycleState extends State<_ServiceManagerLifecycle> {
  @override
  void initState() {
    super.initState();
    widget.serviceManager.start();
  }

  @override
  void dispose() {
    widget.serviceManager.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
