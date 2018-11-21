import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:timeago/timeago.dart' as timeago;

import 'package:suprimidospt/models/supressed.dart';
import 'package:suprimidospt/constants/endpoints.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.location, this.locationTitle}) : super(key: key);

  final String location;
  final String locationTitle;
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List _list = [];
  bool _isLoaded = false;

  _getList() async {
    String url = '${endpoints['getSupressedEndpoint']}${widget.location}';
    final response = await http.get(url);
    final responseData = [json.decode(response.body)];
    this.setState(() {
      _list = responseData.map((model) => Supressed.fromJson(model)).toList();
    });
  }

  _getBody() {
    return ListView.builder(
      itemCount: _list.length,
      itemBuilder: (BuildContext context, index) {
        return ListTile(
          title: Text(_list[index].direction),
          subtitle: Text(_list[index].vendor),
          trailing: Text(
            timeago.format(
              DateTime.fromMillisecondsSinceEpoch(
                  _list[index].timestamp * 1000),
              locale: 'pt_BR',
            ),
          ),
        );
      },
    );
  }

  _getLoading() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!_isLoaded) {
      _isLoaded = true;
      _getList();
    }

    timeago.setLocaleMessages('pt_BR', timeago.PtBrMessages());

    return Scaffold(
      appBar: AppBar(
        title: new Text(
          widget.locationTitle,
          style: TextStyle(color: Color(0xFFe9ecef)),
        ),
        backgroundColor: Color(0xFF343a40),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.refresh, color: Color(0xFFe9ecef)),
            onPressed: () {
              _getList();
            },
          )
        ],
      ),
      body: _isLoaded ? _getBody() : _getLoading(),
    );
  }
}
