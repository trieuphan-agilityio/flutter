import 'package:ad_stream/di.dart';
import 'package:ad_stream/src/modules/on_trip/debugger/camera_debugger.dart';
import 'package:ad_stream/src/modules/on_trip/photo.dart';
import 'package:flutter/material.dart';

class SamplePhoto {
  final String name;
  final Photo photo;

  const SamplePhoto(this.name, this.photo);
}

const _sample = [
  SamplePhoto('No one', const Photo('assets/camera-sample_4.jpg')),
  SamplePhoto('Male', const Photo('assets/camera-sample_3.jpg')),
  SamplePhoto('Female', const Photo('assets/camera-sample_2.jpg')),
  SamplePhoto('Male & Female', const Photo('assets/camera-sample_1.jpg')),
];

class SelectPhoto extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _SelectPhoto(cameraDebugger: DI.of(context).cameraDebugger);
  }
}

class _SelectPhoto extends StatefulWidget {
  final CameraDebugger cameraDebugger;

  const _SelectPhoto({Key key, this.cameraDebugger}) : super(key: key);

  @override
  __SelectPhotoState createState() => __SelectPhotoState();
}

class __SelectPhotoState extends State<_SelectPhoto> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Select Photo')),
      body: Column(children: [
        ListTile(
          key: const Key('camera_debugger_off'),
          leading: Radio<String>(
            value: '',
            groupValue: null,
            onChanged: (_) {},
          ),
          title: Text('Off'),
          onTap: () {
            widget.cameraDebugger.toggle(false);
            Navigator.of(context).pop();
          },
        ),
        ..._sample.map((p) {
          return ListTile(
            key: ValueKey(p.name),
            leading: Radio<String>(
              value: p.name,
              groupValue: null,
              onChanged: (_) {},
            ),
            title: Text(p.name),
            onTap: () {
              widget.cameraDebugger.usePhoto(p.photo);
              Navigator.of(context).pop();
            },
          );
        }).toList(),
      ]),
    );
  }
}
