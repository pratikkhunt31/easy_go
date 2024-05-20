import 'package:easy_go/models/address.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppData extends GetxController{
    var pickupLocation = Rxn<Address>();

  void updatePickUpLocationAddress(Address pickUpAddress) {
    pickupLocation.value = pickUpAddress;
  }
}
//
// class AppData1 extends ChangeNotifier{
//   Address? pickUpLocation;
//
//   void updatePickUpLocationAddress(Address pickUpAddress) {
//     pickUpLocation = pickUpAddress;
//     notifyListeners();
//   }
// }