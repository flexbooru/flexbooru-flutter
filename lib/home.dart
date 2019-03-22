import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart' show DragStartBehavior;
import 'package:flexbooru_flutter/bottom_navigation.dart';
import 'package:flexbooru_flutter/tab_navigator.dart';

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => HomeState();
}

class DrawerItem {
  DrawerItem(this.icon, this.name);
  final IconData icon;
  final String name;
}

class HomeState extends State<Home> with TickerProviderStateMixin {
  
  TabItem currentTab = TabItem.posts;

  AnimationController _controller;
  Animation<double> _drawerContentsOpacity;
  Animation<Offset> _drawerDetailsPosition;
  bool _showDrawerContents = true;

  final _drawerItems = <DrawerItem>[
    DrawerItem(Icons.account_circle, "Account"),
    DrawerItem(Icons.comment, "Comments"),
    DrawerItem(Icons.settings, "Settings"),
    DrawerItem(Icons.info, "About"),
  ];

  static final Animatable<Offset> _drawerDetailsTween = Tween<Offset>(
    begin: const Offset(0.0, -1.0),
    end: Offset.zero,
  ).chain(CurveTween(
    curve: Curves.fastOutSlowIn,
  ));

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
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _drawerContentsOpacity = CurvedAnimation(
      parent: ReverseAnimation(_controller),
      curve: Curves.fastOutSlowIn,
    );
    _drawerDetailsPosition = _controller.drive(_drawerDetailsTween);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final drawerHeader = UserAccountsDrawerHeader(
      accountName: Text("Sample"),
      accountEmail: Text("https://moe.fiepi.com"),
      currentAccountPicture: const CircleAvatar(
        child: Text(
          "S",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 42.0
          ),
        ),
        backgroundColor: Colors.white,
      ),
      otherAccountsPictures: <Widget>[
        GestureDetector(
          dragStartBehavior: DragStartBehavior.down,
          onTap: () {},
          child: Semantics(
            label: 'Switch to Account B',
            child: const CircleAvatar(
              child: Text(
                "B",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 24.0),
              ),
            backgroundColor: Colors.blue,
            ),
          ),
        ),
        GestureDetector(
          dragStartBehavior: DragStartBehavior.down,
          onTap: () {},
          child: Semantics(
            label: 'Switch to Account C',
            child: const CircleAvatar(
              child: Text(
                "C",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 24.0),
              ),
            backgroundColor: Colors.yellow,
            ),
          ),
        ),
      ],
      margin: EdgeInsets.zero,
      onDetailsPressed: () {
        _showDrawerContents = !_showDrawerContents;
        if (_showDrawerContents)
          _controller.reverse();
        else
          _controller.forward();
      },
    );
    final drawerItems = ListView(
      dragStartBehavior: DragStartBehavior.down,
      padding: const EdgeInsets.only(top: 8.0),
      children: <Widget>[
        Stack(
          children: <Widget>[
            Stack(
              children: <Widget>[
                // The initial contents of the drawer.
                FadeTransition(
                  opacity: _drawerContentsOpacity,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: _drawerItems.map<Widget>((DrawerItem item) {
                      return ListTile(
                        leading: Icon(item.icon),
                        title: Text(item.name),
                      );
                    }).toList(),
                  ),
                ),
                SlideTransition(
                  position: _drawerDetailsPosition,
                  child: FadeTransition(
                    opacity: ReverseAnimation(_drawerContentsOpacity),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        ListTile(
                          leading: const Icon(Icons.add),
                          title: const Text('Add booru'),
                        ),
                        ListTile(
                          leading: const Icon(Icons.settings),
                          title: const Text('Manage boorus'),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
    return WillPopScope(
      onWillPop: () async =>
          !await navigatorKeys[currentTab].currentState.maybePop(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(TabHelper.description(currentTab)),
        ),
        body: Stack(children: <Widget>[
          _buildOffstageNavigator(TabItem.posts),
          _buildOffstageNavigator(TabItem.pools),
          _buildOffstageNavigator(TabItem.tags),
        ]),
        bottomNavigationBar: BottomNavigation(
          currentTab: currentTab,
          onSelectTab: _selectTab,
        ),
        drawer: Drawer(
          child: Column(
            children: <Widget>[
              drawerHeader,
              MediaQuery.removePadding(
                context: context,
                // DrawerHeader consumes top MediaQuery padding.
                removeTop: true,
                child: Expanded(
                  child: drawerItems,
                ),
              )
            ],
          ),
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
