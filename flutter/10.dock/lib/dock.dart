import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return DockManager(
      builder: (context, availableWidth, availableHeight) {
        return HorizontalSplitter(
          width: availableWidth,
          height: availableHeight,
          children: <Widget>[
            Panel(
              'Explorer',
              Container(color: Colors.tealAccent),
              initialRatio: 0.18,
            ),
            Panel(
              'Editor',
              Container(color: Colors.white70),
              initialRatio: 0.64,
            ),
            Panel(
              'Properties',
              Container(color: Colors.lightGreenAccent),
              initialRatio: 0.18,
            ),
          ],
        );
      },
    );
  }
}

/// ===================================================================
/// Dock Manager
/// ===================================================================

typedef DockLayoutBuilder = Widget Function(
    BuildContext context, double width, double height);

class DockManager extends StatelessWidget {
  /// Builds child widget given this widget's size.
  final DockLayoutBuilder builder;

  const DockManager({Key key, @required this.builder})
      : assert(builder != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    var mediaWidth = MediaQuery.of(context).size.width;
    var mediaHeight = MediaQuery.of(context).size.height;
    return builder(context, mediaWidth, mediaHeight);
  }
}

class Panel extends StatefulWidget {
  final String _title;
  final Widget child;
  bool stackedVertical;

  /// sizeQuota is the maximum available width/height that
  /// widget can take.
  double sizeQuota;

  /// ratio is the percentage of space the panel takes in the splitter.
  /// The percentage is specified in [initialRatio] and is between 0..1
  double initialRatio;

  Panel(this._title, this.child, {Key key, double initialRatio})
      : assert(initialRatio == null || (initialRatio > 0 && initialRatio <= 1)),
        super(key: key) {
    this.initialRatio = initialRatio;
  }

  @override
  _PanelState createState() => _PanelState();

  String get title => _title;
}

class _PanelState extends State<Panel> {
  double _ratio;

  double get ratio {
    return _ratio == null ? widget.initialRatio : _ratio;
  }

  set ratio(double value) => _ratio = value;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (_, constraints) {
      if (ratio == null) {
        return Expanded(child: _buildContent());
      }
      return SizedBox(
        width: widget.sizeQuota * ratio,
        height: null,
        child: _buildContent(),
      );
    });
  }

  _buildContent() {
    return Container(
      padding: EdgeInsets.all(2),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey, width: 1),
      ),
      child: Container(
        padding: EdgeInsets.all(1),
        child: widget.child,
      ),
    );
  }
}

/// ===================================================================
/// Splitter
/// ===================================================================

class SplitterBar extends StatelessWidget {
  final Widget previousWidget;
  final Widget nextWidget;
  final bool stackedVertical;

  static const num FAT = 4;

  const SplitterBar(this.previousWidget, this.nextWidget, this.stackedVertical,
      {Key key})
      : assert(previousWidget != null),
        assert(stackedVertical != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blueGrey,
      width: stackedVertical ? null : FAT,
      height: stackedVertical ? FAT : null,
    );
  }
}

abstract class Splitter {
  bool stackedVertical;
  double width;
  double height;

  List<Widget> splitterBars;

  /// built_children are the list of child Widget that will be added
  /// into this Splitter widget.
  List<Widget> built_children = [];

  void buildSplitters(List<Widget> children) {
    if (children.length <= 1) {
      return;
    }

    splitterBars = List<Widget>();
    for (var i = 0; i < children.length - 1; i++) {
      var previous = children[i];
      var next = children[i + 1];
      var splitterBar = SplitterBar(previous, next, stackedVertical);
      splitterBars.add(splitterBar);

      // add the panel and split bar to the widget tree
      insertDock(previous);
      built_children.add(splitterBar);
    }
    insertDock(children.last);

    /// estimate size quota for each Dockable widget
    double sizeQuota;
    num numOfSplitterBars = splitterBars.length;
    if (stackedVertical) {
      sizeQuota = height - (SplitterBar.FAT * numOfSplitterBars);
    } else {
      sizeQuota = width - (SplitterBar.FAT * numOfSplitterBars);
    }

    for (var i = 0; i < built_children.length; i++) {
      if (built_children[i] is Panel) {
        (built_children[i] as Panel).sizeQuota = sizeQuota;
      }
    }
  }

  void insertDock(Widget dock) {
    if (dock is Panel) {
      dock.stackedVertical = stackedVertical;
    }
    built_children.add(dock);
  }
}

class HorizontalSplitter extends StatefulWidget with Splitter {
  final double width;
  final double height;

  HorizontalSplitter({
    Key key,
    @required List<Widget> children,
    @required this.width,
    @required this.height,
  }) : super(key: key) {
    this.stackedVertical = false;
    this.buildSplitters(children);
  }

  @override
  _HorizontalState createState() => _HorizontalState();

  @override
  String get title => 'Horizontal Splitter';
}

class _HorizontalState extends State<HorizontalSplitter> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[...widget.built_children],
    );
  }
}
