import 'package:easy_go/models/rideModel.dart';
import 'package:easy_go/screens/booking/payment.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '../../widget/custom_widget.dart';

class Driver extends StatefulWidget {
  const Driver({super.key});

  @override
  State<Driver> createState() => _DriverState();
}

class _DriverState extends State<Driver> {
  late DatabaseReference driverRef;
  Map<dynamic, dynamic>? driverData;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Future.microtask(() async {
      String? driverId = await fetchDriverId();
      driverRef =
          FirebaseDatabase.instance.reference().child('users').child(driverId!);
      getDriverData();
    });
  }

  Future<Map?> getDriverData() async {
    String? driverId = await fetchDriverId();
    if (driverId == null) {
      print("Driver ID is null.");
      return null;
    }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Driver"),
        backgroundColor: const Color(0xFF0000FF),
      ),
      body: Column(
        children: [
          if (driverData != null)
            Column(
              children: [
                Text("Name:- ${driverData!['name'] ?? 'N/A'}"),
                Text("Phone:- ${driverData!['phoneNumber'] ?? 'N/A'}"),
              ],
            )
          else
            Center(
              child: CircularProgressIndicator(),
            ),
          Center(
            child: CustomButton(
              hint: "Test",
              onPress: () {
                // TODO: change this based on your state manegement package
                Navigator.push(
                    context, MaterialPageRoute(builder: (_) => Payment()));
              },
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ],
      ),
    );
  }
}
