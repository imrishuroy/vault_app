import 'dart:io';

import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class ExpandedPhotoView extends StatelessWidget {
  final File file;
  const ExpandedPhotoView({Key? key, required this.file}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PhotoView(
      imageProvider: MemoryImage(file.readAsBytesSync()),
    );
  }
}
