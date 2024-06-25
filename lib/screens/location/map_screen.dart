import 'dart:async';

import 'package:easy_go/assistants/assistantsMethod.dart';
import 'package:easy_go/widget/custom_widget.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shimmer/shimmer.dart';

import '../../dataHandler/appData.dart';
import '../../models/address.dart';

class PickUpMapScreen extends StatefulWidget {
  const PickUpMapScreen({
    super.key,
  });

  @override
  State<PickUpMapScreen> createState() => _PickUpMapScreenState();
}

class _PickUpMapScreenState extends State<PickUpMapScreen> {
  final Completer<GoogleMapController> mapController =
      Completer<GoogleMapController>();
  GoogleMapController? newMapController;
  Position? currentLocation;
  var geoLocator = Geolocator();
  String? currentAddress;
  bool isLoading = false;
  AppData appData = AppData();

  // final LocationController _locationController = Get.find<LocationController>();

  @override
  void initState() {
    super.initState();
    // Call the method to check and request location permissions
    checkLocationPermission();
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

        updateAddress(latLngPosition);
    } catch (e) {
      // validSnackBar('Error fetching location: $e');
      throw e;
    }
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
        title: Text("Location"),
        backgroundColor: const Color(0xFF0000FF),
      ),
      body: Stack(
        children: [
          GoogleMap(
            mapType: MapType.normal,
            myLocationButtonEnabled: true,
            initialCameraPosition: _kGooglePlex,
            myLocationEnabled: true,
            zoomGesturesEnabled: true,
            zoomControlsEnabled: true,
            onMapCreated: (GoogleMapController controller) {
              mapController.complete(controller);
              newMapController = controller;
              locatePosition();
            },
            onCameraMove: (CameraPosition position) {
              updateAddress(position.target);
            },
          ),
          Center(
            child: Image.asset('assets/images/marker2.png'),
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
                              onPress: () async {
                                if (currentAddress != null) {
                                  // Navigator.pop(context, currentAddress);
                                  Get.back(result: currentAddress);
                                }
                                // confirmLocation();
                                // _locationController.updateSelectedLocation(currentAddress!);
                                // Get.back();
                              },
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5)),
                            ),
                          )
                        : CustomButton(
                            hint: "Confirm Location",
                            onPress: () async {
                              if (currentAddress != null) {
                                locatePosition();
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
