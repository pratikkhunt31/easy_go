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

    return rideRequestId;
  } catch (e) {
    print("Failed to send ride request: $e");
    // Optionally, handle the error further, such as showing a message to the user
  }
  return null;
}

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

// await rideRequestRef.child("Ride Request").set(rideInfoMap);

var driverDetails = {}.obs;

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
  final String createdAt;

  Ride({
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
    required this.goods,
    required this.createdAt,
  });

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
      createdAt: data['created_at'] ?? '',
    );
  }
}

// void cancelRequest(){
//   rideRequestRef.remove();
// }
