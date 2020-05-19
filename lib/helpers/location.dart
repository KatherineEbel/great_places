// Google maps key AIzaSyBlJzSccn-Q_-ksA1HcU50HZQL-7iKHY2c
import 'dart:convert';

import 'package:http/http.dart';

// TODO: Add Google API KEY
const GOOGLE_API_KEY = '[GOOGLE_API_KEY]';

class LocationClient {
  static String generateMapURL({double latitude, double longitude}) {
    final baseURL = 'https://maps.googleapis.com/maps/api/staticmap';
    final queryString = '?center=$latitude,$longitude&zoom=13&size=600x300&maptype=roadmap&markers=color:red%7Clabel:C%7C$latitude,$longitude&key=$GOOGLE_API_KEY';
    return baseURL + queryString;
  }

  static Future<String> getPlaceAddress(double lat, double lng) async {
    final url = 'https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$lng&key=$GOOGLE_API_KEY';
    final response = await get(url);
    final placeData = json.decode(response.body);
    return placeData['results'][0]['formatted_address'];
  }
}

