import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class Pending extends StatefulWidget {
  const Pending({super.key});

  @override
  State<Pending> createState() => _PendingState();
}

class _PendingState extends State<Pending> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: const Color(0xFFF5F5FA),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 8.0, left: 5, right: 5),
            child: Card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    leading: SvgPicture.asset(
                        'assets/truck.svg',
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
                    padding:
                    const EdgeInsets.symmetric(horizontal: 25.0),
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
                    padding:
                    const EdgeInsets.symmetric(horizontal: 25.0),
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
                    padding:
                    const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Row(
                      children: const [
                        SizedBox(height: 20),
                        Text(
                          "Driver Details:-",
                          style:
                          TextStyle(fontWeight: FontWeight.bold),
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
            padding: const EdgeInsets.only(top: 8.0, left: 5, right: 5),
            child: Card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    leading: Image.asset('assets/truck2.png',
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
                    padding:
                    const EdgeInsets.symmetric(horizontal: 25.0),
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
                    padding:
                    const EdgeInsets.symmetric(horizontal: 25.0),
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
                    padding:
                    const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Row(
                      children: const [
                        SizedBox(height: 20),
                        Text(
                          "Driver Details:-",
                          style:
                          TextStyle(fontWeight: FontWeight.bold),
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
            padding: const EdgeInsets.only(top: 8.0, left: 5, right: 5),
            child: Card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    leading: SvgPicture.asset(
                        'assets/truck.svg',
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
                    padding:
                    const EdgeInsets.symmetric(horizontal: 25.0),
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
                    padding:
                    const EdgeInsets.symmetric(horizontal: 25.0),
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
                    padding:
                    const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Row(
                      children: const [
                        SizedBox(height: 20),
                        Text(
                          "Driver Details:-",
                          style:
                          TextStyle(fontWeight: FontWeight.bold),
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
    );
  }
}
