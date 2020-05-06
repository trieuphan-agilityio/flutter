import 'dart:math';

import 'package:flutter/material.dart';

main() {
  runApp(MaterialApp(home: _Demo()));
}

class _Demo extends StatefulWidget {
  @override
  __DemoState createState() => __DemoState();
}

class __DemoState extends State<_Demo> with SingleTickerProviderStateMixin {
  double _height;

  double get _estHeight {
    final RenderBox box =
        _boxKey.currentContext?.findRenderObject() as RenderBox;
    if (box != null) return box.size.height;
    return 0.0;
  }

  GlobalKey _boxKey = GlobalKey();

  AnimationController controller;

  Animation<double> foregroundOpacity;

  @override
  void initState() {
    super.initState();
    controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 245));

    foregroundOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(controller);
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          final height = _height ?? constraints.maxHeight;
          final backdropOpacity = 1 - height / constraints.maxHeight;
          return SizedBox(
            key: _boxKey,
            height: _height ?? constraints.maxHeight,
            child: Stack(
              children: <Widget>[
                Container(color: Colors.blueGrey),
                Container(
                  color: Colors.black.withOpacity(backdropOpacity),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    AppBar(
                      elevation: 0,
                      backgroundColor: Colors.black,
                      leading: Icon(Icons.arrow_upward),
                    ),
                    SizedBox(height: 8),
                    Expanded(flex: 1, child: SizedBox.shrink()),
                    Text(
                      'Messages',
                      style: Theme.of(context).textTheme.headline4,
                    ),
                    Expanded(flex: 2, child: SizedBox.shrink()),
                    SizedBox(height: 8),
                  ],
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: GestureDetector(
                    onVerticalDragUpdate: (details) {
                      setState(() {
                        _height = min(constraints.maxHeight,
                            _estHeight + details.primaryDelta);
                      });
                    },
                    child: const EarnMoreWithVisaCard(),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

const double _kPromoBannerHeight = 150;

class EarnMoreWithVisaCard extends StatelessWidget {
  const EarnMoreWithVisaCard({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: _kPromoBannerHeight,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Transform.rotate(
            angle: 0.12,
            origin: Offset(-200, 0),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Container(
                height: 60.0,
                padding: EdgeInsets.symmetric(horizontal: 30),
                decoration: BoxDecoration(
                    color: Color.fromRGBO(33, 33, 33, 1),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    )),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'UBER',
                    style: Theme.of(context)
                        .textTheme
                        .headline6
                        .copyWith(color: Theme.of(context).primaryColorLight),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Card(
              elevation: 1,
              margin: EdgeInsets.zero,
              child: Container(
                height: 90.0,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [Colors.indigoAccent, Colors.lightBlue],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
