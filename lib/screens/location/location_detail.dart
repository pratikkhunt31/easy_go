import 'package:easy_go/assistants/requestAssistants.dart';
import 'package:easy_go/consts/firebase_consts.dart';
import 'package:easy_go/dataHandler/appData.dart';
import 'package:easy_go/models/placePredidction.dart';
import 'package:easy_go/screens/location/map_screen.dart';
import 'package:easy_go/widget/custom_widget.dart';
import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import '../../assistants/assistantsMethod.dart';
import '../../models/address.dart';
import '../../widget/loc_detail_widget.dart';

class LocationDetail extends StatefulWidget {
  const LocationDetail({
    Key? key,
  }) : super(key: key);

  @override
  _LocationDetailState createState() => _LocationDetailState();
}

class _LocationDetailState extends State<LocationDetail> {
  // final GlobalKey<ExpansionTileCardState> cardA = GlobalKey();
  // final GlobalKey<ExpansionTileCardState> cardB = GlobalKey();
  TextEditingController nameController = TextEditingController();
  TextEditingController numberController = TextEditingController();
  TextEditingController pickUpLocController = TextEditingController();
  TextEditingController goodsController = TextEditingController();
  TextEditingController rNameController = TextEditingController();
  TextEditingController rNumberController = TextEditingController();
  TextEditingController dropOffLocController = TextEditingController();

  List<PlacePrediction> placePredictionList = [];
  PlacePrediction? placePrediction;

  bool isChecked = false;
  bool isFetchingLocation = false;
  GoogleMapController? newMapController;
  Position? currentPickLocation;
  Position? currentDropLocation;
  late AppData appData;

  @override
  void initState() {
    super.initState();
    // Call the method to check and request location permissions
    checkLocationPermission();
    appData = Get.put(AppData());
    // currentUser!.updateDisplayName("displayName");
    // printPickupLocation();
  }

  // void printPickupLocation() {
  //   final address = appData.pickupLocation.value;
  //   if (address != null) {
  //     print(
  //         "Pickup Location: ${address.placeName}, ${address.latitude}, ${address.longitude}");
  //     // pickUpLocController.text = address.placeName!;
  //   } else {
  //     print("No pickup location set");
  //   }
  // }

