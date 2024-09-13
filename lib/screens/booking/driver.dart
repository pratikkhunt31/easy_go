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

class _DriverState extends State<Driver> with WidgetsBindingObserver {
  DriverController driverController = Get.put(DriverController());
  late DatabaseReference rideRequestRef;
  late DatabaseReference driverRef;
  Map<dynamic, dynamic>? driverData;
  bool isLoading = true;
  late Razorpay razorpay;
  Timer? countdownTimer;
  int remainingTime = 300;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    razorpay = Razorpay();
    razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, errorHandler);
    razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, successHandler);
    rideRequestRef = FirebaseDatabase.instance
        .ref()
        .child('Ride Request')
        .child(widget.rideRequestId);
    listenForDriverId();
    startCountdownTimer();
  }

  @override
  void dispose() {
    razorpay.clear();
    WidgetsBinding.instance.removeObserver(this);
    countdownTimer?.cancel();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.detached || state == AppLifecycleState.paused) {
      // App is closed or backgrounded
      removeRideRequest();
    }
    super.didChangeAppLifecycleState(state);
  }

  Future<void> removeRideRequest() async {
    await rideRequestRef.remove();
    if (mounted) {
      Navigator.pop(context);
    }
  }

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
          content: Text("driverNotAssign".tr),
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

    return WillPopScope(
      onWillPop: () async {
        await removeRideRequest();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text("driver".tr),
          backgroundColor: const Color(0xFF0000FF),
          elevation: 0,
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
                  Text("findingADriver".tr),
                  const SizedBox(height: 16.0),
                  Text(
                    "timeRemain: ${remainingTime ~/ 60}:${(remainingTime % 60).toString().padLeft(2, '0')}".tr,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  CustomButton(
                    hint: "cancelRide".tr,
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(10),
                    onPress: () async {
                      await rideRequestRef.remove();
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text("rideCancelSuccess".tr),
                        backgroundColor: Colors.red,
                      ));
                      Navigator.pop(context);
                    },
                  ),
                ] else ...[
                  Text(
                    "driverDetails".tr,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Divider(),
                  const SizedBox(height: 8.0),
                  Text(
                    "name: ${driverData!['name'] ?? 'N/A'}".tr,
                    style: const TextStyle(
                      fontSize: 18,
                      // fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  CustomButton(
                    hint: "proceedToPayment".tr,
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
                    hint: "cancelRide".tr,
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
      ),
    );
  }
}

