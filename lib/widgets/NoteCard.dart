import 'package:flutter/material.dart';

class NoteCard extends StatelessWidget {

  NoteCard({this.onPress, @required this.title});
  final Function onPress;
  final String title;

Widget build(BuildContext context) {
  return Center(
    child: Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            leading: Icon(Icons.label),
            title: Text(this.title),
            // subtitle: Text('Music by Julie Gable. Lyrics by Sidney Stein.'),
          ),
          ButtonTheme.bar( // make buttons use the appropriate styles for cards
            child: ButtonBar(
              children: <Widget>[
                FlatButton(
                  child: const Text("REMOVE"),
                  onPressed: this.onPress,
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
}
