import 'package:ad_stream/base.dart';
import 'package:flutter/material.dart';

class LogView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: StreamBuilder<List<String>>(
          stream: Log.last$,
          builder: (context, snapshot) {
            if (snapshot.hasData)
              return ListView.builder(
                  reverse: true,
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) {
                    return Container(
                      child: Text(snapshot.data[index]),
                      padding: EdgeInsets.only(bottom: 4),
                    );
                  });
            else
              return SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
