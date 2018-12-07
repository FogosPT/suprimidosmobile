import 'package:flutter/material.dart';
import 'package:suprimidospt/constants/locations.dart';
import 'package:suprimidospt/constants/hours.dart';

class AddNotificationDialog extends StatefulWidget {
  final onAdd;
  AddNotificationDialog({@required this.onAdd});
  _AddNotificationDialogState createState() => _AddNotificationDialogState();
}

class _AddNotificationDialogState extends State<AddNotificationDialog> {
  String _selectedLocation;
  int _selectedStartHour;
  int _selectedEndHour;

  _getHoursDropdownItems() {
    return hours.map((int hour) {
      return DropdownMenuItem<int>(
        value: hour,
        child: Text('${hour.toString()}h'),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: new Text("Nova notificação"),
      content: Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                DropdownButtonHideUnderline(
                  child: DropdownButton(
                    value: _selectedLocation,
                    onChanged: (location) {
                      setState(() {
                        _selectedLocation = location;
                      });
                    },
                    items: locations.map((location) {
                      return DropdownMenuItem<String>(
                        value: location['key'],
                        child: Text(location['value']),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(right: 8.0),
                  child: Text('Entre as '),
                ),
                DropdownButtonHideUnderline(
                  child: DropdownButton(
                    value: _selectedStartHour,
                    onChanged: (hour) {
                      setState(() {
                        _selectedStartHour = hour;
                      });
                    },
                    items: _getHoursDropdownItems(),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 8.0, right: 8.0),
                  child: Text('e as'),
                ),
                DropdownButtonHideUnderline(
                  child: DropdownButton(
                    value: _selectedEndHour,
                    onChanged: (hour) {
                      setState(() {
                        _selectedEndHour = hour;
                      });
                    },
                    items: _getHoursDropdownItems(),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
      actions: <Widget>[
        new FlatButton(
          child: new Text("CANCELAR"),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        new FlatButton(
          child: new Text("ADICIONAR"),
          onPressed: () {
            widget.onAdd(_selectedLocation);
          },
        ),
      ],
    );
  }
}
