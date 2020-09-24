import 'package:ad_bloc/base.dart';
import 'package:ad_bloc/bloc.dart';
import 'package:bloc/bloc.dart';

class SimpleBlocObserver extends BlocObserver {
  @override
  void onEvent(Bloc bloc, Object event) {
    final blacklist = [
      Located,
      AdFinished,
    ];

    if (!blacklist.contains(event.runtimeType)) {
      Log.debug(event);
    }

    super.onEvent(bloc, event);
  }
}
