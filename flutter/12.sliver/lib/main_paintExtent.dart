import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

void main() {
  runApp(MaterialApp(home: Home()));
}

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: <Widget>[
            SliverToBoxAdapter(child: Logo()),
            SliverToBoxAdapter(child: Logo()),
            SliverDemo(child: Logo(color: Colors.blueGrey, size: 201)),
          ],
        ),
      ),
    );
  }
}

class SliverDemo extends SingleChildRenderObjectWidget {
  const SliverDemo({
    Key key,
    Widget child,
  }) : super(key: key, child: child);

  @override
  RenderSliverDemo createRenderObject(BuildContext context) =>
      RenderSliverDemo();
}

class RenderSliverDemo extends RenderSliverSingleBoxAdapter {
  RenderSliverDemo({RenderBox child}) : super(child: child);

  @override
  void performLayout() {
    final SliverConstraints constraints = this.constraints;
    // The remaining space in the viewportMainAxisExtent. Can be <= 0 if we have
    // scrolled beyond the extent of the screen.
    double extent =
        constraints.viewportMainAxisExtent - constraints.precedingScrollExtent;

    if (child != null) {
      double childExtent;
      switch (constraints.axis) {
        case Axis.horizontal:
          childExtent = child.getMaxIntrinsicWidth(constraints.crossAxisExtent);
          break;
        case Axis.vertical:
          childExtent =
              child.getMaxIntrinsicHeight(constraints.crossAxisExtent);
          break;
      }

      // If the childExtent is greater than the computed extent, we want to use
      // that instead of potentially cutting off the child. This allows us to
      // safely specify a maxExtent.
      extent = math.max(extent, childExtent);
      child.layout(constraints.asBoxConstraints(
        minExtent: extent,
        maxExtent: extent,
      ));
    }

    assert(
      extent.isFinite,
      'The calculated extent for the child of SliverFillRemaining is not finite. '
      'This can happen if the child is a scrollable, in which case, the '
      'hasScrollBody property of SliverFillRemaining should not be set to '
      'false.',
    );
    final double paintedChildSize =
        calculatePaintOffset(constraints, from: 0.0, to: extent);
    assert(paintedChildSize.isFinite);
    assert(paintedChildSize >= 0.0);
    geometry = SliverGeometry(
      scrollExtent: extent,
      paintExtent: paintedChildSize,
      maxPaintExtent: paintedChildSize,
      hasVisualOverflow: extent > constraints.remainingPaintExtent ||
          constraints.scrollOffset > 0.0,
    );
    if (child != null) setChildParentData(child, constraints, geometry);
  }
}

class Logo extends StatelessWidget {
  final Color color;
  final double size;

  const Logo({
    Key key,
    this.color = Colors.orangeAccent,
    this.size = 200,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(children: <Widget>[
        FlutterLogo(size: size),
        Text('$size'),
      ]),
      color: color,
    );
  }
}
