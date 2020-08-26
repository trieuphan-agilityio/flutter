import 'package:ad_stream/base.dart';
import 'package:ad_stream/src/modules/di/di.dart';

import 'service_manager.dart';

class ServiceManagerContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _ServiceManagerLifecycle(
      serviceManager: DI.of(context).serviceManager,
    );
  }
}

class _ServiceManagerLifecycle extends StatefulWidget {
  final ServiceManager serviceManager;

  const _ServiceManagerLifecycle({Key key, this.serviceManager})
      : super(key: key);

  @override
  __ServiceManagerLifecycleState createState() =>
      __ServiceManagerLifecycleState();
}

class __ServiceManagerLifecycleState extends State<_ServiceManagerLifecycle> {
  @override
  void initState() {
    super.initState();
    widget.serviceManager.init();
  }

  @override
  void dispose() {
    widget.serviceManager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.shrink();
  }
}
