import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:timeago/timeago.dart' as timeago;

import 'package:suprimidospt/pages/home_page.dart';
import 'package:suprimidospt/constants/locations.dart';
import 'package:suprimidospt/models/supressed.dart';
import 'package:suprimidospt/constants/endpoints.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final Map<String, WidgetBuilder> routes = {};

  @override
  Widget build(BuildContext context) {
    locations.forEach((location) {
      routes['/${location['key']}'] = (_) => new HomePage(
            locationTitle: location['value'],
            location: location['key'],
          );
    });

    return MaterialApp(
      title: 'Suprimidos',
      home: App(),
      routes: routes,
      debugShowCheckedModeBanner: false,
    );
  }
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Home();
  }
}

class Home extends StatefulWidget {
  @override
  HomeState createState() {
    return new HomeState();
  }
}

class HomeState extends State<Home> {
  List list = [];
  bool _isLoaded = false;
  bool _firstLoaded = false;

  _getListItems() async {
    list.clear();
    _isLoaded = false;
    setState(() {});
    for (Map location in locations) {
      String url = '${endpoints['getSupressedEndpoint']}${location['key']}';
      final response = await http.get(url);
      final responseData = json.decode(response.body);
      if (responseData != null) {
        final data = [responseData];
        list.addAll(data.map((model) => Supressed.fromJson(model)));
      }
    }
    list.sort((a, b) {
      if (a.time < b.time) {
        return 1;
      } else if (a.time > b.time) {
        return -1;
      } else {
        return 0;
      }
    });
    _isLoaded = true;
    setState(() {});
  }

  _getBody() {
    return ListView.builder(
      itemCount: list.length,
      itemBuilder: (BuildContext context, index) {
        return ListTile(
          title: Text(list[index].direction),
          subtitle: Text(list[index].vendor),
          isThreeLine: true,
          trailing: Text(
            timeago.format(
              DateTime.fromMillisecondsSinceEpoch(list[index].timestamp * 1000),
              locale: 'pt_BR',
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!_firstLoaded) {
      _firstLoaded = true;
      _getListItems();
    }

    timeago.setLocaleMessages('pt_BR', timeago.PtBrMessages());

    return Scaffold(
      appBar: AppBar(
        title: new Text(
          'Suprimidos.pt',
          style: TextStyle(color: Color(0xFFe9ecef)),
        ),
        backgroundColor: Color(0xFF343a40),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.refresh, color: Color(0xFFe9ecef)),
            onPressed: () {
              _getListItems();
            },
          )
        ],
      ),
      body: _isLoaded ? _getBody() : Center(child: CircularProgressIndicator()),
    );
  }
}
