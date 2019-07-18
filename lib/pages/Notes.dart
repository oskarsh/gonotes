import 'package:flutter/material.dart';
import 'package:gonotes/api/NoteService.dart';
import 'package:gonotes/models/Note.dart';
import 'package:gonotes/state/appState.dart';

class NotesTab extends StatefulWidget {
  NotesTab();

  @override
  State<StatefulWidget> createState() {
    return _NotesTabState();
  }
}

class _NotesTabState extends State<NotesTab> {
  String test = "hello";
  final List<Note> _collectedNotes = [];

  @override
  // TODO: implement context
  BuildContext get context => super.context;

  void didChangeDependencies() async {
    // empty the notes before pushing in new ones
    _collectedNotes.clear();
    fetchMyCollectedNotes().then((collectedNotes) {
      for (var note in collectedNotes) {
        var lat = note["lat"];
        // checking the types
        if (lat.runtimeType == int) {
          lat = lat + .0;
        }
        var long = note["long"];
        // checking the types
        if (long.runtimeType == int) {
          long = long + .0;
        }

        Note buildNote =
            new Note(lat: lat, long: long, note: note["note"], id: note["id"]);
        _collectedNotes.add(buildNote);
      }
      print(_collectedNotes);
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        body: ListView(
      children: <Widget>[
        ListTile(
          leading: Icon(Icons.map),
          title: Text("test"),
        ),
        ListTile(
          leading: Icon(Icons.photo_album),
          title: Text('Album'),
        ),
        ListTile(
          leading: Icon(Icons.phone),
          title: Text('Phone'),
        ),
      ],
    ));
  }
}
