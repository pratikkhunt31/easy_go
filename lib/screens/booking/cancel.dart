import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:page_transition/page_transition.dart';

import '../../consts/firebase_consts.dart';
import '../../models/rideModel.dart';

class Cancel extends StatefulWidget {
  const Cancel({super.key});

  @override
  State<Cancel> createState() => _CancelState();
}

class _CancelState extends State<Cancel> {

  Stream<List<Ride>> getCancelRides() async* {
    if (currentUser == null) {
      print("User is not logged in");
      yield [];
      return;
    }

    DatabaseReference rideRequestRef =
        FirebaseDatabase.instance.ref().child('Ride Request');

    yield* rideRequestRef
        .orderByChild('u_id')
        .equalTo(currentUser!.uid)
        .onValue
        .map((event) {
      if (event.snapshot.exists) {
        Map<String, dynamic> rides =
            Map<String, dynamic>.from(event.snapshot.value as Map);
        List<Ride> filteredRides = [];

        rides.forEach((key, value) {
          Map<String, dynamic> rideData = Map<String, dynamic>.from(value);
          if (rideData['status'] == 'cancel') {
            filteredRides.add(Ride.fromMap(key, rideData));
          }
        });

        return filteredRides;
      } else {
        // print('No rides found for the current user.');
        return [];
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5FA),
      body: StreamBuilder<List<Ride>>(
        stream: getCancelRides(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
                child: CircularProgressIndicator(
              color: Color(0xFF0000FF),
            ));
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('There is no Cancel Rides.'));
          }

          List<Ride> rides = snapshot.data!;

          return ListView.builder(
            itemCount: rides.length,
            itemBuilder: (context, index) {
              Ride ride = rides[index];
              return Padding(
                padding: const EdgeInsets.only(top: 8.0, left: 5, right: 5),
                child: Card(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
                        leading: Image.asset('assets/images/truck2.png',
                            width: 50, height: 50),
                        title: Text(ride.time),
                        trailing: IconButton(
                          icon: Icon(
                            Icons.arrow_forward,
                            color: Color(0xFF0000FF),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              PageTransition(
                                // child: PendingRideDetails(ride: ride),
                                child: Container(),
                                type: PageTransitionType.bottomToTop,
                              ),
                            );
                          },
                        ),
                      ),
                      const Divider(
                        height: 1.0,
                        thickness: 1.0,
                      ),
                      const SizedBox(height: 5),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25.0),
                        child: Row(
                          children: [
                            Text("From:-"),
                            SizedBox(width: 5),
                            Expanded(
                              child: Text(ride.pickUpAddress),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25.0),
                        child: Row(
                          children: [
                            Text("To:-"),
                            SizedBox(width: 22),
                            Expanded(
                              child: Text(ride.dropOffAddress),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 5),
                      // Padding(
                      //   padding:
                      //   const EdgeInsets.symmetric(horizontal: 25.0),
                      //   child: Row(
                      //     children: const [
                      //       SizedBox(height: 20),
                      //       Text(
                      //         "Driver Details:-",
                      //         style:
                      //         TextStyle(fontWeight: FontWeight.bold),
                      //       ),
                      //       SizedBox(width: 5),
                      //       Text("Name, Mobile Number"),
                      //     ],
                      //   ),
                      // ),
                      // const SizedBox(height: 5),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
