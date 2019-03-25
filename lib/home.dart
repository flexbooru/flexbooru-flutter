import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart' show DragStartBehavior;
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:flexbooru_flutter/bottom_navigation.dart';
import 'package:flexbooru_flutter/page/posts_page.dart';
import 'package:flexbooru_flutter/page/popular_page.dart';
import 'package:flexbooru_flutter/page/pools_page.dart';
import 'package:flexbooru_flutter/page/tags_page.dart';
import 'package:flexbooru_flutter/helper/user.dart';
import 'package:flexbooru_flutter/helper/booru.dart';
import 'package:flexbooru_flutter/helper/database.dart';

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
  
  List<User> _users = [];
  Future<List<Booru>> _boorus;

  TabItem _currentTab = TabItem.posts;

  AnimationController _controller;
  Animation<double> _drawerContentsOpacity;
  Animation<Offset> _drawerDetailsPosition;
  bool _showDrawerContents = true;

  final _drawerItems = <DrawerItem>[
    DrawerItem(OMIcons.accountCircle, "Account"),
    DrawerItem(OMIcons.comment, "Comments"),
    DrawerItem(OMIcons.settings, "Settings"),
    DrawerItem(OMIcons.info, "About"),
  ];

  static final Animatable<Offset> _drawerDetailsTween = Tween<Offset>(
    begin: const Offset(0.0, -1.0),
    end: Offset.zero,
  ).chain(CurveTween(
    curve: Curves.fastOutSlowIn,
  ));

  Map<TabItem, GlobalKey<NavigatorState>> navigatorKeys = {
    TabItem.posts: GlobalKey<NavigatorState>(),
    TabItem.popular: GlobalKey<NavigatorState>(),
    TabItem.pools: GlobalKey<NavigatorState>(),
    TabItem.tags: GlobalKey<NavigatorState>(),
  };

  void _selectTab(TabItem tabItem) {
    setState(() {
      _currentTab = tabItem;
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
    _loadBoorus();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async =>
          !await navigatorKeys[_currentTab].currentState.maybePop(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(TabHelper.description(_currentTab)),
        ),
        body: FutureBuilder<List<Booru>>(
          future: _boorus,
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
                return Center(child: CircularProgressIndicator());
              default:
                if (snapshot.data.length > 0) {
                  return _buildPage(snapshot.data[0]);
                } else {
                  return Center(child: Text('none booru'),);
                }
              }
          }
        ),
        bottomNavigationBar: BottomNavigation(
          currentTab: _currentTab,
          onSelectTab: _selectTab,
        ),
        drawer: Drawer(
          child: Column(
            children: <Widget>[
              _buildDrawerHeader(),
              MediaQuery.removePadding(
                context: context,
                // DrawerHeader consumes top MediaQuery padding.
                removeTop: true,
                child: Expanded(
                  child: _buildDrawerItems(),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _loadBoorus() async {
    List<Booru> boorus = await DatabaseHelper.instance.getAllBoorus();
    if (boorus == null || boorus.isEmpty) {
      await DatabaseHelper.instance.insertBooru(
        Booru(
          type: BooruType.moebooru,
          name: 'Sample',
          scheme: 'https',
          host: 'moe.fiepi.com',
          hashSalt: 'onlymash--your-password--'
        )
      );
      boorus = await DatabaseHelper.instance.getAllBoorus();
    }
    Future<List<Booru>> data = Future.value(boorus);
    if (_boorus != data) {
      setState(() {
        _boorus = data; 
      });
    }
  }

  Widget _buildPage(Booru booru) {
    Stack stack = Stack(
          children: <Widget>[
            _buildOffstageNavigator(TabItem.posts, booru),
            _buildOffstageNavigator(TabItem.popular, booru),
            _buildOffstageNavigator(TabItem.pools, booru),
            _buildOffstageNavigator(TabItem.tags, booru),
          ],);
    return stack;
  }

  Widget _buildOffstageNavigator(TabItem tabItem, Booru booru) {
    Widget widget;
    switch (tabItem) {
      case TabItem.posts:
        widget = PostsPage(booru);
        break;
      case TabItem.popular:
        widget = PopularPage(booru);
        break;
      case TabItem.pools:
        widget = PoolsPage(booru);
        break;
      case TabItem.tags:
        widget = TagsPage(booru);
        break;
    }
    return Offstage(
      offstage: _currentTab != tabItem,
      child: widget,
    );
  }
  
  Widget _buildDrawerHeader() {
    return UserAccountsDrawerHeader(
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
  }

  Widget _buildDrawerItems() {
    return ListView(
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
  }
}
