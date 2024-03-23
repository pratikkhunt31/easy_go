import 'package:easy_go/screens/home_screen.dart';
import 'package:easy_go/screens/login_screen.dart';
import 'package:easy_go/screens/otp_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'num_screen.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  var currentNavIndex = 0.obs;

  var navbarItem = [
    const BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
    const BottomNavigationBarItem(icon: Icon(Icons.speaker), label: "Sound"),
    const BottomNavigationBarItem(
        icon: Icon(Icons.lightbulb_rounded), label: "Light"),
    const BottomNavigationBarItem(icon: Icon(Icons.deck_sharp), label: "Event"),
    // const BottomNavigationBarItem(
    //     icon: Icon(Icons.delete_outline), label: "Dustbin"),
    // const BottomNavigationBarItem(icon: Icon(Icons.person), label: "Watchman"),
    // const BottomNavigationBarItem(
    //     icon: Icon(Icons.water_drop_sharp), label: "Diesel"),
  ];

  var navBody = [
    const HomeScreen(),
    const LoginScreen(),
    const NumberScreen(),
    const OtpScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Obx(
            () => Expanded(
              child: navBody.elementAt(currentNavIndex.value),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Obx(
        ()=> BottomNavigationBar(

          // elevation: 0,
          currentIndex: currentNavIndex.value,
          selectedItemColor: Colors.black87,
          unselectedItemColor: Colors.grey,
          selectedLabelStyle: const TextStyle(fontFamily: "sans_semibold"),
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          items: navbarItem,
          onTap: (value) {
            currentNavIndex.value = value;
          },
        ),
      ),
    );
  }
}
