import 'package:easy_go/models/address.dart';
import 'package:get/get.dart';

class AppData extends GetxController {
  var pickupLocation = Address();
  var dropOffLocation = Address();

  void updatePickUpLocationAddress(Address pickUpAddress) {
    pickupLocation = pickUpAddress;
  }

  void updateDropOffLocationAddress(Address dropOffAddress) {
    dropOffLocation = dropOffAddress;
  }
}

