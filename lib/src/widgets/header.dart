import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:foodstack/src/styles/textStyles.dart';
import 'package:foodstack/src/styles/themeColors.dart';
import 'package:foodstack/src/utilities/alerts.dart';

class Header {
  static getAppBar(
      {String title = '', bool back = true, String alert = 'none'}) {
    return AppBar(
        title: Text(
          title,
          style: TextStyles.heading2(),
        ),
        leading: BackArrow(alert, back),
        elevation: 0,
        backgroundColor: Colors.transparent);
  }
}

class BackArrow extends StatefulWidget {
  final String alert;
  final bool back;

  const BackArrow(this.alert, this.back);

  @override
  _BackArrowState createState() => _BackArrowState();
}

class _BackArrowState extends State<BackArrow> {
  @override
  Widget build(BuildContext context) {
    return widget.back
        ? IconButton(
            icon: Icon(CupertinoIcons.back),
            iconSize: 35.0,
            color: ThemeColors.dark,
            onPressed: () {
              switch (widget.alert) {
                case 'none':
                  Navigator.pop(context);
                  break;
                case 'loseCart':
                  showDialog<String>(context: context, builder: Alerts.loseCart());
                  break;
              }
            })
        : Container();
  }
}
