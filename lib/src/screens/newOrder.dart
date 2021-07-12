import 'package:chips_choice/chips_choice.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:foodstack/src/models/restaurant.dart';
import 'package:foodstack/src/styles/textStyles.dart';
import 'package:foodstack/src/styles/themeColors.dart';
import 'package:foodstack/src/widgets/header.dart';
import 'package:foodstack/src/widgets/restaurantCard.dart';
import 'package:foodstack/src/providers/restaurantProvider.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:foodstack/src/providers/userLocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: must_be_immutable
class NewOrderScreen extends StatefulWidget {
  bool isFilterCardShown = false;
  bool areFiltersEnabled = false;

  List<String> tags = [];
  List<String> options = [
    'Casual',
    'Fast Food',
    'Desserts',
    'Beverages',
    'Healthy',
  ];
  @override
  _NewOrderScreenState createState() => _NewOrderScreenState();
}

class _NewOrderScreenState extends State<NewOrderScreen> {
  @override
  void initState() {
    super.initState();
    _setUserRole();
  }

  Future<void> _setUserRole() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isPooler', false);
  }

  @override
  Widget build(BuildContext context) {
    final restaurantProvider = Provider.of<RestaurantProvider>(context);
    final userLocator = Provider.of<UserLocator>(context);

    Widget _filterCard() {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Cuisine Type',
                style: TextStyles.heading3(),
                textAlign: TextAlign.start,
              ),
              ChipsChoice<String>.multiple(
                value: widget.tags,
                onChanged: (val) => setState(() {
                  widget.tags = val;
                  if (widget.tags.isNotEmpty) {
                    widget.areFiltersEnabled = true;
                  } else {
                    widget.areFiltersEnabled = false;
                  }
                }),
                choiceItems: C2Choice.listFrom<String, String>(
                  source: widget.options,
                  value: (i, v) => v,
                  label: (i, v) => v,
                ),
                wrapCrossAlignment: WrapCrossAlignment.start,
                choiceStyle: C2ChoiceStyle(),
                choiceActiveStyle: C2ChoiceStyle(
                    showCheckmark: true,
                    color: ThemeColors.oranges,
                    labelStyle: TextStyle(color: Colors.white),
                    brightness: Brightness.dark),
              ),
            ],
          ),
        ),
      );
    }

    // TODO Add search bar
    return Scaffold(
        appBar: Header.getAppBar(title: 'Start a New Order'),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: StreamBuilder<List<Restaurant>>(
              stream: restaurantProvider.restaurantsList,
              builder: (context, snapshot) {
                if (snapshot.data == null || userLocator.coordinates == null) {
                  return Center(child: CircularProgressIndicator());
                } else {
                  final userLatitude = userLocator.coordinates.latitude;
                  final userLongitude = userLocator.coordinates.longitude;
                  snapshot.data.sort((a, b) => Geolocator.distanceBetween(
                          a.coordinates.latitude,
                          a.coordinates.longitude,
                          userLatitude,
                          userLongitude)
                      .compareTo(Geolocator.distanceBetween(
                          b.coordinates.latitude,
                          b.coordinates.longitude,
                          userLatitude,
                          userLongitude)));
                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: CupertinoSearchTextField(
                                padding: EdgeInsets.all(15.0),
                              ),
                            ),
                            SizedBox(width: 10),
                            InkResponse(
                              child: Icon(
                                Icons.filter_list,
                                size: 30,
                                color: widget.areFiltersEnabled
                                    ? ThemeColors.oranges
                                    : ThemeColors.dark,
                              ),
                              onTap: () {
                                setState(() {
                                  widget.isFilterCardShown =
                                      !widget.isFilterCardShown;
                                });
                              },
                              radius: 20,
                            ),
                          ],
                        ),
                      ),
                      widget.isFilterCardShown ? _filterCard() : Container(),
                      Expanded(
                        child: Scrollbar(
                          child: ListView.builder(
                              itemCount: snapshot.data.length,
                              itemBuilder: (context, index) {
                                return RestaurantCard(
                                    snapshot.data[index].restaurantId,
                                    snapshot.data[index].restaurantName,
                                    snapshot.data[index].cuisineType,
                                    snapshot.data[index].deliveryFee,
                                    snapshot.data[index].rating,
                                    snapshot.data[index].image);
                              }),
                        ),
                      ),
                    ],
                  );
                }
              }),
        ));
  }
}
