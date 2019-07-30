//
//
// LICENSE: MIT
// AUTHOR: daeh@tuta.io
// TITLE:
// DESCRIPTION: This Class is used as a global state
//

import 'package:flutter/material.dart';
import 'package:gonotes/api/NoteService.dart';
import 'package:gonotes/models/Note.dart';
import 'package:gonotes/api/LocationService.dart';
import 'package:latlong/latlong.dart';
import 'package:flutter_map/flutter_map.dart';


class AppState with ChangeNotifier {
  final List<Note> _notes = [];
  String _activeNote;
  double _activeNoteLong;
  double _activeNoteLat;
  int _activeNoteId;
  bool _dialogHidden = true;

  void collectNote(id){
    collectNoteWithAPI(id);
  }
  void fetchNotes(Function cb) {
    // the API Service will return a Dart Object, which is a Note
    fetchNotesFromApi().then((fetchedNotes) {
      _notes.clear();
      // adding the notes to the global state so everyone can uses them
      for (var note in fetchedNotes) {
        // adding the callBack to the notes
        Note buildNote = new Note(
            cb: cb,
            setActive: onNotePress,
            lat: note.lat,
            long: note.long,
            note: note.note,
            id: note.id);
        _notes.add(buildNote);
      }
    });
    // notify all the Listeners that the list has been updated
    notifyListeners();
  }

    void fetchCollectedNotes(Function cb) {
    
    // the API Service will return a Dart Object, which is a Note
    fetchMyCollectedNotes().then((collectedNotes) {
      var collectedNotes = [];

      // adding the notes to the global state so everyone can uses them
      for (var note in collectedNotes) {
        // adding the callBack to the notes
        Note buildNote = new Note(
            cb: cb,
            setActive: onNotePress,
            lat: note.lat,
            long: note.long,
            note: note.note,
            id: note.id);
        collectedNotes.add(buildNote);
      }
      return collectedNotes;
    });
  }

  void onNotePress(note, lat, long, id) {
    // set as the global active note the note that is pressed on
    _activeNote = note;
    _activeNoteLat = lat;
    _activeNoteLong = long;
    _activeNoteId = id;
    _dialogHidden = false;
    notifyListeners();
  }

  void addNote(Note note) async {
    getLocation().then((location) {
      print("Building the Note");
      var lat = location.latitude;
      var long = location.longitude;
      var text = note.note;
      postNotesToApi(new Note(lat: lat, long: long, note: text));
    });
  }



  // getter for the _notes
  List<Note> getNotes() {
    return _notes;
  }

  Future getCurrentPositionAsMarker() async{
    getLocation().then((location) {
      var lat = location.latitude;
      var long = location.longitude;
      Marker(
        width: 80.0,
        height: 80.0,
        point: LatLng(lat, long),
        builder: (ctx) => Container(
          key: Key('purple'),
          child: FlutterLogo(colors: Colors.purple),
        ),
      );
      // return marker;
    });
  }

  bool getDialogHidden() {
    return _dialogHidden;
  }

  String getActiveNote() {
    return _activeNote;
  }

  double getActiveNoteLat() {
    return _activeNoteLat;
  }

  double getActiveNoteLong() {
    return _activeNoteLong;
  }

  int getActiveNoteId() {
    return _activeNoteId;
  }
}
