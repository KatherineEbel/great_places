import 'dart:io';

import 'package:flutter/foundation.dart';
import '../helpers/db.dart';
import '../models/place.dart';

class Places with ChangeNotifier {
  List<Place> _places = [];

  List<Place> get allPlaces {
    return [..._places];
  }

  Future<void> addPlace(String title, File image) async {
    final place = Place(
      id: DateTime.now().toString(),
      title: title,
      image: image,
      location: null,
    );
    _places.add(place);
    await DB.insert('places', {
      'id': place.id,
      'title': place.title,
      'image': place.image.path,
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
        location: null
      );
    }).toList();
    notifyListeners();
  }
}