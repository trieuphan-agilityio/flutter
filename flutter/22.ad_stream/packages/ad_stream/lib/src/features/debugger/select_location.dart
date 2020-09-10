import 'package:ad_stream/di.dart';
import 'package:ad_stream/models.dart';
import 'package:ad_stream/src/modules/gps/debugger/gps_debugger.dart';
import 'package:flutter/material.dart';

class SampleLocation {
  final String name;
  final LatLng latLng;

  const SampleLocation(this.name, this.latLng);
}

const _sample = [
  SampleLocation('19 Duy Tan, Da Nang', const LatLng(16.048467, 108.212338)),
  SampleLocation('16.040041, 108.210480', const LatLng(16.040041, 108.210480)),
];

class SelectLocation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _SelectLocation(gpsDebugger: DI.of(context).gpsDebugger);
  }
}

class _SelectLocation extends StatefulWidget {
  final GpsDebugger gpsDebugger;

  const _SelectLocation({Key key, @required this.gpsDebugger})
      : super(key: key);

  @override
  __SelectLocationState createState() => __SelectLocationState();
}

class __SelectLocationState extends State<_SelectLocation> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Select Fixed Location')),
      body: Column(children: [
        ..._sample.map((s) => ListTile(
              key: ValueKey(s.name),
              leading: Radio<LatLng>(
                value: s.latLng,
                groupValue: null,
                onChanged: (_) {},
              ),
              title: Text(s.name),
              onTap: () {
                widget.gpsDebugger.useLocation(s.latLng);
                Navigator.of(context).pop();
              },
            ))
      ]),
    );
  }
}
