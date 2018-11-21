import 'package:flutter/material.dart';

import 'package:suprimidospt/pages/home_page.dart';
import 'package:suprimidospt/constants/locations.dart';

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
  _getDrawerItems(context) {
    List<Widget> drawerItems = [];
    locations.forEach((location) {
      drawerItems.add(
        ListTile(
          title: new Text(location['value']),
          onTap: () {
            Navigator.of(context).pushNamed('/${location['key']}');
          },
        ),
      );
    });
    return drawerItems;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: new Text(
          'Suprimidos.pt',
          style: TextStyle(color: Color(0xFFe9ecef)),
        ),
        backgroundColor: Color(0xFF343a40),
      ),
      body: new ListView(
        children: _getDrawerItems(context),
      ),
    );
  }
}
