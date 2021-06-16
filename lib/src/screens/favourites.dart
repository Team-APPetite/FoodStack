import 'package:flutter/material.dart';
import 'package:foodstack/src/widgets/header.dart';

class FavouritesScreen extends StatefulWidget {
  @override
  _FavouritesScreenState createState() => _FavouritesScreenState();
}

class _FavouritesScreenState extends State<FavouritesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Header.getAppBar(title: 'Favourites'),
      body: Center(child: Text('Favs'))
    );
  }
}
