import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flexbooru_flutter/home.dart';
import 'package:flexbooru_flutter/constants.dart';
import 'package:flexbooru_flutter/page/boorus_page.dart';
import 'package:flexbooru_flutter/page/booru_config_page.dart';
import 'package:flexbooru_flutter/page/about_page.dart';
import 'package:flexbooru_flutter/page/account_config_page.dart';
import 'package:flexbooru_flutter/page/account_page.dart';
import 'package:flexbooru_flutter/page/comments_page.dart';
import 'package:flexbooru_flutter/page/settings_page.dart';

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
        ROUTE_ABOUT: (context) => AboutPage(),
        ROUTE_ACCOUNT: (context) => AccountPage(),
        ROUTE_ACCOUNT_CONFIG: (context) => AccountConfigPage(),
        ROUTE_BOORUS: (context) => BoorusPage(),
        ROUTE_BOORU_CONFIG: (context) => BooruConfigPage(),
        ROUTE_COMMENTS: (context) => CommentsPage(),
        ROUTE_SETTINGS: (context) => SettingsPage(),
      },
    );
  }
}

