import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class SettingItem extends StatefulWidget {
  final String title;
  final ValueListenable<bool> value;
  final VoidCallback onChanged;

  const SettingItem({
    Key key,
    @required this.value,
    @required this.title,
    @required this.onChanged,
  }) : super(key: key);

  @override
  _SettingItemState createState() => _SettingItemState();
}

class _SettingItemState extends State<SettingItem> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: widget.value,
      builder: (context, value, child) => ListTile(
        title: Text(widget.title),
        subtitle: Text(value ? 'On' : 'Off'),
        leading: SizedBox.shrink(),
        trailing: AbsorbPointer(
          child: Switch.adaptive(value: value, onChanged: (_) {}),
        ),
        onTap: () => widget.onChanged(),
      ),
    );
  }
}
