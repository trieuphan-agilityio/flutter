part of 'home.dart';

class Recent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final List<_RecentItemModel> recentList = [
      _RecentItemModel('1', 'John', _RecentStatus.videoChatJustEnd),
      _RecentItemModel('11', 'Jack', _RecentStatus.missedVideoChat),
      _RecentItemModel('2', 'Jane', _RecentStatus.busy),
      _RecentItemModel('3', 'Julie', _RecentStatus.available),
    ];

    final AppSettingsStoreReading appSettings =
        AppServices.of(context).appSettingsStore;

    return CustomScrollView(
      slivers: [
        SliverAppBar(
            pinned: true, title: Text('Hello ${appSettings.myIdentity}')),
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

class RecentItem extends StatelessWidget with ChatRouteMixin, StartCallMixin {
  final _RecentItemModel model;

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
        subtitle: _buildSubtitle(model),
        trailing: _buildTrailing(context, model),
        onTap: () => routeToChat(context, model.identity),
      ),
    );
  }

  Widget _buildSubtitle(_RecentItemModel model) {
    switch (model.status) {
      case _RecentStatus.videoChatJustEnd:
        return Text('The video chat just end');
      case _RecentStatus.missedVideoChat:
        return Text('${model.name} missed your video chat');
      case _RecentStatus.busy:
        return Text('Busy');
      case _RecentStatus.available:
        return Text('Time available: 15 min');
      default:
        return SizedBox.shrink();
    }
  }

  Widget _buildTrailing(BuildContext context, _RecentItemModel model) {
    switch (model.status) {
      case _RecentStatus.missedVideoChat:
        return IconButton(
            icon: Icon(Icons.call),
            onPressed: () => startVoiceCall(context, model.identity));
      default:
        return SizedBox.shrink();
    }
  }
}

class _RecentItemModel {
  _RecentItemModel(this.identity, this.name, this.status);

  final String identity;
  final String name;
  final _RecentStatus status;
}

enum _RecentStatus { missedVideoChat, videoChatJustEnd, busy, available }
