import 'package:easy_go/assistants/requestAssistants.dart';
import 'package:easy_go/consts/firebase_consts.dart';
import 'package:easy_go/dataHandler/appData.dart';
import 'package:easy_go/models/address.dart' ;
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

class AssistantsMethod {
  static Future<String> searchCoordinateAddress(Position position) async {
    String placeAddress = "";
    // String st0, st1, st2, st3, st4, st5, st6;
    String url =
        "https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=$mapKey";

    var response = await RequestAssistants.getRequest(url);

    if(response != 'failed'){
      // st0 = response["results"][0]["address_components"][0]["long_name"];
      // st1 = response["results"][0]["address_components"][1]["long_name"];
      // st2 = response["results"][0]["address_components"][5]["long_name"];
      // st3 = response["results"][0]["address_components"][6]["long_name"];
      // st4 = response["results"][0]["address_components"][5]["long_name"];
      // st5 = response["results"][0]["address_components"][7]["long_name"];
      // st6 = response["results"][0]["address_components"][6]["long_name"];

      // placeAddress = st0 + ", " + st1 + ", " + st2 + ", "+ st3 + ", ";
          // + st4 + ", "+ st5 + ", " + st6;
          //  + st3 + ", " + st4;
      placeAddress = response["results"][0]["formatted_address"];


      Address userPickUpAddress = new Address();
      userPickUpAddress.longitude = position.longitude;
      userPickUpAddress.latitude = position.latitude;
      userPickUpAddress.placeName = placeAddress;

      final appData = Get.put(AppData());

      appData.updatePickUpLocationAddress(userPickUpAddress);

      // Provider.of<AppData>(context).updatePickUpLocationAddress(userPickUpAddress);
    }
    return placeAddress;
  }
}
