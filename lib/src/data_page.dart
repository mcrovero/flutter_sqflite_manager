import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

import 'structure_page.dart';

class DataPage extends StatefulWidget {
  
  final String sql;
  final String tableName;
  final Database database;

  DataPage({Key key, this.tableName, this.database, this.sql}) : super(key: key);

  _DataPageState createState() => _DataPageState();
}

class _DataPageState extends State<DataPage> {

  @override
  void initState() {
    super.initState();
    _getData();
    _getColumns();
  }

  FSMDataSource _dataSource = FSMDataSource();

  List<DataColumn> _columns = [];

  _getData() {
    widget.database.query(widget.tableName).then((rows){
      if(rows.length > 0) {
        List<List<String>> list = [];
        
        rows.forEach((row){
          list.add(row.values.map((value)=>value.toString()).toList());
        });
        _dataSource.addData(list);
      } else {
        _dataSource.addData([]);
      }
      setState(() {
        
      });
    });
  }

  _getColumns(){
    var parse = widget.sql.split("(")[1];
    parse = parse.split(")")[0];
    var columns = parse.split(",");
    _columns.clear();
    _columns.addAll(columns.map((key){
      return DataColumn(label: Text(key.trimLeft().split(' ').first));
    }).toList());
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (Navigator.of(context).userGestureInProgress)
          return false;
        else
          return true;
      },
      child: SafeArea(
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
                        widget.database.delete(widget.tableName).then((value){
                          _getData();
                        });
                      },
                      child: Text("Clear table"),
                    ),
                    RaisedButton(
                      onPressed: (){
                        _getData();
                      },
                      child: Text("Refresh"),
                    ),
                    RaisedButton(
                      onPressed: (){
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context){
                            return StructurePage(sql: widget.sql);
                          }
                        ));
                      },
                      child: Text("Structure"),
                    )
                  ],
                )
              ),
              Expanded(
                child: Container(
                  child: _columns.isNotEmpty ? PaginatedDataTable(
                    rowsPerPage: 6,
                    columns: _columns,
                    header: Text(widget.tableName),
                    source: _dataSource,
                  ) : Container(),
                )
              ),
              Container(
                padding: EdgeInsets.all(20),
                alignment: Alignment.bottomLeft,
                child: FloatingActionButton(
                  onPressed: (){
                    Navigator.pop(context);
                  },
                  child: Icon(Icons.arrow_back),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

}

class FSMDataSource extends DataTableSource {

  List<List<String>> _data = [];

  addData(List<List<String>> data) {
    _data.clear();
    _data.addAll(data);
    notifyListeners();
  }

  @override
  DataRow getRow(int index) {
    return DataRow(
      cells: _data[index].map((cell){
        return DataCell(Text(cell));
      }).toList()
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => _data.length;

  @override
  int get selectedRowCount => 0;

}