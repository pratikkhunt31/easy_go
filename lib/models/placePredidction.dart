import 'package:easy_go/assistants/requestAssistants.dart';
import 'package:easy_go/consts/firebase_consts.dart';
import 'package:easy_go/models/address.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../dataHandler/appData.dart';

class PlacePrediction {
  String secondary_text;
  String main_text;
  String place_id;

  PlacePrediction({required this.secondary_text, required this.main_text, required this.place_id});

  PlacePrediction.fromJson(Map<String, dynamic> json) :
        place_id = json["place_id"] ?? '',
        main_text = json["structured_formatting"]?["main_text"] ?? '',
        secondary_text = json["structured_formatting"]?["secondary_text"] ?? '';

}

// getPlaceAddressDetails(placePrediction.place_id, context);

class PlaceTile extends StatelessWidget {
  final PlacePrediction placePrediction;

  const PlaceTile({super.key, required this.placePrediction});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(Icons.location_on, color: Colors.green),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  placePrediction.main_text.isNotEmpty
                      ? placePrediction.main_text
                      : "No main text available",
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 5),
                Text(
                  placePrediction.secondary_text.isNotEmpty
                      ? placePrediction.secondary_text
                      : "No secondary text available",
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 14.0, color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

}

void getPickUpAddressDetails(String placeId, context) async{

  String placeDetailsUrl = "https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$mapKey";

  var res = await RequestAssistants.getRequest(placeDetailsUrl);

  // Navigator.pop(context);

  if(res=="failed"){
    return;
  }

  if(res["status"] == "OK"){
    Address address = Address();
    address.placeName = res["result"]["name"];
    address.placeId = placeId;
    address.latitude = res["result"]["geometry"]["location"]["lat"];
    address.longitude = res["result"]["geometry"]["location"]["lng"];

    final appData = Get.put(AppData());

    appData.updatePickUpLocationAddress(address);
    print("This is PickUp: ${address.placeName}");
  }
}

void getDropOffAddressDetails(String placeId, context) async{

  String placeDetailsUrl = "https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$mapKey";

  var res = await RequestAssistants.getRequest(placeDetailsUrl);

  // Navigator.pop(context);

  if(res=="failed"){
    return;
  }

  if(res["status"] == "OK"){
    Address address = Address();
    address.placeName = res["result"]["name"];
    address.placeId = placeId;
    address.latitude = res["result"]["geometry"]["location"]["lat"];
    address.longitude = res["result"]["geometry"]["location"]["lng"];

    final appData = Get.put(AppData());

    appData.updateDropOffLocationAddress(address);
    print("This is DropOff: ${address.placeName}");
  }
}





// import 'package:flutter/material.dart';
//

//
//
// class PlaceTile extends StatelessWidget {
//   final PlacePrediction placePrediction;
//
//   const PlaceTile({super.key, required this.placePrediction});
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child: Column(
//         children: [
//           SizedBox(height: 10),
//           Row(
//             children: [
//               Icon(Icons.location_on),
//               SizedBox(width: 10),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       placePrediction.main_text.isNotEmpty ? placePrediction.main_text : "No main text available",
//                       // placePrediction.main_text,
//                       overflow: TextOverflow.ellipsis,
//                       style: TextStyle(fontSize: 16.0),
//                     ),
//                     SizedBox(height: 5),
//                     Text(
//                       placePrediction.secondary_text.isNotEmpty ? placePrediction.secondary_text : "No secondary text available",
//                       // placePrediction.secondary_text,
//                       overflow: TextOverflow.ellipsis,
//                       style: TextStyle(fontSize: 16.0),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//           SizedBox(height: 5),
//         ],
//       ),
//     );
//   }
// }
