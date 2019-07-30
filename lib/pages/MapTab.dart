import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:provider/provider.dart';
import 'package:gonotes/state/appState.dart';
import 'package:gonotes/apiToken.dart';
import 'package:gonotes/api/LocationService.dart';
import 'package:geolocator/geolocator.dart';

class MapTab extends StatefulWidget {
  MapTab();

  @override
  State<StatefulWidget> createState() {
    return _MapTabState();
  }
}

List<Marker> _markers = [
  Marker(
    width: 80.0,
    height: 80.0,
    point: LatLng(51.5, -0.09),
    builder: (ctx) => Container(
      child: Icon(Icons.brightness_1),
    ),
  ),
];

class _MapTabState extends State<MapTab> {
  Timer timer;
  double _lat = 0;
  double _long = 0;
  Marker _marker;
  int _markerIndex = 0;
  MapController _mapController;

  @override
  void initState() {
    super.initState();
    _marker = _markers[_markerIndex];
    _mapController = MapController();

    var geolocator = Geolocator();
    var locationOptions =
        LocationOptions(accuracy: LocationAccuracy.high, distanceFilter: 10);

    StreamSubscription<Position> positionStream = geolocator
        .getPositionStream(locationOptions)
        .listen((Position position) {
      var lat = position.latitude;
      var long = position.longitude;
      var currPosMarker = new Marker(
        width: 80.0,
        height: 80.0,
        point: LatLng(lat, long),
        builder: (ctx) => Container(
          key: Key('purple'),
          child: new Icon(Icons.brightness_1),
        ),
      );

      print("MARKERS LENGTH");
      print(_markers.length);
      print("INDEX");
      print(_markerIndex);
      setState(() {
        _marker = _markers[_markerIndex];
        _markerIndex = (_markerIndex + 1) % _markers.length;
        _lat = lat;
        _long = long;
      });
      _markers.add(currPosMarker);
      _mapController.move(LatLng(lat, long), 17.0);
      print(position == null
          ? 'Unknown'
          : position.latitude.toString() +
              ', ' +
              position.longitude.toString());
    });
  }

  void didChangeDependencies() {
    // _mapController.move(LatLng(_lat, _long), 5.0);
  }


  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    return new FlutterMap(
      mapController: _mapController,
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
        new MarkerLayerOptions(markers: <Marker>[_marker])
      ],
    );
  }
}
