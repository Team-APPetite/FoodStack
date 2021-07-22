import 'package:foodstack/src/utilities/numbers.dart';

class PriceCalculation {
  static double finalDeliveryFee(double deliveryFee, int numOfUsers) {
    if (deliveryFee != null) {
      double finalDeliveryFee = deliveryFee / numOfUsers;
      return Numbers.roundTo2d(finalDeliveryFee);
    } else {
      return -1;
    }
  }

  static double totalFee(
      double _subtotal, double _deliveryFee, int _numOfUsers) {
    double _totalFee = 0.0;
    double _finalDeliveryFee = finalDeliveryFee(_deliveryFee, _numOfUsers);
    if (_finalDeliveryFee != -1) {
      _totalFee = _subtotal + _finalDeliveryFee;
      return Numbers.roundTo2d(_totalFee);
    } else {
      return -1;
    }
  }

  static double getAmountSaved(double _deliveryFee, int _numOfUsers) {
    double _amountSaved;
    double _finalDeliveryFee = finalDeliveryFee(_deliveryFee, _numOfUsers);
    if (_finalDeliveryFee != -1) {
      _amountSaved = _deliveryFee - _finalDeliveryFee;
      return Numbers.roundTo2d(_amountSaved);
    } else {
      return -1;
    }
  }
}
