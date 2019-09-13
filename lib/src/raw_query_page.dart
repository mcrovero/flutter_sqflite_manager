import 'package:flutter/material.dart';
import 'package:sqflite/sqlite_api.dart';

class RawQueryPage extends StatefulWidget {
  final Database database;
  final int rowsPerPage;

  const RawQueryPage({
    Key key,
    @required this.database,
    this.rowsPerPage,
  })  : assert(database != null),
        super(key: key);

  @override
  _RawQueryPageState createState() => _RawQueryPageState();
}

class _RawQueryPageState extends State<RawQueryPage> {
  final TextEditingController _sqlQueryController = TextEditingController();
  List<Map<String, dynamic>> _result;
  String _error;
  bool _isQueryRunning = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _sqlQueryController.dispose();
    super.dispose();
  }

  void _runQuery() async {
    String query = _sqlQueryController.text;
    if (query.isEmpty) {
      return;
    }

    try {
      setState(() {
        _error = null;
        _isQueryRunning = true;
      });

      final result = await widget.database.rawQuery(query);

      setState(() {
        _result = result;
        _isQueryRunning = false;
      });
    } catch (error) {
      setState(() {
        _error = "Invalid SQL Query! \n${error.toString()}";
        _isQueryRunning = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 0.0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _sqlQueryController,
              decoration: InputDecoration(
                hintText: "SQL Query",
                border: OutlineInputBorder(),
              ),
            ),
            _buildCommandBar(),
            SizedBox(height: 16.0),
            Expanded(
              child: _buildResult(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResult() {
    if (this._isQueryRunning) {
      return CircularProgressIndicator();
    }

    if (this._error != null) {
      return Text(
        _error,
        style: TextStyle(
          color: Colors.red,
        ),
      );
    }

    if (this._result == null) {
      return Container();
    }

    if (this._result.isEmpty) {
      return Text("Success.\nResults: $_result");
    }

    return SingleChildScrollView(
      child: PaginatedDataTable(
        columns: _result[0].keys.map((key) {
          return DataColumn(label: Text(key));
        }).toList(),
        header: Text('Result'),
        source: TableSource(_result),
        rowsPerPage: this.widget.rowsPerPage ?? 6,
      ),
    );
  }

  Widget _buildCommandBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        RaisedButton.icon(
          color: Colors.blue,
          onPressed: () {
            _sqlQueryController.clear();
          },
          icon: Icon(
            Icons.close,
            color: Colors.white,
          ),
          label: Text(
            'Clear',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
        SizedBox(width: 16.0),
        RaisedButton.icon(
          color: Colors.blue,
          onPressed: !this._isQueryRunning
              ? () {
                  // Hide keyboard
                  FocusScope.of(context).requestFocus(FocusNode());
                  _runQuery();
                }
              : null,
          icon: Icon(
            Icons.play_arrow,
            color: Colors.white,
          ),
          label: Text(
            'Run',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}

class TableSource extends DataTableSource {
  final List<Map<String, dynamic>> _data;

  TableSource(this._data);

  @override
  DataRow getRow(int index) {
    return DataRow(
      cells: _data[index].values.map((value) {
        return DataCell(Text("$value"));
      }).toList(),
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => _data.length;

  @override
  int get selectedRowCount => 0;
}
