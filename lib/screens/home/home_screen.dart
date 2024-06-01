import 'package:easy_go/screens/location/location_detail.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:page_transition/page_transition.dart';

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
    requestLocationPermission();
  }

  Future<void> requestLocationPermission() async {
    PermissionStatus status = await Permission.location.request();
    if (status != PermissionStatus.granted) {
      print('Location permission is not granted');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("City Name"),
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
                                  const Text(
                                    "Your Current Location",
                                    style: TextStyle(fontSize: 18),
                                  ),
                                  Row(
                                    children: const [
                                      Text(
                                        "Surat",
                                        style: TextStyle(fontSize: 15),
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
                                ],
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0, left: 10.0),
                          child: RichText(
                            text: const TextSpan(
                              children: [
                                TextSpan(
                                  text: "Welcome to ",
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.black87,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                TextSpan(
                                  text: "Easy Go\n",
                                  style: TextStyle(
                                    fontSize: 24,
                                    color: Color(0xFF0000FF), // Highlight color
                                    fontWeight: FontWeight.bold,
                                    // decoration: TextDecoration.underline, // Underline for emphasis
                                  ),
                                ),
                                // WidgetSpan(
                                //   child: SizedBox(height: 30),
                                // ),
                                // TextSpan(
                                //   text:
                                //       "Where Every Delivery Begins with Ease.",
                                //   style: TextStyle(
                                //     fontSize: 20,
                                //     color: Colors.black87,
                                //   ),
                                // ),
                              ],
                            ),
                          ),
                        ),
                        // const SizedBox(height: 10),
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
                              "Are you looking for Parcel Delivery?",
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                          SizedBox(height: 10),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              VehicleCard(
                                vName: "Atul Shakti",
                                image: 'assets/images/atul-shakti.png',
                                height: 150,
                                onPress: () {
                                  Navigator.push(
                                    context,
                                    PageTransition(
                                      child: LocationDetail(vType: "tempo"),
                                      type: PageTransitionType.bottomToTop,
                                    ),
                                  );
                                  // Get.to(() => LocationDetail());
                                },
                              ),
                              const SizedBox(width: 10),
                              VehicleCard(
                                vName: "Chhota Hathi",
                                image: 'assets/images/mini.png',
                                height: 110,
                                onPress: () {
                                  Get.to(() => LocationDetail());
                                },
                              ),

                            ],
                          ),
                          SizedBox(height: 10),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              VehicleCard(
                                vName: "Suzuki Pickup",
                                image: 'assets/images/suzuki.png',
                                height: 110,
                                onPress: () {
                                  Get.to(() => LocationDetail());
                                },
                              ),
                              const SizedBox(width: 10),
                              // Add space between SizedBox widgets
                              VehicleCard(
                                vName: "Bolero",
                                image: 'assets/images/bolero.png',
                                height: 110,
                                onPress: () {
                                  Get.to(() => LocationDetail());
                                },
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              VehicleCard(
                                vName: "e-Tempo",
                                image: 'assets/images/e-tempo.png',
                                height: 110,
                                onPress: () {
                                  Get.to(() => LocationDetail());
                                },
                              ),
                              const SizedBox(width: 10),
                              // Add space between SizedBox widgets
                              VehicleCard(
                                vName: "Auto Rickshaw",
                                image: 'assets/images/auto.png',
                                height: 110,
                                onPress: () {
                                  Get.to(() => LocationDetail());
                                },
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              VehicleCard(
                                vName: "e-Rickshaw",
                                image: 'assets/images/e-rickshaw.jpg',
                                height: 110,
                                onPress: () {
                                  Get.to(() => LocationDetail());
                                },
                              ),
                              const SizedBox(width: 10),
                              // Add space between SizedBox widgets
                              VehicleCard(
                                vName: "Eicher",
                                image: 'assets/images/eicher.png',
                                height: 90,
                                onPress: () {
                                  Get.to(() => LocationDetail());
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
              Container(
                width: double.infinity,
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.only(left: 10.0, right: 10),
                  child: Column(
                    children: [
                      const SizedBox(height: 10),
                      Row(
                        children: const [
                          Icon(Icons.history, size: 18),
                          SizedBox(width: 8),
                          Text(
                            "Recent Bookings",
                            style: TextStyle(fontSize: 18),
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Card(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ListTile(
                                leading: Image.asset('assets/images/truck2.png',
                                    width: 50, height: 50),
                                title: const Text('Date and Time'),
                                trailing: const Text('\$1000'),
                              ),
                              const Divider(
                                height: 1.0,
                                thickness: 1.0,
                              ),
                              const SizedBox(height: 5),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 25.0),
                                child: Row(
                                  children: const [
                                    Text("From:-"),
                                    SizedBox(width: 5),
                                    Expanded(
                                      child: Text(
                                          "Pick up Address Pick up Address Pick up Address"),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 8),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 25.0),
                                child: Row(
                                  children: const [
                                    Text("From:-"),
                                    SizedBox(width: 5),
                                    Expanded(
                                      child: Text(
                                          "Drop Location Drop Location Drop Location Drop Location"),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 5),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 25.0),
                                child: Row(
                                  children: const [
                                    SizedBox(height: 20),
                                    Text(
                                      "Driver Details:-",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(width: 5),
                                    Text("Name, Mobile Number"),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 5),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Card(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ListTile(
                                leading: Image.asset('assets/images/truck2.png',
                                    width: 50, height: 50),
                                title: const Text('Date and Time'),
                                trailing: const Text('\$1000'),
                              ),
                              const Divider(
                                height: 1.0,
                                thickness: 1.0,
                              ),
                              const SizedBox(height: 5),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 25.0),
                                child: Row(
                                  children: const [
                                    Text("From:-"),
                                    SizedBox(width: 5),
                                    Expanded(
                                      child: Text(
                                          "Pick up Address Pick up Address Pick up Address"),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 8),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 25.0),
                                child: Row(
                                  children: const [
                                    Text("From:-"),
                                    SizedBox(width: 5),
                                    Expanded(
                                      child: Text(
                                          "Drop Location Drop Location Drop Location Drop Location"),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 5),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 25.0),
                                child: Row(
                                  children: const [
                                    SizedBox(height: 20),
                                    Text(
                                      "Driver Details:-",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(width: 5),
                                    Text("Name, Mobile Number"),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 5),
                            ],
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
      ),
    );
  }
}
