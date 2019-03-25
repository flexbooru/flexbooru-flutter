import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flexbooru_flutter/model/post_base.dart';
import 'package:flexbooru_flutter/network/api/danbooru.dart';
import 'package:flexbooru_flutter/network/api/moebooru.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flexbooru_flutter/helper/database.dart';
import 'package:flexbooru_flutter/helper/user.dart';
import 'package:flexbooru_flutter/helper/booru.dart';

class PostsPage extends StatefulWidget {
  PostsPage(this._booru);
  final Booru _booru;
  @override
  PostsPageState createState() => PostsPageState(_booru); 
}

class PostsPageState extends State<PostsPage> {
  PostsPageState(this._booru);
  final Booru _booru;
  List<PostBase> _posts = [];

  @override
  void initState() {
    super.initState();
    if (_booru != null) {
      _fetchPostsList(); 
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

  void _fetchPostsList() async {
    String scheme = _booru.scheme;
    String host = _booru.host;
    var params = <String, dynamic>{
      'tags': '',
      'limit': 50,
      'page': 1
    };
    List<PostBase> posts = [];
    if (_booru.type == BooruType.danbooru) {
      posts = await DanApi.instance.getPosts(scheme, host, params);
    } else if (_booru.type == BooruType.moebooru) {
      posts = await MoeApi.instance.getPosts(scheme, host, params);
    }
    setState(() {
      _posts = posts;
    });
    if (posts != null && posts.isNotEmpty) {
      await DatabaseHelper.instance.insertPosts(posts); 
    }
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
