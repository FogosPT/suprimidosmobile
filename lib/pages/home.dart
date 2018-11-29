import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:shared_preferences/shared_preferences.dart';

import 'package:suprimidospt/constants/locations.dart';
import 'package:suprimidospt/constants/endpoints.dart';
import 'package:suprimidospt/models/supressed.dart';

class Home extends StatefulWidget {
  @override
  HomeState createState() => new HomeState();
}

class HomeState extends State<Home> {
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  @override
  void initState() {
    super.initState();
    firebaseCloudMessagingListeners();
    _getListItems();
  }

  void firebaseCloudMessagingListeners() {
    if (Platform.isIOS) iOSPermission();

    _firebaseMessaging.getToken().then((token) {
      print('token');
      print(token);
    });

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print('on message $message');
      },
      onResume: (Map<String, dynamic> message) async {
        print('on resume $message');
      },
      onLaunch: (Map<String, dynamic> message) async {
        print('on launch $message');
      },
    );
  }

  void iOSPermission() {
    _firebaseMessaging.requestNotificationPermissions(
        IosNotificationSettings(sound: true, badge: true, alert: true));
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });
  }

  void iOSSubscribeToTopics() async {
    final SharedPreferences prefs = await _prefs;
    for (Map location in locations) {
      String line = location['key'];
      bool _pref = prefs.getBool(line);
      if (_pref == true || _pref == null) {
        print('iOS subscribing to $line');
        _firebaseMessaging.subscribeToTopic('mobile-ios-$line');
      }
    }
  }

  void androidSubscribeToTopics() async {
    final SharedPreferences prefs = await _prefs;
    for (Map location in locations) {
      String line = location['key'];
      bool _pref = prefs.getBool(line);
      if (_pref == true || _pref == null) {
        print('Android subscribing to $line');
        _firebaseMessaging.subscribeToTopic('mobile-android-$line');
      }
    }
  }

  List list = [];
  bool _isLoaded = false;
  bool _hasError = false;
  String _errorMessage = '';

  _getListItems() async {
    list.clear();
    _isLoaded = false;
    _hasError = false;
    _errorMessage = '';
    setState(() {});
    try {
      for (Map location in locations) {
        String url = '${endpoints['supressedEndpoint']}${location['key']}';
        final response = await http.get(url);
        final responseData = json.decode(response.body);
        if (responseData != null) {
          final data = [responseData];
          list.addAll(data.map((model) => Supressed.fromJson(model)));
          list.sort((a, b) {
            if (a.time < b.time) {
              return 1;
            } else if (a.time > b.time) {
              return -1;
            } else {
              return 0;
            }
          });
          setState(() {});
        }
      }
      _isLoaded = true;
      _hasError = false;
      _errorMessage = '';
      setState(() {});
    } catch (error) {
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
        return ListTile(
          title: Column(
            children: <Widget>[
              Text(
                'de ${list[index].begin}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'até ${list[index].end}',
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
          onTap: () {
            Navigator.of(context).pushNamed('/line/${list[index].line}');
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      iOSSubscribeToTopics();
    } else {
      androidSubscribeToTopics();
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
          Container(
            child: _isLoaded
                ? IconButton(
                    icon: Icon(
                      Icons.refresh,
                      color: Color(0xFFe9ecef),
                    ),
                    onPressed: () {
                      _getListItems();
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
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            DrawerHeader(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Icon(Icons.block),
                  Text(
                    'Suprimidos.pt',
                    style: TextStyle(
                      fontSize: 24.0,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              title: Text('Suprimidos'),
              leading: Icon(Icons.block),
              onTap: () {},
            ),
            ListTile(
              title: Text('Atrasos'),
              leading: Icon(Icons.watch),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushNamed('/delays');
              },
            ),
            Divider(),
            ListTile(
              title: Text('Preferências'),
              leading: Icon(Icons.settings),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushNamed('/settings');
              },
            ),
          ],
        ),
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
