import 'package:flutter/material.dart';
import 'package:flutter_sqflite_manager/flutter_sqflite_manager.dart';
import 'package:sqflite/sqflite.dart';

class DbPage extends StatefulWidget {
  DbPage({Key key}) : super(key: key);

  _DbPageState createState() => _DbPageState();
}

class _DbPageState extends State<DbPage> {

  Database database;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: _getPath(),
      builder: (context, snapshot) {
        if(snapshot.hasData) {
          return SqfliteManager(
            path: snapshot.data,
            enable: true,
            child: Container(
              alignment: Alignment.center,
              child: IntrinsicHeight(
                child: Column(
                  children: <Widget>[
                    RaisedButton(
                      onPressed: (){
                        _openDb();
                      },
                      child: Text("Open db"),
                    ),
                    RaisedButton(
                      onPressed: (){
                        _addRow();
                      },
                      child: Text("Add row"),
                    ),
                  ],
                ),
              ),
            ),
          );
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }

  Future<String> _getPath() async {
    var databasesPath = await getDatabasesPath();
    return "$databasesPath/demo.db";
  }
  _openDb() async {
    var path = await _getPath();
    print(path);
    database = await openDatabase(path, version: 1,
    onCreate: (Database db, int version) async {
      // When creating the db, create the table
      await db.execute(
          'CREATE TABLE Test (id INTEGER PRIMARY KEY, value TEXT)');
    });
  }
  _addRow() async {
    try {
      if(database == null) {
        await _openDb();
      }
      await database.insert('Test', {
        'value': 'Test',
      });
    } catch(e) {
      print(e);
    }
  }
}