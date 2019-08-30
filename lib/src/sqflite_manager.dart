import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

import 'initial_page.dart';

class SqfliteManager extends StatefulWidget {

  final bool enable;
  final Widget child;
  final Alignment iconAlignment;
  final String path;

  SqfliteManager({Key key, @required this.child, this.enable = true, this.iconAlignment = Alignment.bottomRight, @required this.path}) : super(key: key);

  _SqfliteManagerState createState() => _SqfliteManagerState();
}

class _SqfliteManagerState extends State<SqfliteManager> {

  bool _showContent = false;
  bool _databaseExists = false;

  @override
  void initState() { 
    super.initState();
    _checkDbExists();
  }

  _checkDbExists() async {
    var dbExists = await databaseExists(widget.path);
    setState(() {
      _databaseExists = dbExists;
    });
  }

  @override
  Widget build(BuildContext context) {
    if(!widget.enable)
      return widget.child;
    return Scaffold(
      body: Stack(
        children: <Widget>[
          widget.child,
          _databaseExists ? Offstage(
            offstage: !_showContent,
            child: Navigator(
              initialRoute: 'root',
              onGenerateRoute: (settings){
                if(settings.name == 'root'){
                  return MaterialPageRoute(
                    builder: (context) {
                      return InitialPage(
                        deleteDb: (){
                          deleteDatabase(widget.path).then((value){
                            _checkDbExists();
                          });
                        },
                        path: widget.path,
                      );
                    }
                  );
                }
                return null;
              },
            ),
          ) : Container(),
          _databaseExists ? Container(
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
          ) : 
          Container(
            margin: EdgeInsets.all(20),
            alignment: widget.iconAlignment,
            child: FloatingActionButton(
              child: Icon(Icons.refresh),
              onPressed: (){
                _checkDbExists();
              },
            ),
          )
        ],
      ),
    );
  }
}