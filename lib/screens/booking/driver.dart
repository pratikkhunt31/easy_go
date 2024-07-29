import 'dart:async';
import 'dart:convert';
import 'package:easy_go/controller/driver_controller.dart';
import 'package:easy_go/screens/booking/bookings.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:loading_indicator/loading_indicator.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:velocity_x/velocity_x.dart';
import '../../consts/firebase_consts.dart';
import '../../widget/custom_widget.dart';

class Driver extends StatefulWidget {
  final int amountToBePaid;
  final String rideRequestId;

  const Driver(
      {super.key, required this.amountToBePaid, required this.rideRequestId});

  @override
  State<Driver> createState() => _DriverState();
}

class _DriverState extends State<Driver> {
  DriverController driverController = Get.put(DriverController());
  late DatabaseReference rideRequestRef;
  late DatabaseReference driverRef;
  Map<dynamic, dynamic>? driverData;
  bool isLoading = true;
  late Razorpay razorpay;

  // Timer? driverFindingTimer;
  Timer? countdownTimer;
  int remainingTime = 300;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    razorpay = Razorpay();
    razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, errorHandler);
    razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, successHandler);
    rideRequestRef = FirebaseDatabase.instance
        .ref()
        .child('Ride Request')
        .child(widget.rideRequestId);

    // Future.delayed(Duration.zero, () {
    //   showDriverFindingBottomSheet();
    // });
    // getDriverData();
    listenForDriverId();
    startCountdownTimer();
    // startDriverFindingTimer();
  }

  @override
  void dispose() {
    razorpay.clear();
    // driverFindingTimer?.cancel();
    countdownTimer?.cancel();
    super.dispose();
  }

  // void listenForDriverId() {
  //   DatabaseReference rideRequestRef = FirebaseDatabase.instance
  //       .ref()
  //       .child('Ride Request')
  //       .child(widget.rideRequestId);
  //
  //   rideRequestRef.onValue.listen((event) {
  //     if (event.snapshot.exists && event.snapshot.value is Map) {
  //       Map<dynamic, dynamic> rideRequestData =
  //           event.snapshot.value as Map<dynamic, dynamic>;
  //       String? driverId = rideRequestData['driver_id'];
  //       if (driverId != null && driverId != 'waiting') {
  //         getDriverData(driverId);
  //       }
  //     }
  //   });
  // }

  void listenForDriverId() {
    rideRequestRef.onValue.listen((event) {
      if (event.snapshot.exists && event.snapshot.value is Map) {
        Map<dynamic, dynamic> rideRequestData =
            event.snapshot.value as Map<dynamic, dynamic>;
        String? driverId = rideRequestData['driver_id'];
        if (driverId != null && driverId != 'waiting') {
          getDriverData(driverId);
          countdownTimer?.cancel();
        }
      }
    });
  }

  Future<void> getDriverData(String driverId) async {
    driverRef =
        FirebaseDatabase.instance.ref().child("drivers").child(driverId);

    driverRef.onValue.listen((event) {
      if (event.snapshot.exists && event.snapshot.value is Map) {
        Map<dynamic, dynamic> driver =
            event.snapshot.value as Map<dynamic, dynamic>;
        if (mounted) {
          setState(() {
            driverData = driver;
            isLoading = false;
          });
        }
        // Navigator.pop(context); // Close the bottom sheet
        // showDriverDetailsBottomSheet();
      } else {
        print("No driver data found or invalid data format.");
      }
    });
  }

  Future<void> cancelRide(String rideId) async {

    DatabaseReference rideRequest = FirebaseDatabase.instance
        .ref()
        .child('Ride Request')
        .child(rideId);
    await rideRequest.update({
      'status': "cancel",
    });
  }

  void startCountdownTimer() {
    countdownTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }

      if (remainingTime <= 0) {
        timer.cancel();
        rideRequestRef.remove();
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Driver not assigned. Please make a new request."),
          backgroundColor: Colors.red,
        ));
      } else {
        setState(() {
          remainingTime--;
        });
      }
    });
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
        "key": "rzp_live_2rwQU48M3FIa72",
        // "key": "rzp_test_gAsXTMY3aoa4io",
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
        "key": "rzp_live_2rwQU48M3FIa72",
        // "key": "rzp_test_gAsXTMY3aoa4io",
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

    Future.delayed(Duration(milliseconds: 300), () {
      // Close the bottom sheet
      // Navigator.of(context).pop();
      // Navigator.pop(context);
      // Navigator.pop(context);
      // Navigator.pop(context);
      Get.offAll(() => Bookings());
    });
  }

  void savePaymentDetails(String orderId, String? paymentId) {
    debugPrint("order id: $orderId");
    debugPrint("payment id: $paymentId");

    DatabaseReference paymentDetailsRef = FirebaseDatabase.instance
        .ref()
        .child("Ride Request")
        .child(widget.rideRequestId)
        .child("paymentDetails");

    DatabaseReference paymentStatusRef = FirebaseDatabase.instance
        .ref()
        .child("Ride Request")
        .child(widget.rideRequestId);

    String status = paymentId != null ? "success" : "failed";

    paymentDetailsRef.update({
      "orderId": orderId,
      "paymentId": paymentId,
      "status": status,
    }).then((_) {
      // Only update payment status if the payment details update succeeds
      paymentStatusRef.update({'payment_status': status});
    }).catchError((error) {
      // Handle any errors here
      debugPrint("Failed to update payment details: $error");
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("Driver"),
        backgroundColor: const Color(0xFF0000FF),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (driverData == null) ...[
                Container(
                  height: 100,
                  width: 100,
                  child: LoadingIndicator(
                    indicatorType: Indicator.ballClipRotateMultiple,
                    colors: [Color(0xFF0000FF)],
                    strokeWidth: 2,
                  ),
                ),
                const SizedBox(height: 16.0),
                Text("Finding a driver..."),
                const SizedBox(height: 16.0),
                Text(
                  "Time remaining: ${remainingTime ~/ 60}:${(remainingTime % 60).toString().padLeft(2, '0')}",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16.0),
                CustomButton(
                  hint: "Cancel Ride",
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(10),
                  onPress: () async {
                    await rideRequestRef.remove();
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text("Ride cancelled successfully"),
                      backgroundColor: Colors.red,
                    ));
                    Navigator.pop(context);
                  },
                ),
              ] else ...[
                Text(
                  "Driver Details",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Divider(),
                const SizedBox(height: 8.0),
                Text(
                  "Name: ${driverData!['name'] ?? 'N/A'}",
                  style: const TextStyle(
                    fontSize: 18,
                    // fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8.0),
                CustomButton(
                  hint: "Proceed to Payment",
                  color: Color(0xFF0000FF),
                  borderRadius: BorderRadius.circular(10),
                  onPress: () async {
                    await Future.delayed(Duration(seconds: 2));
                    openCheckout(
                      userEmail: currentUserInfo?.email.toString() ?? "",
                      userPhoneNumber: currentUserInfo?.phone.toString() ?? "",
                      amount: widget.amountToBePaid,
                      driverRazorpayAccId: driverData!["account_id"],
                      orderTitle: "Pay Securely",
                      orderId: null,
                    );
                  },
                ),
                const SizedBox(height: 16.0),
                CustomButton(
                  hint: "Cancel Ride",
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(10),
                  onPress: () async {
                    // Cancel the ride request and go back to the previous screen
                    await cancelRide(widget.rideRequestId);
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text("Ride cancelled successfully"),
                      backgroundColor: Colors.red,
                    ));
                    Navigator.pop(context); // Go back to the previous screen
                  },
                ),
              ],
            ],
          ),
        ),
      ), // Show loading indicator
    );
  }
}

