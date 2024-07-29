import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:http/http.dart' as http;

class Payment extends StatefulWidget {
  const Payment({
    super.key,
  });

  @override
  State<Payment> createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  late Razorpay razorpay;

  @override
  void initState() {
    super.initState();
    razorpay = Razorpay();
    razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, errorHandler);
    razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, successHandler);
  }

  void errorHandler(response) {
    // TODO: show any failure element here, by default it's snackbar
    // TODO: also save "orderId" to save for further assistance and refunds

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(response.toString()),
      backgroundColor: Colors.red,
    ));
  }

  void successHandler(PaymentSuccessResponse response) {
    // TODO: move to the next screen and save any data to firebase database here
    // TODO: also save "razorpay_order_id" and "razorpay_payment_id" to save for further assistance and refunse, see below debugPrint() to know more
    // sample of below debugPrint() output: {razorpay_signature: 0cc1710ccc23e5a4d2466734dcd3341cf017cff7062bab23c248b71b751fbcd3, razorpay_order_id: order_OGhraAQrMN4H8e, razorpay_payment_id: pay_OGhrnQfEgcIvlv}
    debugPrint(response.data.toString());

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(response.paymentId!),
      backgroundColor: Colors.green,
    ));
  }

  // TODO: build UI anyway you want, just remember to call "openCheckout()" on button press with required attributes
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 50),
            const Text(
              'Payment Title',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                openCheckout(
                  userEmail: "example@example.com",
                  userPhoneNumber: "1234567890",
                  amount: 100,
                  driverRazorpayAccId: "acc_OGZYAaPFqQGXKV",
                  orderTitle: "Vadodara to Ahmedabad",
                );
              },
              child: const Text('Pay Now'),
            ),
          ],
        ),
      ),
    );
  }

  void openCheckout(
      {
      // TODO: if there's an order accociated with the ride/trip then pass it here to avoid creating new order (this mostly happens when user cancels the payment and retries again with same ride/trip id)
      String? orderId,
      required String userPhoneNumber,
      required String userEmail,
      required int amount,
      required String driverRazorpayAccId,
      // TODO: better to use trip pickup and drop off location as order title
      required String orderTitle}) async {
    if (orderId != null) {
      var options = {
        "key": "rzp_live_2rwQU48M3FIa72",
        "name": orderTitle,
        'prefill': {'contact': userPhoneNumber, 'email': userEmail},
        "order_id": orderId,
      };

      razorpay.open(options);
    }

    final http.Response response = await http.post(
        Uri.parse('https://easygoapi-eieu6qudpq-uc.a.run.app/orders'),
        body: json.encode({
          "amount": amount,
          "acc_id": driverRazorpayAccId,
          "order_title": orderTitle
        }),
        headers: {
          'content-type': 'application/json',
        });

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);

      debugPrint(data.toString());

      orderId = data['order_id'];

      var options = {
        "key": "rzp_test_gAsXTMY3aoa4io",
        "name": orderTitle,
        'prefill': {'contact': userPhoneNumber, 'email': userEmail},
        "order_id": orderId,
      };

      razorpay.open(options);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Failed to create order. Please try again."),
        backgroundColor: Colors.red,
      ));
    }
  }
}
