part of 'home.dart';

class Recent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(pinned: true, title: Text('Recent')),
        SliverFixedExtentList(
          itemExtent: _UX.itemHeight,
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, int i) {
              return RecentItem(recentList[i]);
            },
            childCount: recentList.length,
          ),
        )
      ],
    );
  }
}

class RecentItem extends StatelessWidget with ChatItemMixin {
  final RecentItemModel model;

  const RecentItem(this.model, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: ListTile(
        key: ValueKey(model.identity),
        leading:
            Container(width: 50, decoration: const FlutterLogoDecoration()),
        title: Text(model.name),
        subtitle: _getSubtitle(model.status),
        onTap: () => routeToChat(context, model.identity),
      ),
    );
  }

  Widget _getSubtitle(RecentStatus status) {
    switch (status) {
      case RecentStatus.videoChatJustEnd:
        return Text('The video chat just end');
      case RecentStatus.busy:
        return Text('Busy');
      case RecentStatus.available:
        return Text('Time available: 15 min');
      default:
        return SizedBox.shrink();
    }
  }
}

final List<RecentItemModel> recentList = [
  RecentItemModel('1', 'John', RecentStatus.videoChatJustEnd),
  RecentItemModel('2', 'Jane', RecentStatus.busy),
  RecentItemModel('3', 'Julie', RecentStatus.available),
];

class RecentItemModel {
  RecentItemModel(this.identity, this.name, this.status);

  final String identity;
  final String name;
  final RecentStatus status;
}

enum RecentStatus { videoChatJustEnd, busy, available }
