import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

main() {
  runApp(MaterialApp(
    theme: ThemeData(
      primaryColor: Colors.black,
      primaryColorLight: Colors.white,
    ),
    home: _Demo(),
  ));
}

class _Demo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Home(
      map: Container(
          color: Colors.blueGrey,
          child: Container(decoration: FlutterLogoDecoration())),
      appBar: AppBar(
        leading: Icon(Icons.menu),
        backgroundColor: Colors.transparent,
      ),
      input: Card(
        margin: EdgeInsets.symmetric(horizontal: 16),
        child: ListTile(
          leading: Icon(Icons.location_on),
          title: Text('Where to?'),
        ),
      ),
      locationRefresher: LocationRefresher(),
      promoBanner: const PromoBanner(),
      sliverFeedItems: <Widget>[
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

/// ===================================================================
/// Home
/// ===================================================================

class Home extends StatefulWidget {
  final Widget map;
  final Widget appBar;
  final Widget input;
  final Widget locationRefresher;
  final Widget promoBanner;
  final List<Widget> sliverFeedItems;

  const Home({
    Key key,
    @required this.map,
    this.appBar,
    this.input,
    this.locationRefresher,
    this.promoBanner,
    this.sliverFeedItems,
  }) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Positioned.fill(child: widget.map),
        Align(
          alignment: Alignment.topCenter,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              widget.appBar,
              widget.input,
            ],
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: _FeedController(
            promoBanner: widget.promoBanner,
            sliverFeedItems: widget.sliverFeedItems,
          ),
        ),
      ],
    );
  }
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
    this.promoBanner,
    this.sliverFeedItems,
    this.feedDrawerCallback,
    this.edgeDragHeight,
  })  : assert(promoBanner != null),
        assert(sliverFeedItems != null),
        super(key: key);

  /// The widget below this widget in the tree.
  final Widget promoBanner;

  final List<Widget> sliverFeedItems;

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

const double _kEdgeDragHeight = 150.0;
const double _kMinFlingVelocity = 365.0;
const Duration _kBaseSettleDuration = Duration(milliseconds: 246);

class _FeedControllerState extends State<_FeedController>
    with SingleTickerProviderStateMixin {
  ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(duration: _kBaseSettleDuration, vsync: this)
          ..addListener(_animationChanged)
          ..addStatusListener(_animationStatusChanged);

    _scrollController = ScrollController()..addListener(_scrollChanged);
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _animationChanged() {
    setState(() {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(_controller.value * 812.0);
      }
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
    return _kEdgeDragHeight;
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
  final GlobalKey _customScrollKey = GlobalKey();

  double backdropOpacity = 0.0;

  void _scrollChanged() {
    setState(() {
      // when scrolling over 30% the backdrop turn to black completely
      backdropOpacity = math.min(1.0, _scrollController.offset / (812.0 * 0.3));
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_controller.status == AnimationStatus.dismissed) {
      return Align(
          alignment: AlignmentDirectional.bottomCenter,
          child: GestureDetector(
              key: _gestureDetectorKey,
              onVerticalDragUpdate: _move,
              onVerticalDragEnd: _settle,
              child: widget.promoBanner));
    } else {
      return GestureDetector(
        key: _gestureDetectorKey,
        onVerticalDragDown: _handleDragDown,
        onVerticalDragUpdate: _move,
        onVerticalDragEnd: _settle,
        onVerticalDragCancel: _handleDragCancel,
        child: _buildCustomScrollView(),
      );
    }
  }

  Widget _buildCustomScrollView() {
    return RepaintBoundary(
      child: CustomScrollView(
        key: _customScrollKey,
        controller: _scrollController,
        slivers: <Widget>[
          SliverPromoBanner(
            child: Stack(
              children: <Widget>[
                Container(color: Theme.of(context).primaryColor),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: widget.promoBanner,
                ),
              ],
            ),
          ),
          ...widget.sliverFeedItems,
        ],
      ),
    );
  }
}

/// ===================================================================
/// Feed Header
/// ===================================================================

class SliverPromoBanner extends SingleChildRenderObjectWidget {
  SliverPromoBanner({Key key, Widget child}) : super(key: key, child: child);

  @override
  RenderSliverPromoBanner createRenderObject(BuildContext context) =>
      RenderSliverPromoBanner();
}

class RenderSliverPromoBanner extends RenderSliverSingleBoxAdapter {
  /// Creates a [RenderSliver] that wraps a non-scrollable [RenderBox] which is
  /// sized to fit the remaining space in the viewport.
  RenderSliverPromoBanner({RenderBox child}) : super(child: child);

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

class PromoBanner extends StatelessWidget {
  const PromoBanner({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: _kEdgeDragHeight,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              height: 60.0,
              padding: EdgeInsets.symmetric(horizontal: 50),
              decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                  )),
              child: Text(
                'UBER',
                style: Theme.of(context)
                    .textTheme
                    .headline6
                    .copyWith(color: Theme.of(context).primaryColorLight),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Container(height: 90.0, color: Colors.teal),
          ),
        ],
      ),
    );
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
        ));
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
        separatorBuilder: (_, __) =>
            Container(width: 6, color: Theme.of(context).primaryColor),
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
    return Container(height: 6, color: Theme.of(context).primaryColor);
  }
}