// void showDriverFindingBottomSheet() {
//   showModalBottomSheet(
//     context: context,
//     isDismissible: false,
//     builder: (context) {
//       return StatefulBuilder(
//         builder: (BuildContext context, StateSetter setState) {
//           if (countdownTimer == null) {
//             startCountdownTimer(
//                 setState); // Start countdown timer when bottom sheet is shown
//           }
//           return WillPopScope(
//             onWillPop: () async => false, // Disable back button
//             child: Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   CircularProgressIndicator(
//                     color: Color(0xFF0000FF),
//                   ),
//                   const SizedBox(height: 16.0),
//                   Text("Finding a driver..."),
//                   const SizedBox(height: 16.0),
//                   Text(
//                     "Time remaining: ${remainingTime ~/ 60}:${(remainingTime % 60).toString().padLeft(2, '0')}",
//                     style: const TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   const SizedBox(height: 16.0),
//                   CustomButton(
//                     hint: "Cancel Ride",
//                     color: Colors.red,
//                     borderRadius: BorderRadius.circular(10),
//                     onPress: () {
//                       // Cancel the ride request and go back to the previous screen
//                       rideRequestRef.remove();
//                       Navigator.pop(context); // Close the bottom sheet
//                       Navigator.pop(
//                           context); // Go back to the previous screen
//                     },
//                   ),
//                 ],
//               ),
//             ),
//           );
//         },
//       );
//     },
//   );
// }
//
// void showDriverDetailsBottomSheet() {
//   showModalBottomSheet(
//     context: context,
//     isDismissible: false,
//     builder: (context) {
//       return Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             if (driverData == null) ...[
//               CircularProgressIndicator(),
//               const SizedBox(height: 16.0),
//               Text("Driver details not available yet."),
//             ] else ...[
//               Text(
//                 "Driver Details",
//                 style: const TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               Divider(),
//               const SizedBox(height: 8.0),
//               Text(
//                 "Name: ${driverData!['name'] ?? 'N/A'}",
//                 style: const TextStyle(
//                   fontSize: 18,
//                   // fontWeight: FontWeight.bold,
//                 ),
//               ),
//               const SizedBox(height: 8.0),
//               CustomButton(
//                 hint: "Proceed to Payment",
//                 color: Color(0xFF0000FF),
//                 borderRadius: BorderRadius.circular(10),
//                 onPress: () async {
//                   await Future.delayed(Duration(seconds: 2));
//                   openCheckout(
//                     userEmail: currentUserInfo?.email.toString() ?? "",
//                     userPhoneNumber: currentUserInfo?.phone.toString() ?? "",
//                     amount: widget.amountToBePaid,
//                     driverRazorpayAccId: driverData!["account_id"],
//                     orderTitle: "Pay Securely",
//                     orderId: null,
//                   );
//                 },
//               ),
//               const SizedBox(height: 16.0),
//               CustomButton(
//                 hint: "Cancel Ride",
//                 color: Colors.red,
//                 borderRadius: BorderRadius.circular(10),
//                 onPress: () {
//                   // Cancel the ride request and go back to the previous screen
//                   rideRequestRef.remove();
//                   Navigator.pop(context);
//                   Navigator.pop(context); // Go back to the previous screen
//                 },
//               ),
//             ],
//           ],
//         ),
//       );
//     },
//   );
// }

