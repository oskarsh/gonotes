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
      var id = entry["id"];

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

      collectedNotes.add(new Note(lat: lat, long: long, note: note, id: id));
    }
    return collectedNotes;
  } catch (e) {
    print("ERROR");
    print(e);
  }
}


collectNoteWithAPI(id) async {

  print("COLLECTING NOTE: "+ id.toString());

  // getting the our user object from server
  Response userObject = await Dio()
      .get(baseUrl + "/Users/me", options: Options(headers: authHeader));

  // add to collectors
  var data = {
    "collectors": [
      userObject.data]
  };
  print("SENDING");
  print(data);

  Dio dio = new Dio();
  var response = await dio.put(baseUrl + "/Notes/"+id.toString(),
      data: data, options: Options(headers: authHeader));    
}

// in order to send notes to the server a user must
// be logged in. Since we need to add a relation that WE created
// the Note we must first get the User Object of ourself and append
// it to the Note
postNotesToApi(Note note) async {
  // getting the our user object from server
  Response userObject = await Dio()
      .get(baseUrl + "/Users/me", options: Options(headers: authHeader));

  var newNote = {
    "note": note.note.toString(),
    "id": note.id,
    "lat": note.lat,
    "long": note.long,
    "user": userObject.data
  };

  print(newNote);
  Dio dio = new Dio();
  var response = await dio.post(baseUrl + "/Notes",
      data: newNote, options: Options(headers: authHeader));
  print(response);
}
