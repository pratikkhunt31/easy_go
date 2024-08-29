import 'dart:async';

import 'package:easy_go/assistants/assistantsMethod.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as loc;
import 'package:shimmer/shimmer.dart';
import '../../widget/custom_widget.dart';

class DropOffMapScreen extends StatefulWidget {
  const DropOffMapScreen({super.key});

  @override
  State<DropOffMapScreen> createState() => _DropOffMapScreenState();
}

class _DropOffMapScreenState extends State<DropOffMapScreen> {
  final Completer<GoogleMapController> mapController =
      Completer<GoogleMapController>();
  final Completer<GoogleMapController> controller = Completer();
  GoogleMapController? newMapController;
  Position? currentLocation;
  var geoLocator = Geolocator();
  String? currentAddress;
  bool isLoading = false;
  loc.LocationData? initialLocation;
  Timer? locationUpdateTimer;

  @override
  void initState() {
    super.initState();
    // Call the method to check and request location permissions
    Future.microtask(() {
      showDialog(
        context: context,
        builder: (BuildContext context) =>
            ProgressDialog(message: "Processing, Please wait..."),
        barrierDismissible: false,
      );
      checkLocationPermission();
      getCurrentLocation();
      Future.delayed(Duration(seconds: 3), () {
        setState(() {
          isLoading = false; // Set isLoading to false after loading is done
        });
        Navigator.of(context).pop(); // Dismiss the dialog
      });
    });
  }

  void checkLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      // Request location permissions if not granted or permanently denied
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        // Handle the case where the user denies or permanently denies permission
        validSnackBar('User denied or permanently denied location permission');
      } else {
        locatePosition();
      }
    } else {
      locatePosition();
    }
  }

  Future<void> locatePosition() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      if (mounted) {
        setState(() {
          currentLocation = position;
        });
      }

      LatLng latLngPosition = LatLng(position.latitude, position.longitude);

      CameraPosition cameraPosition =
      new CameraPosition(target: latLngPosition, zoom: 18);

      newMapController
          ?.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

      // String address = await AssistantsMethod.searchCoordinateAddress(position);

      updateLocationDetailsAfterDelay(latLngPosition);
    } catch (e) {
      // validSnackBar('Error fetching location: $e');
      throw e;
    }
  }

  void updateLocationDetailsAfterDelay(LatLng position) {
    locationUpdateTimer?.cancel(); // Cancel previous timer
    locationUpdateTimer = Timer(const Duration(milliseconds: 100), () {
      // Fetch location details after 500 milliseconds of inactivity
      updateAddress(position);
    });
  }

  void updateAddress(LatLng position) async {
    setState(() {
      isLoading = true;
    });

    String address = await AssistantsMethod.searchDropCoordinateAddress(Position(
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

  void getCurrentLocation() async {
    loc.Location location = loc.Location();

    location.getLocation().then((location) => initialLocation = location);

    GoogleMapController googleMapController = await controller.future;

    location.onLocationChanged.listen((newLoc) {
      initialLocation = newLoc;

      googleMapController.animateCamera(CameraUpdate.newCameraPosition(
          CameraPosition(
              zoom: 13.5,
              target: LatLng(newLoc.latitude!, newLoc.longitude!))));

      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Location"),
        backgroundColor: const Color(0xFF0000FF),
        elevation: 0,
      ),
      body: Stack(
        children: [
          if (initialLocation != null)
            GoogleMap(
              mapType: MapType.normal,
              myLocationButtonEnabled: true,
              initialCameraPosition: CameraPosition(
                target: LatLng(
                    initialLocation!.latitude!, initialLocation!.longitude!),
                zoom: 18,
              ),
              myLocationEnabled: true,
              zoomGesturesEnabled: true,
              zoomControlsEnabled: true,
              onMapCreated: (GoogleMapController controller) {
                mapController.complete(controller);
                newMapController = controller;
                locatePosition();
              },
              onCameraMove: (CameraPosition position) {
                updateLocationDetailsAfterDelay(position.target);
              },
            ),
          Center(
            child: Image.asset('assets/images/drop-pin.png'),
          ),
          if (currentAddress != null)
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                // margin: EdgeInsets.symmetric(horizontal: 15),
                padding:
                    EdgeInsets.only(top: 10, left: 15, right: 15, bottom: 15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    isLoading
                        ? Shimmer.fromColors(
                            baseColor: Colors.grey[300]!,
                            highlightColor: Colors.grey[100]!,
                            child: Container(
                              // width: double.infinity,
                              height: 20,
                              color: Colors.white,
                            ),
                          )
                        : Text(
                            currentAddress!,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black87,
                            ),
                            textAlign: TextAlign.center,
                          ),
                    SizedBox(height: 15),
                    isLoading
                        ? Shimmer.fromColors(
                            baseColor: Colors.grey[300]!,
                            highlightColor: Colors.grey[100]!,
                            child: CustomButton(
                              hint: "Confirm Location",
                              onPress: () {
                                if (currentAddress != null) {
                                  // Navigator.pop(context, currentAddress);
                                  Get.back(result: currentAddress);
                                }

                              },
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5)),
                            ),
                          )
                        : CustomButton(
                            hint: "Confirm Location",
                            onPress: () {

                              if (currentAddress != null) {
                                Navigator.pop(context, currentAddress);
                              }
                              // confirmLocation();
                              // ElevatedButton(
                              //   onPressed: () {
                              //     if (currentAddress != null) {
                              //       Navigator.pop(context, currentAddress);
                              //     }
                              //   },
                              //   child: Text("Select this location"),
                              // ),
                            },
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                          ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// static const CameraPosition _kGooglePlex = CameraPosition(
//   target: LatLng(initialLocation.latitude, -122.085749655962),
//   zoom: 18,
// );
