import 'package:easy_go/widget/custom_widget.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../consts/firebase_consts.dart';
import '../dataHandler/appData.dart';

DatabaseReference rideRequestRef = FirebaseDatabase.instance.ref();
AppData appData = Get.put(AppData());

void saveRideRequest(int farePrice, String vType) async {
  var pickUp = appData.pickupLocation;
  var dropOff = appData.dropOffLocation;

  Map<String, String> pickUpLocMap = {
    'latitude': pickUp.latitude.toString(),
    'longitude': pickUp.longitude.toString()
  };

  Map<String, String> dropOffLocMap = {
    'latitude': dropOff.latitude.toString(),
    'longitude': dropOff.longitude.toString()
  };

  String formattedDateTime =
      DateFormat('dd-MM-yyyy HH:mm:ss').format(DateTime.now());

  Map<String, dynamic> rideInfoMap = {
    'driver_id': "waiting",
    'payment_status': "waiting",
    'payout': "${farePrice}₹",
    'v_type': vType,
    'pickUp': pickUpLocMap,
    'dropOff': dropOffLocMap,
    'created_at': formattedDateTime,
    'rider_name': currentUserInfo!.name,
    'rider_phone': currentUserInfo!.phone,
    'pickUp_address': pickUp.placeName,
    'dropOff_address': dropOff.placeName
  };

  try {
    DatabaseReference newRideRequestRef =
        FirebaseDatabase.instance.ref().child("Ride Request").push();
    await newRideRequestRef.set(rideInfoMap);
    String rideRequestId = newRideRequestRef.key!;

    // Notify relevant drivers
    DatabaseReference driversRef =
        FirebaseDatabase.instance.ref().child('drivers');
    driversRef.once().then((DatabaseEvent event) {
      Map<String, dynamic> drivers =
          Map<String, dynamic>.from(event.snapshot.value as Map);
      drivers.forEach((key, value) {
        if (value['vehicleType'] == 'Tempo' && value['is_online'] == true) {
          DatabaseReference driverRef =
              driversRef.child(key).child('newRideRequests');
          driverRef.child(rideRequestId).set(true);
        }
      });
    });

    successSnackBar("Ride request sent successfully.");
  } catch (e) {
    print("Failed to send ride request: $e");
  }
}

Future<String?> fetchDriverId() async {
  DatabaseReference rideRequestRef =
      FirebaseDatabase.instance.ref().child("drivers").child(currentUser!.uid);

  try {
    DatabaseEvent event = await rideRequestRef.once();
    DataSnapshot snapshot = event.snapshot;

    if (snapshot.exists && snapshot.value is Map) {
      Map<dynamic, dynamic> rideRequests =
          snapshot.value as Map<dynamic, dynamic>;
      if (rideRequests.isNotEmpty) {
        String driverId = rideRequests['d_id'] as String? ?? "";
        if (driverId.isNotEmpty && driverId != "waiting") {
          return driverId;
        }
      }
    } else {
      print("No ride requests found or invalid data format.");
    }
  } catch (e) {
    print("Error fetching driver ID: $e");
  }
  return null;
}
