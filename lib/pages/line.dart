import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:timeago/timeago.dart' as timeago;

import 'package:suprimidospt/constants/locations.dart';
import 'package:suprimidospt/constants/endpoints.dart';
import 'package:suprimidospt/models/supressed.dart';

class Line extends StatefulWidget {
  final String line;
  final String type;

  Line({@required this.line, @required this.type});
  _LineState createState() => _LineState();
}

class _LineState extends State<Line> {
  List list = [];
  bool _isLoaded = false;
  bool _hasError = false;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _getSupressedListItems();
  }

  _getSupressedListItems() async {
    _isLoaded = false;
    _hasError = false;
    _errorMessage = '';
    setState(() {});

    try {
      String url = '${endpoints['supressedDetailEndpoint']}${widget.line}';
      final response = await http.get(url);
      final responseData = json.decode(response.body);
      if (responseData != null) {
        list.addAll(responseData.map((model) => Supressed.fromJson(model)));
        setState(() {});
      }
      _isLoaded = true;
      _hasError = false;
      _errorMessage = '';
      setState(() {});
    } catch (error) {
      print(error);
      _isLoaded = true;
      _hasError = true;
      _errorMessage = 'Ocorreu um erro. Por favor tenta novamente.';
      setState(() {});
    }
  }

  _getBody() {
    return ListView.builder(
      itemCount: list.length,
      itemBuilder: (BuildContext context, index) {
        String _thisStart = 'de ${list[index].begin}';
        String _thisEnd = 'até ${list[index].end}';

        if (list[index].startTime != null) {
          _thisStart = _thisStart + ' (${list[index].startTime.trim()})';
        }

        if (list[index].endTime != null) {
          _thisEnd = _thisEnd + ' (${list[index].endTime.trim()})';
        }

        return ListTile(
          title: Column(
            children: <Widget>[
              Text(
                _thisStart,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                _thisEnd,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(locationNames[list[index].line]),
            ],
            crossAxisAlignment: CrossAxisAlignment.start,
          ),
          trailing: Text(list[index].vendor),
          isThreeLine: false,
          subtitle: Text(
            'Suprimido ' +
                timeago.format(
                  DateTime.fromMillisecondsSinceEpoch(
                      list[index].timestamp * 1000),
                  locale: 'pt_BR',
                ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final String title =
        '${locationNames[widget.line]}: ${(widget.type == 'supressed' ? 'Suprimidos' : 'Atrasos')}';

    return Scaffold(
      appBar: AppBar(
        title: new Text(
          title,
          style: TextStyle(color: Color(0xFFe9ecef)),
        ),
        backgroundColor: Color(0xFF343a40),
        actions: <Widget>[
          Container(
            child: _isLoaded
                ? IconButton(
                    icon: Icon(Icons.calendar_today),
                    onPressed: () {
                      Navigator.of(context)
                          .pushNamed('/line/${widget.line}/stats');
                    },
                  )
                : Center(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 16.0),
                      child: CircularProgressIndicator(
                        strokeWidth: 3.0,
                      ),
                    ),
                  ),
          )
        ],
      ),
      body: list.length > 0
          ? _getBody()
          : Center(
              child:
                  _hasError ? Text(_errorMessage) : CircularProgressIndicator(),
            ),
    );
  }
}
