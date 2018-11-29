import 'package:flutter/material.dart';

import 'package:suprimidospt/constants/locations.dart';

class Line extends StatefulWidget {
  final String line;
  Line({@required this.line});
  _LineState createState() => _LineState();
}

class _LineState extends State<Line> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: new Text(
          locationNames[widget.line],
          style: TextStyle(color: Color(0xFFe9ecef)),
        ),
        backgroundColor: Color(0xFF343a40),
      ),
      body: Container(),
    );
  }
}
