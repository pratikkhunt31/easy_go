import 'package:easy_go/widget/custom_widget.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';

import '../consts/firebase_consts.dart';
import '../dataHandler/appData.dart';

// DatabaseReference rideRequestRef = FirebaseDatabase.instance.ref();
AppData appData = Get.put(AppData());

Future<String?> saveRideRequest({
  int? farePrice,
  String? vType,
  String? dist,
  String? sName,
  String? sNumber,
  String? rName,
  String? rNumber,
  String? goods,
}) async {
  // rideRequestRef = FirebaseDatabase.instance.ref().child("Ride Request");

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
    'payout': "${farePrice} ₹",
    'v_type': vType,
    'status': "pending",
    'is_started': false,
    'distance': "${dist} km",
    'pickUp': pickUpLocMap,
    'dropOff': dropOffLocMap,
    'u_id': currentUser!.uid,
    'goods': goods,
    'created_at': formattedDateTime,
    'sender_name': sName,
    'sender_phone': sNumber,
    'receiver_name': rName,
    'receiver_phone': rNumber,
    'pickUp_address': pickUp.placeName,
    'dropOff_address': dropOff.placeName
  };

  try {
    DatabaseReference rideRequestRef =
        FirebaseDatabase.instance.ref().child("Ride Request").push();
    await rideRequestRef.set(rideInfoMap);
    String rideRequestId = rideRequestRef.key!;

    // Notify relevant drivers
    // DatabaseReference driversRef =
    //     FirebaseDatabase.instance.ref().child('drivers');
    // driversRef.once().then((DatabaseEvent event) {
    //   Map<String, dynamic> drivers =
    //       Map<String, dynamic>.from(event.snapshot.value as Map);
    //   drivers.forEach((key, value) {
    //     if (value['vehicleType'] == vType && value['is_online'] == true) {
    //       DatabaseReference driverRef =
    //           driversRef.child(key).child('newRideRequests');
    //       driverRef.child(rideRequestId).set(true);
    //     }
    //   });
    // });
    return rideRequestId;

    // await rideRequestRef.child("Ride Request").set(rideInfoMap);
    successSnackBar("Ride request sent successfully.");
  } catch (e) {
    print("Failed to send ride request: $e");
    // Optionally, handle the error further, such as showing a message to the user
  }
  return null;
}

var driverDetails = {}.obs;

void fetchDriverDetails() async {
  if (currentUser == null) {
    print("No current user is logged in.");
    return;
  }

  DatabaseReference rideRequestsRef =
      FirebaseDatabase.instance.ref().child('Ride Request');
  rideRequestsRef.once().then((DatabaseEvent event) {
    if (event.snapshot.value != null) {
      Map<String, dynamic> allRideRequests =
          Map<String, dynamic>.from(event.snapshot.value as Map);

      for (var entry in allRideRequests.entries) {
        var rideRequest = Map<String, dynamic>.from(entry.value);
        if (rideRequest.containsKey('u_id') &&
            rideRequest['u_id'] == currentUser!.uid) {
          if (rideRequest.containsKey('driver_id')) {
            String driverId = rideRequest['driver_id'] as String? ?? "";
            if (driverId.isNotEmpty && driverId != "waiting") {
              // If a driver ID is found and it's not "waiting"
              return driverId;
            }
            // Assuming you only want the first matching request
            break;
          }
        }
      }
    }
  }).catchError((error) {
    print("Failed to fetch driver details: $error");
  });
}

Future<String?> fetchDriverId() async {
  DatabaseReference rideRequestRef =
      FirebaseDatabase.instance.ref().child("Ride Request");

  try {
    DatabaseEvent event = await rideRequestRef.once();
    DataSnapshot snapshot = event.snapshot;

    if (snapshot.exists && snapshot.value is Map) {
      Map<dynamic, dynamic> rideRequests =
          snapshot.value as Map<dynamic, dynamic>;
      if (rideRequests.isNotEmpty) {
        String driverId = rideRequests['driver_id'] as String? ?? "";
        if (driverId.isNotEmpty && driverId != "waiting") {
          // If a driver ID is found and it's not "waiting"
          return driverId;
        }
      }
      // return rideRequests['driver_id'];
    } else {
      print("No ride requests found or invalid data format.");
    }
  } catch (e) {
    print("Error fetching driver ID: $e");
    return null;
  }
  return null;
}

class Ride {
  final String rideId;
  final String dropOffAddress;
  final String pickUpAddress;
  final String senderName;
  final String senderPhone;
  final String receiverName;
  final String receiverPhone;
  final String amount;
  final String distance;
  final String time;
  final bool isStarted;
  final LatLng pickUpLatLng;
  final LatLng dropOffLatLng;
  final LatLng dLatLng;
  final String goods;

  Ride(
      {
        required this.rideId,
        required this.dropOffAddress,
      required this.pickUpAddress,
      required this.senderName,
      required this.senderPhone,
      required this.receiverName,
      required this.receiverPhone,
      required this.amount,
      required this.distance,
      required this.time,
      required this.isStarted,
      required this.pickUpLatLng,
      required this.dropOffLatLng,
      required this.dLatLng,
      required this.goods});

  factory Ride.fromMap(String rideRequestId, Map<String, dynamic> data) {
    return Ride(
      rideId: rideRequestId,
      dropOffAddress: data['dropOff_address'],
      pickUpAddress: data['pickUp_address'],
      senderName: data['sender_name'],
      senderPhone: data['sender_phone'],
      receiverName: data['receiver_name'],
      receiverPhone: data['receiver_phone'],
      amount: data['payout'],
      distance: data['distance'],
      time: data['created_at'],
      isStarted: data['is_started'],
      pickUpLatLng: LatLng(
        double.parse(data['pickUp']['latitude']),
        double.parse(data['pickUp']['longitude']),
      ),
      dropOffLatLng: LatLng(
        double.parse(data['dropOff']['latitude']),
        double.parse(data['dropOff']['longitude']),
      ),
      dLatLng: LatLng(
        double.parse(data['d_location']['latitude']),
        double.parse(data['d_location']['longitude']),
      ),
      goods: data['goods'],
    );
  }
}

// void cancelRequest(){
//   rideRequestRef.remove();
// }
