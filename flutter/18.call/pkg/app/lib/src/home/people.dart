part of 'home.dart';

class People extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final List<_ContactItemModel> contactList = [
      _ContactItemModel('1', 'John'),
      _ContactItemModel('2', 'Jane'),
      _ContactItemModel('3', 'Julie'),
    ];

    return CustomScrollView(
      slivers: <Widget>[
        SliverAppBar(pinned: true, title: Text('People')),
        SliverFixedExtentList(
          itemExtent: _UX.itemHeight,
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, int i) {
              return ContactItem(contactList[i]);
            },
            childCount: contactList.length,
          ),
        )
      ],
    );
  }
}

class ContactItem extends StatelessWidget {
  final _ContactItemModel model;

  const ContactItem(this.model, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: ListTile(
        key: ValueKey(model.identity),
        leading:
            Container(width: 50, decoration: const FlutterLogoDecoration()),
        title: Text(model.name),
      ),
    );
  }
}

class _ContactItemModel {
  _ContactItemModel(this.identity, this.name);

  final String identity;
  final String name;
}
