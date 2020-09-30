import 'package:ad_bloc/base.dart';
import 'package:ad_bloc/src/service/debugger_builder.dart';

class DebugPassengerPhoto extends StatefulWidget {
  final DebuggerBuilder debuggerBuilder;

  const DebugPassengerPhoto({Key key, @required this.debuggerBuilder})
      : super(key: key);

  @override
  _DebugPassengerPhotoState createState() => _DebugPassengerPhotoState();
}

class _DebugPassengerPhotoState extends State<DebugPassengerPhoto> {
  final debugPhotos = [
    _ViewModel(
      'assets/camera-sample_1.png',
      '29-years-old female & 24-years-old male',
    ),
    _ViewModel(
      'assets/camera-sample_2.png',
      '29-years-old female',
    ),
    _ViewModel(
      'assets/camera-sample_3.png',
      '24-years-old male',
    ),
    _ViewModel(
      'assets/camera-sample_4.png',
      'no passenger',
    ),
  ];
  String selected;

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      key: const Key('load_passengers_photos'),
      title: const Text('Passenger photo is located at'),
      children: [
        for (final model in debugPhotos)
          ListTile(
            key: ValueKey(model.filePath),
            title: Text(model.filePath),
            subtitle: Text(model.desc),
            leading: Container(
                width: 80,
                height: 60,
                child: Image.asset(
                  model.filePath,
                  fit: BoxFit.cover,
                )),
            trailing: selected == model.filePath
                ? Icon(Icons.done, color: Theme.of(context).primaryColor)
                : null,
            onTap: () {
              setState(() => selected = model.filePath);
              widget.debuggerBuilder.passengerPhotoAt(model.filePath);
            },
          ),
      ],
    );
  }
}

class _ViewModel {
  final String filePath;
  final String desc;

  _ViewModel(this.filePath, this.desc);
}
