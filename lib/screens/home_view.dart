import 'package:easy_go/screens/home/home_screen.dart';
import 'package:easy_go/screens/profile/profile_screen.dart';
import 'package:easy_go/screens/wallet/wallet.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/home_controller.dart';
import '../widget/custom_widget.dart';
import 'booking/bookings.dart';

class HomeView extends StatelessWidget {
  HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(HomeController());

    var navbarItem = [
      BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
      BottomNavigationBarItem(icon: Icon(Icons.history), label: "Bookings"),
      BottomNavigationBarItem(
          icon: Icon(Icons.account_balance_wallet_sharp), label: "Wallet"),
      BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
    ];

    var navBody = [
      HomeScreen(),
      Bookings(),
      Wallet(),
      ProfileScreen(),
    ];

    return WillPopScope(
      onWillPop: () async {
        showDialog(context: context, builder: (context) => exitDialog(context));
        return false;
      },
      child: Scaffold(
        body: Column(
          children: [
            Obx(
              () => Expanded(
                child: navBody.elementAt(controller.currentNavIndex.value),
              ),
            ),
          ],
        ),
        bottomNavigationBar: Obx(
          () => BottomNavigationBar(
            // elevation: 0.5,
            currentIndex: controller.currentNavIndex.value,
            selectedItemColor: Colors.black87,
            unselectedItemColor: Colors.grey,
            selectedLabelStyle: const TextStyle(fontFamily: "sans_semibold"),
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.white,
            items: navbarItem,
            onTap: (value) {
              controller.currentNavIndex.value = value;
            },
          ),
        ),
      ),
    );
  }
}