// return Scaffold(
// appBar: AppBar(
// title: Text("Driver"),
// backgroundColor: const Color(0xFF0000FF),
// ),
// bottomNavigationBar: Padding(
// padding: const EdgeInsets.all(16.0),
// child: CustomButton(
// hint: "Proceed to Payment",
// onPress: () {
// log('Payment Button Pressed');
// if (driverData == null) {
// ScaffoldMessenger.of(context).showSnackBar(SnackBar(
// content: Text("Driver data not available. Please try again."),
// backgroundColor: Colors.red,
// ));
// return;
// }
// openCheckout(
// userEmail: currentUserInfo?.email.toString() ?? "",
// // email of user requesting the ride
// userPhoneNumber: currentUserInfo?.phone.toString() ?? "",
// // phone number of user requesting the ride
// amount: widget.amountToBePaid,
// driverRazorpayAccId: driverData!["account_id"],
// orderTitle: "Pay Securely",
// // title of the order
// orderId: null,
// );
// },
// borderRadius: BorderRadius.circular(10),
// ),
// ),
// body: driverData != null
// ? Padding(
// padding: const EdgeInsets.all(16.0),
// child: Card(
// elevation: 5,
// shape: RoundedRectangleBorder(
// borderRadius: BorderRadius.circular(10),
// ),
// child: Padding(
// padding: const EdgeInsets.all(16.0),
// child: Column(
// crossAxisAlignment: CrossAxisAlignment.start,
// mainAxisSize: MainAxisSize.min,
// children: [
// if (driverData!['vehicleImages'] != null &&
// driverData!['vehicleImages'].isNotEmpty)
// ClipRRect(
// borderRadius: BorderRadius.circular(8.0),
// child: Image.network(
// driverData!['vehicleImages'][0],
// height: 150,
// width: double.infinity,
// fit: BoxFit.fill,
// ),
// ),
// const SizedBox(height: 16.0),
// Text(
// "Name: ${driverData!['name'] ?? 'N/A'}",
// style: const TextStyle(
// fontSize: 18,
// fontWeight: FontWeight.bold,
// ),
// ),
// const SizedBox(height: 8.0),
// Text(
// "Phone: ${driverData!['phoneNumber'] ?? 'N/A'}",
// style: const TextStyle(
// fontSize: 16,
// ),
// ),
// const SizedBox(height: 16.0),
// Center(
// child: CustomButton(
// hint: "Test",
// onPress: () {
// // TODO: Add your desired action here
// // Navigator.push(context,
// //     MaterialPageRoute(builder: (_) => Payment()));
// },
// borderRadius: BorderRadius.circular(10),
// ),
// ),
// ],
// ),
// ),
// ),
// )
//     : Center(child: const CircularProgressIndicator()),
// );
