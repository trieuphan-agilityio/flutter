import 'dart:math';

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

/// ===================================================================
/// Splitters
/// ===================================================================

/// The horizontal/vertical layouts are represented by a pseudo string as
/// format below:
///
/// 0.20, 0.62, 0.18.
///
/// The fraction number represented for the width of a panel in the layout.
/// They are separated by ', '.
const MASK_SEPARATOR = ', ';

class _SplitterScope extends InheritedWidget {
  final ValueNotifier<String> layoutMask;
  final ValueNotifier<double> dividerPosition;

  const _SplitterScope({
    Key key,
    @required this.layoutMask,
    @required this.dividerPosition,
    Widget child,
  }) : super(key: key, child: child);

  @override
  bool updateShouldNotify(_SplitterScope oldWidget) {
    return true;
  }

  static _SplitterScope of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType();
}

abstract class Splitter extends StatefulWidget {
  final List<Widget> children;
  final String initialLayoutMask;
  final bool stackedVertical;

  const Splitter(
      {Key key,
      @required this.children,
      this.initialLayoutMask,
      @required this.stackedVertical})
      : super(key: key);
}

mixin SplitterStateMixin<T extends Splitter> on State<T> {
  String _lastLayoutMask;
  ValueNotifier<String> layoutMask;

  double _lastDividerPosition;
  ValueNotifier<double> dividerPosition;

  double estDividerPosition;

  @override
  void initState() {
    if (widget.initialLayoutMask == null) {
      // By default, the dock layout should fill panel equally.
      //
      // Below are few default layout mask if we don't specify
      // the initialLayoutMask:
      //
      // 2 panels: 0.5, 0.5
      // 3 panels: 0.33, 0.33, 0.33
      final numOfDocks = widget.children.length;
      _lastLayoutMask =
          List.filled(numOfDocks, 1 / numOfDocks).join(MASK_SEPARATOR);
    } else {
      _lastLayoutMask = widget.initialLayoutMask;
    }

    layoutMask = ValueNotifier<String>(_lastLayoutMask);
    layoutMask.addListener(_layoutMaskChanged);

    dividerPosition = ValueNotifier<double>(null);
    dividerPosition.addListener(_dividerPositionChanged);

    super.initState();
  }

  @override
  void dispose() {
    layoutMask.removeListener(_layoutMaskChanged);
    dividerPosition.removeListener(_dividerPositionChanged);
    super.dispose();
  }

  void _layoutMaskChanged() {
    setState(() {
      _lastLayoutMask = layoutMask.value;
    });
  }

  void _dividerPositionChanged() {
    setState(() {
      _lastDividerPosition = dividerPosition.value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _SplitterScope(
      layoutMask: layoutMask,
      dividerPosition: dividerPosition,
      child: LayoutBuilder(builder: (context, constraints) {
        return Stack(children: <Widget>[
          buildLayout(_buildContent(constraints)),
          if (_lastDividerPosition != null)
            _buildDividerShadow(_lastDividerPosition, constraints),
        ]);
      }),
    );
  }

  /// Leaving the decision to build a layout widget to the concrete class.
  /// This layout widget will contains all the dock widgets inside.
  Widget buildLayout(List<Widget> children);

  List<Widget> _buildContent(BoxConstraints constraints) {
    var children = <Widget>[];

    for (var i = 0; i < widget.children.length; i++) {
      final child = widget.children[i];
      final w = constraints.maxWidth;
      final h = constraints.maxHeight;

      final numOfSplitters = (widget.children.length / 2).ceil();
      final layoutSize = widget.stackedVertical ? h : w;
      final sizeQuota = layoutSize - numOfSplitters * Divider.FAT;

      // build the children with layout mask from the state
      final ratio = double.parse(_lastLayoutMask.split(MASK_SEPARATOR)[i]);
      final dockSize = ratio * sizeQuota;

      Widget dockedWidget;
      if (widget.stackedVertical) {
        dockedWidget = SizedBox(height: dockSize, child: child);
      } else {
        dockedWidget = SizedBox(width: dockSize, child: child);
      }
      children.add(dockedWidget);

      // don't add splitter bar at the edge.
      if (i == widget.children.length - 1) {
        break;
      }

      final splitterBar = Divider(
        index: i,
        stackedVertical: widget.stackedVertical,
        layoutSize: sizeQuota,
      );
      children.add(splitterBar);
    }
    return children;
  }

  Widget _buildDividerShadow(double offset, BoxConstraints constraints) {
    return AnimatedPositioned(
      curve: Curves.easeOutExpo,
      duration: Duration(milliseconds: 16),
      top: offset,
      child: Container(
        child: SizedBox(
          width: widget.stackedVertical ? constraints.maxWidth : 2,
          height: widget.stackedVertical ? 2 : constraints.maxHeight,
        ),
      ),
    );
  }
}

/// ===================================================================
/// Horizontal Splitter
/// ===================================================================

class HorizontalSplitter extends Splitter {
  HorizontalSplitter({
    Key key,
    @required children,
    initialLayoutMask,
  }) : super(
          children: children,
          initialLayoutMask: initialLayoutMask,
          stackedVertical: false,
        );

  @override
  _HorizontalSplitterState createState() => _HorizontalSplitterState();
}

class _HorizontalSplitterState extends State<HorizontalSplitter>
    with SingleTickerProviderStateMixin, SplitterStateMixin {
  @override
  Widget buildLayout(List<Widget> children) {
    return Row(children: children);
  }
}

/// ===================================================================
/// Vertical Splitter
/// ===================================================================

class VerticalSplitter extends Splitter {
  VerticalSplitter({
    Key key,
    @required children,
    initialLayoutMask,
  }) : super(
          children: children,
          initialLayoutMask: initialLayoutMask,
          stackedVertical: true,
        );
  @override
  _VerticalSplitterState createState() => _VerticalSplitterState();
}

class _VerticalSplitterState extends State<VerticalSplitter>
    with SingleTickerProviderStateMixin, SplitterStateMixin {
  @override
  Widget buildLayout(List<Widget> children) {
    return Column(children: children);
  }
}

/// ===================================================================
/// Divider
/// ===================================================================

class Divider extends StatefulWidget {
  final bool stackedVertical;

  /// Total width or height of the layout in which this splitter is placed.
  final double layoutSize;

  /// indicates the location of the Divider in the layout.
  final int index;

  const Divider(
      {Key key,
      @required this.index,
      @required this.stackedVertical,
      @required this.layoutSize})
      : super(key: key);

  @override
  _DividerState createState() => _DividerState();

  // UX
  static const double FAT = 8;
  static const double PADDING = 3;
}

class _DividerState extends State<Divider> {
  // The amount the splitter bar has move in the main axis in
  // the coordinate space of the event receiver since started.
  double _delta;

  @override
  Widget build(BuildContext context) {
    // find the layout mask that this splitter can manipulate by dragging.
    final splitter = _SplitterScope.of(context);
    final layoutMask = splitter.layoutMask;
    final dividerPosition = splitter.dividerPosition;

    return GestureDetector(
      onPanStart: (details) {
        _delta = 0;
        _dividerPositionChanged(_delta, layoutMask, dividerPosition);
      },
      onPanUpdate: (details) {
        var changed;
        if (widget.stackedVertical) {
          changed = details.delta.dy;
        } else {
          changed = details.delta.dx;
        }

        // if there is no change on the main axis then not notify.
        if (changed == 0) return;

        _delta += changed;
        _dividerPositionChanged(_delta, layoutMask, dividerPosition);
      },
      onPanEnd: (_) {
        /// Take the delta while the resizer is dragged and transform it to
        /// the layout mask for the dock layout manager to rebuild.
        final ratio = (_delta / widget.layoutSize).toPrecision(2);

        // unboxed the layout mask from string to easier format to read.
        var currentMask =
            layoutMask.value.split(MASK_SEPARATOR).map(double.parse).toList();
        currentMask[widget.index] = currentMask[widget.index] + ratio;
        currentMask[widget.index + 1] = currentMask[widget.index + 1] - ratio;

        layoutMask.value = currentMask.join(MASK_SEPARATOR);

        // clean placeholder
        dividerPosition.value = null;
      },
      child: Container(
        padding: const EdgeInsets.all(Divider.PADDING),
        width: widget.stackedVertical ? null : Divider.FAT,
        height: widget.stackedVertical ? Divider.FAT : null,
        child: Container(),
      ),
    );
  }

  void _dividerPositionChanged(
    double delta,
    ValueNotifier<String> layoutMask,
    ValueNotifier<double> dividerPosition,
  ) {
    // unboxed the layout mask from string to easier format to read.
    final currentMask =
        layoutMask.value.split(MASK_SEPARATOR).map(double.parse).toList();

    var centerOffset = 0.0;
    for (var i = 0; i <= widget.index; i++) {
      // panel width
      centerOffset += currentMask[i] * widget.layoutSize;
      // divider width
      centerOffset += Divider.FAT;
    }
    // adjust it to the center offset
    centerOffset -= Divider.FAT / 2;

    dividerPosition.value = centerOffset + delta;
  }
}

/// ===================================================================
/// Misc
/// ===================================================================

/// Round a double to a given degree of precision after decimal point.
/// https://stackoverflow.com/a/59522007
extension Precision on double {
  double toPrecision(int fractionDigits) {
    double mod = pow(10, fractionDigits.toDouble());
    return ((this * mod).round().toDouble() / mod);
  }
}
