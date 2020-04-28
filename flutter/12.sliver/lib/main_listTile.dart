import 'package:flutter/material.dart';

main() {
  runApp(MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            title: Text('Demo'),
          ),
          body: _Demo())));
}

class _Demo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: ListTile.divideTiles(
        tiles: _widgets(),
        color: Colors.grey,
      ).toList(),
    );
  }
}

List<Widget> _widgets() {
  return _items()
      .map((i) => ListTile(leading: Icon(Icons.add_call), title: Text(i)))
      .toList();
}

Iterable<String> _items() sync* {
  for (var i = 0; i < 100; i++) {
    yield 'Item $i';
  }
}
