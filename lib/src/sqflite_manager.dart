import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

import 'initial_page.dart';

class SqfliteManager extends StatefulWidget {

  final bool enable;
  final Widget child;
  final Alignment iconAlignment;
  final Database database;
  final Function onDatabaseDeleted;

  SqfliteManager({Key key, @required this.child, this.enable = true, this.iconAlignment = Alignment.bottomRight, @required this.database, this.onDatabaseDeleted}) : super(key: key);

  _SqfliteManagerState createState() => _SqfliteManagerState();
}

class _SqfliteManagerState extends State<SqfliteManager> {

  bool _showContent = false;

  @override
  void initState() { 
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if(!widget.enable || widget.database == null)
      return widget.child;
    return Scaffold(
      body: Stack(
        children: <Widget>[
          widget.child,
          Offstage(
            offstage: !_showContent,
            child: Navigator(
              initialRoute: 'root',
              onGenerateRoute: (settings){
                if(settings.name == 'root'){
                  return MaterialPageRoute(
                    builder: (context) {
                      return InitialPage(
                        database: widget.database,
                        deleteDb: (){
                          var path = widget.database.path;
                          deleteDatabase(path).then((value){
                            widget.database.close();
                            setState(() {
                              
                            });
                          });
                        },
                      );
                    }
                  );
                }
                return null;
              },
            ),
          ),
          Container(
            margin: EdgeInsets.all(20),
            alignment: widget.iconAlignment,
            child: FloatingActionButton(
              child: Icon(Icons.storage),
              onPressed: (){
                setState(() {
                  _showContent = !_showContent;
                });
              },
            ),
          ) 
        ],
      ),
    );
  }
}