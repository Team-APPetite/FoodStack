import 'package:flutter_braintree/flutter_braintree.dart';

class BraintreeServices {
  static makePayment(double amount, String payee) async {
    var request = BraintreeDropInRequest(
      tokenizationKey: 'sandbox_x6ht3hjz_wy33zpcrkwngprjq',
      collectDeviceData: true,
      paypalRequest: BraintreePayPalRequest(
        amount: amount.toString(),
        displayName: payee
      ),
      cardEnabled: true
    );

    BraintreeDropInResult result = await BraintreeDropIn.start(request);

    if (result != null) {
      print(result.paymentMethodNonce.description);
      print(result.paymentMethodNonce.nonce);
    }
  }
}