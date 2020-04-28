import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

main() {
  runApp(MaterialApp(home: RideOnboarding()));
}

class RideOnboarding extends StatefulWidget {
  @override
  _RideOnboardingState createState() => _RideOnboardingState();
}

class _RideOnboardingState extends State<RideOnboarding> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
          leading: Icon(Icons.menu, color: Colors.black),
          backgroundColor: Colors.transparent,
          elevation: 0),
      body: Stack(children: <Widget>[
        Positioned.fill(
            child: Container(
                color: Colors.blueGrey,
                child: Container(decoration: FlutterLogoDecoration()))),
        SafeArea(
          child: CustomScrollView(
            slivers: <Widget>[
              SliverHome(
                child: Container(
                  color: Colors.transparent,
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Card(
                          child: ListTile(
                            leading: Icon(Icons.location_on),
                            title: Text('Where to?'),
                          ),
                        ),
                      ),
                      SizedBox(height: 350),
                      Center(
                        child: Column(
                          children: <Widget>[
                            FloatingActionButton(
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.black,
                              onPressed: () {},
                              child: Icon(Icons.refresh),
                            ),
                            SizedBox(height: 16),
                            Text('490 Post St',
                                style: Theme.of(context).textTheme.subtitle2),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
              PromoBanner(child: Container(color: Colors.teal, height: 100)),
              SliverToBoxAdapter(child: FeedDivider()),
              SliverToBoxAdapter(child: FeedSingleItem()),
              SliverToBoxAdapter(child: FeedDivider()),
              SliverToBoxAdapter(child: FeedMultiItem()),
              SliverToBoxAdapter(child: FeedDivider()),
              SliverToBoxAdapter(child: FeedSingleItem()),
              SliverToBoxAdapter(child: FeedDivider()),
              SliverToBoxAdapter(child: FeedMultiItem()),
              SliverToBoxAdapter(child: FeedDivider()),
            ],
          ),
        )
      ]),
    );
  }
}

/// ===================================================================
/// Home
/// ===================================================================

class SliverHome extends SingleChildRenderObjectWidget {
  /// Creates a sliver that contains a single box widget.
  const SliverHome({
    Key key,
    Widget child,
  }) : super(key: key, child: child);

  @override
  RenderSliverHome createRenderObject(BuildContext context) =>
      RenderSliverHome();
}

class RenderSliverHome extends RenderSliverSingleBoxAdapter {
  RenderSliverHome({
    RenderBox child,
  }) : super(child: child);

  @override
  void performLayout() {
    final SliverConstraints constraints = this.constraints;
    // The space in the viewportMainAxisExtent.
    // Leaving some space for the promotion bar.
    double extent = constraints.viewportMainAxisExtent - 100;

    child.layout(constraints.asBoxConstraints(
      minExtent: extent,
      maxExtent: extent,
    ));

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

/// ===================================================================
/// Promotion Banner
/// ===================================================================

class PromoBanner extends SingleChildRenderObjectWidget {
  /// Creates a sliver that contains a single box widget.
  const PromoBanner({Key key, Widget child}) : super(key: key, child: child);

  @override
  RenderSliverPromoBanner createRenderObject(BuildContext context) =>
      RenderSliverPromoBanner();
}

class RenderSliverPromoBanner extends RenderSliverToBoxAdapter {
  @override
  void performLayout() {
    if (child == null) {
      geometry = SliverGeometry.zero;
      return;
    }
    final SliverConstraints constraints = this.constraints;
    child.layout(constraints.asBoxConstraints(), parentUsesSize: true);
    double childExtent;
    switch (constraints.axis) {
      case Axis.horizontal:
        childExtent = child.size.width;
        break;
      case Axis.vertical:
        childExtent = child.size.height;
        break;
    }
    assert(childExtent != null);
    final double paintedChildSize =
        calculatePaintOffset(constraints, from: 0.0, to: childExtent);

    assert(paintedChildSize.isFinite);
    assert(paintedChildSize >= 0.0);
    geometry = SliverGeometry(
      scrollExtent: childExtent,
      paintExtent: paintedChildSize,
      maxPaintExtent: childExtent,
      hasVisualOverflow: childExtent > constraints.remainingPaintExtent ||
          constraints.scrollOffset > 0.0,
    );
    setChildParentData(child, constraints, geometry);
  }
}

/// ===================================================================
/// Feed Body
/// ===================================================================

class FeedSingleItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      child: Card(
        shape: BeveledRectangleBorder(),
        margin: EdgeInsets.zero,
      ),
    );
  }
}

class FeedMultiItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: 3,
        itemBuilder: (context, i) {
          return Container(
            width: 300,
            child: Card(
              shape: BeveledRectangleBorder(),
              margin: EdgeInsets.zero,
            ),
          );
        },
        separatorBuilder: (_, __) => Container(width: 6, color: Colors.black),
      ),
    );
  }
}

/// ===================================================================
/// Feed Divider
/// ===================================================================

class FeedDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(height: 6, color: Colors.black);
  }
}
