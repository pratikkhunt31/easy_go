import 'package:easy_go/assistants/requestAssistants.dart';
import 'package:easy_go/consts/firebase_consts.dart';
import 'package:geolocator/geolocator.dart';

class AssistantsMethod {
  static Future<String> searchCoordinateAddress(Position position) async {
    String placeAddress = "";
    String url =
        "https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=$mapKey";

    var response = await RequestAssistants.getRequest(url);

    if(response != 'failed'){
      placeAddress = response["results"][0]["formatted_address"];
    }
    return placeAddress;
  }
}
