import 'package:easy_go/assistants/requestAssistants.dart';
import 'package:easy_go/consts/firebase_consts.dart';
import 'package:easy_go/dataHandler/appData.dart';
import 'package:easy_go/models/address.dart';
import 'package:easy_go/models/allUsers.dart';
import 'package:easy_go/models/directionDetail.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AssistantsMethod {
  static Future<String> searchCoordinateAddress(Position position) async {
    String placeAddress = "";
    // String st0, st1, st2, st3, st4, st5, st6;
    String url =
        "https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=$mapKey";

    var response = await RequestAssistants.getRequest(url);

    if (response != 'failed') {
      // st0 = response["results"][0]["address_components"][0]["long_name"];
      // st1 = response["results"][0]["address_components"][1]["long_name"];
      // st2 = response["results"][0]["address_components"][5]["long_name"];
      // st3 = response["results"][0]["address_components"][6]["long_name"];
      // st4 = response["results"][0]["address_components"][5]["long_name"];
      // st5 = response["results"][0]["address_components"][7]["long_name"];
      // st6 = response["results"][0]["address_components"][6]["long_name"];

      // placeAddress = st0 + ", " + st1 + ", " + st2 + ", "+ st3 + ", ";
      // + st4 + ", "+ st5 + ", " + st6;
      //  + st3 + ", " + st4;
      placeAddress = response["results"][0]["formatted_address"];

      Address userPickUpAddress = new Address();
      userPickUpAddress.longitude = position.longitude;
      userPickUpAddress.latitude = position.latitude;
      userPickUpAddress.placeName = placeAddress;

      final appData = Get.put(AppData());

      appData.updatePickUpLocationAddress(userPickUpAddress);

      // Provider.of<AppData>(context).updatePickUpLocationAddress(userPickUpAddress);
    }
    return placeAddress;
  }

  static Future<String> searchDropCoordinateAddress(Position position) async {
    String placeAddress = "";
    // String st0, st1, st2, st3, st4, st5, st6;
    String url =
        "https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=$mapKey";

    var response = await RequestAssistants.getRequest(url);

    if (response != 'failed') {
      // st0 = response["results"][0]["address_components"][0]["long_name"];
      // st1 = response["results"][0]["address_components"][1]["long_name"];
      // st2 = response["results"][0]["address_components"][5]["long_name"];
      // st3 = response["results"][0]["address_components"][6]["long_name"];
      // st4 = response["results"][0]["address_components"][5]["long_name"];
      // st5 = response["results"][0]["address_components"][7]["long_name"];
      // st6 = response["results"][0]["address_components"][6]["long_name"];

      // placeAddress = st0 + ", " + st1 + ", " + st2 + ", "+ st3 + ", ";
      // + st4 + ", "+ st5 + ", " + st6;
      //  + st3 + ", " + st4;
      placeAddress = response["results"][0]["formatted_address"];

      Address userDropOffAddress = new Address();
      userDropOffAddress.longitude = position.longitude;
      userDropOffAddress.latitude = position.latitude;
      userDropOffAddress.placeName = placeAddress;

      final appData = Get.put(AppData());

      appData.updateDropOffLocationAddress(userDropOffAddress);

      // Provider.of<AppData>(context).updatePickUpLocationAddress(userPickUpAddress);
    }
    return placeAddress;
  }

  static Future<DirectionDetail?> obtainPlaceDirection(
      LatLng initialPosition, LatLng finalPosition) async {
    String directionUrl =
        "https://maps.googleapis.com/maps/api/directions/json?destination=${finalPosition.latitude},${finalPosition.longitude}&origin=${initialPosition.latitude},${initialPosition.longitude}&key=$mapKey";

    var res = await RequestAssistants.getRequest(directionUrl);

    if (res == "failed") {
      return null;
    }

    DirectionDetail directionDetail = DirectionDetail();

    directionDetail.encodedPoint =
        res["routes"][0]["overview_polyline"]["points"];

    directionDetail.distanceText =
        res["routes"][0]["legs"][0]["distance"]["text"];
    directionDetail.distanceValue =
        res["routes"][0]["legs"][0]["distance"]["value"];

    directionDetail.durationText =
        res["routes"][0]["legs"][0]["duration"]["text"];
    directionDetail.durationValue =
        res["routes"][0]["legs"][0]["duration"]["value"];

    return directionDetail;
  }

  static int calculateFares(DirectionDetail directionDetail) {
    double distanceTraveledFare =
        (directionDetail.distanceValue! / 1000) * 0.20;
    double total = distanceTraveledFare;

    double totalAmount = total * 80;

    return totalAmount.truncate();
  }

  static void getCurrentOnlineUserInfo() async {
    if (currentUser != null) {
      String userId = currentUser!.uid;

      DatabaseReference reference =
          FirebaseDatabase.instance.ref("users").child(userId);

      DatabaseEvent event = await reference.once();
      DataSnapshot dataSnapshot = event.snapshot;

      if (dataSnapshot.value != null) {
        currentUserInfo = Users.fromSnapshot(dataSnapshot);
      }
    }
  }
}
