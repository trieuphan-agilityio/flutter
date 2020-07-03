import 'package:app/src/call/start_call_mixin.dart';
import 'package:app/src/chat/chat_item_mixin.dart';
import 'package:flutter/material.dart';

part 'people.dart';
part 'recent.dart';

class _UX {
  static const double itemHeight = 72.0;
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;
  bool get isShowRecent => _currentIndex == 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isShowRecent ? Recent() : People(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            title: Text('Recent'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.group),
            title: Text('People'),
          ),
        ],
        onTap: (i) {
          setState(() => _currentIndex = i);
        },
      ),
    );
  }
}
