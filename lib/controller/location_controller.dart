import 'package:easy_go/controller/shared_pref.dart';
import 'package:geocoding/geocoding.dart' as geo;
import 'package:get/get.dart';
import 'package:location/location.dart';

class LocationController extends GetxController {
  late RxString city;
  RxBool isLocating = false.obs;
  static LocationController instance = Get.find();

  @override
  void onInit() async {
    city = (await SharedPref.getLocation()).obs;
    super.onInit();
  }

  Future<void> getLocation() async {
    Location location = Location();
    bool serviceEnabled;
    PermissionStatus permissionGranted;
    LocationData locationData;
    setIsLocating(false);

    //check if the location service enabled or not
    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    //check the location permission is granted or not
    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    setIsLocating(true);
    //getting the current location
    locationData = await location.getLocation();

    var address =
        await geo.GeocodingPlatform.instance?.placemarkFromCoordinates(
      locationData.latitude!,
      locationData.longitude!,
    );
    isLocating(false);
    setCity(address![0].locality!);
  }

  setCity(String myCity) async {
    city = myCity.obs;
    await SharedPref.storeLocation(myCity);
    update();
  }

  setIsLocating(bool val) {
    isLocating = val.obs;
    update();
  }
}
