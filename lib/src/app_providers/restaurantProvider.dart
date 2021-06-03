import 'package:flutter/cupertino.dart';
import 'package:foodstack/src/services/firestoreService.dart';
import 'package:uuid/uuid.dart';

class RestaurantProvider with ChangeNotifier {
  final firestoreService = FirestoreService();

  String _restaurantId;
  String _restaurantName;
  String _cuisineType;
  String _deliveryMins;
  double _rating;
  String _image;

  var uuid = Uuid();

}