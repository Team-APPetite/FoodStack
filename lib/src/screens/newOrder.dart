import 'dart:async';

import 'package:chips_choice/chips_choice.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:foodstack/src/models/restaurant.dart';
import 'package:foodstack/src/styles/textStyles.dart';
import 'package:foodstack/src/styles/themeColors.dart';
import 'package:foodstack/src/utilities/filters.dart';
import 'package:foodstack/src/utilities/sortingOptions.dart';
import 'package:foodstack/src/widgets/header.dart';
import 'package:foodstack/src/widgets/restaurantCard.dart';
import 'package:foodstack/src/providers/restaurantProvider.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:foodstack/src/providers/userLocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NewOrderScreen extends StatefulWidget {
  @override
  _NewOrderScreenState createState() => _NewOrderScreenState();
}

class _NewOrderScreenState extends State<NewOrderScreen> {
  Stream<List<Restaurant>> restaurantsList;
  Stream<List<Restaurant>> filteredList;

  String initialSearchString;
  String searchString;

  bool isFilterCardShown = false;
  bool areFiltersEnabled = false;

  List<String> tags = [];

  TextEditingController textEditingController = TextEditingController();
  FocusNode focusNode;

  // Commented out since this code is not being used currently

  // final sortDirection = [
  //   'Low to High',
  //   'High to Low',
  // ];
  //
  // final directionIcons = [
  //   Icons.arrow_upward_outlined,
  //   Icons.arrow_downward_outlined,
  // ];

  bool ascending = true;
  bool descending = false;

  Color ascendingColour = ThemeColors.oranges;
  Color descendingColour = ThemeColors.dark;

  int value = 0;

  @override
  void initState() {
    final restaurantProvider =
        Provider.of<RestaurantProvider>(context, listen: false);
    restaurantsList = restaurantProvider.restaurantsList;
    filteredList = restaurantsList;
    focusNode = FocusNode();
    super.initState();
    _setUserRole();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final arguments = ModalRoute.of(context).settings.arguments as Map;

    if (arguments != null) {
      textEditingController.text = arguments['searchString'];
      focusNode.requestFocus();
      _onSearchChanged(textEditingController.text);
    }
  }

