import 'package:flutter/material.dart';
import 'package:gonotes/pages/MapTab.dart';
import 'package:gonotes/pages/Notes.dart';
import 'package:gonotes/pages/Profile.dart';
import 'package:gonotes/widgets/NoteDialog.dart';
import 'package:provider/provider.dart';
import 'package:gonotes/state/appState.dart';
import 'package:gonotes/models/Note.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'flatmap client',
        theme: ThemeData(
          primarySwatch: Colors.teal,
        ),
        home: ChangeNotifierProvider<AppState>(
          builder: (_) => AppState(),
          child: MyHomePage(title: "Flatmap Alpha"),
        ));
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  IconData _iconData = Icons.add;
  int _selectedTab = 1;

  final _pageOptions = [NotesTab(), MapTab(), ProfileTab()];

  void _showNoteDialog() async {
  final myController = TextEditingController();
  final appState = Provider.of<AppState>(context);

    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
              child: Container(
    height: 450.0,
    width: 400.0,
    child: Column(children: <Widget>[
      Container(
          height: 75,
          width: 450,
          color: Colors.teal,
          child: Text("Say someing nice")),
      TextField(
        controller: myController,
        decoration: InputDecoration(
            border: InputBorder.none, hintText: 'Enter a search term'),
      ),
      RaisedButton(
          onPressed: () {
            appState.addNote(new Note(lat: 0, long: 0, note: myController.text));
            
          },
          textColor: Colors.white,
          padding: const EdgeInsets.all(0.0),
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: <Color>[
                  Color.fromRGBO(115, 182, 230, 1.0),
                  Color.fromRGBO(0, 150, 136, 1.0),
                ],
              ),
            ),
            padding: const EdgeInsets.all(10.0),
            child: const Text(
              'Add Note',
              style: TextStyle(fontSize: 20)
            ),
          )
      )
    ]),
  )
  );
  }
);
  }


  void _onPressFloatingButton() {
    setState(() {
      if (_selectedTab == 1) {
        _iconData = Icons.add;
        _showNoteDialog();
      } else {
        setState(() {
          _selectedTab = 1;
          // getting the global appState
          final appState = Provider.of<AppState>(context);
          // if the FloatingButton is pressed ask the server if there are any new markers
          appState.fetchNotes();
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // the top bar for the App
        appBar: AppBar(title: Text(widget.title)),
        // the tab renderer
        body: _pageOptions[_selectedTab],
        // Floating Center Docken Action Button
        // changes Icons when tabs are switched
        floatingActionButton: FloatingActionButton(
          onPressed: _onPressFloatingButton,
          tooltip: 'Map',
          child: Icon(_iconData),
          elevation: 2.0,
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        // the navigation Bar
        bottomNavigationBar: BottomAppBar(
          color: Colors.teal,
          shape: CircularNotchedRectangle(),
          child: new Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              IconButton(
                  icon: Icon(Icons.beenhere),
                  onPressed: () {
                    setState(() {
                      _iconData = Icons.map;
                      _selectedTab = 0;
                    });
                  }),
              IconButton(
                  icon: Icon(Icons.person),
                  onPressed: () {
                    setState(() {
                      _iconData = Icons.map;
                      _selectedTab = 2;
                    });
                  })
            ],
          ),
        ));
  }
}
