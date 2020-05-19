import 'package:flutter/material.dart';

void main() {
  runApp(_Demo());
}

class _Demo extends StatefulWidget {
  @override
  __DemoState createState() => __DemoState();
}

class __DemoState extends State<_Demo> {
  final items = List<String>.generate(20, (i) => "Item ${i + 1}");

  @override
  Widget build(BuildContext context) {
    final title = 'Dismissing Items';

    return MaterialApp(
      title: title,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text(title),
        ),
        body: ListView.builder(
          itemCount: items.length,
          itemBuilder: (context, index) {
            final item = items[index];

            return Dismissible(
              // Each Dismissible must contain a Key. Key allow Flutter to
              // uniquely identify widget.
              key: Key(item),
              onDismissed: (direction) {
                setState(() {
                  items.removeAt(index);
                });

                Scaffold.of(context)
                    .showSnackBar(SnackBar(content: Text("$item dismissed")));
              },
              child: ListTile(title: Text('$item')),
            );
          },
        ),
      ),
    );
  }
}
