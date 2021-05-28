import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:foodstack/src/widgets/header.dart';

class AddressScreen extends StatefulWidget {
  @override
  _AddressScreenState createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Header.getAppBar(),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: ListView(
            children: [
              // TextField(
              //   decoration: InputDecoration(
              //     icon: Icon(Icons.search),
              //     hintText: 'Search',
              //
              //   ),
              // ),
              CupertinoSearchTextField(
                padding: EdgeInsets.all(15.0),
              ),
              SizedBox(height: 30.0),
              Container(
                height: 300.0,
                child: GoogleMap(
                  mapType: MapType.normal,
                  myLocationEnabled: true,
                  initialCameraPosition:
                      CameraPosition(
                          target: LatLng(1.3521, 103.8198), // Singapore
                      ),
                ),
              )
            ],
          ),
        ));
  }
}
