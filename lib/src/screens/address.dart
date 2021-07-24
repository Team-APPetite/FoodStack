import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:foodstack/src/blocs/auth_blocs.dart';
import 'package:foodstack/src/providers/userLocator.dart';
import 'package:foodstack/src/services/firestoreUsers.dart';
import 'package:foodstack/src/styles/textStyles.dart';
import 'package:foodstack/src/styles/themeColors.dart';
import 'package:foodstack/src/widgets/button.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:foodstack/src/widgets/header.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddressScreen extends StatefulWidget {
  @override
  _AddressScreenState createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  int value = 0;
  bool isPooler = false;

  FirestoreUsers firestoreService = FirestoreUsers();

  @override
  void initState() {
    super.initState();
    _getUserRole();
  }

  Future<bool> _getUserRole() async {
    final prefs = await SharedPreferences.getInstance();
    isPooler = prefs.getBool('isPooler');
    return isPooler;
  }

  @override
  Widget build(BuildContext context) {
    final userLocator = Provider.of<UserLocator>(context);
    final authBloc = Provider.of<AuthBloc>(context);
    LatLng userCoordinates = userLocator.coordinates;
    GoogleMapController _mapController;

    void whenMapCreated(GoogleMapController _controller) {
      setState(() {
        _mapController = _controller;
      });
    }

    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: Header.getAppBar(title: 'Add delivery address'),
        body: (userLocator.deliveryAddress == null)
            ? Center(child: CircularProgressIndicator())
            : Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    CupertinoSearchTextField(
                      padding: EdgeInsets.all(15.0),
                      onChanged: (value) {
                        Fluttertoast.showToast(
                          msg:
                              'Unfortunately you cannot search for addresses yet, please set your location using the map',
                          gravity: ToastGravity.TOP,
                          timeInSecForIosWeb: 5,
                          backgroundColor: ThemeColors.dark,
                        );
                      },
                    ),
                    SizedBox(height: 30.0),
                    Expanded(
                      child: Stack(
                        children: [
                          Container(
                            child: GoogleMap(
                                mapType: MapType.normal,
                                zoomControlsEnabled: false,
                                minMaxZoomPreference:
                                    MinMaxZoomPreference(1.5, 21),
                                myLocationEnabled: true,
                                myLocationButtonEnabled: true,
                                mapToolbarEnabled: true,
                                initialCameraPosition: CameraPosition(
                                  target: userCoordinates,
                                  zoom: 14,
                                ),
                                onCameraMove: (CameraPosition cameraPosition) {
                                  userLocator.onCameraMove(cameraPosition);
                                },
                                onMapCreated: whenMapCreated,
                                onCameraIdle: () {
                                  userLocator.getCameraLocation();
                                }),
                          ),
                          Center(
                            child: Container(
                              height: 500,
                              child: Icon(
                                Icons.location_pin,
                                color: ThemeColors.oranges,
                                size: 50.0,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: 200.0,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 30.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              userLocator.deliveryAddress.featureName,
                              style: TextStyles.heading3(),
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              userLocator.deliveryAddress.addressLine,
                              style: TextStyles.body(),
                              textAlign: TextAlign.center,
                            ),
                            AppButton(
                              buttonText: 'DELIVER HERE',
                              onPressed: () {
                                firestoreService.updateAddress(
                                    authBloc.user.uid,
                                    userLocator.deliveryAddress.addressLine);
                                firestoreService.updateCoordinates(
                                    authBloc.user.uid,
                                    userLocator.getUserLocation());
                                Fluttertoast.showToast(
                                  msg: 'Address Updated',
                                  gravity: ToastGravity.TOP,
                                  timeInSecForIosWeb: 3,
                                  backgroundColor: ThemeColors.dark,
                                );
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ));
  }
}
