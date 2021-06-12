import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:foodstack/src/app_providers/userLocator.dart';
import 'package:foodstack/src/services/firestoreUsers.dart';
import 'package:foodstack/src/styles/textStyles.dart';
import 'package:foodstack/src/styles/themeColors.dart';
import 'package:foodstack/src/widgets/button.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:foodstack/src/widgets/header.dart';
import 'package:provider/provider.dart';

class AddressScreen extends StatefulWidget {
  @override
  _AddressScreenState createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  FirestoreUsers firestoreService = FirestoreUsers();
  @override
  Widget build(BuildContext context) {
    final userLocator = Provider.of<UserLocator>(context);
    LatLng userCoordinates = userLocator.coordinates;
    GoogleMapController _mapController;

    void whenMapCreated(GoogleMapController _controller) {
      setState(() {
        _mapController = _controller;
      });
    }

    return Scaffold(
        appBar: Header.getAppBar(title: 'Add delivery address'),
        body: (userLocator.deliveryAddress == null)
            ? Center(child: CircularProgressIndicator())
            : Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    // TODO Search for addresses
                    CupertinoSearchTextField(
                      padding: EdgeInsets.all(15.0),
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
                            AppButton(buttonText: 'DELIVER HERE', onPressed: () {
                              firestoreService.updateAddress(userLocator.deliveryAddress.addressLine);
                            },),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ));
  }
}
