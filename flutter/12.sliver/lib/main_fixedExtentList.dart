import 'package:flutter/material.dart';

main() {
  runApp(MaterialApp(home: Scaffold(body: _Demo())));
}

class _Demo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final delegate = SliverChildListDelegate.fixed(_widgets());
    final items = _items().toList();
    return CustomScrollView(
      slivers: <Widget>[
        SliverFixedExtentList(
            itemExtent: 56,
            delegate: SliverChildBuilderDelegate(
              (context, i) {
                return ListTile(title: Text(items[i]));
              },
              childCount: items.length,
            ))
      ],
    );
  }
}

List<Widget> _widgets() {
  return _items().map((i) => ListTile(title: Text(i))).toList();
}

Iterable<String> _items() sync* {
  for (var i = 0; i < 100; i++) {
    yield 'Item $i';
  }
}
