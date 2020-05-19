import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:greatplaces/helpers/location.dart';
import '../helpers/db.dart';
import '../models/place.dart';

class Places with ChangeNotifier {
  List<Place> _places = [];

  List<Place> get allPlaces {
    return [..._places];
  }

  Future<void> addPlace(String title, File image, Location location) async {
    final address = await LocationClient.getPlaceAddress(location.latitude, location.longitude);
    final place = Place(
      id: DateTime.now().toString(),
      title: title,
      image: image,
      location: Location(
          latitude: location.latitude,
          longitude: location.longitude,
          address: address),
    );
    _places.add(place);
    await DB.insert('places', {
      'id': place.id,
      'title': place.title,
      'image': place.image.path,
      'latitude': place.location.latitude,
      'longitude': place.location.longitude,
      'address': place.location.address
    });
    notifyListeners();
  }

  Future<void> getAll() async {
    final placesList = await DB.query('places');
    _places = placesList.map((place) {
      return Place(
        id: place['id'],
        title: place['title'],
        image: File(place['image']),
        location: Location(
          longitude: place['longitude'],
          latitude: place['latitude'],
          address: place['address']
        )
      );
    }).toList();
    notifyListeners();
  }

  Place findBy({String id}) {
    return _places.firstWhere((place) => place.id == id);
  }
}