import 'package:flutter/material.dart';
import 'package:flexbooru_flutter/bottom_navigation.dart';
import 'package:flexbooru_flutter/page/posts_page.dart';
import 'package:flexbooru_flutter/page/pools_page.dart';
import 'package:flexbooru_flutter/page/tags_page.dart';

class TabNavigatorRoutes {
  static const String root = '/';
}

class TabNavigator extends StatelessWidget {
  TabNavigator({this.navigatorKey, this.tabItem});
  final GlobalKey<NavigatorState> navigatorKey;
  final TabItem tabItem;

  Map<String, WidgetBuilder> _routeBuilders(BuildContext context) {
    switch (tabItem) {
      case TabItem.posts:
      return {
        TabNavigatorRoutes.root: (context) => PostsPage(),
        };
      case TabItem.pools:
      return {
        TabNavigatorRoutes.root: (context) => PoolsPage(),
        };
      case TabItem.tags:
      return {
        TabNavigatorRoutes.root: (context) => TagsPage(),
        };
      default:
      return {
        TabNavigatorRoutes.root: (context) => PostsPage(),
        };
      }
  }
  @override
  Widget build(BuildContext context) {
    var routeBuilders = _routeBuilders(context);
    return Navigator(
        key: navigatorKey,
        initialRoute: TabNavigatorRoutes.root,
        onGenerateRoute: (routeSettings) {
          return MaterialPageRoute(
            builder: (context) => routeBuilders[routeSettings.name](context),
          );
        });
  }
}