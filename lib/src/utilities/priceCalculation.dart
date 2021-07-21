import 'package:foodstack/src/utilities/numbers.dart';

class PriceCalculation {

  static double finalDeliveryFee(double deliveryFee, int numOfUsers) {
    double finalDeliveryFee = deliveryFee/numOfUsers;
    return Numbers.roundTo2d(finalDeliveryFee);
  }

  static double totalFee(double _subtotal, double _deliveryFee, int _numOfUsers) {
   double _totalFee = 0.0;
   double _finalDeliveryFee = finalDeliveryFee(_deliveryFee, _numOfUsers);
   _totalFee = _subtotal + _finalDeliveryFee;
   return Numbers.roundTo2d(_totalFee);
  }



}