import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

main() {
  runApp(MaterialApp(home: _Demo()));
}

class _Demo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Home(
      map: Container(
          color: Colors.blueGrey,
          child: Container(decoration: FlutterLogoDecoration())),
      input: Card(
        child: ListTile(
          leading: Icon(Icons.location_on),
          title: Text('Where to?'),
        ),
      ),
      locationRefresher: LocationRefresher(),
      feedDrawer: Feed(),
    );
  }
}

/// ===================================================================
/// Home
/// ===================================================================

class Home extends StatefulWidget {
  final Widget map;
  final Widget input;
  final Widget locationRefresher;
  final Widget feedDrawer;

  const Home({
    Key key,
    @required this.map,
    this.input,
    this.locationRefresher,
    this.feedDrawer,
  }) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    final List<LayoutId> children = <LayoutId>[];

    _addIfNonNull(children, widget.map, _HomeSlot.map);
    _addIfNonNull(
      children,
      _FeedController(
        child: widget.feedDrawer,
      ),
      _HomeSlot.feedDrawer,
    );

    return CustomMultiChildLayout(
      children: children,
      delegate: _HomeLayout(),
    );
  }

  void _addIfNonNull(
    List<LayoutId> children,
    Widget child,
    Object childId,
  ) {
    MediaQueryData data = MediaQuery.of(context);
    if (child != null) {
      children.add(LayoutId(
        id: childId,
        child: MediaQuery(data: data, child: child),
      ));
    }
  }
}

enum _HomeSlot {
  map,
  input,
  locationRefresher,
  feedDrawer,
}

class _HomeLayout extends MultiChildLayoutDelegate {
  @override
  void performLayout(Size size) {
    final BoxConstraints looseConstraints = BoxConstraints.loose(size);
    final BoxConstraints fullWidthConstraints =
        looseConstraints.tighten(width: size.width);

    if (hasChild(_HomeSlot.map)) {
      layoutChild(_HomeSlot.map, BoxConstraints.tight(size));
      positionChild(_HomeSlot.map, Offset.zero);
    }

    if (hasChild(_HomeSlot.input)) {
      layoutChild(_HomeSlot.input, fullWidthConstraints);
      positionChild(_HomeSlot.input, Offset.zero);
    }

    if (hasChild(_HomeSlot.locationRefresher)) {
      layoutChild(_HomeSlot.locationRefresher, fullWidthConstraints);
      positionChild(_HomeSlot.locationRefresher, Offset.zero);
    }

    if (hasChild(_HomeSlot.feedDrawer)) {
      layoutChild(_HomeSlot.feedDrawer, BoxConstraints.tight(size));
      positionChild(_HomeSlot.feedDrawer, Offset.zero);
    }
  }

  @override
  bool shouldRelayout(MultiChildLayoutDelegate oldDelegate) => false;
}

class LocationRefresher extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: <Widget>[
          FloatingActionButton(
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            onPressed: () {},
            child: Icon(Icons.refresh),
          ),
          SizedBox(height: 16),
          Text('490 Post St', style: Theme.of(context).textTheme.subtitle2),
        ],
      ),
    );
  }
}

/// ===================================================================
/// Promotion Banner
/// ===================================================================

/// Signature for the callback that's called when a [_FeedController] is
/// opened or closed.
typedef _FeedDrawerCallback = void Function(bool isOpened);

class _FeedController extends StatefulWidget {
  const _FeedController({
    GlobalKey key,
    @required this.child,
    this.feedDrawerCallback,
    this.edgeDragHeight,
  }) : super(key: key);

  /// The widget below this widget in the tree.
  final Widget child;

  /// Optional callback that is called when a [Drawer] is opened or closed.
  final _FeedDrawerCallback feedDrawerCallback;

  /// The height of the area within which a vertical swipe will open the drawer.
  ///
  /// By default, the value used is the PromoBanner's height added to the padding
  /// edge of `MediaQuery.of(context).padding` that corresponds to [alignment].
  final double edgeDragHeight;

