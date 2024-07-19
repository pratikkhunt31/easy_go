import 'dart:async';

import 'package:easy_go/consts/firebase_consts.dart';
import 'package:easy_go/models/rideModel.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:shimmer/shimmer.dart';

import '../../assistants/assistantsMethod.dart';
import '../../widget/custom_widget.dart';

class PendingRideDetails extends StatefulWidget {
  final Ride ride;

  const PendingRideDetails({super.key, required this.ride});

  @override
  State<PendingRideDetails> createState() => _PendingRideDetailsState();
}

class _PendingRideDetailsState extends State<PendingRideDetails> {
  final Completer<GoogleMapController> controller = Completer();
  bool isLoading = true;
  late LatLng sourceLocation;
  late LatLng destinationLocation;
  late LatLng driverLocation;
  late bool isRideStarted;
  BitmapDescriptor? truckIcon;
  String eta = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    sourceLocation = widget.ride.pickUpLatLng;
    destinationLocation = widget.ride.dropOffLatLng;
    driverLocation = widget.ride.dLatLng;
    isRideStarted = widget.ride.isStarted;
    loadCustomMarker();
    listenToRideUpdates();
    Future.microtask(() {
      showDialog(
        context: context,
        builder: (BuildContext context) =>
            ProgressDialog(message: "Processing, Please wait..."),
        barrierDismissible: false,
      );
      // getPlaceDirection();
      getPolyPoints();
      getCurrentLocation();
      updateETA();
      Future.delayed(Duration(seconds: 3), () {
        setState(() {
          isLoading = false; // Set isLoading to false after loading is done
        });
        Navigator.of(context).pop(); // Dismiss the dialog
      });
    });
  }

  List<LatLng> polylineCoordinates = [];
  LocationData? currentLocation;

  BitmapDescriptor sourceIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor destinationIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor currentLocationIcon = BitmapDescriptor.defaultMarker;
  StreamSubscription<LocationData>? locationSubscription;

  @override
  void dispose() {
    locationSubscription?.cancel();
    super.dispose();
  }

  void listenToRideUpdates() {
    DatabaseReference rideRequestRef = FirebaseDatabase.instance
        .ref()
        .child('Ride Request')
        .child(widget.ride.rideId);

    rideRequestRef.onValue.listen((event) {
      if (event.snapshot.exists) {
        Map<String, dynamic> rideData =
            Map<String, dynamic>.from(event.snapshot.value as Map);
        bool updatedIsStarted = rideData['is_started'];
        if (updatedIsStarted != isRideStarted) {
          setState(() {
            isRideStarted = updatedIsStarted;
            polylineCoordinates.clear();
            getPolyPoints();
          });
        }
        if (rideData.containsKey('d_location')) {
          setState(() {
            driverLocation = LatLng(
              double.parse(rideData['d_location']['latitude']),
              double.parse(rideData['d_location']['longitude']),
            );
          });
        }
      }
    });
  }

  void getCurrentLocation() async {
    Location location = Location();

    location.getLocation().then((location) => currentLocation = location);

    GoogleMapController googleMapController = await controller.future;

    location.onLocationChanged.listen((newLoc) {
      if (!mounted) return;
      currentLocation = newLoc;

      googleMapController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            zoom: 13.5,
            target: LatLng(newLoc.latitude!, newLoc.longitude!),
          ),
        ),
      );

      if (mounted) {
        setState(() {
          currentLocation = newLoc;
        });
        if (!isRideStarted) {
          updateETA(); // Update ETA when ride is not started
        }
      }
    });
  }

  void getPolyPoints() async {
    PolylinePoints polylinePoints = PolylinePoints();

    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      mapKey,
      PointLatLng(sourceLocation.latitude, sourceLocation.longitude),
      PointLatLng(destinationLocation.latitude, destinationLocation.longitude),
    );

    if (isRideStarted) {
      result = await polylinePoints.getRouteBetweenCoordinates(
        mapKey,
        PointLatLng(driverLocation.latitude, driverLocation.longitude),
        PointLatLng(
            destinationLocation.latitude, destinationLocation.longitude),
      );
    } else {
      result = await polylinePoints.getRouteBetweenCoordinates(
        mapKey,
        PointLatLng(sourceLocation.latitude, sourceLocation.longitude),
        PointLatLng(driverLocation.latitude, driverLocation.longitude),
      );
    }

    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) =>
          polylineCoordinates.add(LatLng(point.latitude, point.longitude)));
      setState(() {});
    }
    // await Future.delayed(Duration(seconds: 2));
    // Navigator.pop(context);
  }

  void loadCustomMarker() async {
    truckIcon = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(),
      'assets/images/truck_icon1.png',
    );
  }

  void updateETA() async {
    if (currentLocation != null && !isRideStarted) {
      LatLng currentDriverLocation = LatLng(
        currentLocation!.latitude!,
        currentLocation!.longitude!,
      );

      var directionDetails =
          await AssistantsMethod.obtainPlaceDirection(
        currentDriverLocation,
        sourceLocation,
      );

      if (directionDetails != null) {
        setState(() {
          eta = directionDetails.durationText!; // Update ETA text
        });
      }
    }
  }

  Widget buildShimmerEffect() {
    return Shimmer.fromColors(
      baseColor: Colors.white,
      highlightColor: Colors.white12,
      child: Container(
        height: 145,
        color: Colors.white,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Ride Details"),
        backgroundColor: const Color(0xFF0000FF),
      ),
      body: Container(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 12.0, right: 12.0, top: 10),
              child: Container(
                // color: Colors.black,
                width: double.infinity,
                height: 250,
                child:
                    // currentLocation == null
                    //     ? const Center(
                    //         child: Text('Loading'),
                    //       )
                    //     :
                    GoogleMap(
                  initialCameraPosition: CameraPosition(
                      target: LatLng(
                          driverLocation.latitude, driverLocation.longitude),
                      zoom: 18),
                  polylines: {
                    Polyline(
                        polylineId: PolylineId('route'),
                        points: polylineCoordinates,
                        width: 4,
                        color: Colors.blueAccent)
                  },
                  markers: {
                    Marker(
                      markerId: MarkerId('driverLocation'),
                      icon: truckIcon ??
                          BitmapDescriptor.defaultMarkerWithHue(
                              BitmapDescriptor.hueGreen),
                      position: LatLng(
                          driverLocation.latitude, driverLocation.longitude),
                    ),
                    Marker(
                      icon: BitmapDescriptor.defaultMarkerWithHue(
                          BitmapDescriptor.hueGreen),
                      markerId: MarkerId('source'),
                      position: sourceLocation,
                    ),
                    Marker(
                      markerId: MarkerId('destination'),
                      position: destinationLocation,
                    )
                  },
                  onMapCreated: (mapController) {
                    controller.complete(mapController);
                  },
                ),
              ),
            ),
            SizedBox(height: 15),
            isRideStarted
                ? Container() // No ETA if ride is started
                : Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Estimated time of arriving: $eta",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent,
                      ),
                    ),
                  ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 12.0, right: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            "Contact Details",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 8),
                    Padding(
                      padding: EdgeInsets.only(left: 8.0, right: 8.0),
                      child: isLoading
                          ? buildShimmerEffect() // Show shimmer if isLoading is true
                          : Container(
                              child: ContactDetailCard(
                                senderName: widget.ride.senderName,
                                senderPhone: widget.ride.senderPhone,
                                receiverName: widget.ride.receiverName,
                                receiverPhone: widget.ride.receiverPhone,
                              ),
                            ),
                    ),
                    SizedBox(height: 15),
                    Padding(
                      padding: EdgeInsets.only(left: 12.0, right: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            "Fare Summary",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                      child: isLoading
                          ? buildShimmerEffect() // Show shimmer if isLoading is true
                          : Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              color: Colors.white,
                              child: Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Fare Summary",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                    ),
                                    Divider(),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text("Total Distance"),
                                        Text("${widget.ride.distance}"),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text("Trip Fare (incl. Toll)"),
                                        Text("${widget.ride.amount}"),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text("Net Fare"),
                                        Text("${widget.ride.amount}"),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Amount Payable (rounded)",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          "${widget.ride.amount}",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                    // const SizedBox(height: 8),
                                  ],
                                ),
                              ),
                            ),
                    ),
                    SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                      child: isLoading
                          ? buildShimmerEffect() // Show shimmer if isLoading is true
                          : Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              color: Colors.white,
                              child: Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Goods",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                    ),
                                    Divider(),
                                    Row(
                                      children: [
                                        Text(
                                          "${widget.ride.goods}",
                                          style: TextStyle(fontSize: 16),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),

                                    // const SizedBox(height: 8),
                                  ],
                                ),
                              ),
                            ),
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
