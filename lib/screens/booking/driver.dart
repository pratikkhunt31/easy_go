import 'package:easy_go/controller/driver_controller.dart';
import 'package:easy_go/models/rideModel.dart';
import 'package:easy_go/screens/booking/payment.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../widget/custom_widget.dart';

class Driver extends StatefulWidget {
  const Driver({super.key});

  @override
  State<Driver> createState() => _DriverState();
}

class _DriverState extends State<Driver> {
  DriverController driverController = Get.put(DriverController());
  late DatabaseReference driverRef;
  Map<dynamic, dynamic>? driverData;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.microtask(() async {
      getDriverData();
      driverController.fetchDriverId();
    });
  }

  Future<Map?> getDriverData() async {
    String? driverId = await driverController.fetchDriverId();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Driver"),
        backgroundColor: const Color(0xFF0000FF),
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
                            Navigator.push(context,
                                MaterialPageRoute(builder: (_) => Payment()));
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
