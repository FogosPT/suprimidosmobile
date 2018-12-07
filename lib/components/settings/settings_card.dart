import 'package:flutter/material.dart';

class SettingsCard extends StatelessWidget {
  final String title;
  final String line;
  final int startTime;
  final int endTime;
  final onRemove;

  SettingsCard({
    @required this.title,
    @required this.line,
    @required this.startTime,
    @required this.endTime,
    @required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return new Container(
      child: new Card(
        child: new Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            new ListTile(
              leading: new Icon(Icons.train),
              title: new Text(
                title,
                style: new TextStyle(fontSize: 18.0),
              ),
              subtitle: Text(
                'das ${startTime}h às ${endTime}h',
              ),
              trailing: FlatButton(
                child: const Text('ELIMINAR'),
                onPressed: () {
                  this.onRemove('$line-$startTime-$endTime');
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
