import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:greatplaces/models/place.dart';
import 'package:greatplaces/providers/places.dart';
import 'package:greatplaces/widgets/image_input.dart';
import 'package:greatplaces/widgets/location_input.dart';
import 'package:provider/provider.dart';

class AddPlaceScreen extends StatefulWidget {
  static const routeName = '/add-place';
  @override
  _AddPlaceScreenState createState() => _AddPlaceScreenState();
}

class _AddPlaceScreenState extends State<AddPlaceScreen> {
  final _titleController = TextEditingController();
  File _pickedImage;
  Location _location;

  void _onSelectImage(File pickedImage) {
    _pickedImage = pickedImage;
  }

  void _onAddPlace() {
    if (_titleController.text.isEmpty || _pickedImage == null || _location == null) {
      return;
    }
    Provider
        .of<Places>(context, listen: false)
        .addPlace(_titleController.text, _pickedImage, _location);
    Navigator.of(context).pop();
  }

  void _onPlaceSelected(double latitude, double longitude) {
    _location = Location(longitude: longitude, latitude: latitude);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add a new place'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: <Widget>[
                    TextField(
                      decoration: InputDecoration(
                        labelText: 'Title'
                      ),
                      controller: _titleController,
                    ),
                    SizedBox(height: 10,),
                    ImageInput(onSelectImage: _onSelectImage),
                    SizedBox(height: 10,),
                    LocationInput(onPlaceSelected: _onPlaceSelected),
                  ],
                ),
              ),
            ),
          ),
          RaisedButton.icon(
            icon: Icon(
                Icons.add,
            ),
            onPressed: _onAddPlace,
            label: Text('Add Place'),
            elevation: 0,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            color: Theme.of(context).accentColor,
          )
        ],
      ),
    );
  }
}
