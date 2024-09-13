import 'package:easy_go/screens/booking/cancel.dart';
import 'package:easy_go/screens/booking/complete.dart';
import 'package:easy_go/screens/booking/pending.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TabBarWidget extends StatelessWidget {
  const TabBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: const Color(0xFF0000FF),
          title: Text("bookings".tr),
          bottom:  TabBar(
            indicatorColor: Colors.white,
            indicatorWeight: 2,
            isScrollable: false,
            tabs: [
              Padding(
                padding: EdgeInsets.only(bottom: 10.0),
                child: Text(
                  "pending".tr,
                  style: TextStyle(fontSize: 18),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 10.0),
                child: Text(
                  "complete".tr,
                  style: TextStyle(fontSize: 18),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 10.0),
                child: Text(
                  "cancel".tr,
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            Pending(),
            Complete(),
            Cancel(),
          ],
        ),
      ),
    );
  }
}
