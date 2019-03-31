import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart' show DragStartBehavior;
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flexbooru/bottom_navigation.dart';
import 'package:flexbooru/widget/boorus_drawer_header.dart';
import 'package:flexbooru/page/posts_page.dart';
import 'package:flexbooru/page/popular_page.dart';
import 'package:flexbooru/page/pools_page.dart';
import 'package:flexbooru/page/tags_page.dart';
import 'package:flexbooru/helper/user.dart';
import 'package:flexbooru/helper/booru.dart';
import 'package:flexbooru/helper/database.dart';
import 'package:flexbooru/constants.dart';
import 'package:flexbooru/helper/settings.dart';
import 'package:flexbooru/theme/theme_model.dart' show ThemeType;
import 'package:flexbooru/theme/theme_bloc.dart';

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

class HomeState extends State<Home> with TickerProviderStateMixin, BooruListener {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  String _keyword = '';
  List<User> _users = [];
  List<Booru> _boorus;
  Future<List<Booru>> _boorusFuture;
  Booru _activeBooru;

  ThemeType _currentThemeType = ThemeType.light;

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
    DatabaseHelper.instance.setBooruListener(this);
  }

  @override
  void dispose() {
    _controller.dispose();
    DatabaseHelper.instance.setBooruListener(null);
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
          elevation: 1.0,
        ),
        body: FutureBuilder<List<Booru>>(
          future: _boorusFuture,
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
                return Center(child: CircularProgressIndicator());
              default:
                _boorus = snapshot.data;
                if (_activeBooru != null) {
                  return _buildPage();
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
    _currentThemeType = await Settings.instance.getTheme();
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
    _loadActiveBooru();
  }

  void _loadActiveBooru() async {
    if (_boorus == null || _boorus.isEmpty) {
      setState(() {
        _activeBooru = null;
      });
      return;
    }
    int uid = await Settings.instance.getActiveBooruUid();
    if (uid < 0) {
      uid = _boorus[0].uid;
      Settings.instance.setActiveBooruUid(uid);
    }
    Booru activeBooru;
    _boorus.forEach((booru) {
      if(booru.uid == uid) {
        activeBooru = booru;
        return;
      }
    });
    if (activeBooru == null) {
      activeBooru = _boorus[0];
      Settings.instance.setActiveBooruUid(activeBooru.uid);
    }
    setState(() {
      _activeBooru = activeBooru;
    });
  }

  Widget _buildPage() {
    return Stack(
      children: <Widget>[
        _buildOffstageNavigator(TabItem.posts),
        _buildOffstageNavigator(TabItem.popular),
        _buildOffstageNavigator(TabItem.pools),
        _buildOffstageNavigator(TabItem.tags),
      ],
    );
  }

  Widget _buildOffstageNavigator(TabItem tabItem) {
    Widget widget;
    switch (tabItem) {
      case TabItem.posts:
        widget = PostsPage(_activeBooru, _keyword);
        break;
      case TabItem.popular:
        widget = PopularPage(_activeBooru);
        break;
      case TabItem.pools:
        widget = PoolsPage(_activeBooru);
        break;
      case TabItem.tags:
        widget = TagsPage(_activeBooru);
        break;
    }
    return Offstage(
      offstage: _currentTab != tabItem,
      child: widget,
    );
  }

  Widget _buildDrawerHeader() {
    if (_boorus == null || _boorus.isEmpty || _activeBooru == null) {
      return _buildEmptyDrawerHeaderItems();
    } else {
      return _buildDrawerHeaderItems(_boorus);
    }
  }
  
  Widget _buildDrawerHeaderItems(List<Booru> boorus) {
    return BoorusDrawerHeader(
        booruName: Text(_activeBooru.name),
        booruUrl: Text("${_activeBooru.scheme}://${_activeBooru.host}"),
        currentBooruPicture: CircleAvatar(
          backgroundImage: CachedNetworkImageProvider(
            "${_activeBooru.scheme}://${_activeBooru.host}/favicon.ico"
          ),
        ),
        margin: EdgeInsets.zero,
        onDetailsPressed: () => _onDetailsPressed(),
      );
  }

  void _onDetailsPressed() {
    _showDrawerContents = !_showDrawerContents;
    if (_showDrawerContents)
      _controller.reverse();
    else
      _controller.forward();
  }

  Widget _buildEmptyDrawerHeaderItems() {
    return BoorusDrawerHeader(
      booruName: Text('none booru'),
      booruUrl: Text(''),
      margin: EdgeInsets.zero,
      onDetailsPressed: () => _onDetailsPressed(),
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
                FadeTransition(
                  opacity: _drawerContentsOpacity,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: _buildDrawerItemsTile(),
                  ),
                ),
                SlideTransition(
                  position: _drawerDetailsPosition,
                  child: FadeTransition(
                    opacity: ReverseAnimation(_drawerContentsOpacity),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: _buildBooruItems(),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  List<Widget> _buildBooruItems() {
    List<Widget> items = [];
    _boorus?.forEach((item) {
      items.add(
        ListTile(
        leading: CircleAvatar(
          backgroundImage: CachedNetworkImageProvider(
            "${item.scheme}://${item.host}/favicon.ico"
          ),
        ),
        title: Text(item.name),
        subtitle: Text("${item.scheme}://${item.host}"),
        onTap: () {
          setState(() {
            _activeBooru = item;
          });
          Settings.instance.setActiveBooruUid(item.uid);
          _onDetailsPressed();
        },
      )
      );
    });
    items.add(
      ListTile(
        leading: const Icon(Icons.settings),
        title: const Text('Manage boorus'),
        onTap: () {
          // _onDetailsPressed();
          Navigator.of(context).pushNamed(ROUTE_BOORUS);
        },
      )
    );
    return items;
  }

  List<Widget> _buildDrawerItemsTile() {
    List<Widget> widgets = _drawerItems.map<Widget>((DrawerItem item) {
      return ListTile(
      leading: Icon(item.icon),
      title: Text(item.name),
      onTap: () {
        Navigator.of(context).pushNamed(item.routeName);
        },
      );
    }).toList();
    widgets.add(
      ListTile(
        leading: Icon(OMIcons.style),
        title: Text('Night Mode'),
        trailing: Switch(
          activeColor: Colors.grey[50],
          value: _currentThemeType == ThemeType.dark,
          onChanged: (bool value) {
            if(value) {
              setState(() {
                _currentThemeType = ThemeType.dark;
              });
              themeBloc.onDarkTheme();
            } else {
              setState(() {
                _currentThemeType = ThemeType.light;
              });
              themeBloc.onLightTheme();
            }
          },
        ),
        onTap: () {
          if (_currentThemeType == ThemeType.dark) {
            setState(() {
                _currentThemeType = ThemeType.light;
            });
            themeBloc.onLightTheme();
          } else {
            setState(() {
                _currentThemeType = ThemeType.dark;
            });
            themeBloc.onDarkTheme();
          }
        },
      )
    );
    return widgets;
  }

  @override
  void onBooruChanged() {
    _loadBoorus();
  }
}
