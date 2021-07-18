import 'dart:convert';

import 'package:flutter_braintree/flutter_braintree.dart';
import 'package:http/http.dart' as http;

class BraintreeService {
  static var url = 'https://us-central1-foodstack-e8d0f.cloudfunctions.net/makePayment';

  Future<String> makePayment(double amount, String payee) async {
    var request = BraintreeDropInRequest(
        tokenizationKey: 'sandbox_x6ht3hjz_wy33zpcrkwngprjq',
        collectDeviceData: true,
        paypalRequest: BraintreePayPalRequest(
            amount: amount.toString(), displayName: payee),
        cardEnabled: true);

    BraintreeDropInResult result = await BraintreeDropIn.start(request);

    if (result != null) {
      final http.Response response = await http.post(Uri.tryParse(
          '$url?payment_method_nonce=${result.paymentMethodNonce.nonce}&device_data=${result.deviceData}'));

      final paymentResult = response.body.isNotEmpty ? jsonDecode(response.body) : null;

      if (paymentResult['result'] == 'Success') {
        return "Payment successful!";
      } else {
        return "Unsuccessful transaction, Please try again";
      }
    } else {
      return "Please make payment for your order";
    }
  }
}
