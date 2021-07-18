import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:foodstack/src/models/order.dart';
import 'package:geoflutterfire/geoflutterfire.dart';

Geoflutterfire geo = Geoflutterfire();
GeoFirePoint location = geo.point(latitude: 1.00, longitude: 100.0);
Timestamp currentTime = Timestamp.now();

Order mockOrder = Order(
    orderId: "123",
    restaurantId: "456",
    restaurantName: "Mc Donald's",
    creatorId: "789",
    paymentId: "1011",
    status: "Status.none",
    deliveryAddress: "12 Science Park",
    coordinates: location,
    orderTime: currentTime,
    totalPrice: 14.50,
    cartIds: ["1213"]);

var jsonOrder = {
  "orderId": "123",
  "restaurantId": "456",
  "restaurantName": "Mc Donald's",
  "creatorId": "789",
  "paymentId": "1011",
  "status": "Status.none",
  "deliveryAddress": "12 Science Park",
  "coordinates": location.data,
  "orderTime": currentTime,
  "totalPrice": 14.50,
  "cartIds": ["1213"]
};

void main() async {
  group('Food item model', () {
    test('From json', () {
      Order order = Order.fromFirestore(jsonOrder);
      expect(order.orderId, mockOrder.orderId);
      expect(order.restaurantId, mockOrder.restaurantId);
      expect(order.restaurantName, mockOrder.restaurantName);
      expect(order.creatorId, mockOrder.creatorId);
      expect(order.paymentId, mockOrder.paymentId);
      expect(order.status, mockOrder.status);
      expect(order.deliveryAddress, mockOrder.deliveryAddress);
      expect(order.getCoordinates, mockOrder.coordinates.data);
      expect(order.orderTime, mockOrder.orderTime);
      expect(order.totalPrice, mockOrder.totalPrice);
      expect(order.cartIds, mockOrder.cartIds);
    });

    test('To map', () {
      expect(mockOrder.toMap(), jsonOrder);
    });
  });
}
