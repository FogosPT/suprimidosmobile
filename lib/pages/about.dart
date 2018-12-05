import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class About extends StatelessWidget {
  final Map people = {
    'project': 'https://github.com/fogospt/suprimidosmobile',
    'guilherme': 'https://twitter.com/theoneguilherme',
    'jorge': 'https://twitter.com/jandresaco',
    'ricardo': 'https://github.com/ricardojrgpimentel',
    'ze': 'https://github.com/oZeca',
  };

  _openLink(person) {
    try {
      _launchURL(people[person]);
    } catch (err) {}
  }

  _launchURL(url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: new Text(
          'Sobre',
          style: TextStyle(color: Color(0xFFe9ecef)),
        ),
        backgroundColor: Color(0xFF343a40),
      ),
      body: ListView(
        children: <Widget>[
          Hero(
            tag: 'logo',
            child: Center(
              child: ConstrainedBox(
                child: Image.asset('assets/logo.png'),
                constraints: BoxConstraints.tight(
                  Size.square(
                    100.0,
                  ),
                ),
              ),
            ),
          ),
          Center(
            child: Text(
              'Suprimidos.pt',
              style: TextStyle(fontSize: 26.0),
            ),
          ),
          Divider(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'O Suprimidos.pt é um serviço que possibilita o acesso à informação atualizada sobre comboios suprimidos e atrasados nas várias linhas ferroviárias do país. O Suprimidos.pt nasce pelas mãos da mesma equipa que desenvolveu o Fogos.pt.',
              style: TextStyle(
                fontSize: 18.0,
              ),
            ),
          ),
          Divider(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'O projeto é de código aberto, pelo que tu também podes contribuir!',
              style: TextStyle(
                fontSize: 18.0,
              ),
            ),
          ),
          IconButton(
            icon: Icon(FontAwesomeIcons.github),
            onPressed: () {
              _openLink('project');
            },
          ),
          Divider(),
          Padding(
            padding: const EdgeInsets.fromLTRB(8.0, 20.0, 8.0, 8.0),
            child: Center(
              child: Text(
                'Agradecimentos',
                style: TextStyle(
                  fontSize: 22.0,
                ),
              ),
            ),
          ),
          ListTile(
            title: Text('Guilherme Cabral'),
            trailing: Icon(FontAwesomeIcons.twitter),
            onTap: () {
              _openLink('guilherme');
            },
          ),
          ListTile(
            title: Text('Ricardo Pimentel'),
            trailing: Icon(FontAwesomeIcons.github),
            onTap: () {
              _openLink('ricardo');
            },
          ),
          ListTile(
            title: Text('Zé Caetano'),
            trailing: Icon(FontAwesomeIcons.github),
            onTap: () {
              _openLink('ze');
            },
          ),
          ListTile(
            title: Text('Jorge Saco'),
            trailing: Icon(FontAwesomeIcons.twitter),
            onTap: () {
              _openLink('jorge');
            },
          ),
        ],
      ),
    );
  }
}
