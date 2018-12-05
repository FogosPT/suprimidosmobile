import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:suprimidospt/constants/locations.dart';
import 'package:suprimidospt/constants/endpoints.dart';
import 'package:suprimidospt/models/supressed_by_week.dart';

class LineStats extends StatefulWidget {
  final String line;
  final String type;
  LineStats({@required this.line, @required this.type});
  _LineStatsState createState() => _LineStatsState();
}

class _LineStatsState extends State<LineStats> {
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
      String url = '${endpoints['supressedWeekEndpoint']}${widget.line}';
      final response = await http.get(url);
      final responseData = json.decode(response.body);
      if (responseData != null) {
        list.addAll(
            responseData.map((model) => SupressedByWeek.fromJson(model)));
        list.sort((a, b) {
          if (a.timestamp < b.timestamp) {
            return 1;
          } else if (a.timestamp > b.timestamp) {
            return -1;
          } else {
            return 0;
          }
        });
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
    bool _needsTitle = true;

    return ListView.builder(
      itemCount: list.length,
      itemBuilder: (BuildContext context, index) {
        if (_needsTitle) {
          _needsTitle = false;
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Número de comboios suprimidos por dia.',
                textAlign: TextAlign.center,
                style: new TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 22.0,
                ),
              ),
            ),
          );
        } else {
          return ListTile(
            title: Text(
              list[index].dateString,
            ),
            trailing: list[index].count > 0
                ? Text(
                    list[index].count.toString(),
                  )
                : Icon(Icons.check_circle),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final String title = '${locationNames[widget.line]}: Últimos 30 dias';

    return Scaffold(
      appBar: AppBar(
        title: new Text(
          title,
          style: TextStyle(color: Color(0xFFe9ecef)),
        ),
        backgroundColor: Color(0xFF343a40),
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
