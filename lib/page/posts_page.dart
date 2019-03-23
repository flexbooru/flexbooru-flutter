import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flexbooru_flutter/model/post_base.dart';
import 'package:flexbooru_flutter/network/api/danbooru.dart';
import 'package:flexbooru_flutter/network/api/moebooru.dart';
import 'package:cached_network_image/cached_network_image.dart';


class PostsPage extends StatefulWidget {
  @override
  PostsPageState createState() => PostsPageState(); 
}

class PostsPageState extends State<PostsPage> {
  
  PostsPageState() : _posts = [];
  
  List<PostBase> _posts;

  @override
  void initState() {
    super.initState();
    _fetchPostsList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(4.0),
        child: StaggeredGridView.countBuilder(
          primary: false,
          crossAxisCount: 3,
          mainAxisSpacing: 0.0,
          crossAxisSpacing: 0.0,
          itemCount: _getItemCount(),
          itemBuilder: (context, index) => _Tile(_posts[index]),
          staggeredTileBuilder: (index) => StaggeredTile.fit(1),
        ),
      ),
    );
  }

  int _getItemCount() {
    if (_posts == null) 
    return 0;
    else 
    return _posts.length;
  }

  void _fetchPostsList() async {
    String scheme = 'https';
    String host = 'yande.re';
    var params = <String, dynamic>{
      'tags': 'mash_kyrielight',
      'limit': 40,
      'page': 1
    };
    var posts = await MoeApi.instance.getPosts(scheme, host, params);
    setState(() {
      _posts = posts;
    });
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
