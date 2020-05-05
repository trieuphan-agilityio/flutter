import 'dart:ui';

import 'package:flutter/material.dart';

main() {
  runApp(MaterialApp(home: ReorderableTodoDemo()));
}

class ReorderableTodoDemo extends StatefulWidget {
  @override
  _ReorderableTodoDemoState createState() => _ReorderableTodoDemoState();
}

class _ReorderableTodoDemoState extends State<ReorderableTodoDemo> {
  bool selected = false;

  List<TodoItem> todoItems;

  @override
  void initState() {
    super.initState();

    todoItems = [
      TodoItem(1, 'Adopt a Kitten'),
      TodoItem(2, 'Weed Garden'),
      TodoItem(3, 'Go to Beach'),
      TodoItem(4, 'Pay Taxes'),
      TodoItem(5, 'Cook Feast'),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Reorderable To do list app')),
      body: Card(
        elevation: 1,
        child: ReorderableListView(
          onReorder: (int oldIndex, int newIndex) {
            setState(() {
              todoItems.insert(newIndex, todoItems.removeAt(oldIndex));
            });
          },
          children: <Widget>[
            for (var i = 0; i < todoItems.length; i++)
              TodoTile(key: ValueKey(todoItems[i].id), model: todoItems[i]),
          ],
        ),
      ),
    );
  }
}

class TodoTile extends StatefulWidget {
  final TodoItem model;

  const TodoTile({Key key, @required this.model}) : super(key: key);

  @override
  _TodoTileState createState() => _TodoTileState();
}

class _TodoTileState extends State<TodoTile> {
  TodoItem m;

  @override
  void initState() {
    super.initState();
    m = widget.model;
  }

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      key: ValueKey(m.id),
      title: Text(m.text,
          style: TextStyle(
              decoration:
                  m.isDone ? TextDecoration.lineThrough : TextDecoration.none)),
      onChanged: (bool value) {
        setState(() {
          m = TodoItem(m.id, m.text, isDone: !m.isDone);
        });
      },
      value: m.isDone,
    );
  }
}

class TodoItem {
  final int id;
  final String text;
  final bool isDone;

  const TodoItem(this.id, this.text, {this.isDone = false});
}
