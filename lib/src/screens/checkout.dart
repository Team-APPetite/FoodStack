    import 'package:flutter/material.dart';
    import 'package:foodstack/src/providers/userLocator.dart';
    import 'package:foodstack/src/screens/home.dart';
    import 'package:foodstack/src/services/firestoreUsers.dart';
    import 'package:foodstack/src/styles/textStyles.dart';
    import 'package:foodstack/src/styles/themeColors.dart';
    import 'package:foodstack/src/utilities/payment.dart';
    import 'package:foodstack/src/widgets/button.dart';
    import 'package:foodstack/src/widgets/header.dart';
    import 'package:google_maps_flutter/google_maps_flutter.dart';
    import 'package:provider/provider.dart';

    class CheckoutScreen extends StatefulWidget {
      @override
      _CheckoutScreenState createState() => _CheckoutScreenState();
    }

    class _CheckoutScreenState extends State<CheckoutScreen> {
      FirestoreUsers firestoreService = FirestoreUsers();
      int value = 0;
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
            appBar: Header.getAppBar(title: 'Checkout'),
            body: (userLocator.deliveryAddress == null)
                ? Center(child: CircularProgressIndicator())
                : Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Deliver to',
                        style: TextStyles.heading2(),
                      ),
                    ),
                SizedBox(height: 30.0),
                Expanded(
                  child: Stack(
                    children: [
                         GoogleMap(
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
                      Center(
                        child: Container(
                          height: 500,
                          child: Icon(
                            Icons.location_pin,
                            color: ThemeColors.oranges,
                            size: 50.0,
                          ),
                        ),
                      ),],
                  ),
                ),

                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              userLocator.deliveryAddress.addressLine,
                              style: TextStyles.body(),
                              textAlign: TextAlign.center,
                            ),
                            AppButton(buttonText: 'ADD NEW ADDRESS', onPressed: () {
                              firestoreService.updateAddress(userLocator.deliveryAddress.addressLine);
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    


                    Expanded(
                      child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Payment Methods',
                            style: TextStyles.heading2(),
                          ),
                        ),
                    ),



                    Expanded(
                      child: ListView.separated(
                        itemCount: paymentLabels.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            leading: Radio(
                              activeColor: ThemeColors.oranges,
                              value: index,
                              groupValue: value,
                              onChanged: (i) => setState(() => value = i),
                            ),
                            title: Text(
                              paymentLabels[index],
                              style: TextStyle(color: ThemeColors.dark),
                            ),
                            trailing: Icon(paymentIcons[index], color: ThemeColors.oranges),
                          );
                        },
                        separatorBuilder: (context, index) {
                          return Divider();
                        },
                      ),
                    ),

                    Expanded (
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            AppButton(
                              buttonText: 'PAY',
                              onPressed: () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) => HomeScreen()));
                                },
                            ),
                          ],
                        ),
                      )
                    )
                  ])
            )
        );
      }
    }
