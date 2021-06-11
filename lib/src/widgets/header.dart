import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:foodstack/src/styles/themeColors.dart';

class Header {
  static getAppBar({String title = ''}) {
    return AppBar(
      title: Text(
        title,
        style: TextStyle(
          color: ThemeColors.dark,
          fontWeight: FontWeight.bold,
          fontFamily: 'Avenir',
          fontSize: 22.0,
        ),
      ),
      leading: BackArrow(),
      elevation: 0,
      backgroundColor: Colors.transparent
    );
  }
}

class BackArrow extends StatefulWidget {
  @override
  _BackArrowState createState() => _BackArrowState();
}

class _BackArrowState extends State<BackArrow> {
  @override
  Widget build(BuildContext context) {
    return IconButton(
        icon: Icon(CupertinoIcons.back),
        iconSize: 35.0,
        color: ThemeColors.dark,
        onPressed: () {
          Navigator.pop(context);
        });
  }
}
