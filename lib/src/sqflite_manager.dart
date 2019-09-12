import 'package:flutter/material.dart';
import 'package:flutter_sqflite_manager/src/tables_page.dart';
import 'package:sqflite/sqflite.dart';

class SqfliteManager extends StatefulWidget {
  /// If set false the widget is disabled and the icon is not displayed (e.g. in production).
  final bool enable;

  /// Contains the app itsel
  final Widget child;

  /// Indicates the icon position of the manager
  final Alignment iconAlignment;

  /// To pass the app's database to the manager
  final Database database;

  /// Called when the database is deleted inside the manager
  final Function onDatabaseDeleted;

  /// Set the number of rows visible per each page in order to avoid scrolling
  final int rowsPerPage;

  SqfliteManager(
      {Key key,
      @required this.child,
      this.enable = true,
      this.iconAlignment = Alignment.bottomRight,
      @required this.database,
      this.onDatabaseDeleted,
      this.rowsPerPage = 6})
      : super(key: key);

  _SqfliteManagerState createState() => _SqfliteManagerState();
}

class _SqfliteManagerState extends State<SqfliteManager> {
  bool _showContent = false;

  @override
  Widget build(BuildContext context) {
    if (!widget.enable || widget.database == null) return widget.child;
    return Scaffold(
      body: Stack(
        children: <Widget>[
          widget.child,
          Offstage(
            offstage: !_showContent,
            child: Navigator(
              initialRoute: 'root',
              onGenerateRoute: (settings) {
                if (settings.name == 'root') {
                  return MaterialPageRoute(builder: (context) {
                    return TablesPage(
                      database: widget.database,
                      onDatabaseDeleted: widget.onDatabaseDeleted,
                      rowsPerPage: widget.rowsPerPage,
                    );
                  });
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
              onPressed: () {
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
