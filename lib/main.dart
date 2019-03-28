import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flexbooru/home.dart';
import 'package:flexbooru/constants.dart';
import 'package:flexbooru/page/boorus_page.dart';
import 'package:flexbooru/page/booru_config_page.dart';
import 'package:flexbooru/page/about_page.dart';
import 'package:flexbooru/page/account_config_page.dart';
import 'package:flexbooru/page/account_page.dart';
import 'package:flexbooru/page/comments_page.dart';
import 'package:flexbooru/page/settings_page.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  final SystemUiOverlayStyle _currentStyle = SystemUiOverlayStyle.light.copyWith(
    statusBarColor: Colors.grey[50],
    statusBarBrightness: Brightness.light,
    // systemNavigationBarColor: Colors.grey[50],
    // systemNavigationBarIconBrightness: Brightness.light,
  );
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(_currentStyle);
    return MaterialApp(
      title: 'Flexbooru',
      theme: ThemeData(
        primaryColor: Colors.deepPurple,
        primaryColorDark: Colors.grey[50],
        primaryColorBrightness: Brightness.light,
        accentColor: Colors.pinkAccent,
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

