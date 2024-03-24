import 'package:easy_go/screens/home/home_screen.dart';
import 'package:easy_go/screens/login/login_screen.dart';
import 'package:easy_go/screens/login/otp_screen.dart';
import 'package:easy_go/screens/profile/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'login/num_screen.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  var currentNavIndex = 0.obs;

  var navbarItem = [
    const BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
    const BottomNavigationBarItem(icon: Icon(Icons.history), label: "Bookings"),
    const BottomNavigationBarItem(
        icon: Icon(Icons.account_balance_wallet_sharp), label: "Wallet"),
    const BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
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
    const ProfileScreen(),
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
          // elevation: 0.5,
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
