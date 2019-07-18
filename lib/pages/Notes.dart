import 'package:flutter/material.dart';
import 'package:gonotes/api/NoteService.dart';
import 'package:gonotes/models/Note.dart';
import 'package:gonotes/state/appState.dart';
import 'package:loading/indicator/ball_beat_indicator.dart';
import 'package:loading/loading.dart';

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
  bool _isLoading = true;

  @override
  BuildContext get context => super.context;

  void didChangeDependencies() async {
    // empty the notes before pushing in new ones
    _collectedNotes.clear();
    fetchMyCollectedNotes().then((collectedNotes) {
      setState(() { _isLoading = false; });
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
    });
  }

  List<Widget> _buildList() {
    print(_collectedNotes);
    List<Widget> list = new List<Widget>();
    for (var note in _collectedNotes) {
      print(note.note);
       list.add(ListTile(title: Text(note.note)));
    }
    return list;
  }

  Widget _buildChild() {
  if (_isLoading) {
    return Container(
        color: Colors.teal,
        child: Center(
          // child: Loading(indicator: BallBeatIndicator(), size: 100.0),
          child: Text("LOADING LIST"),
        ),
      );
  }
  return ListView(
  children: _buildList(),
);
}

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        body: Container(child: _buildChild())
        );
  }
}
