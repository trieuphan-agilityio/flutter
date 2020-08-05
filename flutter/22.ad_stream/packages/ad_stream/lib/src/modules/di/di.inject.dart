import 'di.dart' as _i1;
import '../ad/ad_services.dart' as _i2;
import '../../base/config.dart' as _i3;
import '../ad/ad_repository.dart' as _i4;
import '../ad/ad_scheduler.dart' as _i5;
import '../../features/ad_displaying/ad_presenter.dart' as _i6;
import 'dart:async' as _i7;

class DI$Injector implements _i1.DI {
  DI$Injector._(this._adServices);

  final _i2.AdServices _adServices;

  _i3.ConfigFactory _singletonConfigFactory;

  _i4.AdRepository _singletonAdRepository;

  _i5.AdScheduler _singletonAdScheduler;

  _i6.AdPresentable _singletonAdPresentable;

  static _i7.Future<_i1.DI> create(_i2.AdServices adServices) async {
    final injector = DI$Injector._(adServices);

    return injector;
  }

  _i3.ConfigFactory _createConfigFactory() =>
      _singletonConfigFactory ??= _adServices.configFactory();
  _i6.AdPresentable _createAdPresentable() =>
      _singletonAdPresentable ??= _adServices.adPresenter(_createAdScheduler());
  _i5.AdScheduler _createAdScheduler() =>
      _singletonAdScheduler ??= _adServices.adScheduler(_createAdRepository());
  _i4.AdRepository _createAdRepository() =>
      _singletonAdRepository ??= _adServices.adRepository();
  @override
  _i3.ConfigFactory get configFactory => _createConfigFactory();
  @override
  _i6.AdPresentable get adPresenter => _createAdPresentable();
  @override
  _i5.AdScheduler get adScheduler => _createAdScheduler();
  @override
  _i4.AdRepository get adRepository => _createAdRepository();
}
