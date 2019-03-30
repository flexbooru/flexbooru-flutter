import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flexbooru/model/post_base.dart';
import 'package:flexbooru/network/api/danbooru.dart';
import 'package:flexbooru/network/api/moebooru.dart';
import 'package:flexbooru/network/api/danbooru_one.dart';
import 'package:flexbooru/helper/database.dart';
import 'package:flexbooru/helper/settings.dart';
import 'package:flexbooru/helper/booru.dart';
import 'package:flexbooru/widget/post_tile.dart';
import 'base_state.dart';

class PostsPage extends StatefulWidget {
  PostsPage(this._booru, this._keyword);
  final Booru _booru;
  final String _keyword;
  @override
  PostsPageState createState() => PostsPageState(_booru, _keyword); 
}

class PostsPageState extends BaseState<PostsPage> {
  PostsPageState(this._booru, this._keyword);
  Booru _booru;
  final String _keyword;
  List<PostBase> _posts = [];

  int _page = 1;
  int _limit = 20;
  int _lastResponseSize = 0;
  LoadingStatus _loadingStatus = LoadingStatus.idle;
  ScrollController _scrollController =ScrollController();

  @override
  void initState() {
    super.initState();
    if (_booru != null) {
      _initPosts(); 
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: refreshData,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              _buildStaggeredGrid(context),
              _buildFooter(),
            ],
          ),
          controller: _scrollController,
        ),
      ),
    );
  }

  Widget _buildFooter() {
    if (_loadingStatus == LoadingStatus.loading) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    if (_loadingStatus == LoadingStatus.failed) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: RaisedButton(
            child: Text('Retry'),
            onPressed: () {
              _fetchPostsList();
              setState(() {
                _loadingStatus = LoadingStatus.loading;
              });
            },
          ),
        ),
      );
    }
    return Center();
  }

  Widget _buildStaggeredGrid(BuildContext context) {
    return StaggeredGridView.countBuilder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      primary: false,
      crossAxisCount: _getCrossAxisCount(context),
      staggeredTileBuilder: (_) => StaggeredTile.fit(1),
      itemBuilder: (context, index) => PostTile(_posts[index]),
      itemCount: _getItemCount(),
    );
  }

  int _getCrossAxisCount(BuildContext context) {
    int count = MediaQuery.of(context).size.width ~/ 130;
    return count > 1 ? count : 1;
  }

  int _getItemCount() {
    if (_posts == null) 
    return 0;
    else 
    return _posts.length;
  }

  void _initPosts() async {
    var posts = await DatabaseHelper.instance.getPosts(
      type: _booru.type,
      host: _booru.host,
      keyword: _keyword);
    if (posts == null || posts.isEmpty) {
     _fetchPostsList();
    } else {
      setState(() {
        _posts = posts;
      });
    }
  }

  Future<int> _fetchPostsList() async {
    String scheme = _booru.scheme;
    String host = _booru.host;
    var params = <String, dynamic>{
      'tags': _keyword,
      'limit': _limit,
      'page': _page
    };
    List<PostBase> posts = [];
    if (_booru.type == BooruType.danbooru) {
      posts = await DanApi.instance.getPosts(scheme, host, params);
    } else if (_booru.type == BooruType.moebooru) {
      posts = await MoeApi.instance.getPosts(scheme, host, params);
    } else if (_booru.type == BooruType.danbooru_one) {
      posts = await DanOneApi.instance.getPosts(scheme, host, params);
    }
    if (posts != null && posts.isNotEmpty) {
      if (_page == 1) {
        await DatabaseHelper.instance.deletePosts(_booru.type, _booru.host, _keyword);
      }
      await DatabaseHelper.instance.insertPosts(posts); 
    }
    if (posts == null) {
      setState(() {
        _loadingStatus = LoadingStatus.failed;
      });
      _lastResponseSize = 0;
      if (_page == 1) {
        setState(() {
          _posts = [];
        });
      }
    } else {
      _loadingStatus = LoadingStatus.idle;
      _lastResponseSize = posts.length;
      if (_page != 1) {
        setState(() {
          _posts.addAll(posts);
        });
      } else {
        setState(() {
          _posts = posts;
        });
      }
    }
    return _lastResponseSize;
  }

  @override
  void onActiveBooruChanged(int uid) async {
    _booru = await DatabaseHelper.instance.getBooruByUid(uid);
    Timer.periodic(Duration(milliseconds: 210), (timer) {  
      timer.cancel();
      _initPosts();
    });
  }

  @override
  LoadingStatus getLoadingStatus() => _loadingStatus;

  @override
  ScrollController getScrollController() => _scrollController;

  @override
  void loadMoreData() {
    setState(() {
      _loadingStatus = LoadingStatus.loading;
    });
    _page += 1;
    _fetchPostsList();
  }

  @override
  Future<void> refreshData() async {
    setState(() {
      _loadingStatus = LoadingStatus.refreshing;
    });
    _page = 1;
    await _fetchPostsList();
  }
}