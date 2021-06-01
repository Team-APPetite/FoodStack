import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:foodstack/src/app_providers/userLocator.dart';
import 'package:foodstack/src/themeColors.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:foodstack/src/widgets/header.dart';
import 'package:provider/provider.dart';

class AddressScreen extends StatefulWidget {
  @override
  _AddressScreenState createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
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
                padding: const EdgeInsets.only(
                    left: 30.0, right: 30.0, bottom: 30.0),
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
                        padding: const EdgeInsets.all(30.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              userLocator.deliveryAddress.featureName,
                              style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              userLocator.deliveryAddress.addressLine,
                              style: TextStyle(
                                fontSize: 16.0,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            ElevatedButton(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 80.0, vertical: 16.0),
                                child: Text(
                                  'DELIVER HERE',
                                  style: TextStyle(
                                    fontSize: 16.0,
                                  ),
                                ),
                              ),
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                ),
                                primary: ThemeColors.oranges,
                              ),
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
