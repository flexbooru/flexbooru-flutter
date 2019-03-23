
import 'package:flutter/material.dart';
import 'package:outline_material_icons/outline_material_icons.dart';

enum TabItem { posts, pools, tags }

class TabHelper {
  static TabItem item({int index}) {
    switch (index) {
      case 0:
        return TabItem.posts;
      case 1:
        return TabItem.pools;
      case 2:
        return TabItem.tags;
    }
    return TabItem.posts;
  }

  static int index(TabItem tabItem) {
    switch (tabItem) {
      case TabItem.posts:
        return 0;
      case TabItem.pools:
        return 1;
      case TabItem.tags:
        return 2;
    }
    return 0;
  }

  static String description(TabItem tabItem) {
    switch (tabItem) {
      case TabItem.posts:
        return 'Posts';
      case TabItem.pools:
        return 'Pools';
      case TabItem.tags:
        return 'Tags';
    }
    return '';
  }
  static IconData icon(TabItem tabItem) {
    switch (tabItem) {
      case TabItem.posts:
        return OMIcons.photo;
      case TabItem.pools:
        return OMIcons.photoAlbum;
      case TabItem.tags:
        return OMIcons.bookmarkBorder;
      default:
        return OMIcons.photo;
    }
  }
  static IconData activeIcon(TabItem tabItem) {
    switch (tabItem) {
      case TabItem.posts:
        return Icons.photo;
      case TabItem.pools:
        return Icons.photo_album;
      case TabItem.tags:
        return Icons.bookmark;
      default:
        return Icons.photo;
    }
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
        _buildItem(tabItem: TabItem.pools),
        _buildItem(tabItem: TabItem.tags),
      ],
      currentIndex: TabHelper.index(currentTab),
      onTap: (index) => onSelectTab(
        TabHelper.item(index: index),
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