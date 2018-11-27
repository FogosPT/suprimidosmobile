import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:shared_preferences/shared_preferences.dart';

import 'package:suprimidospt/constants/locations.dart';
import 'package:suprimidospt/models/supressed.dart';
import 'package:suprimidospt/constants/endpoints.dart';
import 'package:suprimidospt/pages/settings.dart';

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
        });
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
      if (_pref) {
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
      if (_pref) {
        print('Android subscribing to $line');
        _firebaseMessaging.subscribeToTopic('mobile-android-$line');
      }
    }
  }

  List list = [];
  bool _isLoaded = false;

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
          IconButton(
            icon: Icon(Icons.refresh, color: Color(0xFFe9ecef)),
            onPressed: () {
              _getListItems();
            },
          ),
          IconButton(
            icon: Icon(Icons.settings, color: Color(0xFFe9ecef)),
            onPressed: () {
              Navigator.of(context).pushNamed('/settings');
            },
          ),
        ],
      ),
      body: _isLoaded ? _getBody() : Center(child: CircularProgressIndicator()),
    );
  }
}
