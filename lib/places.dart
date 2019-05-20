import 'dart:convert';
import 'dart:async';

import 'package:http/http.dart' as http;

import './key.dart' show key;

main() {
  getPlaces(33.9850, -118.4695);
}

class Place {
  final String name;
  final double rating;
  final String address;

  Place.fromJson(Map jsonMap)
      : name = jsonMap['name'],
        rating = jsonMap['rating']?.toDouble() ?? -1.0,
        address = jsonMap['vicinity'];

  String toString() => 'Place: $name';
}

Future<Stream<Place>> getPlaces(double lat, double lng) async {
  var url = 'https://maps.googleapis.com/maps/api/place/nearbysearch/json' +
      '?location=$lat,$lng' +
      '&radius=500&type=restaurant' +
      '&key=$key';

  var client = new http.Client();
  var streamedRes = await client.send(new http.Request('get', Uri.parse(url)));

  return streamedRes.stream
      .transform(utf8.decoder)
      .transform(json.decoder)
      .expand((jsonBody) => (jsonBody as Map)['results'])
      .map((jsonPlace) => new Place.fromJson(jsonPlace));
}
