//
//
// LICENSE: MIT
// AUTHOR: daeh@tuta.io
// TITLE:
// DESCRIPTION: This Class is used as a global state
//

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gonotes/api/NoteService.dart';
import 'package:gonotes/models/Note.dart';
import 'package:gonotes/api/LocationService.dart';
import 'package:http/http.dart' as http;

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
    print(" I AM FETCHING NOTES NOW");
    // the API Service will return a Dart Object, which is a Note
    fetchNotesFromApi().then((fetchedNotes) {
      _notes.clear();
      // adding the notes to the global state so everyone can uses them
      for (var note in fetchedNotes) {
        print(note.note);
        print(note.lat);
        print(note.long);
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

  void onNotePress(note, lat, long, id) {
    print("YEEEES HAHAHAHA");
    print(id);
    _activeNote = note;
    _activeNoteLat = lat;
    _activeNoteLong = long;
    _activeNoteId = id;
    _dialogHidden = false;
    print(_dialogHidden);
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
