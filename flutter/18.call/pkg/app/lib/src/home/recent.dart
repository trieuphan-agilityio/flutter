part of 'home.dart';

class Recent extends StatelessWidget {
  final List<RecentItemModel> recentList;

  const Recent({Key key, this.recentList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
        subtitle: _buildSubtitle(model),
        trailing: _buildTrailing(context, model),
        onTap: () => routeToChat(context, model.identity),
      ),
    );
  }

  Widget _buildSubtitle(RecentItemModel model) {
    switch (model.status) {
      case RecentStatus.videoChatJustEnd:
        return Text('The video chat just end');
      case RecentStatus.missedVideoChat:
        return Text('${model.name} missed your video chat');
      case RecentStatus.busy:
        return Text('Busy');
      case RecentStatus.available:
        return Text('Time available: 15 min');
      default:
        return SizedBox.shrink();
    }
  }

  Widget _buildTrailing(BuildContext context, RecentItemModel model) {
    switch (model.status) {
      case RecentStatus.missedVideoChat:
        return IconButton(
            icon: Icon(Icons.call),
            onPressed: () => startVideoCall(context, model.identity));
      default:
        return SizedBox.shrink();
    }
  }
}

class RecentItemModel {
  RecentItemModel(this.identity, this.name, this.status);

  final String identity;
  final String name;
  final RecentStatus status;
}

enum RecentStatus { missedVideoChat, videoChatJustEnd, busy, available }