  Future<void> _setUserRole() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isPooler', false);
  }

  _onSearchChanged(String searchWord) {
    var result;
    searchString = searchWord;
    if (searchWord.isEmpty) {
      result = restaurantsList;
    } else {
      result = restaurantsList.map((restaurants) => restaurants
          .where((restaurant) => restaurant.restaurantName
              .toLowerCase()
              .trim()
              .contains(searchWord.toLowerCase().trim()))
          .toList());
    }

    setState(() {
      filteredList = result;
    });
  }

  _onFiltersAdded({List filters, int sortBy, bool isLowToHigh}) {
    String sortingParameter;
    if (sortBy == 1) {
      sortingParameter = 'rating';
    } else if (sortBy == 2) {
      sortingParameter = 'deliveryFee';
    } else {
      sortingParameter = '';
    }
    final restaurantProvider =
        Provider.of<RestaurantProvider>(context, listen: false);
    print(filters);
    if (filters.isNotEmpty || sortingParameter.isNotEmpty) {
      restaurantsList = restaurantProvider.filterRestaurantsList(
          filters: filters, sortBy: sortingParameter, isLowToHigh: isLowToHigh);
      setState(() {
        filteredList = restaurantsList;
      });
      if (searchString != null) _onSearchChanged(searchString);
    } else {
      restaurantsList = restaurantProvider.restaurantsList;
      setState(() {
        filteredList = restaurantsList;
      });
      if (searchString != null) _onSearchChanged(searchString);
    }
  }

  @override
  Widget build(BuildContext context) {
    final userLocator = Provider.of<UserLocator>(context);
    Widget _filterCard() {
      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.0),
          border: Border.all(
            color: ThemeColors.light,
            width: 1,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 10),
              Text(
                'Cuisine Type',
                style: TextStyles.heading3(),
                textAlign: TextAlign.start,
              ),
              ChipsChoice<String>.multiple(
                value: tags,
                onChanged: (val) => setState(() {
                  tags = val;
                  _onFiltersAdded(
                      filters: tags, sortBy: value, isLowToHigh: ascending);
                  if (tags.isNotEmpty) {
                    areFiltersEnabled = true;
                  } else {
                    areFiltersEnabled = false;
                  }
                }),
                choiceItems: C2Choice.listFrom<String, String>(
                  source: filtersList,
                  value: (i, v) => v,
                  label: (i, v) => v,
                ),
                choiceStyle: C2ChoiceStyle(),
                choiceActiveStyle: C2ChoiceStyle(
                    showCheckmark: true,
                    color: ThemeColors.oranges,
                    labelStyle: TextStyle(color: Colors.white),
                    brightness: Brightness.dark),
                // wrapped: true,
              ),
              SizedBox(height: 20.0),
              Text(
                'Sort By',
                style: TextStyles.heading3(),
                textAlign: TextAlign.start,
              ),
              RadioListTile(
                dense: true,
                activeColor: ThemeColors.oranges,
                value: 0,
                groupValue: value,
                onChanged: (i) {
                  setState(() => value = i);
                },
                title: Text(
                  sortOptions[0],
                  style: TextStyle(color: ThemeColors.dark, fontSize: 15),
                ),
                secondary: Icon(sortIcons[0], color: ThemeColors.oranges),
              ),
              RadioListTile(
                dense: true,
                activeColor: ThemeColors.oranges,
                value: 1,
                groupValue: value,
                onChanged: (i) {
                  setState(() {
                    value = i;
                    _onFiltersAdded(
                        filters: tags, sortBy: value, isLowToHigh: ascending);
                  });
                },
                title: Text(
                  sortOptions[1],
                  style: TextStyle(color: ThemeColors.dark, fontSize: 15),
                ),
                secondary: Icon(sortIcons[1], color: ThemeColors.oranges),
              ),
              RadioListTile(
                dense: true,
                activeColor: ThemeColors.oranges,
                value: 2,
                groupValue: value,
                onChanged: (i) {
                  setState(() {
                    value = i;
                    _onFiltersAdded(
                        filters: tags, sortBy: value, isLowToHigh: ascending);
                  });
                },
                title: Text(
                  sortOptions[2],
                  style: TextStyle(color: ThemeColors.dark, fontSize: 15),
                ),
                secondary: Icon(sortIcons[2], color: ThemeColors.oranges),
              ),
              SizedBox(
                height: 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: InkWell(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24.0),
                          border: Border.all(
                            color: ThemeColors.light,
                            width: 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(
                                Icons.arrow_upward_outlined,
                                color: ascendingColour,
                              ),
                            ),
                            Text(
                              "Low to High",
                              style: TextStyle(color: ThemeColors.dark),
                            ),
                          ],
                        ),
                      ),
                      onTap: () {
                        setState(() {
                          ascending = true;
                          descending = false;
                          ascendingColour = ThemeColors.oranges;
                          descendingColour = ThemeColors.dark;
                          _onFiltersAdded(
                              filters: tags,
                              sortBy: value,
                              isLowToHigh: ascending);
                        });
                      },
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: InkWell(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24.0),
                          border: Border.all(
                            color: ThemeColors.light,
                            width: 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(
                                Icons.arrow_downward_outlined,
                                color: descendingColour,
                              ),
                            ),
                            Text(
                              "High to Low",
                              style: TextStyle(color: ThemeColors.dark),
                            ),
                          ],
                        ),
                      ),
                      onTap: () {
                        setState(() {
                          ascending = false;
                          descending = true;
                          ascendingColour = ThemeColors.dark;
                          descendingColour = ThemeColors.oranges;
                          _onFiltersAdded(
                              filters: tags,
                              sortBy: value,
                              isLowToHigh: ascending);
                        });
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 15),
              Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    OutlinedButton(
                        child: Text(
                          'Clear',
                          style: TextStyle(
                              color: Colors.grey,
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold),
                        ),
                        onPressed: () {
                          setState(() {
                            tags = [];
                            value = 0;
                            ascending = true;
                            descending = false;
                            ascendingColour = ThemeColors.oranges;
                            descendingColour = ThemeColors.dark;
                            areFiltersEnabled = false;
                            _onFiltersAdded(
                                filters: tags, sortBy: 0, isLowToHigh: true);
                          });
                        }),
                    SizedBox(
                      width: 10,
                    ),
                    OutlinedButton(
                        child: Text(
                          'Done',
                          style: TextStyles.textButton(),
                        ),
                        onPressed: () {
                          setState(() {
                            isFilterCardShown = false;
                          });
                        })
                  ])
            ],
          ),
        ),
      );
    }

    return Scaffold(
        appBar: Header.getAppBar(title: 'Start a New Order'),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: StreamBuilder<List<Restaurant>>(
              stream: filteredList,
              builder: (context, snapshot) {
                if (snapshot.data == null || userLocator.coordinates == null) {
                  return Center(child: CircularProgressIndicator());
                } else {
                  final userLatitude = userLocator.coordinates.latitude;
                  final userLongitude = userLocator.coordinates.longitude;
                  if (value == 0) {
                    if (ascending) {
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
                    } else {
                      snapshot.data.sort((a, b) => Geolocator.distanceBetween(
                              b.coordinates.latitude,
                              b.coordinates.longitude,
                              userLatitude,
                              userLongitude)
                          .compareTo(Geolocator.distanceBetween(
                              a.coordinates.latitude,
                              a.coordinates.longitude,
                              userLatitude,
                              userLongitude)));
                    }
                  }
                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: CupertinoSearchTextField(
                                controller: textEditingController,
                                focusNode: focusNode,
                                onChanged: (value) {
                                  _onSearchChanged(value);
                                },
                                padding: EdgeInsets.all(15.0),
                              ),
                            ),
                            SizedBox(width: 10),
                            InkResponse(
                              child: Icon(
                                Icons.filter_list,
                                size: 30,
                                color: areFiltersEnabled
                                    ? ThemeColors.oranges
                                    : ThemeColors.dark,
                              ),
                              onTap: () {
                                setState(() {
                                  isFilterCardShown = !isFilterCardShown;
                                });
                              },
                              radius: 20,
                            ),
                          ],
                        ),
                      ),
                      isFilterCardShown ? _filterCard() : Container(),
                      Expanded(
                        child: Scrollbar(
                          child: ListView.builder(
                              itemCount: snapshot.data.length,
                              itemBuilder: (context, index) {
                                return RestaurantCard(
                                    'restaurant$index',
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

  @override
  void dispose() {
    searchString = null;
    textEditingController.dispose();
    focusNode.dispose();
    super.dispose();
  }
}
