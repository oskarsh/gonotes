import 'package:gonotes/models/Note.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:provider/provider.dart';
import 'package:gonotes/state/appState.dart';
import 'package:gonotes/apiToken.dart';

class MapTab extends StatefulWidget {
  
  MapTab();  

  @override
  State<StatefulWidget> createState() {
    return _MapTabState();
  }
}

class _MapTabState extends State<MapTab> {


  @override
  Widget build(BuildContext context) {
    
      final appState = Provider.of<AppState>(context);
      print("hello wORLD");
      print(config);
      return new FlutterMap(
      options: new MapOptions(
        center: new LatLng(51.5, -0.09),
        zoom: 5.0
      ),
      layers: [
        new TileLayerOptions(
          urlTemplate: "https://api.tiles.mapbox.com/v4/"
              "{id}/{z}/{x}/{y}@2x.png?access_token={accessToken}",
          additionalOptions: {
            'accessToken': config["MapBoxToken"],
            'id': 'mapbox.streets',
          },
        ),
        // here are the markers which well be read by an service from api
        new MarkerLayerOptions(
          markers: appState.getNotes(),
        ),
      ],
    );
  }
}


