import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:easy_go/consts/firebase_consts.dart';
import 'package:easy_go/dataHandler/appData.dart';
import 'package:easy_go/models/allUsers.dart';
import 'package:easy_go/models/directionDetail.dart';
import 'package:easy_go/models/rideModel.dart';
import 'package:easy_go/screens/booking/driver.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import '../../assistants/assistantsMethod.dart';
import '../../controller/driver_controller.dart';
import '../../widget/custom_widget.dart';

class BookRide extends StatefulWidget {
  final String? vType;
  final bool isChecked;
  final String sName;
  final String sNumber;
  final String rName;
  final String rNumber;
  final String goods;

  const BookRide(
    this.vType, {
    super.key,
    required this.isChecked,
    required this.sName,
    required this.sNumber,
    required this.rName,
    required this.rNumber,
    required this.goods,
  });

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
  int additionalFee = 0;
  DriverController driverController = Get.put(DriverController());
  late DatabaseReference driverRef;
  Map<dynamic, dynamic>? driverData;
  late Razorpay razorpay;
  Timer? driverFindingTimer;
  String? rideRequestId;
  int remainingSeconds = 300;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    razorpay = Razorpay();
    razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, errorHandler);
    razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, successHandler);
    Future.microtask(() {
      showDialog(
        context: context,
        builder: (BuildContext context) =>
            ProgressDialog(message: "Processing, Please wait..."),
        barrierDismissible: false,
      );
      getPlaceDirection();
      AssistantsMethod.getCurrentOnlineUserInfo();
    });
  }

  @override
  void dispose() {
    razorpay.clear();
    driverFindingTimer?.cancel();
    super.dispose();
  }

  void listenForDriverId(String rideRequestId) {
    DatabaseReference rideRequestRef = FirebaseDatabase.instance
        .ref()
        .child('Ride Request')
        .child(rideRequestId);

    rideRequestRef.onValue.listen((event) {
      if (event.snapshot.exists && event.snapshot.value is Map) {
        Map<dynamic, dynamic> rideRequestData =
            event.snapshot.value as Map<dynamic, dynamic>;
        String? driverId = rideRequestData['driver_id'];
        if (driverId != null && driverId != 'waiting') {
          getDriverData(driverId);
        }
      }
    });
  }

  Future<void> getDriverData(String driverId) async {
    driverRef =
        FirebaseDatabase.instance.ref().child("drivers").child(driverId);

    driverRef.onValue.listen((event) {
      if (event.snapshot.exists && event.snapshot.value is Map) {
        Map<dynamic, dynamic> driver =
            event.snapshot.value as Map<dynamic, dynamic>;
        setState(() {
          driverData = driver;
          isLoading = false; // Ensure isLoading is set to false
        });
      } else {
        print("No driver data found or invalid data format.");
      }
    });
  }

  void startDriverFindingTimer(String rideRequestId) {
    driverFindingTimer = Timer.periodic(Duration(minutes: 3), (timer) {
      if (remainingSeconds > 0) {
        setState(() {
          remainingSeconds--;
        });
      } else {
        timer.cancel();
        // Cancel the ride request if no driver is assigned within 5 minutes
        DatabaseReference rideRequestRef = FirebaseDatabase.instance
            .ref()
            .child('Ride Request')
            .child(rideRequestId);
        rideRequestRef.remove();
        Navigator.pop(context); // Close the driver finding bottom sheet
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Driver not assigned. Please make a new request."),
          backgroundColor: Colors.red,
        ));
      }
    });
  }

  void errorHandler(response) {
    if (response.data != null) {
      savePaymentDetails(response.data!["razorpay_order_id"],
          response.data!["razorpay_payment_id"]);
    }

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(response.toString()),
      backgroundColor: Colors.red,
    ));
  }

  void successHandler(PaymentSuccessResponse response) {
    if (response.data != null) {
      savePaymentDetails(response.data!["razorpay_order_id"],
          response.data!["razorpay_payment_id"]);
    }

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(response.paymentId!),
      backgroundColor: Colors.green,
    ));

    // Get.offAll(HomeScreen());
    Navigator.pop(context);
  }

  void savePaymentDetails(String orderId, String? paymentId) {
    debugPrint("order id: $orderId");
    debugPrint("payment id: $paymentId");

    DatabaseReference paymentDetailsRef = FirebaseDatabase.instance
        .ref()
        .child("Ride Request")
        .child(rideRequestId!)
        .child("paymentDetails");

    paymentDetailsRef.update({
      "orderId": orderId,
      "paymentId": paymentId,
      "status": paymentId != null ? "success" : "failed"
    });
  }

  void openCheckout({
    String? orderId,
    required String userPhoneNumber,
    required String userEmail,
    required int amount,
    required String driverRazorpayAccId,
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
          "account_id": driverRazorpayAccId,
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
      debugPrint(json.decode(response.body).toString());

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Failed to create order. Please try again."),
        backgroundColor: Colors.red,
      ));
    }
  }

  void showDriverFindingBottomSheet(String rideRequestId) {
    showModalBottomSheet(
      context: context,
      isDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return WillPopScope(
              onWillPop: () async => false, // Disable back button
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (driverData == null) ...[
                      CircularProgressIndicator(
                        color: Color(0xFF0000FF),
                      ),
                      const SizedBox(height: 16.0),
                      Text("Finding a driver..."),
                    ] else ...[
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
                      CustomButton(
                        hint: "Proceed to Payment",
                        color: const Color(0xFF0000FF),
                        borderRadius: BorderRadius.circular(10),
                        onPress: () {
                          // log('Payment Button Pressed');
                          openCheckout(
                            userEmail: currentUserInfo?.email.toString() ?? "",
                            userPhoneNumber:
                                currentUserInfo?.phone.toString() ?? "",
                            amount: farePrice,
                            driverRazorpayAccId: driverData!["account_id"],
                            orderTitle: "Pay Securely",
                            orderId: null,
                          );
                        },
                      ),
                    ],
                    const SizedBox(height: 16.0),
                    Text(
                      "Time remaining: ${remainingSeconds ~/ 60}:${remainingSeconds % 60}",
                      style: const TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0000FF),
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    CustomButton(
                      hint: "Cancel Ride",
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(10),
                      onPress: () {
                        // Cancel the ride request and go back to the previous screen
                        DatabaseReference rideRequestRef = FirebaseDatabase
                            .instance
                            .ref()
                            .child('Ride Request')
                            .child(rideRequestId);
                        rideRequestRef.remove();
                        Navigator.pop(context); // Close the bottom sheet
                        Navigator.pop(context);
                        driverFindingTimer
                            ?.cancel(); // Go back to the previous screen
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
    startDriverFindingTimer(rideRequestId);
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
                    SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Card(
                        elevation: 5,
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
                                    child: Text(
                                        appData.dropOffLocation.placeName!),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 5),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Card(
                        elevation: 5,
                        color: Colors.white,
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Total Distance"),
                                  Text(
                                      "${totalDistance.toStringAsFixed(2)} km"),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Trip Fare (incl. Toll)"),
                                  Text("₹${farePrice}"),
                                ],
                              ),
                              const SizedBox(height: 8),
                              if (widget.isChecked) ...[
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Additional Fee"),
                                    Text("₹100"),
                                  ],
                                ),
                                const SizedBox(height: 8),
                              ],
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Net Fare"),
                                  Text("₹${farePrice}"),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Amount Payable (rounded)",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    "₹${farePrice}",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                      child: Card(
                        elevation: 5,
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
                                    fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              Divider(),
                              Row(
                                children: [
                                  Text(
                                    "${widget.goods}",
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
          onPress: () async {
            // print();
            // AssistantsMethod.getCurrentOnlineUserInfo();
            String? rideId = await saveRideRequest(
              farePrice: farePrice,
              vType: widget.vType!,
              sName: widget.sName,
              sNumber: widget.sNumber,
              rName: widget.rName,
              rNumber: widget.rNumber,
              dist: totalDistance.toStringAsFixed(2),
              goods: widget.goods,
            );

            if (rideId != null) {
              // setState(() {
              //   rideRequestId = rideId;
              // });
              // showDriverFindingBottomSheet(rideId);
              // startDriverFindingTimer(rideId);
              // listenForDriverId(rideId);

              Get.to(() => Driver(
                    amountToBePaid: farePrice,
                    rideRequestId: rideId,
                  ));
            } else {
              // Handle error, e.g., show a message to the user
              validSnackBar("Failed to send ride request. Please try again.");
            }
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

    var details = await AssistantsMethod.obtainPlaceDirection(
        pickUpLatLng, dropOffLatLng);

    if (details != null) {
      // Calculate total distance in kilometers
      double distanceInKm = details.distanceValue! / 1000;

      // Calculate fare price
      int fare = calculateFares(details, widget.vType!);

      setState(() {
        totalDistance = distanceInKm;
        farePrice = fare;
        additionalFee = widget.isChecked ? 100 : 0;
      });

      // Navigator.pop(context);

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

  int calculateFares(DirectionDetail directionDetail, String vType) {
    double fareRate = vType == "Eicher" ? 75 : 45;
    int additionalFee = widget.isChecked ? 100 : 0;
    double distanceTraveledFare =
        (directionDetail.distanceValue! / 1000) * fareRate;
    double total = distanceTraveledFare + additionalFee;

    double totalAmount = total;

    return totalAmount.truncate();
  }
}
