import 'package:flutter/material.dart';

import 'package:suprimidospt/pages/home.dart';
import 'package:suprimidospt/pages/settings.dart';
import 'package:suprimidospt/pages/delays.dart';
import 'package:suprimidospt/pages/line.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Suprimidos',
      home: App(),
      debugShowCheckedModeBanner: false,
      routes: {
        '/settings': (_) => Settings(),
        '/delays': (_) => Delays(),
      },
      onGenerateRoute: _getRoute,
    );
  }
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Home();
  }
}

Route<dynamic> _getRoute(RouteSettings settings) {
  final List<String> path = settings.name.split('/');
  if (path[0] != '') return null;
  if (path[1] == 'line') {
    return new MaterialPageRoute<void>(
      settings: settings,
      builder: (BuildContext context) => Line(line: path[2]),
    );
  }
  return null;
}
