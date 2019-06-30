import 'dart:convert';
import 'package:gonotes/models/Note.dart';
import 'package:http/http.dart' as http;
import 'package:gonotes/apiToken.dart';
import 'package:dio/dio.dart';

const baseUrl = "http://localhost:1337";
final authHeader = {"Authorization": "Bearer " + config["sampleBearerToken"]};


Future fetchNotesFromApi() async {
  print("JSON");

  try {
    Response response = await Dio().get(baseUrl + "/Notes");
    var entries = response.data;
    print(entries);

    // array to collect the notes generated
    var collectedNotes = [];

    for (var entry in entries) {

      var lat = entry["lat"];
      var long = entry["long"];
      var note = entry["note"];

      // checking the types
      if (lat.runtimeType == int) {
        print("CONVERTING");
        lat = lat + .0;
        print(lat.runtimeType);
      }

      // checking the types
      if (long.runtimeType == int) {
        long = long + .0;
      }

      collectedNotes.add(new Note(lat: lat, long: long, note: note));
    }
    return collectedNotes;
  } catch (e) {
    print("ERROR");
    print(e);
  }
}

postNotesToApi2(Note note) async {
  var client = new http.Client();
  print("SENDING POST TO SERVER");
  var newNote = {
    "text": note.note.toString(),
    "lat": note.lat.toString(),
    "long": note.long.toString()
  };

  print(newNote);
  try {
    var uriResponse = await client.post(
        baseUrl + '/save/Notes?token=' + config["APIToken"].toString(),
        body: {"data": "hello"});
    print("response");
    print(uriResponse.statusCode);
  } finally {
    client.close();
  }
}

postNotesToApi(Note note) async {
  var client = new http.Client();
  print("SENDING POST TO SERVER");
  var newNote = {
    "note": note.note.toString(),
    "lat": note.lat,
    "long": note.long
  };

  print(newNote);
  Dio dio = new Dio();
  var response = await dio.post(
      baseUrl + "/Notes",
      data: newNote,
      options: Options(headers: authHeader)
      
      );
  print(response);
}
