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
import 'package:flutter_user_agent/flutter_user_agent.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flexbooru/bloc/theme/theme_bloc.dart';
import 'package:flexbooru/bloc/theme/theme_state.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    
    initUserAgentState();

    return BlocBuilder(
      bloc: themeBloc,
      builder: (BuildContext context, ThemeState state) {
        return MaterialApp(
          title: 'Flexbooru',
          theme: state.themeModel.themedata,
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
      },
    );
  }

  Future<void> initUserAgentState() async {
    try {
      await FlutterUserAgent.init();
      webViewUserAgent = FlutterUserAgent.webViewUserAgent;
    } on PlatformException {
      print('<error>');
    }
  }
}

