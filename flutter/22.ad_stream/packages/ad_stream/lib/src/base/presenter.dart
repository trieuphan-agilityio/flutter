/// The base class of all Presenter.
///
/// A Presenter translates business models into values the corresponding
/// View can consume and display.
///
/// It also maps UI events to business logic method, invoked to its listener.
abstract class Presentable<ViewType> {
  /// View component is attached to this presenter.
  /// It could be nullable when the View is disposed by View engine.
  ViewType get view;

  /// Attach a View to a Presenter.
  /// It usually happens when View engine starts rendering the View.
  attach(ViewType newView);

  /// Detach a View from a Presenter.
  /// It usually happens when View engine re-new or kill the View.
  detach();
}

/// A mixin that help concrete presenter satisfies Presenter interface.
mixin PresenterMixin<ViewType> {
  ViewType _view;
  ViewType get view => _view;

  attach(ViewType newView) => _view = newView;
  detach() => _view = null;
}
