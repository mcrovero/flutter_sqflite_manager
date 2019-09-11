import 'package:flutter/material.dart';
import 'package:sqflite/sqlite_api.dart';

class RawQueryPage extends StatefulWidget {
  final Database database;

  const RawQueryPage({
    Key key,
    @required this.database,
  })  : assert(database != null),
        super(key: key);

  @override
  _RawQueryPageState createState() => _RawQueryPageState();
}

class _RawQueryPageState extends State<RawQueryPage> {
  final TextEditingController _sqlQueryController = TextEditingController();
  String _result = "empty";
  bool _isQueryRunning = false;

  @override
  void initState() {
    super.initState();
  }

  void _runQuery() async {
    try {
      setState(() {
        _isQueryRunning = true;
      });

      String query = _sqlQueryController.text;
      final result = await widget.database.rawQuery(query);

      setState(() {
        _result = result.toString();
        _isQueryRunning = false;
      });
    } catch (error) {
      setState(() {
        print(error);
        _result = "Invalid SQL Query! \n${error.toString()}";
        _isQueryRunning = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _sqlQueryController,
              decoration: InputDecoration(
                hintText: "SQL Query",
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: RaisedButton(
                onPressed: () {
                  _runQuery();
                },
                child: Text('RUN'),
              ),
            ),
            Text(this._result)
          ],
        ),
      ),
    );
  }
}
