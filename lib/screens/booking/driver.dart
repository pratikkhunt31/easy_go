import 'dart:convert';
import 'dart:developer';

import 'package:easy_go/controller/driver_controller.dart';
import 'package:easy_go/models/rideModel.dart';
import 'package:easy_go/screens/booking/payment.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import 'package:get/get.dart';import 'package:razorpay_flutter/razorpay_flutter.dart';

import '../../consts/firebase_consts.dart';
import '../../widget/custom_widget.dart';
import '../home/home_screen.dart';

class Driver extends StatefulWidget {
  final int amountToBePaid;
  final String rideRequestId;
  const Driver({super.key,required this.amountToBePaid, required this.rideRequestId});

  @override
  State<Driver> createState() => _DriverState();
}

class _DriverState extends State<Driver> {
  DriverController driverController = Get.put(DriverController());
  late DatabaseReference driverRef;
  Map<dynamic, dynamic>? driverData;
  bool isLoading = true;
  late Razorpay razorpay;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    razorpay = Razorpay();
    razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, errorHandler);
    razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, successHandler);
    // getDriverData();
    listenForDriverId();
  }

  void listenForDriverId() {
    DatabaseReference rideRequestRef = FirebaseDatabase.instance
        .ref()
        .child('Ride Request')
        .child(widget.rideRequestId);

    rideRequestRef.onValue.listen((event) {
      if (event.snapshot.exists && event.snapshot.value is Map) {
        Map<dynamic, dynamic> rideRequestData =
        event.snapshot.value as Map<dynamic, dynamic>;
        String? driverId = rideRequestData['driver_id'];
        if (driverId != null && driverId != 'waiting') {
          getDriverData(driverId);
        }
      }
    });
  }

  Future<void> getDriverData(String driverId) async {
    driverRef = FirebaseDatabase.instance.ref().child("drivers").child(driverId);

    driverRef.onValue.listen((event) {
      if (event.snapshot.exists && event.snapshot.value is Map) {
        Map<dynamic, dynamic> driver = event.snapshot.value as Map<dynamic, dynamic>;
        setState(() {
          driverData = driver;
          isLoading = false;
        });
      } else {
        print("No driver data found or invalid data format.");
      }
    });
  }


  Future<Map?> getDriverData2() async {
    String? driverId = await driverController.getDriverIdFromRideRequest(widget.rideRequestId);
    if (driverId == null) {
      print("Driver ID is null.");
      return null;
    }
    print(driverId);
    DatabaseReference driverRef =
        FirebaseDatabase.instance.ref().child("drivers").child(driverId);

    try {
      DatabaseEvent event = await driverRef.once();
      DataSnapshot snapshot = event.snapshot;

      if (snapshot.exists && snapshot.value is Map) {
        Map<dynamic, dynamic> driver = snapshot.value as Map<dynamic, dynamic>;
        setState(() {
          driverData = driver;
        });
        return driver;
      } else {
        print("No ride requests found or invalid data format.");
      }
    } catch (e) {
      print("Failed to retrieve ride requests: $e");
    }

    return null;
  }

  void openCheckout({
    String? orderId,
    required String userPhoneNumber,
    required String userEmail,
    required int amount,
    required String driverRazorpayAccId,
    required String orderTitle,
  }) async {
    if (orderId != null) {
      var options = {
        "key": "rzp_test_gAsXTMY3aoa4io",
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
          "account_id": driverRazorpayAccId,
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
      debugPrint(json.decode(response.body).toString());

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Failed to create order. Please try again."),
        backgroundColor: Colors.red,
      ));
    }
  }

  void errorHandler(response) {
    if (response.data != null) {
      savePaymentDetails(response.data!["razorpay_order_id"],
          response.data!["razorpay_payment_id"]);
    }

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(response.toString()),
      backgroundColor: Colors.red,
    ));
  }

  void successHandler(PaymentSuccessResponse response) {
    if (response.data != null) {
      savePaymentDetails(response.data!["razorpay_order_id"],
          response.data!["razorpay_payment_id"]);
    }

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(response.paymentId!),
      backgroundColor: Colors.green,
    ));

    // Get.offAll(HomeScreen());
    Navigator.pop(context);
  }

  void savePaymentDetails(String orderId, String? paymentId) {
    debugPrint("order id: $orderId");
    debugPrint("payment id: $paymentId");

    DatabaseReference paymentDetailsRef = FirebaseDatabase.instance
        .ref()
        .child("Ride Request")
        .child(widget.rideRequestId)
        .child("paymentDetails");

    paymentDetailsRef.update({
      "orderId": orderId,
      "paymentId": paymentId,
      "status": paymentId != null ? "success" : "failed"
    });
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Driver"),
        backgroundColor: const Color(0xFF0000FF),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: CustomButton(
          hint: "Proceed to Payment",
          onPress: () {
            log('Payment Button Pressed');
            if (driverData == null) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text("Driver data not available. Please try again."),
                backgroundColor: Colors.red,
              ));
              return;
            }

            openCheckout(
              userEmail: currentUserInfo?.email.toString() ??
                  "", // email of user requesting the ride
              userPhoneNumber: currentUserInfo?.phone.toString() ??
                  "", // phone number of user requesting the ride
              amount: widget.amountToBePaid,
              driverRazorpayAccId: driverData!["account_id"],
              orderTitle: "Pay Securely", // title of the order
              orderId: null,
            );
          },
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      body: driverData != null
          ? Padding(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (driverData!['vehicleImages'] != null &&
                          driverData!['vehicleImages'].isNotEmpty)
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: Image.network(
                            driverData!['vehicleImages'][0],
                            height: 150,
                            width: double.infinity,
                            fit: BoxFit.fill,
                          ),
                        ),
                      const SizedBox(height: 16.0),
                      Text(
                        "Name: ${driverData!['name'] ?? 'N/A'}",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                        "Phone: ${driverData!['phoneNumber'] ?? 'N/A'}",
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      Center(
                        child: CustomButton(
                          hint: "Test",
                          onPress: () {
                            // TODO: Add your desired action here
                            // Navigator.push(context,
                            //     MaterialPageRoute(builder: (_) => Payment()));
                          },
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          : Center(child: const CircularProgressIndicator()),
      // Column(
      //   children: [
      //     if (driverData != null)
      //       Column(
      //         children: [
      //           Text("Name:- ${driverData!['name'] ?? 'N/A'}"),
      //           Text("Phone:- ${driverData!['phoneNumber'] ?? 'N/A'}"),
      //
      //         ],
      //       )
      //     else
      //       Center(
      //         child: CircularProgressIndicator(),
      //       ),
      //     Center(
      //       child: CustomButton(
      //         hint: "Test",
      //         onPress: () {
      //           // TODO: change this based on your state management package
      //           fetchDriverDetails();
      //           // Navigator.push(
      //           //     context, MaterialPageRoute(builder: (_) => Payment()));
      //         },
      //         borderRadius: BorderRadius.circular(10),
      //       ),
      //     ),
      //   ],
      // ),
    );
  }
}
