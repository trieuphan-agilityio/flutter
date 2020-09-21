import 'package:ad_bloc/base.dart';
import 'package:bloc/bloc.dart';

class SimpleBlocObserver extends BlocObserver {
  @override
  void onEvent(Bloc bloc, Object event) {
    Log.debug(event);
    super.onEvent(bloc, event);
  }
}
