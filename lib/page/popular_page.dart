import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flexbooru/model/post_base.dart';
import 'package:flexbooru/network/api/danbooru.dart';
import 'package:flexbooru/network/api/moebooru.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flexbooru/helper/database.dart';
import 'package:flexbooru/helper/user.dart';
import 'package:flexbooru/helper/booru.dart';
import 'package:flexbooru/constants.dart';
import 'package:flexbooru/helper/settings.dart';
import 'base_state.dart';

class PopularPage extends StatefulWidget {
  PopularPage(this._booru);
  final Booru _booru;
  @override
  PopularPageState createState() => PopularPageState(_booru); 
}

class PopularPageState extends State<PopularPage> with ActiveBooruListener {
  PopularPageState(this._booru);
  Booru _booru;
  List<PostBase> _posts;
  String _scale = SCALE_DAY;
  String _period = PERIOD_DAY;
  String _keyword = SCALE_DAY;

  LoadingStatus _loadingStatus = LoadingStatus.idle;
  
  @override
  void initState() {
    super.initState();
    Settings.instance.registerActiveBooruListener(this);
    if (_booru != null) {
      _initPosts();
    }
  }

  @override
  void dispose() {
    super.dispose();
    Settings.instance.unregisterActiveBooruListener(this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: SingleChildScrollView(
          child: _buildStaggeredGrid(context),
        ),
      ),
    );
  }

  Widget _buildStaggeredGrid(BuildContext context) {
    return StaggeredGridView.countBuilder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      primary: false,
      crossAxisCount: _getCrossAxisCount(context),
      staggeredTileBuilder: (_) => StaggeredTile.fit(1),
      itemBuilder: (context, index) => _Tile(_posts[index]),
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
    switch (_booru.type) {
      case BooruType.danbooru:
        _keyword = _scale;
        break;
      case BooruType.moebooru:
        _keyword = _period;
        break;
      default:
    }
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

  Future<void> _fetchPostsList() async {
    List<PostBase> posts = [];
    Map<String, dynamic> params = {};
    params.addAll({
      SCALE_KEY: _scale,
      PERIOD_KEY: _period
    });
    if (_booru.type == BooruType.danbooru) {
      _keyword = _scale;
      posts = await DanApi.instance.getPopularPosts(_booru.scheme, _booru.host, params);
    } else if (_booru.type == BooruType.moebooru) {
      _keyword = _period;
      posts = await MoeApi.instance.getPopularPosts(_booru.scheme, _booru.host, params);
    }
    if (posts != null) {
      setState(() {
        _loadingStatus = LoadingStatus.idle;
      });
      await DatabaseHelper.instance.deletePosts(_booru.type, _booru.host, _keyword);
      await DatabaseHelper.instance.insertPosts(posts);
      setState(() {
        _posts = posts;
      });
    } else {
      setState(() {
        _loadingStatus = LoadingStatus.failed;
      });
    }
  }
  @override
  void onActiveBooruChanged(int uid) async {
    _booru = await DatabaseHelper.instance.getBooruByUid(uid);
    Timer.periodic(Duration(milliseconds: 220), (timer) {  
      timer.cancel();
      _initPosts();
    });
  }

  Future<void> _refreshData() async {
    setState(() {
      _loadingStatus = LoadingStatus.refreshing;
    });
    await _fetchPostsList();
  }
}

class _Tile extends StatelessWidget {

  const _Tile(this.post);

  final PostBase post;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: <Widget>[
          Stack(
            children: <Widget>[
              Container(
                child: AspectRatio(
                  aspectRatio: post.getPostWidth()/post.getPostHeight(),
                  child: CachedNetworkImage(
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Placeholder(color: Colors.grey[200],),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                    imageUrl: post.getPreviewUrl()),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Column(
                children: <Widget>[
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text('#${post.getPostId()}'),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                            '${post.getPostWidth()} x ${post.getPostHeight()}',
                            style: const TextStyle(color: Colors.grey),
                          ),
                  ),
                  
                ],
            ),
          )
        ],
      ),
    );
  }
}
