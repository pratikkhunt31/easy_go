import 'package:easy_go/consts/firebase_consts.dart';
import 'package:easy_go/screens/location/map_screen.dart';
import 'package:easy_go/widget/custom_widget.dart';
import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../assistants/assistantsMethod.dart';
import '../../widget/loc_detail_widget.dart';

class LocationDetail extends StatefulWidget {
  const LocationDetail({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _LocationDetailState createState() => _LocationDetailState();
}

class _LocationDetailState extends State<LocationDetail> {
  // final GlobalKey<ExpansionTileCardState> cardA = GlobalKey();
  // final GlobalKey<ExpansionTileCardState> cardB = GlobalKey();
  TextEditingController nameController = TextEditingController();
  TextEditingController numberController = TextEditingController();
  TextEditingController locController = TextEditingController();

  bool isChecked = false;
  bool isFetchingLocation = false;
  GoogleMapController? newMapController;
  Position? currentLocation;

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
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        currentLocation = position;
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
      print("This is your address: " + address);
      setState(() {
        locController.text = address;
      });
    } catch (e) {
      // Handle any errors that occur during location fetching
      validSnackBar('Error fetching location: $e');
      throw e; // Re-throw the error to propagate it further if needed
    }
  }

  @override
  Widget build(BuildContext context) {
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
                    height: 55,
                    width: double.infinity,
                    child: DetailWidget(
                      labelText: "Location",
                      controller: locController,
                      icon: Icons.location_on_sharp,
                    ),
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
                            await locatePosition();
                          } catch (e) {
                            // Handle any errors that occur while fetching the location
                            validSnackBar('Error fetching location: $e');
                          } finally {
                            Navigator.pop(context); // Close the progress dialog
                          }
                        },
                      ),
                      const SizedBox(width: 7),
                      LocationButton(
                        label: "Locate On The Map",
                        icon: Icons.map_sharp,
                        onPress: () {
                          Get.to(() => MapScreen());
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
                                isChecked = newValue ??
                                    false; // Update the checkbox state
                                if (isChecked) {
                                  // Set the value of nameController to the current user's name
                                  nameController.text =
                                      currentUser!.phoneNumber ??
                                          ''; // Ensure null safety
                                } else {
                                  // Optionally, reset the value of nameController when checkbox is unchecked
                                  nameController.text =
                                      ''; // Set to empty string or any desired default value
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
                        controller: nameController,
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
                'Drop Details',
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
                    height: 55,
                    width: double.infinity,
                    child: DetailWidget(
                      labelText: "Location",
                      controller: nameController,
                      icon: Icons.location_on_sharp,
                    ),
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
                        onPress: () {},
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
                        controller: nameController,
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
              print(currentUser);
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
}
