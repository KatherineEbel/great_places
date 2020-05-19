import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/places.dart';
import '../screens/map_screen.dart';

class PlaceDetailScreen extends StatelessWidget {
  static const routeName = '/place-detail';

  @override
  Widget build(BuildContext context) {
    final id = ModalRoute.of(context).settings.arguments as String;
    final place = Provider.of<Places>(context, listen: false).findBy(id: id);
    return Scaffold(
      appBar: AppBar(
        title: Text(place.title),
      ),
      body: Column(children: <Widget>[
        Container(
          height: 250,
          width: double.infinity,
          child: Image.file(
            place.image,
            fit: BoxFit.cover,
            width: double.infinity,
          ),
        ),
        SizedBox(height: 10,),
        Text(
            place.location.address,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20,
            color: Colors.grey,
          ),
        ),
        SizedBox(height: 10,),
        FlatButton(
          child: Text('View on Map'),
          textColor: Theme.of(context).primaryColor,
          onPressed: () => Navigator.of(context).push(
            MaterialPageRoute(
              fullscreenDialog: true,
              builder: (ctx) => MapScreen(location: place.location,)
            )
          ),
        )
      ],),
    );
  }
}
