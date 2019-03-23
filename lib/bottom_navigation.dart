
import 'package:flutter/material.dart';
import 'package:outline_material_icons/outline_material_icons.dart';

enum TabItem { posts, popular, pools, tags }

class TabHelper {
  static TabItem item(int index) {
    TabItem item;
    switch (index) {
      case 0:
        item = TabItem.posts;
        break;
      case 1:
        item = TabItem.popular;
        break;
      case 2:
        item = TabItem.pools;
        break;
      case 3:
        item = TabItem.tags;
        break;
    }
    return item;
  }

  static int index(TabItem tabItem) {
    int index = -1;
    switch (tabItem) {
      case TabItem.posts:
        index = 0;
        break;
      case TabItem.popular:
        index = 1;
        break;
      case TabItem.pools:
        index = 2;
        break;
      case TabItem.tags:
        index = 3;
        break;
    }
    return index;
  }

  static String description(TabItem tabItem) {
    String title = '';
    switch (tabItem) {
      case TabItem.posts:
        title = "Posts";
        break;
      case TabItem.popular:
        title = "Popular";
        break;
      case TabItem.pools:
        title = "Pools";
        break;
      case TabItem.tags:
        title = "Tags";
        break;
    }
    return title;
  }
  static IconData icon(TabItem tabItem) {
    IconData data;
    switch (tabItem) {
      case TabItem.posts:
        data = OMIcons.photo;
        break;
      case TabItem.popular:
        data = OMIcons.whatshot;
        break;
      case TabItem.pools:
        data = OMIcons.photoAlbum;
        break;
      case TabItem.tags:
        data = OMIcons.bookmarkBorder;
        break;
    }
    return data;
  }
  static IconData activeIcon(TabItem tabItem) {
    IconData data;
    switch (tabItem) {
      case TabItem.posts:
        data = Icons.photo;
        break;
      case TabItem.popular:
        data = Icons.whatshot;
        break;
      case TabItem.pools:
        data = Icons.photo_album;
        break;
      case TabItem.tags:
        data = Icons.bookmark;
        break;
    }
    return data;
  }
}

class BottomNavigation extends StatelessWidget {
  BottomNavigation({this.currentTab, this.onSelectTab});
  final TabItem currentTab;
  final ValueChanged<TabItem> onSelectTab;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: [
        _buildItem(tabItem: TabItem.posts),
        _buildItem(tabItem: TabItem.popular),
        _buildItem(tabItem: TabItem.pools),
        _buildItem(tabItem: TabItem.tags),
      ],
      type: BottomNavigationBarType.fixed,
      currentIndex: TabHelper.index(currentTab),
      onTap: (index) => onSelectTab(
        TabHelper.item(index),
      ),
    );
  }

  BottomNavigationBarItem _buildItem({TabItem tabItem}) {

    String _text = TabHelper.description(tabItem);
    IconData _icon = TabHelper.icon(tabItem);
    IconData _activeIcon =TabHelper.activeIcon(tabItem);

    return BottomNavigationBarItem(
      icon: Icon(_icon),
      activeIcon: Icon(_activeIcon),
      title: Text(_text),
    );
  }
}