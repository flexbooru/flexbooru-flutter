import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flexbooru_flutter/home.dart';
import 'package:flexbooru_flutter/constants.dart';
import 'package:flexbooru_flutter/page/boorus_page.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  final SystemUiOverlayStyle _currentStyle = SystemUiOverlayStyle.light;
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(_currentStyle);
    return MaterialApp(
      title: 'Flexbooru',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: Home(),
      routes: <String, WidgetBuilder> {
        ROUTE_BOORUS: (context) => BoorusPage()
      },
    );
  }
}

