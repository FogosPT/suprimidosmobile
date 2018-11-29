import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:suprimidospt/constants/locations.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  List<Widget> checkboxes = [];
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  Map settings = {};

  @override
  void initState() {
    super.initState();
    for (Map location in locations) {
      settings[location['key']] = _prefs.then((SharedPreferences prefs) {
        return (prefs.getBool(location['key']) ?? true);
      });
    }
    settings['all'] = _prefs.then((SharedPreferences prefs) {
      return (prefs.getBool('all') ?? true);
    });
  }

  _handleChange(key, bool value) async {
    final SharedPreferences prefs = await _prefs;
    prefs.setBool(key, value);
    settings[key] = _prefs.then((SharedPreferences prefs) {
      return (prefs.getBool(key) ?? value);
    });

    if (key == 'all') {
      for (Map location in locations) {
        prefs.setBool(location['key'], value);
        settings[location['key']] = _prefs.then((SharedPreferences prefs) {
          return value;
        });
      }
    }

    setState(() {});
  }

  List<Widget> _buildCheckboxes() {
    List<Widget> checkboxes = [];
    checkboxes.add(
      FutureBuilder(
        future: settings['all'],
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          switch (snapshot.connectionState) {
            default:
              return CheckboxListTile(
                title: Text(
                  'Todas',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                value: snapshot.data ?? false,
                onChanged: (bool value) {
                  _handleChange('all', value);
                },
              );
          }
        },
      ),
    );

    checkboxes.add(Divider());
    for (Map location in locations) {
      checkboxes.add(
        FutureBuilder(
          future: settings[location['key']],
          builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
            switch (snapshot.connectionState) {
              default:
                return CheckboxListTile(
                  title: Text(location['value']),
                  value: snapshot.data ?? false,
                  onChanged: (bool value) {
                    _handleChange(location['key'], value);
                  },
                );
            }
          },
        ),
      );
    }
    return checkboxes;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: new Text(
          'Preferências',
          style: TextStyle(color: Color(0xFFe9ecef)),
        ),
        backgroundColor: Color(0xFF343a40),
      ),
      body: Container(
        child: ListView(
          children: _buildCheckboxes(),
        ),
      ),
    );
  }
}
