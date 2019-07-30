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
      child: FlutterLogo(),
    ),
  ),
  Marker(
    width: 80.0,
    height: 80.0,
    point: LatLng(53.3498, -6.2603),
    builder: (ctx) => Container(
      child: FlutterLogo(),
    ),
  ),
  Marker(
    width: 80.0,
    height: 80.0,
    point: LatLng(48.8566, 2.3522),
    builder: (ctx) => Container(
      child: FlutterLogo(),
    ),
  ),
];

class _MapTabState extends State<MapTab> {
  Timer timer;
  double _lat = 0;
  double _long = 0;
  Marker _marker;
  Timer _timer;
  int _markerIndex = 0;

    @override
  void initState() {
    super.initState();
    _marker = _markers[_markerIndex];

    // _timer = Timer.periodic(Duration(seconds: 2), (_) {
    // getLocation().then((location) {
    //   var lat = location.latitude;
    //   var long = location.longitude;
    //   print(_markerIndex);
    //   print(long);
    //   print(lat);
    //   var currPosMarker = new Marker(
    //     width: 80.0,
    //     height: 80.0,
    //     point: LatLng(lat, long),
    //     builder: (ctx) => Container(
    //       key: Key('purple'),
    //       child: new Icon(Icons.change_history),
    //     ),
    //   );
    // _markers.add(currPosMarker);
    //   setState(() {
    //     _marker = _markers[_markerIndex];
    //     _markerIndex = (_markerIndex + 1) % _markers.length;
    //   });
    // });
    // });

    var geolocator = Geolocator();
var locationOptions = LocationOptions(accuracy: LocationAccuracy.high, distanceFilter: 10);

  StreamSubscription<Position> positionStream = geolocator.getPositionStream(locationOptions).listen(
    (Position position) {
      var lat = position.latitude;
      var long = position.longitude;
        var currPosMarker = new Marker(
        width: 80.0,
        height: 80.0,
        point: LatLng(lat, long),
        builder: (ctx) => Container(
          key: Key('purple'),
          child: new Icon(Icons.change_history),
        ),
      );
    _markers.add(currPosMarker);
      setState(() {
        _marker = _markers[_markerIndex];
        _markerIndex = (_markerIndex + 1) % _markers.length;
      });
      print(position == null ? 'Unknown' : position.latitude.toString() + ', ' + position.longitude.toString());
    });

  }

  void didChangeDependencies() {
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
        new MarkerLayerOptions(markers: <Marker>[_marker])
      ],
    );
  }
}
