import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flexbooru_flutter/model/post_base.dart';
import 'package:flexbooru_flutter/network/api/danbooru.dart';
import 'package:flexbooru_flutter/network/api/moebooru.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flexbooru_flutter/helper/database.dart';
import 'package:flexbooru_flutter/helper/user.dart';
import 'package:flexbooru_flutter/helper/booru.dart';
import 'package:flexbooru_flutter/constants.dart';
import 'base_state.dart';

class PopularPage extends StatefulWidget {
  PopularPage(this._booru);
  final Booru _booru;
  @override
  PopularPageState createState() => PopularPageState(_booru); 
}

class PopularPageState extends BaseState<PopularPage> {
  PopularPageState(this._booru);
  Booru _booru;
  List<PostBase> _posts;
  String scale = SCALE_DAY;
  String period = PERIOD_DAY;
  
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
      body: SingleChildScrollView(
        child: _buildStaggeredGrid(context),
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
    String keyword;
    switch (_booru.type) {
      case BooruType.danbooru:
        keyword = scale;
        break;
      case BooruType.moebooru:
        keyword = period;
        break;
      default:
    }
    var posts = await DatabaseHelper.instance.getPosts(
      type: _booru.type,
      host: _booru.host,
      keyword: keyword);
      if (posts == null || posts.isEmpty) {
        _fetchPostsList();
      } else {
        setState(() {
          _posts = posts;
        });
      }
  }

  void _fetchPostsList() async {
    List<PostBase> posts = [];
    Map<String, dynamic> params = {};
    if (_booru.type == BooruType.danbooru) {
      params.addAll({
        SCALE_KEY: scale
      });
      posts = await DanApi.instance.getPopularPosts(_booru.scheme, _booru.host, params);
    } else if (_booru.type == BooruType.moebooru) {
      params.addAll({
        PERIOD_KEY: period
      });
      posts = await MoeApi.instance.getPopularPosts(_booru.scheme, _booru.host, params);
    }
    setState(() {
      _posts = posts;
    });
    if (posts != null && posts.isNotEmpty) {
      DatabaseHelper.instance.insertPosts(posts); 
    }
  }
  @override
  void onActiveBooruChanged(int uid) async {
    _booru = await DatabaseHelper.instance.getBooruByUid(uid);
    _initPosts();
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
                    placeholder: (context, url) => CircularProgressIndicator(),
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
