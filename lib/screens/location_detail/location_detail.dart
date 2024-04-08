import 'package:easy_go/widget/custom_widget.dart';
import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

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
                      const SizedBox(width: 7),
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
                        controller: nameController,
                        icon: Icons.call,
                      ),
                      // Add some vertical spacing between fields and checkbox
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
                                                const Text("Waiting for Driver Acceptance")
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
