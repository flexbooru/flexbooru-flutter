import 'package:flutter/material.dart';
import 'package:flexbooru_flutter/bottom_navigation.dart';
import 'package:flexbooru_flutter/tab_navigator.dart';

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => HomeState();
}

class HomeState extends State<Home> {
  
  TabItem currentTab = TabItem.posts;

  Map<TabItem, GlobalKey<NavigatorState>> navigatorKeys = {
    TabItem.posts: GlobalKey<NavigatorState>(),
    TabItem.pools: GlobalKey<NavigatorState>(),
    TabItem.tags: GlobalKey<NavigatorState>(),
  };

  void _selectTab(TabItem tabItem) {
    setState(() {
      currentTab = tabItem;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async =>
          !await navigatorKeys[currentTab].currentState.maybePop(),
      child: Scaffold(
        body: Stack(children: <Widget>[
          _buildOffstageNavigator(TabItem.posts),
          _buildOffstageNavigator(TabItem.pools),
          _buildOffstageNavigator(TabItem.tags),
        ]),
        bottomNavigationBar: BottomNavigation(
          currentTab: currentTab,
          onSelectTab: _selectTab,
        ),
      ),
    );
  }

  Widget _buildOffstageNavigator(TabItem tabItem) {
    return Offstage(
      offstage: currentTab != tabItem,
      child: TabNavigator(
        navigatorKey: navigatorKeys[tabItem],
        tabItem: tabItem,
      ),
    );
  }
}
