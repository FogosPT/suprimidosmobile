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

  _onChangeLocation(location) {
    setState(() {
      _selectedLocation = location;
    });
  }

  _onChangeStartTime(hour) {
    if (_selectedEndHour != null) {
      if (_selectedEndHour < hour) {
        int _highest = hour;
        int _lowest = _selectedEndHour;

        setState(() {
          _selectedStartHour = _lowest;
          _selectedEndHour = _highest;
        });
      } else {
        setState(() {
          _selectedStartHour = hour;
        });
      }
    } else {
      setState(() {
        _selectedStartHour = hour;
      });
    }
  }

  _onChangeEndTime(hour) {
    if (_selectedStartHour != null) {
      if (_selectedStartHour > hour) {
        int _highest = _selectedStartHour;
        int _lowest = hour;

        setState(() {
          _selectedStartHour = _lowest;
          _selectedEndHour = _highest;
        });
      } else {
        setState(() {
          _selectedEndHour = hour;
        });
      }
    } else {
      setState(() {
        _selectedEndHour = hour;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
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
                    onChanged: _onChangeLocation,
                    items: locations.map((location) {
                      return DropdownMenuItem<String>(
                        value: location['key'],
                        child: Text('Linha de ${location['value']}'),
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
                    onChanged: _onChangeStartTime,
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
                    onChanged: _onChangeEndTime,
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
            widget.onAdd(
              _selectedLocation,
              _selectedStartHour,
              _selectedEndHour,
            );
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
