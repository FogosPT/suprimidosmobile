import 'package:flutter/material.dart';

class Line extends StatefulWidget {
  final String line;
  final String type;

  Line({@required this.line, @required this.type});
  _LineState createState() => _LineState();
}

class _LineState extends State<Line> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
