import 'package:ad_bloc/base.dart';
import 'package:permission_handler/permission_handler.dart';

import 'debug_button.dart';

/// Constructs a [ListView] containing [PermissionWidget] for each available
/// permission.
class PermissionList extends StatelessWidget {
  final List<Permission> permissions;

  const PermissionList({Key key, @required this.permissions}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Use WillPopScope to prevent the page from being popped by the system.
    return WillPopScope(
      key: const Key('permission_list'),
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Permission'),
          leading: null,
          automaticallyImplyLeading: false,
        ),
        body: Center(
          child: ListView(
            children: permissions
                .map((permission) => PermissionWidget(permission))
                .toList(),
          ),
        ),
        floatingActionButton: DebugButton(),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }
}

/// Permission widget which displays a permission and allows users to request
/// the permissions.
class PermissionWidget extends StatefulWidget {
  /// Constructs a [PermissionWidget] for the supplied [Permission].
  const PermissionWidget(this._permission);

  final Permission _permission;

  @override
  _PermissionState createState() => _PermissionState(_permission);
}

class _PermissionState extends State<PermissionWidget> {
  _PermissionState(this._permission);

  final Permission _permission;
  PermissionStatus _permissionStatus = PermissionStatus.undetermined;

  @override
  void initState() {
    super.initState();
    _listenForPermissionStatus();
  }

  void _listenForPermissionStatus() async {
    final status = await _permission.status;
    setState(() => _permissionStatus = status);
  }

  Color getPermissionColor() {
    switch (_permissionStatus) {
      case PermissionStatus.denied:
        return SolarizedColor.red;
      case PermissionStatus.granted:
        return SolarizedColor.green;
      default:
        return SolarizedColor.base1;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        _permission.toString(),
        style: Theme.of(context).textTheme.bodyText1,
      ),
      subtitle: Text(
        _permissionStatus.toString(),
        style: TextStyle(color: getPermissionColor()),
      ),
      trailing: IconButton(
          icon: const Icon(
            Icons.info,
            color: Colors.white,
          ),
          onPressed: () {
            checkServiceStatus(context, _permission);
          }),
      onTap: () {
        requestPermission(_permission);
      },
    );
  }

  void checkServiceStatus(BuildContext context, Permission permission) async {
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text((await permission.status).toString()),
    ));
  }

  void requestPermission(Permission permission) async {
    final status = await permission.request();
    setState(() => _permissionStatus = status);
  }
}
