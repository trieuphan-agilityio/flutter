import 'package:app/core.dart';
import 'package:app/src/call/start_call_mixin.dart';
import 'package:app/src/debug/debug_drawer.dart';
import 'package:app/src/home/home.dart';

class Member extends StatefulWidget with StartCallMixin {
  @override
  _MemberState createState() => _MemberState();
}

class _MemberState extends State<Member> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DebugDrawer(),
      body: Recent(recentList: [
        RecentItemModel('kim', 'Kim', RecentStatus.videoChatJustEnd),
        RecentItemModel('kim', 'Kim', RecentStatus.missedVideoChat),
      ]),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          widget.startVideoCall(context, 'kim');
        },
        icon: Icon(Icons.call),
        label: Text('Call Kim'),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            title: Text('Recent'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            title: Text('Settings'),
          ),
        ],
      ),
    );
  }
}