  @override
  _FeedControllerState createState() => _FeedControllerState();
}

const double _kHeight = 200.0;
const double _kEdgeDragHeight = 50.0;
const double _kMinFlingVelocity = 365.0;
const Duration _kBaseSettleDuration = Duration(milliseconds: 246);

class _FeedControllerState extends State<_FeedController>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(duration: _kBaseSettleDuration, vsync: this)
          ..addListener(_animationChanged)
          ..addStatusListener(_animationStatusChanged);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _animationChanged() {
    setState(() {
      // The animation controller's state is our build state, and it changed already.
    });
  }

  void _animationStatusChanged(AnimationStatus status) {}

  AnimationController _controller;

  void _handleDragDown(DragDownDetails details) {
    _controller.stop();
  }

  void _handleDragCancel() {
    if (_controller.isDismissed || _controller.isAnimating) return;
    if (_controller.value < 0.5) {
      close();
    } else {
      open();
    }
  }

  final GlobalKey _drawerKey = GlobalKey();

  double get _height {
    final RenderBox box =
        _drawerKey.currentContext?.findRenderObject() as RenderBox;
    if (box != null) return box.size.height;
    return _kHeight;
  }

  bool _previouslyOpened = false;

  void _move(DragUpdateDetails details) {
    double delta = details.primaryDelta / _height;
    _controller.value = _controller.value + -delta;

    final bool opened = _controller.value > 0.5;
    if (opened != _previouslyOpened && widget.feedDrawerCallback != null)
      widget.feedDrawerCallback(opened);
    _previouslyOpened = opened;
  }

  void _settle(DragEndDetails details) {
    if (_controller.isDismissed) return;
    if (details.velocity.pixelsPerSecond.dy.abs() >= _kMinFlingVelocity) {
      double visualVelocity = details.velocity.pixelsPerSecond.dy / _height;
      _controller.fling(velocity: visualVelocity);
      if (widget.feedDrawerCallback != null)
        widget.feedDrawerCallback(visualVelocity > 0.0);
    } else if (_controller.value < 0.5) {
      close();
    } else {
      open();
    }
  }

  void open() {
    _controller.fling(velocity: 1.0);
    if (widget.feedDrawerCallback != null) widget.feedDrawerCallback(true);
  }

  void close() {
    _controller.fling(velocity: -1.0);
    if (widget.feedDrawerCallback != null) widget.feedDrawerCallback(false);
  }

  final GlobalKey _gestureDetectorKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    double dragAreaHeight = widget.edgeDragHeight;
    if (widget.edgeDragHeight == null) {
      dragAreaHeight = _kEdgeDragHeight;
    }

    if (_controller.status == AnimationStatus.dismissed) {
      return Align(
          alignment: AlignmentDirectional.bottomCenter,
          child: GestureDetector(
              key: _gestureDetectorKey,
              onVerticalDragUpdate: _move,
              onVerticalDragEnd: _settle,
              child: Container(color: Colors.red, height: dragAreaHeight)));
    } else {
      return GestureDetector(
          key: _gestureDetectorKey,
          onVerticalDragDown: _handleDragDown,
          onVerticalDragUpdate: _move,
          onVerticalDragEnd: _settle,
          onVerticalDragCancel: _handleDragCancel,
          child: Stack(children: <Widget>[
            Align(
              alignment: Alignment.bottomCenter,
              child: Align(
                alignment: Alignment.topCenter,
                heightFactor: _controller.value,
                child: widget.child,
              ),
            ),
          ]));
    }
  }
}

class Feed extends StatefulWidget {
  @override
  _FeedState createState() => _FeedState();
}

class _FeedState extends State<Feed> {
  var noScroll = false;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: <Widget>[
        SliverAppBar(
          backgroundColor: Colors.black,
          pinned: true,
          stretch: true,
          expandedHeight: 300.0,
          flexibleSpace: FlexibleSpaceBar(
            title: const Text('Messages'),
            centerTitle: false,
            background: ColoredBox(color: Colors.black),
          ),
        ),
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
    );
  }
}

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
