import 'package:flutter/material.dart';
import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_porter/sqflite_porter.dart';
import 'package:share/share.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DriveMate',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'DriveMate Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  Future<Database> _database;

  void main() async {
    if (_database == null) {
      _database = openDatabase(
        // Set the path to the database. Note: Using the `join` function from the
        // `path` package is best practice to ensure the path is correctly
        // constructed for each platform.
        join(await getDatabasesPath(), 'drivemate.db'),
        onCreate: (db, version) {
          // Run the CREATE TABLE statement on the database.
          print("database created"); // Logging for testing backup things
          return db.execute(
            "CREATE TABLE expenses(id INTEGER PRIMARY KEY, base64img TEXT, cost REAL);\n"
                "CREATE TABLE shifts(starttime TEXT PRIMARY KEY, endtime TEXT, startodometer REAL, endodometer REAL);",
          );
        },
        version: 1,
      );
    }
  }

  void _newEntry() {
    setState(() {
        // TODO screen to record a new trip or expense
      _counter++;
    });
  }

  void _exportSpreadsheets() async {
    Share.shareFiles([join(await getDatabasesPath(), "drivemate.db")]);
    // print(await dbExportSql(await _database));
  }

  void _handleMenu(String choice) {
    // make this actually do things when there are multiple options
    _exportSpreadsheets();
  }

  @override
  Widget build(BuildContext context) {
    main();
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.`
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
        actions: <Widget>[
          PopupMenuButton<String>(
            onSelected: _handleMenu,
            itemBuilder: (BuildContext context) {
              return {'Export Spreadsheets',}.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
          ),
        ],
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            // TODO list logged trips
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _newEntry,
        tooltip: 'New Log Entry',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
class ShiftEntry {
  final DateTime startTime;
  final DateTime endTime;
  final double startOdometer;
  final double endOdometer;
  ShiftEntry({this.startTime, this.endTime, this.startOdometer, this.endOdometer});
}
class ExpenseEntry {
  final double cost;
  final String base64img;
  final int id;
  ExpenseEntry({this.cost, this.base64img, this.id});
}
