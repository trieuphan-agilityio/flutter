import 'package:flutter/material.dart';

class Chat extends StatelessWidget {
  final String identity;

  const Chat({Key key, @required this.identity}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            pinned: true,
            title: Text('identity'),
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.call),
                onPressed: () {},
              ),
              IconButton(
                icon: Icon(Icons.videocam),
                onPressed: () {},
              ),
            ],
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int i) {
                return ListTile(title: Text(identity));
              },
              childCount: 3,
            ),
          )
        ],
      ),
    );
  }
}
