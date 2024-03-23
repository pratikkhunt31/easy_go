import 'package:easy_go/screens/home_screen.dart';
import 'package:easy_go/screens/num_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    // TODO: implement initState
    ChangeScreen();
    super.initState();
  }

  void ChangeScreen(){
    Future.delayed(const Duration(seconds: 2), (){
      Get.off(() => const NumberScreen());

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Image.asset('assets/delivery.gif'),
      ),
    );
  }
}
