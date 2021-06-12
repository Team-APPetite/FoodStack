import 'package:flutter/material.dart';
import 'package:foodstack/src/utilities/enums.dart';
import 'package:foodstack/src/screens/home.dart';
import 'package:foodstack/src/screens/profile.dart';
import 'package:foodstack/src/screens/track.dart';
import 'package:foodstack/src/styles/themeColors.dart';

class CustomBottomNavBar extends StatelessWidget{
  const CustomBottomNavBar({
    Key key,
    @required this.selectedMenu,
  }) : super(key: key);

  final MenuState selectedMenu;
  @override
  Widget build(BuildContext context) {
    final Color inActiveIconColor = Color(0xFFB6B6B6);
    return Container(
        padding: EdgeInsets.symmetric(vertical: 8.0),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(40), topRight: Radius.circular(40)),
            boxShadow: [
              BoxShadow(
                offset: Offset(0, -15),
                blurRadius: 20,
                color: Color(0xFFDADADA).withOpacity(0.15),
              )
            ]),
        child: SafeArea(
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
              IconButton(
                icon: Icon(Icons.list_alt_outlined,
                    size: 30,
                    color: MenuState.order == selectedMenu
                        ? ThemeColors.oranges
                        : inActiveIconColor),
                onPressed: () => Navigator.push(context,
                    MaterialPageRoute(builder: (context) => HomeScreen())),
              ),
              IconButton(
                icon: Icon(Icons.location_on_outlined,
                    size: 30,
                    color: MenuState.track == selectedMenu
                        ? ThemeColors.oranges
                        : inActiveIconColor),
                onPressed: () => Navigator.push(context,
                    MaterialPageRoute(builder: (context) => TrackScreen())),
              ),
              IconButton(
                icon: Icon(Icons.person,
                    size: 30,
                    color: MenuState.profile == selectedMenu
                        ? ThemeColors.oranges
                        : inActiveIconColor),
                onPressed: () => Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ProfilePage())),
              )
            ])));
  }
}
