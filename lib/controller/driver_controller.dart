import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';

import '../consts/firebase_consts.dart';

class DriverController extends GetxController {
  var driverDetails = {}.obs;
  // final currentUser = FirebaseAuth.instance.currentUser;

  void fetchDriverDetails() async {
    if (currentUser == null) {
      print("No current user is logged in.");
      return;
    }

    DatabaseReference rideRequestsRef = FirebaseDatabase.instance.ref().child('Ride Request');
    rideRequestsRef.once().then((DatabaseEvent event) {
      if (event.snapshot.value != null) {
        Map<String, dynamic> allRideRequests = Map<String, dynamic>.from(event.snapshot.value as Map);

        for (var entry in allRideRequests.entries) {
          var rideRequest = Map<String, dynamic>.from(entry.value);
          if (rideRequest.containsKey('u_id') && rideRequest['u_id'] == currentUser!.uid) {
            if (rideRequest.containsKey('driver_id')) {
              driverDetails.value = {
                'driver_id': rideRequest['driver_id'],
                'rider_name': rideRequest['rider_name'] ?? '',
                'rider_phone': rideRequest['rider_phone'] ?? ''
              };
              break; // Assuming you only want the first matching request
            }
          }
        }
      }
    }).catchError((error) {
      print("Failed to fetch driver details: $error");
    });
  }

  Future<String?> fetchDriverId() async {
    if (currentUser == null) {
      print("No current user is logged in.");
      return null;
    }

    DatabaseReference rideRequestsRef = FirebaseDatabase.instance.ref().child('Ride Request');
    try {
      DatabaseEvent event = await rideRequestsRef.once();
      if (event.snapshot.value != null) {
        Map<String, dynamic> allRideRequests = Map<String, dynamic>.from(event.snapshot.value as Map);

        for (var entry in allRideRequests.entries) {
          var rideRequest = Map<String, dynamic>.from(entry.value);
          if (rideRequest.containsKey('u_id') && rideRequest['u_id'] == currentUser!.uid) {
            if (rideRequest.containsKey('driver_id')) {
              return rideRequest['driver_id'];
            }
          }
        }
      }
    } catch (error) {
      print("Failed to fetch driver ID: $error");
    }
    return null;
  }
}