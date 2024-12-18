import 'package:easy_go/controller/location_controller.dart';
import 'package:easy_go/screens/home/select_location.dart';
import 'package:easy_go/screens/location/location_detail.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:page_transition/page_transition.dart';
import '../../consts/firebase_consts.dart';
import '../../controller/shared_pref.dart';
import '../../widget/custom_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SharedPref.getLocation()
        .then((value) => LocationController.instance.setCity(value));
    requestLocationPermission();
    checkNotificationPermission();
    updateFcmToken();
    checkForUpdate();
  }

  Future<void> requestLocationPermission() async {
    PermissionStatus status = await Permission.location.request();
    if (status != PermissionStatus.granted) {
      print('Location permission is not granted');
    }
  }

  void checkNotificationPermission() async {
    PermissionStatus permission = await Permission.notification.status;
    if (permission.isDenied || permission.isPermanentlyDenied) {
      // Request notification permissions if not granted or permanently denied
      permission = await Permission.notification.request();

      if (permission.isGranted) {
        // Permission granted
        // validSnackBar('Notification permission granted.');
      } else {
        // Handle the case where the user denies or permanently denies permission
        validSnackBar('You have to enable notification permission.');
      }
    } else {}
  }

  Future<void> updateFcmToken() async {
    try {
      if (currentUser != null) {
        FirebaseMessaging fMessaging = FirebaseMessaging.instance;
        final fCMToken = await fMessaging.getToken();

        DatabaseReference database = FirebaseDatabase.instance.ref();
        await database
            .child('users')
            .child(currentUser!.uid)
            .update({'fcmToken': fCMToken});
      } else {
        // print("User is not logged in");
      }
    } catch (e) {
      print("Failed to update FCM token: $e");
    }
  }

  // Future<void> checkForUpdate() async {
  //   InAppUpdate.checkForUpdate().then((value) {
  //     setState(() {
  //       if (value.updateAvailability == UpdateAvailability.updateAvailable) {
  //         update();
  //       }
  //     });
  //   }).catchError((e) {});
  // }
  //
  // void update() async {
  //   await InAppUpdate.startFlexibleUpdate();
  //   InAppUpdate.completeFlexibleUpdate().then((_) {}).catchError((e) {});
  // }
  Future<void> checkForUpdate() async {
    try {
      AppUpdateInfo updateInfo = await InAppUpdate.checkForUpdate();
      if (updateInfo.updateAvailability == UpdateAvailability.updateAvailable) {
        showUpdateDialog();
      }
    } catch (e) {
      // Handle the error appropriately, if needed
      // showErrorSnackBar('Failed to check for updates. Please try again later.');
    }
  }

  void showUpdateDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Update Available'),
          content: Text('A new version of the app is available. Please update to continue using the app.'),
          actions: <Widget>[
            TextButton(
              child: Text('Later'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Update'),
              onPressed: () {
                Navigator.of(context).pop();
                performUpdate();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> performUpdate() async {
    try {
      await InAppUpdate.startFlexibleUpdate();
      await InAppUpdate.completeFlexibleUpdate();
      showSuccessSnackBar('App updated successfully.');
    } catch (e) {
      showErrorSnackBar('Failed to update the app. Please try again later.');
    }
  }

  void showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
      ),
    );
  }

  void showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text("welcomeMessage".tr),
        backgroundColor: const Color(0xFF0000FF),
        elevation: 0,
        // leading: null,
      ),
      body: SingleChildScrollView(
        child: Container(
          color: const Color(0xFFF5F5FA),
          child: Column(
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10),
                      ),
                      color: Colors.white,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 12),
                        Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.location_on_sharp,
                                size: 40,
                                color: Colors.green,
                              ),
                              const SizedBox(width: 8),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                   Text(
                                    "location".tr,
                                    style: TextStyle(fontSize: 18),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Get.to(() => SelectLocation());
                                    },
                                    child: Row(
                                      children: [
                                        Text(
                                          LocationController
                                              .instance.city.value,
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(left: 8.0),
                                          child: Icon(
                                            Icons.arrow_forward_sharp,
                                            size: 18,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        // Padding(
                        //   padding: const EdgeInsets.only(top: 10.0, left: 10.0),
                        //   child: RichText(
                        //     text: const TextSpan(
                        //       children: [
                        //         TextSpan(
                        //           text: "Welcome to ",
                        //           style: TextStyle(
                        //             fontSize: 20,
                        //             color: Colors.black87,
                        //             fontWeight: FontWeight.bold,
                        //           ),
                        //         ),
                        //         TextSpan(
                        //           text: "Easy Go\n",
                        //           style: TextStyle(
                        //             fontSize: 24,
                        //             color: Color(0xFF0000FF), // Highlight color
                        //             fontWeight: FontWeight.bold,
                        //             // decoration: TextDecoration.underline, // Underline for emphasis
                        //           ),
                        //         ),
                        //         // WidgetSpan(
                        //         //   child: SizedBox(height: 30),
                        //         // ),
                        //         // TextSpan(
                        //         //   text:
                        //         //       "Where Every Delivery Begins with Ease.",
                        //         //   style: TextStyle(
                        //         //     fontSize: 20,
                        //         //     color: Colors.black87,
                        //         //   ),
                        //         // ),
                        //       ],
                        //     ),
                        //   ),
                        // ),
                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10),
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                      ),
                      color: Colors.white,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 10.0, right: 10.0, bottom: 10.0),
                      child: Column(
                        children: [
                          SizedBox(height: 10),
                          Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              "lookingParcelDeliver".tr,
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                          SizedBox(height: 10),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              VehicleCard(
                                vName: "atulShakti".tr,
                                image: 'assets/images/atul-shakti.png',
                                height: 150,
                                onPress: () {
                                  Navigator.push(
                                    context,
                                    PageTransition(
                                      child:
                                          LocationDetail(vType: "Atul Shakti"),
                                      type: PageTransitionType.bottomToTop,
                                    ),
                                  );
                                  // Get.to(() => LocationDetail());
                                },
                              ),
                              const SizedBox(width: 10),
                              VehicleCard(
                                vName: "chotaHathi".tr,
                                image: 'assets/images/mini.png',
                                height: 110,
                                onPress: () {
                                  Navigator.push(
                                    context,
                                    PageTransition(
                                      child:
                                          LocationDetail(vType: "Chhota Hathi"),
                                      type: PageTransitionType.bottomToTop,
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              VehicleCard(
                                vName: "suzuki".tr,
                                image: 'assets/images/suzuki.png',
                                height: 110,
                                onPress: () {
                                  Navigator.push(
                                    context,
                                    PageTransition(
                                      child: LocationDetail(
                                          vType: "Suzuki Pickup"),
                                      type: PageTransitionType.bottomToTop,
                                    ),
                                  );
                                },
                              ),
                              const SizedBox(width: 10),
                              // Add space between SizedBox widgets
                              VehicleCard(
                                vName: "bolero".tr,
                                image: 'assets/images/bolero.png',
                                height: 110,
                                onPress: () {
                                  Navigator.push(
                                    context,
                                    PageTransition(
                                      child: LocationDetail(vType: "Bolero"),
                                      type: PageTransitionType.bottomToTop,
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              VehicleCard(
                                vName: "eTempo".tr,
                                image: 'assets/images/e-tempo.png',
                                height: 110,
                                onPress: () {
                                  Navigator.push(
                                    context,
                                    PageTransition(
                                      child: LocationDetail(vType: "e-Tempo"),
                                      type: PageTransitionType.bottomToTop,
                                    ),
                                  );
                                },
                              ),
                              const SizedBox(width: 10),
                              // Add space between SizedBox widgets
                              VehicleCard(
                                vName: "rickshaw".tr,
                                image: 'assets/images/auto.png',
                                height: 110,
                                onPress: () {
                                  Navigator.push(
                                    context,
                                    PageTransition(
                                      child: LocationDetail(
                                          vType: "Auto Rickshaw"),
                                      type: PageTransitionType.bottomToTop,
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              VehicleCard(
                                vName: "eRickshaw".tr,
                                image: 'assets/images/e-rickshaw.jpg',
                                height: 110,
                                onPress: () {
                                  Navigator.push(
                                    context,
                                    PageTransition(
                                      child:
                                          LocationDetail(vType: "e-Rickshaw"),
                                      type: PageTransitionType.bottomToTop,
                                    ),
                                  );
                                },
                              ),
                              const SizedBox(width: 10),
                              // Add space between SizedBox widgets
                              VehicleCard(
                                vName: "eicher".tr,
                                image: 'assets/images/eicher.png',
                                height: 90,
                                onPress: () {
                                  Navigator.push(
                                    context,
                                    PageTransition(
                                      child: LocationDetail(vType: "Eicher"),
                                      type: PageTransitionType.bottomToTop,
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              // Container(
              //   width: double.infinity,
              //   color: Colors.white,
              //   child: Padding(
              //     padding: const EdgeInsets.only(left: 10.0, right: 10),
              //     child: Column(
              //       children: [
              //         const SizedBox(height: 10),
              //         Row(
              //           children: const [
              //             Icon(Icons.history, size: 18),
              //             SizedBox(width: 8),
              //             Text(
              //               "Recent Bookings",
              //               style: TextStyle(fontSize: 18),
              //             ),
              //           ],
              //         ),
              //         const SizedBox(height: 5),
              //         // Expanded(
              //         //   child: StreamBuilder<List<Ride>>(
              //         //     stream: getPendingRides(),
              //         //     builder: (context, snapshot) {
              //         //       if (snapshot.connectionState ==
              //         //           ConnectionState.waiting) {
              //         //         return Center(
              //         //             child: CircularProgressIndicator(
              //         //           color: Color(0xFF0000FF),
              //         //         ));
              //         //       } else if (snapshot.hasError) {
              //         //         return Center(
              //         //             child: Text('Error: ${snapshot.error}'));
              //         //       } else if (!snapshot.hasData ||
              //         //           snapshot.data!.isEmpty) {
              //         //         return Center(
              //         //             child: Text('There is no pending request.'));
              //         //       }
              //         //
              //         //       List<Ride> rides = snapshot.data!;
              //         //
              //         //       return ListView.builder(
              //         //         itemCount: rides.length,
              //         //         itemBuilder: (context, index) {
              //         //           Ride ride = rides[index];
              //         //           return Padding(
              //         //             padding: const EdgeInsets.only(
              //         //                 top: 8.0, left: 5, right: 5),
              //         //             child: Card(
              //         //               child: Column(
              //         //                 crossAxisAlignment:
              //         //                     CrossAxisAlignment.start,
              //         //                 children: [
              //         //                   ListTile(
              //         //                     leading: Image.asset(
              //         //                         'assets/images/truck2.png',
              //         //                         width: 50,
              //         //                         height: 50),
              //         //                     title: Text(ride.time),
              //         //                     trailing: IconButton(
              //         //                       icon: Icon(
              //         //                         Icons.arrow_forward,
              //         //                         color: Color(0xFF0000FF),
              //         //                       ),
              //         //                       onPressed: () {
              //         //                         Navigator.push(
              //         //                           context,
              //         //                           PageTransition(
              //         //                             // child: PendingRideDetails(ride: ride),
              //         //                             child: Container(),
              //         //                             type: PageTransitionType
              //         //                                 .bottomToTop,
              //         //                           ),
              //         //                         );
              //         //                       },
              //         //                     ),
              //         //                   ),
              //         //                   const Divider(
              //         //                     height: 1.0,
              //         //                     thickness: 1.0,
              //         //                   ),
              //         //                   const SizedBox(height: 5),
              //         //                   Padding(
              //         //                     padding: const EdgeInsets.symmetric(
              //         //                         horizontal: 25.0),
              //         //                     child: Row(
              //         //                       children: [
              //         //                         Text("From:-"),
              //         //                         SizedBox(width: 5),
              //         //                         Expanded(
              //         //                           child: Text(ride.pickUpAddress),
              //         //                         ),
              //         //                       ],
              //         //                     ),
              //         //                   ),
              //         //                   const SizedBox(height: 8),
              //         //                   Padding(
              //         //                     padding: const EdgeInsets.symmetric(
              //         //                         horizontal: 25.0),
              //         //                     child: Row(
              //         //                       children: [
              //         //                         Text("To:-"),
              //         //                         SizedBox(width: 22),
              //         //                         Expanded(
              //         //                           child:
              //         //                               Text(ride.dropOffAddress),
              //         //                         ),
              //         //                       ],
              //         //                     ),
              //         //                   ),
              //         //                   const SizedBox(height: 5),
              //         //                 ],
              //         //               ),
              //         //             ),
              //         //           );
              //         //         },
              //         //       );
              //         //     },
              //         //   ),
              //         // ),
              //         SizedBox(height: 200),
              //         // Padding(
              //         //   padding: const EdgeInsets.only(bottom: 8.0),
              //         //   child: Card(
              //         //     child: Column(
              //         //       crossAxisAlignment: CrossAxisAlignment.start,
              //         //       children: [
              //         //         ListTile(
              //         //           leading: Image.asset('assets/images/truck2.png',
              //         //               width: 50, height: 50),
              //         //           title: const Text('Date and Time'),
              //         //           trailing: const Text('\$1000'),
              //         //         ),
              //         //         const Divider(
              //         //           height: 1.0,
              //         //           thickness: 1.0,
              //         //         ),
              //         //         const SizedBox(height: 5),
              //         //         Padding(
              //         //           padding: const EdgeInsets.symmetric(
              //         //               horizontal: 25.0),
              //         //           child: Row(
              //         //             children: const [
              //         //               Text("From:-"),
              //         //               SizedBox(width: 5),
              //         //               Expanded(
              //         //                 child: Text(
              //         //                     "Pick up Address Pick up Address Pick up Address"),
              //         //               ),
              //         //             ],
              //         //           ),
              //         //         ),
              //         //         const SizedBox(height: 8),
              //         //         Padding(
              //         //           padding: const EdgeInsets.symmetric(
              //         //               horizontal: 25.0),
              //         //           child: Row(
              //         //             children: const [
              //         //               Text("From:-"),
              //         //               SizedBox(width: 5),
              //         //               Expanded(
              //         //                 child: Text(
              //         //                     "Drop Location Drop Location Drop Location Drop Location"),
              //         //               ),
              //         //             ],
              //         //           ),
              //         //         ),
              //         //         const SizedBox(height: 5),
              //         //         Padding(
              //         //           padding: const EdgeInsets.symmetric(
              //         //               horizontal: 25.0),
              //         //           child: Row(
              //         //             children: const [
              //         //               SizedBox(height: 20),
              //         //               Text(
              //         //                 "Driver Details:-",
              //         //                 style: TextStyle(
              //         //                     fontWeight: FontWeight.bold),
              //         //               ),
              //         //               SizedBox(width: 5),
              //         //               Text("Name, Mobile Number"),
              //         //             ],
              //         //           ),
              //         //         ),
              //         //         const SizedBox(height: 5),
              //         //       ],
              //         //     ),
              //         //   ),
              //         // ),
              //         // Padding(
              //         //   padding: const EdgeInsets.only(bottom: 8.0),
              //         //   child: Card(
              //         //     child: Column(
              //         //       crossAxisAlignment: CrossAxisAlignment.start,
              //         //       children: [
              //         //         ListTile(
              //         //           leading: Image.asset('assets/images/truck2.png',
              //         //               width: 50, height: 50),
              //         //           title: const Text('Date and Time'),
              //         //           trailing: const Text('\$1000'),
              //         //         ),
              //         //         const Divider(
              //         //           height: 1.0,
              //         //           thickness: 1.0,
              //         //         ),
              //         //         const SizedBox(height: 5),
              //         //         Padding(
              //         //           padding: const EdgeInsets.symmetric(
              //         //               horizontal: 25.0),
              //         //           child: Row(
              //         //             children: const [
              //         //               Text("From:-"),
              //         //               SizedBox(width: 5),
              //         //               Expanded(
              //         //                 child: Text(
              //         //                     "Pick up Address Pick up Address Pick up Address"),
              //         //               ),
              //         //             ],
              //         //           ),
              //         //         ),
              //         //         const SizedBox(height: 8),
              //         //         Padding(
              //         //           padding: const EdgeInsets.symmetric(
              //         //               horizontal: 25.0),
              //         //           child: Row(
              //         //             children: const [
              //         //               Text("From:-"),
              //         //               SizedBox(width: 5),
              //         //               Expanded(
              //         //                 child: Text(
              //         //                     "Drop Location Drop Location Drop Location Drop Location"),
              //         //               ),
              //         //             ],
              //         //           ),
              //         //         ),
              //         //         const SizedBox(height: 5),
              //         //         Padding(
              //         //           padding: const EdgeInsets.symmetric(
              //         //               horizontal: 25.0),
              //         //           child: Row(
              //         //             children: const [
              //         //               SizedBox(height: 20),
              //         //               Text(
              //         //                 "Driver Details:-",
              //         //                 style: TextStyle(
              //         //                     fontWeight: FontWeight.bold),
              //         //               ),
              //         //               SizedBox(width: 5),
              //         //               Text("Name, Mobile Number"),
              //         //             ],
              //         //           ),
              //         //         ),
              //         //         const SizedBox(height: 5),
              //         //       ],
              //         //     ),
              //         //   ),
              //         // ),
              //       ],
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
