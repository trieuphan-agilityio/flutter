import 'package:ad_stream/ad_stream.dart';
import 'package:ad_stream_app/src/features/ad_displaying/ad_presenter.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

/// To pass compiler for now, it supposes to use inject.dart package.
class DI {
  static DI of(BuildContext context) {
    return Provider.of<DI>(context);
  }

  AdScheduler get adScheduler => AdSchedulerImpl(creativeRepository);

  AdRepository get creativeRepository => AdRepositoryImpl();

  AdPresentable get adPresenter {
    return AdPresenter(adScheduler);
  }
}
