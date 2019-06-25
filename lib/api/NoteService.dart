import 'dart:convert';
import 'package:gonotes/models/Note.dart';
import 'package:http/http.dart' as http;
import 'package:gonotes/apiToken.dart';

const baseUrl = "http://reflectcards.com:8080/api/collections";

fetchNotesFromApi() async {
  var response = await http.get(baseUrl + '/get/Notes?token='+config["APIToken"].toString());
  // sample info available in response
  int statusCode = response.statusCode;
  Map<String, String> headers = response.headers;
  String contentType = headers['content-type'];
  var json = jsonDecode(response.body);
  var entries = json["entries"];

  // array to collect the notes generated
  var collectedNotes = [];

  for (var entry in entries) {
    var lat = double.parse(entry["lat"]);
    var long = double.parse(entry["long"]);
    var note = entry["text"];
    collectedNotes.add(new Note(lat: lat, long: long, note: note)); 
  }
  return collectedNotes;
}

postNotesToApi(Note note) async {
  var client = new http.Client();
  print("SENDING POST TO SERVER");
  var newNote = {
    "data": {
      "text": note.note.toString(),
      "lat": note.lat.toString(),
      "long": note.long.toString()
    }
  };
  print(newNote);
  try {
    var uriResponse = await client.post(baseUrl + '/save/Notes?token='+config["APIToken"].toString(),
        body: {"data" : {"text": "test hello hello", "lat": "1.0", "long": "2.0"}});
    print("RESPONSE" + uriResponse.toString());
  } finally {
    client.close();
  }
}