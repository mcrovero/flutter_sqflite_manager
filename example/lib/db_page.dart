import 'package:flutter/material.dart';
import 'package:flutter_sqflite_manager/flutter_sqflite_manager.dart';
import 'package:sqflite/sqflite.dart';

class DbPage extends StatefulWidget {
  DbPage({Key key}) : super(key: key);

  _DbPageState createState() => _DbPageState();
}

class _DbPageState extends State<DbPage> {

  Database database;

  final TextEditingController _textEditingController = TextEditingController(text:"Test");

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Database>(
      future: _getDatabase(),
      builder: (context, snapshot) {
        if(snapshot.hasData) {
          return SqfliteManager(
            database: snapshot.data,
            onDatabaseDeleted: (){

            },
            enable: true,
            child: Container(
              padding: EdgeInsets.all(20),
              color: Colors.white,
              alignment: Alignment.center,
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.only(right:20),
                      child: TextField(controller: _textEditingController)
                    )
                  ),
                  RaisedButton(
                    onPressed: (){
                      _addRow(_textEditingController.text);
                    },
                    child: Text("Add row"),
                  ),
                ],
              ),
            ),
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

  _addRow(String value) async {
    try {
      await (await _getDatabase()).insert('Test', {
        'value': value ?? 'Test',
        'name': 'John',
        'surname': 'Doe'
      });
    } catch(e) {
      print(e);
    }
  }
}