  // void updateLocationFromMap(Position position) async {
  //   String address = await AssistantsMethod.searchCoordinateAddress(position);
  //   setState(() {
  //     currentLocation = position;
  //     pickUpLocController.text = address;
  //   });
  // }

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
        // locatePosition();
      }
    } else {
      // locatePosition();
    }
  }

  Future<void> locatePosition() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        currentPickLocation = position;
      });

      LatLng latLngPosition = LatLng(position.latitude, position.longitude);

      CameraPosition cameraPosition = CameraPosition(
        target: latLngPosition,
        zoom: 18,
      );

      await newMapController?.animateCamera(
        CameraUpdate.newCameraPosition(cameraPosition),
      );

      String address = await AssistantsMethod.searchCoordinateAddress(position);
      // print("This is your address: " + address);

      setState(() {
        pickUpLocController.text = address;
      });

      appData.updatePickUpLocationAddress(Address(
        placeName: address,
        latitude: position.latitude,
        longitude: position.longitude,
      ));
    } catch (e) {
      // Handle any errors that occur during location fetching
      validSnackBar('Error fetching location: $e');
      throw e; // Re-throw the error to propagate it further if needed
    }
  }

  Future<void> locateDropPosition() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        currentDropLocation = position;
      });

      LatLng latLngPosition = LatLng(position.latitude, position.longitude);

      CameraPosition cameraPosition = CameraPosition(
        target: latLngPosition,
        zoom: 18,
      );

      await newMapController?.animateCamera(
        CameraUpdate.newCameraPosition(cameraPosition),
      );

      String address = await AssistantsMethod.searchCoordinateAddress(position);
      // print("This is your address: " + address);

      setState(() {
        dropOffLocController.text = address;
      });

      appData.updateDropOffLocationAddress(Address(
        placeName: address,
        latitude: position.latitude,
        longitude: position.longitude,
      ));
    } catch (e) {
      // Handle any errors that occur during location fetching
      validSnackBar('Error fetching location: $e');
      throw e; // Re-throw the error to propagate it further if needed
    }
  }

  @override
  Widget build(BuildContext context) {
    // final address = appData.pickupLocation.value;
    // if(address != null) {
    //   pickUpLocController.text = address.placeName!;
    // }

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5FA),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: Padding(
          padding: const EdgeInsets.only(left: 12.0),
          child: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
            onPressed: () {
              Get.back();
            },
          ),
        ),
      ),
      body: ListView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: ExpansionTileCard(
              borderRadius: BorderRadius.circular(15),
              leading: const Icon(
                Icons.flag_sharp,
                size: 35,
                color: Colors.green,
              ),
              title: const Text(
                'Pick up Details',
                style: TextStyle(color: Colors.black),
              ),
              children: <Widget>[
                const Divider(
                  thickness: 1.0,
                  height: 1.0,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10.0,
                    vertical: 15.0,
                  ),
                  child: SizedBox(
                    width: double.infinity,
                    child: TextFormField(
                      cursorColor: Colors.black,
                      readOnly: true,
                      onTap: pickUpLocationSearchSheet,
                      onChanged: (val) {
                        findPlace(val);
                      },
                      controller: pickUpLocController,
                      decoration: InputDecoration(
                        labelText: "Location",
                        labelStyle: const TextStyle(color: Colors.black),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: const BorderSide(color: Colors.black),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: const BorderSide(color: Colors.black),
                        ),
                        prefixIcon: Icon(
                          Icons.location_on_sharp,
                          color: const Color(0xFF0000FF),
                        ),
                      ),
                    ),
                    // DetailWidget(
                    //   labelText: "Location",
                    //   controller: pickUpLocController,
                    //   icon: Icons.location_on_sharp,
                    // ),
                  ),
                ),
                // (placePredictionList.length > 0)
                //     ? Padding(
                //         padding: EdgeInsets.symmetric(vertical: 1.0),
                //         child: ListView.separated(
                //           itemBuilder: (context, index) {
                //             return PlaceTile(
                //                 placePrediction: placePredictionList[index]);
                //           },
                //           separatorBuilder: (BuildContext context, int index) =>
                //               Divider(),
                //           itemCount: placePredictionList.length,
                //           shrinkWrap: true,
                //           physics: ClampingScrollPhysics(),
                //           padding: EdgeInsets.only(left: 8),
                //         ),
                //       )
                //     : Container(),
                Padding(
                  padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    // mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      LocationButton(
                        label: "Use Current Location",
                        icon: Icons.my_location,
                        onPress: () async {
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (BuildContext context) {
                              return ProgressDialog(
                                  message: "Fetching location detail");
                            },
                          );
                          try {
                            await locatePosition();
                          } catch (e) {
                            // Handle any errors that occur while fetching the location
                            validSnackBar('Error fetching location: $e');
                            print(e);
                          } finally {
                            Navigator.pop(context); // Close the progress dialog
                          }
                        },
                      ),
                      const SizedBox(width: 7),
                      LocationButton(
                        label: "Locate On The Map",
                        icon: Icons.map_sharp,
                        onPress: () async {
                          final selectedLocation = await Navigator.push(
                            context,
                            PageTransition(
                                child: PickUpMapScreen(),
                                type: PageTransitionType.rightToLeft),
                          );
                          if (selectedLocation != null) {
                            setState(() {
                              pickUpLocController.text =
                                  selectedLocation as String;
                            });
                          }
                          // Get location from MapScreen and update locController
                          //   Get.to(MapScreen());
                        },
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 10.0, right: 10, top: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: const [
                          Text(
                            "Sender's Detail :-",
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      DetailWidget(
                        labelText: "Name",
                        controller: nameController,
                        icon: Icons.person,
                      ),
                      const SizedBox(height: 10),
                      DetailWidget(
                        labelText: "Mobile Number",
                        controller: numberController,
                        icon: Icons.call,
                      ),
                      // Add some vertical spacing between fields and checkbox
                      Row(
                        children: [
                          Checkbox(
                            value: isChecked,
                            onChanged: (bool? newValue) {
                              setState(() {
                                isChecked = newValue ?? false;
                                if (isChecked) {
                                  nameController.text =
                                      currentUser!.displayName ?? '';
                                  numberController.text =
                                      currentUser!.phoneNumber ?? ' ';
                                } else {
                                  nameController.text = '';
                                  numberController.text = '';
                                }
                              });
                            },
                          ),
                          const Text(
                            'Use My Details',
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      DetailWidget(
                        labelText: "Enter Good's Type",
                        controller: goodsController,
                        icon: Icons.insights_outlined,
                      ),
                      const SizedBox(height: 15),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 15),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: ExpansionTileCard(
              borderRadius: BorderRadius.circular(15),
              leading:
                  // Image.asset("assets/bottom-left.png"),
                  const Icon(
                Icons.flag_sharp,
                size: 35,
                color: Colors.red,
              ),
              title: const Text(
                'Drop off Details',
                style: TextStyle(color: Colors.black),
              ),
              children: <Widget>[
                const Divider(
                  thickness: 1.0,
                  height: 1.0,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10.0,
                    vertical: 15.0,
                  ),
                  child: SizedBox(
                    width: double.infinity,
                    child: TextFormField(
                      cursorColor: Colors.black,
                      readOnly: true,
                      onTap: () {
                        dropOFfLocationSearchSheet;
                      },
                      onChanged: (val) {
                        findPlace(val);
                      },
                      controller: dropOffLocController,
                      decoration: InputDecoration(
                        labelText: "Location",
                        labelStyle: const TextStyle(color: Colors.black),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: const BorderSide(color: Colors.black),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: const BorderSide(color: Colors.black),
                        ),
                        prefixIcon: Icon(
                          Icons.location_on_sharp,
                          color: const Color(0xFF0000FF),
                        ),
                      ),
                    ),
                    // DetailWidget(
                    //   labelText: "Location",
                    //   controller: pickUpLocController,
                    //   icon: Icons.location_on_sharp,
                    // ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    // mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      LocationButton(
                        label: "Use Current Location",
                        icon: Icons.my_location,
                        onPress: () async {
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (BuildContext context) {
                              return ProgressDialog(
                                  message: "Fetching location detail");
                            },
                          );
                          try {
                            await locateDropPosition();
                          } catch (e) {
                            // Handle any errors that occur while fetching the location
                            validSnackBar('Error fetching location: $e');
                            print(e);
                          } finally {
                            Navigator.pop(context); // Close the progress dialog
                          }
                        },
                      ),
                      const SizedBox(width: 5),
                      LocationButton(
                        label: "Locate On The Map",
                        icon: Icons.map_sharp,
                        onPress: () {},
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 10.0, right: 10, top: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: const [
                          Text(
                            "Receiver's Detail :-",
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      DetailWidget(
                        labelText: "Name",
                        controller: nameController,
                        icon: Icons.person,
                      ),
                      const SizedBox(height: 10),
                      DetailWidget(
                        labelText: "Mobile Number",
                        controller: numberController,
                        icon: Icons.call,
                      ),
                      const SizedBox(height: 5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: const [
                          Icon(Icons.info_outline, size: 18),
                          SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              "Receiver wil receive OTP on this number "
                              "to verify",
                              style: TextStyle(fontSize: 12),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Checkbox(
                            value: false, // Set initial value of checkbox
                            onChanged: (bool? newValue) {
                              // Handle checkbox value change
                            },
                          ),
                          const Text(
                            'Use My Details',
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          CustomButton(
            hint: "hint",
            onPress: () {
              // print(appData.dropOffLocation.placeName);
              // print(appData.pickupLocation.placeName);
              getPlaceDirection();
            },
            borderRadius: BorderRadius.circular(10),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10),
            child: CustomButton(
              hint: "Continue",
              onPress: () {
                showModalBottomSheet(
                  context: context,
                  builder: (BuildContext context) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 16),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Select the truck',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Divider(
                            thickness: 1.0,
                            height: 1.0,
                          ),
                          Card(
                            child: ListTile(
                              leading: SvgPicture.asset('assets/truck.svg',
                                  width: 50, height: 50),
                              title: const Text(
                                'Truck Name',
                                style: TextStyle(fontSize: 18),
                              ),
                              subtitle: const Text('Up to 100 Kg'),
                              trailing: const Text('\$1000'),
                              onTap: () {
                                // Handle selection of the first truck
                              },
                            ),
                          ),
                          const SizedBox(height: 10),
                          Card(
                            child: ListTile(
                              leading: Image.asset('assets/truck2.png',
                                  width: 50, height: 50),
                              title: const Text(
                                'Truck Name',
                                style: TextStyle(fontSize: 18),
                              ),
                              subtitle: const Text('Up to 50 Kg'),
                              trailing: const Text('\$1500'),
                              onTap: () {
                                // Handle selection of the second truck
                              },
                            ),
                          ),
                          const SizedBox(height: 20),
                          Align(
                            alignment: Alignment.center,
                            child: CustomButton(
                              hint: "Continue",
                              onPress: () {
                                showModalBottomSheet(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 20, horizontal: 16),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Center(
                                            child: Column(
                                              children: [
                                                const Text(
                                                  'Find the Driver',
                                                  style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                const SizedBox(height: 10),
                                                const Divider(
                                                  thickness: 1.0,
                                                  height: 1.0,
                                                ),
                                                const SizedBox(height: 10),
                                                Container(
                                                  decoration: BoxDecoration(
                                                      color:
                                                          Colors.grey.shade300,
                                                      shape: BoxShape.circle),
                                                  child: const Icon(
                                                    Icons.person,
                                                    size: 70,
                                                    color: Color(0xFF0000FF),
                                                  ),
                                                ),
                                                const SizedBox(height: 15),
                                                const Text(
                                                    "Waiting for Driver Acceptance")
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                );
                              },
                              borderRadius: BorderRadius.circular(5),
                              color: const Color(0xFF0000FF),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
              color: const Color(0xFF0000FF),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ],
      ),
    );
  }

  void findPlace(String placeName) async {
    if (placeName.length > 1) {
      String autoCompleteUrl =
          "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$placeName&key=$mapKey&sessiontoken=1234567890&components=country:in";

      var res = await RequestAssistants.getRequest(autoCompleteUrl);

      if (res == "failed") {
        return;
      }
      print("Places");
      print(res);
      if (res["status"] == "OK") {
        var predictions = res["predictions"];

        var placeList = (predictions as List)
            .map((e) => PlacePrediction.fromJson(e))
            .toList();
        print("Destination: $placeList");
        setState(() {
          placePredictionList = placeList;
        });
      }
    }
  }

  void pickUpLocationSearchSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: FractionallySizedBox(
            heightFactor: 0.7,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextFormField(
                    controller: pickUpLocController,
                    onChanged: (val) {
                      findPlace(val);
                    },
                    decoration: InputDecoration(
                      labelText: "Search Location",
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: placePredictionList.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            pickUpLocController.text =
                                placePredictionList[index].main_text;
                            // getPlaceAddressDetails(placePrediction!.place_id, context);
                          });
                          Navigator.pop(context);
                          getPickUpAddressDetails(
                              placePredictionList[index].place_id, context);
                        },
                        child: PlaceTile(
                            placePrediction: placePredictionList[index]),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void dropOFfLocationSearchSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: FractionallySizedBox(
            heightFactor: 0.7,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextFormField(
                    controller: dropOffLocController,
                    onChanged: (val) {
                      findPlace(val);
                    },
                    decoration: InputDecoration(
                      labelText: "Search Location",
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: placePredictionList.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            dropOffLocController.text =
                                placePredictionList[index].main_text;
                            // getPlaceAddressDetails(placePrediction!.place_id, context);
                          });
                          Navigator.pop(context);
                          getPickUpAddressDetails(
                              placePredictionList[index].place_id, context);
                        },
                        child: PlaceTile(
                            placePrediction: placePredictionList[index]),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> getPlaceDirection() async {
    var initialPos = appData.pickupLocation;
    var finalPos = appData.dropOffLocation;

    var pickUpLatLng = LatLng(initialPos.latitude!, initialPos.longitude!);
    var dropOffLatLng = LatLng(finalPos.latitude!, finalPos.longitude!);

    showDialog(
        context: context,
        builder: (BuildContext context) => ProgressDialog(message: "message"));

    var details = await AssistantsMethod.obtainPlaceDirectionDirection(
        pickUpLatLng, dropOffLatLng);

    Navigator.pop(context);

    print("This is Encoded Points: ${details!.encodedPoint}");
    print(details.encodedPoint);
  }
}
