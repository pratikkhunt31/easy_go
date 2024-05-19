
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../screens/login/num_screen.dart';

class HomeController extends GetxController {

  var currentNavIndex = 0.obs;
  @override
  void onReady() {
    super.onReady();
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        Get.offAll(() => NumberScreen());
      }
    });
  }
}