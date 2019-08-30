import 'package:flutter/material.dart';

class PanWidget extends StatefulWidget {
  final Widget child;
  PanWidget({Key key, this.child}) : super(key: key);

  _PanWidgetState createState() => _PanWidgetState();
}

class _PanWidgetState extends State<PanWidget> {

  Offset _offset = Offset(0,0);

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: Stack(
        children: <Widget>[
          Transform.translate(
            offset: _offset,
            child: widget.child
          ),
          GestureDetector(
            onPanUpdate: (details){
              _offset += details.delta;
              if(_offset.dx > 0) {
                _offset = Offset(0,_offset.dy);
              }
              if(_offset.dy > 0) {
                _offset = Offset(_offset.dx,0);
              }
              setState(() {
              });
            },
            child: Container(
              alignment: Alignment.topLeft,
              color: Colors.transparent,
            ),
          ),
        ],
      ),
    );
  }
}