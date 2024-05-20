import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/material.dart';

class DetailWidget extends StatelessWidget {
  const DetailWidget({
    super.key,
    required this.controller,
    required this.icon,
    required this.labelText,
  });

  final String labelText;
  final IconData icon;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      cursorColor: Colors.black,
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
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
          icon,
          color: const Color(0xFF0000FF),
        ),
      ),
    );
  }
}

class LocationButton extends StatelessWidget {
  const LocationButton({
    super.key,
    required this.label,
    required this.icon,
    required this.onPress,
  });

  final String label;
  final IconData icon;
  final Function onPress;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          onPress();
        },
        child: Container(
          decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(5),
              border: Border.all(color: Colors.grey.shade500)),
          padding: const EdgeInsets.only(left: 5, top: 12, bottom: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: const Color(0xFF0000FF),
                size: 20,
              ),
              const SizedBox(width: 3),
              Text(
                label,
                style: const TextStyle(color: Colors.black, fontSize: 13),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

ExpansionTileCard dropCard(
    TextEditingController nameController,
TextEditingController numberController

    ) {
  return ExpansionTileCard(
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
  );
}
