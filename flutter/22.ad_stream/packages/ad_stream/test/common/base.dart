import 'package:ad_stream/base.dart';

final Future<Config> configFuture = ConfigFactoryImpl().createConfig();

const kPermissionChannel = 'flutter.baseflow.com/permissions/methods';
