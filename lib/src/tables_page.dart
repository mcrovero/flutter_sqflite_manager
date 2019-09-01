import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_sqflite_manager/src/table_page.dart';
import 'package:sqflite/sqflite.dart';

import 'table_item.dart';

class TablesPage extends StatefulWidget {
  
  final Database database;
  final Function onDatabaseDeleted;
  final int rowsPerPage;

  TablesPage({Key key, this.database, this.onDatabaseDeleted, this.rowsPerPage}) : super(key: key);

  _TablesPageState createState() => _TablesPageState();
}

class _TablesPageState extends State<TablesPage> {
  
  final _streamController = StreamController<List<TableItem>>();

  @override
  void initState() { 
    super.initState();
    
    _getTables();
  }


  Future<void> _getTables() async {
    if(widget.database.isOpen) {
      var tablesRows = await widget.database.query('sqlite_master');
      List<TableItem> tables = [];
      tablesRows.forEach((table){
        if(table['type'] == 'table') {
          tables.add(TableItem(table['name'],table['sql']));
        }
      });
      _streamController.sink.add(tables);
    } else {
      print("database closed");
    }
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
                    onPressed: (){
                      var path = widget.database.path;
                      deleteDatabase(path).then((value){
                        _streamController.sink.add([]);
                        widget.database.close();
                      });
                    },
                    child: Text("Delete database"),
                  ),
                  RaisedButton(
                    onPressed: (){
                      _getTables();
                    },
                    child: Text("Refresh"),
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
                                return TablePage(tableName: table.name,database: widget.database, sql:table.sql, rowsPerPage: widget.rowsPerPage,);
                              }
                            ));
                          },
                          trailing: Icon(Icons.art_track,color: Colors.black),
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