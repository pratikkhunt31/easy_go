import 'dart:async';
import 'dart:math';

import 'package:easy_go/consts/firebase_consts.dart';
import 'package:easy_go/dataHandler/appData.dart';
import 'package:easy_go/models/directionDetail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../assistants/assistantsMethod.dart';
import '../../widget/custom_widget.dart';

class BookRide extends StatefulWidget {
  const BookRide({super.key});

  @override
  State<BookRide> createState() => _BookRideState();
}

class _BookRideState extends State<BookRide> {
  AppData appData = Get.put(AppData());
  final Completer<GoogleMapController> mapController =
      Completer<GoogleMapController>();
  GoogleMapController? newMapController;
  Position? currentLocation;
  var geoLocator = Geolocator();
  String? currentAddress;
  bool isLoading = false;
  List<LatLng> pLineCoordinates = [];
  Set<Polyline> polylineSet = {};
  Set<Marker> markersSet = {};
  Set<Circle> circlesSet = {};
  double totalDistance = 0.0;
  int farePrice = 0;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.microtask(() {
      showDialog(
        context: context,
        builder: (BuildContext context) =>
            ProgressDialog(message: "Processing, Please wait..."),
        barrierDismissible: false,
      );
      getPlaceDirection();
    });
  }

  void updateAddress(LatLng position) async {
    setState(() {
      isLoading = true;
    });

    String address = await AssistantsMethod.searchCoordinateAddress(Position(
      latitude: position.latitude,
      longitude: position.longitude,
      timestamp: DateTime.now(),
      altitude: 0.0,
      accuracy: 0.0,
      altitudeAccuracy: 0.0,
      heading: 0.0,
      headingAccuracy: 0.0,
      speed: 0.0,
      speedAccuracy: 0.0,
    ));

    setState(() {
      currentAddress = address;
      isLoading = false;
    });
  }

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 18,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Ride Details"),
        backgroundColor: const Color(0xFF0000FF),
      ),
      body: Container(
        color: Color(0xA4A4A4A2),
        child: Column(
          children: [
            // SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.only(left: 12.0, right: 12.0, top: 10),
              child: Container(
                // color: Colors.black,
                width: double.infinity,
                height: 200,
                child: GoogleMap(
                  mapType: MapType.normal,
                  myLocationButtonEnabled: true,
                  initialCameraPosition: _kGooglePlex,
                  myLocationEnabled: true,
                  zoomGesturesEnabled: true,
                  zoomControlsEnabled: true,
                  polylines: polylineSet,
                  markers: markersSet,
                  // circles: circlesSet,
                  onMapCreated: (GoogleMapController controller) {
                    mapController.complete(controller);
                    newMapController = controller;
                    // locatePosition();
                  },
                ),
              ),
            ),
            SizedBox(height: 10),
            Container(
              height: 426,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: 5),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Card(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 5),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15.0),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.location_on,
                                    color: Colors.green,
                                  ),
                                  SizedBox(width: 5),
                                  Expanded(
                                    child:
                                        Text(appData.pickupLocation.placeName!),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 8),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15.0),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.location_on,
                                    color: Colors.red,
                                  ),
                                  SizedBox(width: 5),
                                  Expanded(
                                    child:
                                        Text(appData.dropOffLocation.placeName!),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 5),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Card(
                        color: Colors.white54,
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Fare Summary",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              Divider(),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Total Distance"),
                                  Text("${totalDistance.toStringAsFixed(2)} km"),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Trip Fare (incl. Toll)"),
                                  Text("₹${farePrice}"),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Net Fare"),
                                  Text("₹${farePrice}"),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Amount Payable (rounded)",
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    "₹${farePrice}",
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                            ],
                          ),
                        ),
                      ),
                    ),

                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: CustomButton(
          hint: "Confirm Ride",
          onPress: () {

          },
          borderRadius: BorderRadius.circular(0),
        ),
      ),
    );
  }

  Future<void> getPlaceDirection() async {
    var initialPos = appData.pickupLocation;
    var finalPos = appData.dropOffLocation;

    var pickUpLatLng = LatLng(initialPos.latitude!, initialPos.longitude!);
    var dropOffLatLng = LatLng(finalPos.latitude!, finalPos.longitude!);

    var details = await AssistantsMethod.obtainPlaceDirectionDirection(
        pickUpLatLng, dropOffLatLng);

    if (details != null) {
      // Calculate total distance in kilometers
      double distanceInKm = details.distanceValue! / 1000;

      // Calculate fare price
      int fare = calculateFares(details);

      setState(() {
        totalDistance = distanceInKm;
        farePrice = fare;
      });

      // Navigator.pop(context);

      // print("This is Encoded Points: ${details.encodedPoint}");
      print(details.encodedPoint);

      PolylinePoints polylinePoints = PolylinePoints();
      List<PointLatLng> decodedLinePoints =
          polylinePoints.decodePolyline(details.encodedPoint!);

      pLineCoordinates.clear();

      if (decodedLinePoints.isNotEmpty) {
        decodedLinePoints.forEach((PointLatLng pointLatLng) {
          pLineCoordinates
              .add(LatLng(pointLatLng.latitude, pointLatLng.longitude));
        });
      }

      polylineSet.clear();
      markersSet.clear();

      setState(() {
        Polyline polyline = Polyline(
            color: Colors.black,
            polylineId: PolylineId("PolyLineId"),
            jointType: JointType.round,
            points: pLineCoordinates,
            width: 4,
            startCap: Cap.roundCap,
            endCap: Cap.roundCap,
            geodesic: true);

        polylineSet.add(polyline);
      });

      LatLngBounds latLngBounds;
      if (pickUpLatLng.latitude > dropOffLatLng.latitude &&
          pickUpLatLng.longitude > dropOffLatLng.longitude) {
        latLngBounds =
            LatLngBounds(southwest: dropOffLatLng, northeast: pickUpLatLng);
      } else if (pickUpLatLng.longitude > dropOffLatLng.longitude) {
        latLngBounds = LatLngBounds(
            southwest: LatLng(pickUpLatLng.latitude, dropOffLatLng.longitude),
            northeast: LatLng(dropOffLatLng.latitude, pickUpLatLng.longitude));
      } else if (pickUpLatLng.latitude > dropOffLatLng.latitude) {
        latLngBounds = LatLngBounds(
            southwest: LatLng(dropOffLatLng.latitude, pickUpLatLng.longitude),
            northeast: LatLng(pickUpLatLng.latitude, dropOffLatLng.longitude));
      } else {
        latLngBounds =
            LatLngBounds(southwest: pickUpLatLng, northeast: dropOffLatLng);
      }

      newMapController
          ?.animateCamera(CameraUpdate.newLatLngBounds(latLngBounds, 70));

      Marker pickUpMarker = Marker(
        markerId: MarkerId("pickUpId"),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        infoWindow: InfoWindow(
            title: initialPos.placeName, snippet: "Pick Up Location"),
        position: pickUpLatLng,
      );

      Marker dropOffMarker = Marker(
        markerId: MarkerId("dropOffId"),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        infoWindow:
            InfoWindow(title: finalPos.placeName, snippet: "Drop Off Location"),
        position: dropOffLatLng,
      );

      setState(() {
        markersSet.add(pickUpMarker);
        markersSet.add(dropOffMarker);
      });

      Circle pickUpCircle = Circle(
        circleId: CircleId("pickUpId"),
        fillColor: Colors.blueAccent,
        center: pickUpLatLng,
        radius: 12,
        strokeWidth: 4,
        strokeColor: Colors.blueAccent,
      );

      Circle dropOffCircle = Circle(
        circleId: CircleId("dropOffId"),
        fillColor: Colors.deepPurple,
        center: dropOffLatLng,
        radius: 12,
        strokeWidth: 4,
        strokeColor: Colors.deepPurple,
      );

      setState(() {
        circlesSet.add(pickUpCircle);
        circlesSet.add(dropOffCircle);
      });

      await Future.delayed(Duration(seconds: 2));
      Navigator.pop(context);
    }
  }

  int calculateFares(DirectionDetail directionDetail) {
    double distanceTraveledFare = (directionDetail.distanceValue! / 1000) * 45 /80 ;
    double total = distanceTraveledFare;

    double totalAmount = total * 80;

    return totalAmount.truncate();
  }
}
// Container(
// child: CustomButton(
// hint: "hint",
// onPress: () {
// // print(appData.dropOffLocation.placeName);
// // print(appData.pickupLocation.placeName);
// getPlaceDirection();
// },
// borderRadius: BorderRadius.circular(10),
// )
