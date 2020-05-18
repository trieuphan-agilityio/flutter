import 'package:flutter/foundation.dart';

/// ===================================================================
/// Aspect
/// ===================================================================

/// An aspect of the game world that can be listened to.
///
/// This is like a [ChangeNotifier], but it uses the concept of dirtiness.
///
/// This is a very game-centric approach, gear toward state that is heavily
/// interdependent (like in a game simulation) and that is changed all the time
/// (again, like in a game simulation). You probably do not need this
/// for a regular app. Use regular [ChangeNotifier], which is cleaner.
abstract class Aspect extends ChangeNotifier {
  bool _dirty = false;

  /// The aspect has changed since the last time [update] was called.
  bool get isDirty => _dirty;

  /// Mark the aspect dirty (changed).
  ///
  /// This can be called from outside the class (unlike [notifyListener], which
  /// is [protected]). Also unlike [notifyListener], this does not immediately
  /// notify. Listener will be called on next call of [update].
  void markDirty() {
    _dirty = true;
  }

  /// Called every "logical frame" (physical update in game parlance),to update
  /// the state of this aspect.
  @mustCallSuper
  void update() {
    if (_dirty) {
      notifyListeners();
      _dirty = false;
    }
  }
}

abstract class AspectContainer<T extends Aspect> extends Aspect {
  final List<T> children;
  AspectContainer() : children = [];
  bool _guardRemove = false;
  List<T> _queuedRemoval;

  // Whether or not this container gets marked dirty when a child is dirty.
  bool get inheritsDirt => false;

  void update() {
    // guard against changing the list while iterating is dirty.
    _guardRemove = true;
    for (final T child in children) {
      if (inheritsDirt && child.isDirty) {
        markDirty();
      }
      child.update();
    }
    _guardRemove = false;

    // Process any queued removals.
    if (_queuedRemoval != null) {
      _queuedRemoval.forEach(children.remove);
      _queuedRemoval = null;
      markDirty();
    }

    super.update();
  }

  void addAspects(Iterable<T> aspects) => aspects.forEach(addAspect);
  void clearAspects() {
    _queuedRemoval?.clear();
    children.clear();
  }

  void setAspects(Iterable<T> aspects) {
    clearAspects();
    addAspects(aspects);
  }

  void addAspect(T aspect) {
    children.add(aspect);
    if (aspect is ChildAspect) {
      (aspect as ChildAspect).parent = this;
    }
    markDirty();
  }

  void removeAspect(T aspect) {
    // If we attempt to remove an aspect while the list is being iterated,
    // queue the removal and process it on our next update.
    if (_guardRemove) {
      _queuedRemoval ??= [];
      _queuedRemoval.add(aspect);
      return;
    }
    children.remove(aspect);
    markDirty();
  }
}

mixin ChildAspect {
  Aspect parent;

  T get<T>() {
    Aspect looking = parent;
    while (looking != null) {
      if (looking is T) {
        return looking as T;
      }
      looking = looking is ChildAspect ? (looking as ChildAspect).parent : null;
    }
    return null;
  }
}
