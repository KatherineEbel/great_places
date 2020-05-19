import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../helpers/location.dart';
import '../screens/map_screen.dart';
import 'package:location/location.dart';

class LocationInput extends StatefulWidget {
  final Function onPlaceSelected;

  const LocationInput({this.onPlaceSelected});

  @override
  _LocationInputState createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {
  String _previewImageURL;

  void _showMapPreview(double lat, double lng) {
    final mapURL = LocationClient.generateMapURL(
        latitude: lat,
        longitude: lng
    );
    setState(() {
      _previewImageURL = mapURL;
    });
  }

  Future<void> _getLocation() async {
    final location = Location();
    var serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) { return; }
    }
    var permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) { return; }
    }
    final locationData = await location.getLocation();
    _showMapPreview(locationData.latitude, locationData.longitude);
    widget.onPlaceSelected(locationData.latitude, locationData.longitude);
  }

  Future<void> _onSelectOnMap() async {
    final location = await Navigator.of(context).push<LatLng>(MaterialPageRoute(
      builder: (ctx) => MapScreen(selecting: true,)
    ));

    if (location == null) { return; }
    _showMapPreview(location.latitude, location.longitude);
    widget.onPlaceSelected(location.latitude, location.longitude);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border.all(width: 1, color: Colors.grey),
          ),
          height: 170,
          width: double.infinity,
          child: _previewImageURL == null ?
          Text('No Location Chosen', textAlign: TextAlign.center,) : Image.network(
            _previewImageURL,
            fit: BoxFit.cover,
            width: double.infinity,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FlatButton.icon(
              icon: Icon(Icons.location_on),
              label: Text('Get Location', textScaleFactor: 1.0,),
              textColor: Theme.of(context).primaryColor,
              onPressed: _getLocation,
            ),
            FlatButton.icon(
              icon: Icon(Icons.map),
              label: Text('Select on Map', textScaleFactor: 1.0,),
              textColor: Theme.of(context).primaryColor,
              onPressed: _onSelectOnMap,
            ),
          ],
        )
      ],
    );
  }
}
