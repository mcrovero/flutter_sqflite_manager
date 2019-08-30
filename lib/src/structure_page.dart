import 'package:flutter/material.dart';

class StructurePage extends StatefulWidget {

  final String sql;

  StructurePage({Key key, this.sql}) : super(key: key);

  _StructurePageState createState() => _StructurePageState();
}

class _StructurePageState extends State<StructurePage> {
  @override
  Widget build(BuildContext context) {
    var parse = widget.sql.split("(")[1];
    parse = parse.split(")")[0];
    var columns = parse.split(",");
    
    return Container(
      color: Colors.white,
      child: ListView(
        children: columns.map((column){
          return ListTile(
            title: Text(column,style: TextStyle(color: Colors.black)),
          );
        }).toList(),
      ),
    );
  }
}