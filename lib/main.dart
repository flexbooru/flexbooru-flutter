import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flexbooru_flutter/home.dart';

void main() => runApp(new App());

class App extends StatelessWidget {
  final SystemUiOverlayStyle _currentStyle = SystemUiOverlayStyle.light;
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(_currentStyle);
    return new MaterialApp(
      title: 'Flexbooru',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: new Home(),
    );
  }
}

