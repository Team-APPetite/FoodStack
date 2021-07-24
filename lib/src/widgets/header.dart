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

  static getSliverAppBar(
      {String title = '',
      Widget details,
      bool back = true,
      String logo = '',
      String alert = 'none',
      double height = 300}) {
    var top = 0.0;
    return SliverAppBar(
        title: logo == '' ? Text(title, style: TextStyles.heading2()) : null,
        pinned: true,
        leading: BackArrow(alert, back),
        elevation: 0,
        backgroundColor: Color(ThemeColors.hexColor('FAFAFA')),
        collapsedHeight: details != null ? 80 : kToolbarHeight,
        expandedHeight: logo != '' ? height : null,
        flexibleSpace: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
          top = constraints.biggest.height;
          return logo != ''
              ? FlexibleSpaceBar(
                  centerTitle: true,
                  title: top ==
                          MediaQuery.of(context).padding.top +
                              (details != null ? 80 : kToolbarHeight)
                      ? Stack(
                          alignment: Alignment.center,
                          children: [
                            Text(title, style: TextStyles.heading2()),
                            details != null
                                ? Padding(
                                    padding: const EdgeInsets.only(top: 50.0),
                                    child: details,
                                  )
                                : Text('')
                          ],
                        )
                      : Container(),
                  background: Image.network(
                    logo,
                    fit: BoxFit.cover,
                  ))
              : Container();
        }));
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
            key: Key('backButton'),
            icon: Icon(CupertinoIcons.back),
            iconSize: 35.0,
            color: ThemeColors.dark,
            onPressed: () {
              switch (widget.alert) {
                case 'none':
                  Navigator.pop(context);
                  break;
                case 'loseCart':
                  showDialog<String>(
                      context: context, builder: Alerts.loseCart());
                  break;
              }
            })
        : Container();
  }
}
