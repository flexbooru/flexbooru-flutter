import 'package:flutter/material.dart';
import 'package:flexbooru/helper/settings.dart';

enum LoadingStatus {
  idle,
  refreshing,
  loading,
  failed,
  nomore,
}

abstract class BaseState<T extends StatefulWidget> extends State<T> with ActiveBooruListener {
  
  @override
  void initState() {
    super.initState();
    Settings.instance.registerActiveBooruListener(this);
    ScrollController scrollController = getScrollController();
    scrollController.addListener(() {
      if (getLoadingStatus() == LoadingStatus.idle && scrollController.position.pixels == scrollController.position.maxScrollExtent) {
        loadMoreData();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    Settings.instance.unregisterActiveBooruListener(this);
    getScrollController().dispose();
  }

  LoadingStatus getLoadingStatus();

  ScrollController getScrollController();

  Future<void> refreshData();

  void loadMoreData();
}