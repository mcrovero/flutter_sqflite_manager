import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

class YourApp extends StatefulWidget {
  
  final Database database;
  YourApp({Key key, this.database}) : super(key: key);

  _YourAppState createState() => _YourAppState();
}

class _YourAppState extends State<YourApp> {

  final TextEditingController _textEditingController = TextEditingController(text:"Test");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
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
  }

  _addRow(String value) async {
    try {
      await (widget.database).insert('Test', {
        'value': value ?? 'Test',
        'name': 'John',
        'surname': 'Doe'
      });
    } catch(e) {
      print(e);
    }
  }
}