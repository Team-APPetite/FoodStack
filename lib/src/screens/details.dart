import 'package:flutter/material.dart';
import 'package:foodstack/src/providers/menuProvider.dart';
import 'package:foodstack/src/widgets/header.dart';
import 'package:provider/provider.dart';

class DetailsScreen extends StatefulWidget {
  @override
  _DetailsScreenState createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  @override
  Widget build(BuildContext context) {
    final menuProvider = Provider.of<MenuProvider>(context);
    return Scaffold(
      appBar: Header.getAppBar(title: menuProvider.foodName),
    );
  }
}
