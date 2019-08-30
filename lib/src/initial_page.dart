import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

import 'data_page.dart';
import 'structure_page.dart';
import 'table_item.dart';

class InitialPage extends StatefulWidget {
  
  final String path;
  final Function deleteDb;

  InitialPage({Key key, this.path, this.deleteDb}) : super(key: key);

  _InitialPageState createState() => _InitialPageState();
}

class _InitialPageState extends State<InitialPage> {

  Database _database;
  
  final _streamController = StreamController<List<TableItem>>();

  @override
  void initState() { 
    super.initState();
    _getDatabase().then((value){
      _getTables();
    });
  }

  Future<void> _getDatabase() async {
    if(widget.path == null) {
      throw "Add a valid path to a database";
    }
    if(await databaseExists(widget.path)){
      _database = await openDatabase(widget.path);
    } else {
      throw "Database doesn't exist yet";
    }
  }

  _getTables() async {
    var tablesRows = await _database.query('sqlite_master');
    List<TableItem> tables = [];
    tablesRows.forEach((table){
      if(table['type'] == 'table') {
        tables.add(TableItem(table['name'],table['sql']));
      }
    });
    _streamController.sink.add(tables);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        color: Colors.white,
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(10),
              child: Row(
                children: <Widget>[
                  RaisedButton(
                    onPressed: widget.deleteDb,
                    child: Text("Delete database"),
                  )
                ],
              )
            ),
            Expanded(
              child: StreamBuilder<List<TableItem>>(
                stream: _streamController.stream,
                builder: (context, snapshot){
                  if(snapshot.hasData) {
                    return ListView(
                      children: snapshot.data.map((table){
                        return ListTile(
                          title: Text(table.name,style: TextStyle(color: Colors.black)),
                          onTap: (){
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context){
                                return DataPage(tableName: table.name,database: _database,);
                              }
                            ));
                          },
                          trailing: IconButton(
                            onPressed: (){
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context){
                                  return StructurePage(sql: table.sql,);
                                }
                              ));
                            },
                            icon: Icon(Icons.art_track,color: Colors.black,)
                          ),
                        );
                      }).toList(),
                    );
                  } else {
                    return Container();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() { 
    _streamController.close();
    super.dispose();
  }
}