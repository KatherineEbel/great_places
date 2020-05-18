import 'package:flutter/material.dart';
import 'package:greatplaces/providers/places.dart';
import 'package:greatplaces/screens/add_place_screen.dart';
import 'package:provider/provider.dart';

class PlacesListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Places'),
        actions: <Widget>[
          IconButton(
            icon: Icon(
                Icons.add,
            ),
            onPressed: () {
              Navigator.of(context).pushNamed(AddPlaceScreen.routeName);
            },
          )
        ],
      ),
      body: FutureBuilder(
        future: Provider.of<Places>(context, listen: false).getAll(),
        builder: (ctx, snapshot) => snapshot.connectionState == ConnectionState.waiting
            ? Center(child: CircularProgressIndicator(),) : Consumer<Places>(
          child: Center(
            child: const Text('Start adding some places!'),
          ),
          builder: (ctx, places, child) => places.allPlaces.isEmpty
              ? child : ListView.builder(
            itemCount: places.allPlaces.length,
            itemBuilder: (ctx, i) => ListTile(
              leading: CircleAvatar(
                backgroundImage: FileImage(places.allPlaces[i].image),
              ),
              title: Text(places.allPlaces[i].title),
              onTap: () {
                // TODO: go to detail page
              },
            ),
          ),
        ),
      ),
    );
  }
}
