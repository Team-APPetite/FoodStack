import 'package:flutter/material.dart';
import 'package:foodstack/src/app_providers/menuProvider.dart';
import 'package:foodstack/src/widgets/header.dart';

class DetailsScreen extends StatefulWidget {
  final MenuProvider menuProvider;

  const DetailsScreen(this.menuProvider);


  @override
  _DetailsScreenState createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Header.getAppBar(title: widget.menuProvider.foodName),
    );
  }
}
