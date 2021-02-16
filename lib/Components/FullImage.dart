import 'dart:io';

import 'package:flutter/material.dart';

class FullImage extends StatefulWidget {
  File image;
  FullImage(this.image);
  @override
  _FullImageState createState() => _FullImageState();
}

class _FullImageState extends State<FullImage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Image.file(widget.image),
    );
  }
}
