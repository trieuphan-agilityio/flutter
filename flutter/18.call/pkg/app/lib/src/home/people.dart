part of 'home.dart';

class People extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: <Widget>[
        SliverAppBar(pinned: true, title: Text('People')),
        SliverFixedExtentList(
          itemExtent: _UX.itemHeight,
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, int i) {
              return ContactItem(_contactList[i]);
            },
            childCount: _contactList.length,
          ),
        )
      ],
    );
  }
}

class ContactItem extends StatelessWidget {
  final ContactItemModel model;

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

final List<ContactItemModel> _contactList = [
  ContactItemModel('1', 'John'),
  ContactItemModel('2', 'Jane'),
  ContactItemModel('3', 'Julie'),
];

class ContactItemModel {
  ContactItemModel(this.identity, this.name);

  final String identity;
  final String name;
}
