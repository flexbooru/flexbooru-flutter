import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart' show DragStartBehavior;
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:flexbooru_flutter/bottom_navigation.dart';
import 'package:flexbooru_flutter/widget/boorus_drawer_header.dart';
import 'package:flexbooru_flutter/page/posts_page.dart';
import 'package:flexbooru_flutter/page/popular_page.dart';
import 'package:flexbooru_flutter/page/pools_page.dart';
import 'package:flexbooru_flutter/page/tags_page.dart';
import 'package:flexbooru_flutter/helper/user.dart';
import 'package:flexbooru_flutter/helper/booru.dart';
import 'package:flexbooru_flutter/helper/database.dart';
import 'package:flexbooru_flutter/constants.dart';

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => HomeState();
}

class DrawerItem {
  DrawerItem(this.icon, this.name, this.routeName);
  final IconData icon;
  final String name;
  final String routeName;
}

class HomeState extends State<Home> with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  String _keyword = '';
  List<User> _users = [];
  List<Booru> _boorus;
  Future<List<Booru>> _boorusFuture;

  TabItem _currentTab = TabItem.posts;

  AnimationController _controller;
  Animation<double> _drawerContentsOpacity;
  Animation<Offset> _drawerDetailsPosition;
  bool _showDrawerContents = true;

  final _drawerItems = <DrawerItem>[
    DrawerItem(OMIcons.accountCircle, "Account", ROUTE_ACCOUNT),
    DrawerItem(OMIcons.comment, "Comments", ROUTE_COMMENTS),
    DrawerItem(OMIcons.settings, "Settings", ROUTE_SETTINGS),
    DrawerItem(OMIcons.info, "About", ROUTE_ABOUT),
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

  void _showInSnackBar(String msg, Duration duration) {
    _scaffoldKey.currentState.showSnackBar(
      SnackBar(content: Text(msg), duration: duration,)
    );
  }

  bool exit = false;
  
  Future<bool> _doubleClickBack(BuildContext context) {
    if (_scaffoldKey.currentState.isDrawerOpen) {
      Navigator.pop(context);
      return Future.value(false);
    }
    if (!exit) {
      exit = true;
      var duration = Duration(seconds: 2);
      Timer.periodic(duration, (timer) {
        exit = false;
        timer.cancel();
      });
      _showInSnackBar("Press twice to exit.", duration);
      return Future.value(false);
    } else {
      return Future.value(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _doubleClickBack(context),
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text(TabHelper.description(_currentTab)),
          backgroundColor: Colors.grey[50],
        ),
        body: FutureBuilder<List<Booru>>(
          future: _boorusFuture,
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
              _buildDrawerItems(),
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
    setState(() {
      _boorus = boorus;
    });
    Future<List<Booru>> data = Future.value(boorus);
    if (_boorusFuture != data) {
      setState(() {
        _boorusFuture = data; 
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
        widget = PostsPage(booru, _keyword);
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
    return FutureBuilder<List<Booru>>(
      future: _boorusFuture,
      builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return _buildEmptyDrawerHeaderItems();
            default :
              var data = snapshot.data;
              if ( data == null || data.isEmpty) {
                return _buildEmptyDrawerHeaderItems();
              } else {
                return _buildDrawerHeaderItems(data);
              }
          }
        },
    );
  }
  
  Widget _buildDrawerHeaderItems(List<Booru> boorus) {
    Widget headerItems;
    if (boorus != null && boorus.isNotEmpty) {
      headerItems = BoorusDrawerHeader(
        decoration: BoxDecoration(
          color: Colors.grey[50],
        ),
        booruName: Text(boorus[0].name),
        booruUrl: Text("${boorus[0].scheme}://${boorus[0].host}"),
        currentBooruPicture: CircleAvatar(
          child: Text(
            boorus[0].name[0],
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 42.0),
            ),
          backgroundColor: Colors.pink[300],
        ),
        otherBoorusPictures: boorus.map<Widget>((booru) {
          GestureDetector(
            dragStartBehavior: DragStartBehavior.down,
            onTap: () {

            },
            child: Semantics(
              label: booru.name,
              child: CircleAvatar(
                child: Text(
                booru.name[0],
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 24.0),
                ),
              backgroundColor: Colors.grey[50],
              ),
            ),
          );
        }).toList(),
        margin: EdgeInsets.zero,
        onDetailsPressed: () {
          _showDrawerContents = !_showDrawerContents;
          if (_showDrawerContents)
            _controller.reverse();
          else
            _controller.forward();
        },
      );
    } else {
      headerItems =_buildEmptyDrawerHeaderItems();
    }
    return headerItems;
  }

  Widget _buildEmptyDrawerHeaderItems() {
    return BoorusDrawerHeader(
      decoration: BoxDecoration(
          color: Colors.grey[50],
        ),
      booruName: Text('none booru'),
      booruUrl: Text(''),
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
    return MediaQuery.removePadding(
      context: context,
      // DrawerHeader consumes top MediaQuery padding.
      removeTop: true,
      child: Expanded(
        child: ListView(
          dragStartBehavior: DragStartBehavior.down,
          padding: const EdgeInsets.only(top: 8.0),
          children: <Widget>[
            Stack(
              children: <Widget>[
                Stack(
                  children: <Widget>[
                    FadeTransition(
                      opacity: _drawerContentsOpacity,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: _drawerItems.map<Widget>((DrawerItem item) {
                          return ListTile(
                            leading: Icon(item.icon),
                            title: Text(item.name),
                            onTap: () {
                              Navigator.of(context).pushNamed(item.routeName);
                            },
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
                              leading: const Icon(Icons.settings),
                              title: const Text('Manage boorus'),
                              onTap: () {
                                Navigator.of(context).pushNamed(ROUTE_BOORUS);
                              },
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
        ),
      ),
    );
  }
}
