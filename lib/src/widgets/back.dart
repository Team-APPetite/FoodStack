import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BackArrow extends StatefulWidget {
  @override
  _BackArrowState createState() => _BackArrowState();
}

class _BackArrowState extends State<BackArrow> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 50.0),
      child: IconButton(
          icon: Icon(CupertinoIcons.back),
          iconSize: 35.0,
          onPressed: () {
            Navigator.pop(context);
          }),
    );
  }
}
