// import 'package:inject/inject.dart';
// import 'package:mex_bloc/src/auth/service.dart';
// import 'package:mex_bloc/src/login/service.dart';
// import 'package:mex_bloc/src/user/service.dart';

// import 'mex_bloc.inject.dart' as g;

// @Injector([UserService, AuthService, LoginService])
// abstract class AppServices
//     implements UserServiceLocator, AuthServiceLocator, LoginServiceLocator {
//   static Future<AppServices> create(
//     UserService userModule,
//     AuthService authModule,
//     LoginService loginModule,
//   ) async {
//     var services = await g.Mex$Injector.create(
//       userModule,
//       authModule,
//       loginModule,
//     );

//     userService = services;
//     authService = services;
//     return services;
//   }
// }
