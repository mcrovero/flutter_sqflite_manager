import 'package:example/your_app.dart';
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
    return FutureBuilder<Database>(
      future: _getDatabase(),
      builder: (context, snapshot) {
        if(snapshot.hasData) {
          return SqfliteManager(
            database: snapshot.data,
            enable: true,
            child: YourApp(
              database: snapshot.data,
            )
          );
        } else {
          return Container(
            alignment: Alignment.center,
            child: CircularProgressIndicator()
          );
        }
      },
    );
  }

  Future<Database> _getDatabase() async {
    if(database != null) 
      return database;
    var databasesPath = await getDatabasesPath();
    var path = "$databasesPath/demo.db";
    return await openDatabase(path, version: 1,
      onCreate: (Database db, int version) async {
        // When creating the db, create the table
        await db.execute('CREATE TABLE Test (id INTEGER PRIMARY KEY, value TEXT, name TEXT, surname TEXT)');
        await db.execute('CREATE TABLE OtherTable (id INTEGER PRIMARY KEY, value TEXT, name TEXT, surname TEXT)');
      }
    );
  }

}