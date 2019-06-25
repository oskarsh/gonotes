import 'package:flutter/material.dart';
import 'package:gonotes/api/NoteService.dart';

class NotesTab extends StatefulWidget {

  NotesTab();

  @override
  State<StatefulWidget> createState() {
    return _NotesTabState();
  }
}

class _NotesTabState extends State<NotesTab> {

  String test="hello";

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Container(
        child: new Center(
          child: new Column(
            // center the children
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Icon(
                Icons.filter_hdr,
                size: 60.0,
              ),
              new Text(test),
              IconButton(
                  icon: Icon(Icons.person),
                  onPressed: () {
                    print(" I have been pressed :=");
                  })
            ],
          ),
        ),
      ),
    );
  }
}

