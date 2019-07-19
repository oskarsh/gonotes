import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:provider/provider.dart';
import 'package:gonotes/state/appState.dart';
import 'package:gonotes/apiToken.dart';
import 'package:gonotes/api/LocationService.dart';

class MapTab extends StatefulWidget {
  MapTab();

  @override
  State<StatefulWidget> createState() {
    return _MapTabState();
  }
}

class _MapTabState extends State<MapTab> {
  Timer timer;
  double _lat = 0;
  double _long = 0;

  void didChangeDependencies() {
    timer = Timer.periodic(
        // Duration(seconds: 15), (Timer t) => getCurrentPosition());
  }

  void getCurrentPosition() {
    print("searching");
    getLocation().then((location) {
      double lat = location.latitude;
      double long = location.longitude;
      setState(() {
        _lat = lat;
        _long = long;
      });
    });
    print("inside location");
    print(_lat);
    print(_long);
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print(_lat);
    final appState = Provider.of<AppState>(context);
    return new FlutterMap(
      options: new MapOptions(center: new LatLng(_lat, _long), zoom: 5.0),
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
