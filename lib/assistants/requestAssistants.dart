import 'dart:convert';

import 'package:http/http.dart' as http;

class RequestAssistants {
  static Future<dynamic> getRequest(String url) async {
    Uri uri = Uri.parse(url);
    try {
      http.Response response = await http.get(uri);

      if (response.statusCode == 200) {
        // If the server returns a 200 OK response, parse the JSON
        var decodeData = json.decode(response.body);
        return decodeData;
      } else {
        // If the server returns an error response, throw an exception
        return 'failed';
      }
    } catch (e) {
      return 'failed';
    }
  }
}
