import 'dart:io';

import 'package:ad_bloc/bloc.dart';
import 'package:flutter/material.dart';

class ImageView extends StatelessWidget {
  final AdViewModel model;

  const ImageView({Key key, @required this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints.tightFor(
        width: double.infinity,
        height: double.infinity,
      ),
      child: Image.file(File(model.filePath), fit: BoxFit.cover),
    );
  }
}
