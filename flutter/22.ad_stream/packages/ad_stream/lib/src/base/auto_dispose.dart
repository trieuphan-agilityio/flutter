import 'dart:async';

import 'package:meta/meta.dart';

/// Provides functionality to simplify listening to streams.
///
/// See also:
/// * [AutoDisposeControllerMixin] which integrates this functionality
///   with [DisposableController] objects.
/// * [AutoDisposeMixin], which integrates this functionality with [State]
///   objects.
class Disposer {
  final List<StreamSubscription> _subscriptions = [];

  /// Track a stream subscription to be automatically cancelled on dispose.
  void autoDispose(StreamSubscription subscription) {
    if (subscription == null) return;
    _subscriptions.add(subscription);
  }

  /// Cancel all stream subscriptions.
  void cancel() {
    for (StreamSubscription subscription in _subscriptions) {
      subscription.cancel();
    }
    _subscriptions.clear();
  }
}

/// Base class for controllers that need to manage their lifecycle.
abstract class DisposableController {
  @mustCallSuper
  void dispose() {}
}

/// Mixin to simplifying managing the lifetime of listeners used by a
/// [DisposableController].
///
/// This mixin works by delegating to a [Disposer]. It implements all of
/// [Disposer]'s interface.
mixin AutoDisposeControllerMixin on DisposableController implements Disposer {
  final Disposer _delegate = Disposer();

  @override
  void dispose() {
    cancel();
    super.dispose();
  }

  @override
  void autoDispose(StreamSubscription subscription) {
    _delegate.autoDispose(subscription);
  }

  @override
  void cancel() {
    _delegate.cancel();
  }
}
