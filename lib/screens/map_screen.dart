import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as gm;
import '../models/place.dart';

class MapScreen extends StatefulWidget {
  final Location location;
  final bool selecting;

  const MapScreen({
    this.location = const Location(latitude: 37.422, longitude: -122.084),
    this.selecting = false,
  });
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  gm.LatLng _location;
  void _selectLocation(gm.LatLng location) {
    setState(() {
      _location = location;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your map'),
        actions: <Widget>[
          if (widget.selecting)
            IconButton(
              icon: Icon(Icons.check),
              onPressed: () => Navigator.of(context).pop(_location),
            ),
        ],
      ),
      body: gm.GoogleMap(
        initialCameraPosition: gm.CameraPosition(
          target: gm.LatLng(widget.location.latitude, widget.location.longitude),
          zoom: 16,
        ),
        onTap: widget.selecting ? _selectLocation : null,
        markers: _location == null && widget.selecting ? null : {
          gm.Marker(markerId: gm.MarkerId('m1'), position: _location ?? gm.LatLng(
            widget.location.latitude, widget.location.longitude
          ))
        },
      ),
    );
  }
}
