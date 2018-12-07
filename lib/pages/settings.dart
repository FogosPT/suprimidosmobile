import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:suprimidospt/constants/locations.dart';
import 'package:suprimidospt/components/settings/settings_card.dart';
import 'package:suprimidospt/components/settings/add_notification_dialog.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  String _selectedLocation = '';
  Map settings = {};
  List<Widget> cards = [];

  _removeCard(card) {
    print(card);
  }

  _onAdd(location, start, end) {
    print('add notification for $location, $start, $end');
  }

  _addCardFormOpen() {
    print('addCardFormOpen');
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print('render');

    return Scaffold(
      appBar: AppBar(
        title: new Text(
          'Notificações',
          style: TextStyle(color: Color(0xFFe9ecef)),
        ),
        backgroundColor: Color(0xFF343a40),
      ),
      body: Column(
        children: <Widget>[
          SettingsCard(
            title: 'Cascais',
            line: 'cascais',
            startTime: 9,
            endTime: 12,
            onRemove: _removeCard,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          showDialog(
              barrierDismissible: true,
              context: context,
              builder: (BuildContext context) {
                return AddNotificationDialog(
                  onAdd: _onAdd,
                );
              });
          _addCardFormOpen();
        },
      ),
    );
  }
}
