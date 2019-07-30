//
//
// LICENSE: MIT
// AUTHOR: daeh@tuta.io
// TITLE: 
// DESCRIPTION: This Class is used as a Model to create a Note which
// will include the Fields: Text, Lat, Long and extends a marker
//



import 'package:flutter_map/flutter_map.dart';
import 'package:flutter/material.dart';
import 'package:latlong/latlong.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:gonotes/state/appState.dart';


@JsonSerializable(nullable: false)
class Note extends Marker{
  String note;
  double lat;
  int id;
  double long;
  Function cb;
  Function setActive;

  Note({this.note, this.lat, this.long, this.cb, this.setActive, this.id}) : super(width: 80.0,
              height: 80.0,
              point: new LatLng(lat, long),
              builder: (ctx) =>
              new Container(
                child: new IconButton(
                  icon: Icon(Icons.album),
                  onPressed: () {
                    cb(note, lat, long);
                    setActive(note, lat, long, id);
                  },
                ),
              ),);

  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
      note: json['text'],
      lat: json['lat'],
      long: json['long'],
    );
  }
}