import 'dart:convert';
import 'dart:developer';
import 'package:easy_go/models/rideModel.dart';
import 'package:easy_go/screens/booking/payment.dart';
import 'package:easy_go/screens/home/home_screen.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:http/http.dart' as http;
import '../../widget/custom_widget.dart';

class Driver extends StatefulWidget {
  const Driver({super.key});

  @override
  State<Driver> createState() => _DriverState();
}

class _DriverState extends State<Driver> {
  Map<dynamic, dynamic>? driverData;
  bool isLoading = true;
  late Razorpay razorpay;

  @override
  void initState() {
    super.initState();
    razorpay = Razorpay();
    razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, errorHandler);
    razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, successHandler);
    _loadDriverData();
  }

  Future<void> _loadDriverData() async {
    String? driverId = await fetchDriverId();
    if (driverId != null) {
      await getDriverData(driverId);
    } else {
      print("Driver ID is null.");
    }
    setState(() {
      isLoading = false;
    });
  }

  Future<void> getDriverData(String driverId) async {
    DatabaseReference driverRef =
        FirebaseDatabase.instance.ref().child("drivers").child(driverId);
    try {
      DatabaseEvent event = await driverRef.once();
      DataSnapshot snapshot = event.snapshot;
      if (snapshot.exists && snapshot.value is Map) {
        setState(() {
          driverData = snapshot.value as Map<dynamic, dynamic>;
        });
      } else {
        print("No driver data found or invalid data format.");
      }
    } catch (e) {
      print("Failed to retrieve driver data: $e");
    }
  }

  void openCheckout({
    // If there's an order associated with the ride/trip then pass it here to avoid creating a new order
    String? orderId,
    required String userPhoneNumber,
    required String userEmail,
    required int amount,
    required String driverRazorpayAccId,
    // Better to use trip pickup and drop off location as order title
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

  void errorHandler(response) {
    // Show any failure element here, by default it's a snackbar
    // Also save "orderId" for further assistance and refunds

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(response.toString()),
      backgroundColor: Colors.red,
    ));
  }

  void successHandler(PaymentSuccessResponse response) {
    // Move to the next screen and save any data to Firebase database here
    // Also save "razorpay_order_id" and "razorpay_payment_id" for further assistance and refunds, see debugPrint() below to know more
    // Sample of debugPrint() output: {razorpay_signature: 0cc1710ccc23e5a4d2466734dcd3341cf017cff7062bab23c248b71b751fbcd3, razorpay_order_id: order_OGhraAQrMN4H8e, razorpay_payment_id: pay_OGhrnQfEgcIvlv}
    debugPrint(response.data.toString());

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(response.paymentId!),
      backgroundColor: Colors.green,
    ));

    Get.offAll(HomeScreen());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Checkout"),
        backgroundColor: const Color(0xFF0000FF),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : driverData != null
              ? SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Driver Details",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 20),
                        _buildDetailRow("Name", driverData!['bank_name']),
                        _buildDetailRow("Phone", driverData!['phoneNumber']),
                        _buildImageRow(
                            "License Image", driverData!['licenseImage']),
                        _buildImageRow(
                            "PassBook Image", driverData!['passBookImage']),
                        _buildImageRow(
                            "RC Book Image", driverData!['rcBookImage']),
                        _buildDetailRow(
                            "Vehicle RC Number", driverData!['rcNumber']),
                      ],
                    ),
                  ),
                )
              : Center(child: Text("No driver data available")),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: CustomButton(
          hint: "Proceed to Payment",
          onPress: () {
            log('Payment Button Pressed');
            openCheckout(
              userEmail: "example@example.com",
              userPhoneNumber: "1234567890",
              amount: 100, // Replace with actual amount
              driverRazorpayAccId: "acc_OGZYAaPFqQGXKV",
              orderTitle:
                  "Vadodara to Ahmedabad", // Replace with actual order title
            );
          },
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Text(
            "$label: ",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          Text(
            value ?? 'N/A',
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildImageRow(String label, String? imageUrl) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$label:",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          SizedBox(height: 10),
          imageUrl != null
              ? Image.network(
                  imageUrl,
                  height: 150,
                  fit: BoxFit.cover,
                )
              : Text(
                  'No image available',
                  style: TextStyle(fontSize: 16),
                ),
        ],
      ),
    );
  }
}
