import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flexbooru_flutter/transparent_image.dart';
import 'package:flexbooru_flutter/model/post_base.dart';
import 'package:flexbooru_flutter/model/post_dan.dart';
import 'package:flexbooru_flutter/model/post_moe.dart';
import 'package:flexbooru_flutter/network/api/danbooru.dart';
import 'package:flexbooru_flutter/network/http_core.dart';
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
      body: StaggeredGridView.countBuilder(
        primary: false,
        crossAxisCount: 3,
        mainAxisSpacing: 2.0,
        crossAxisSpacing: 2.0,
        itemCount: _getItemCount(),
        itemBuilder: (context, index) => _Tile(_posts[index]),
        staggeredTileBuilder: (index) => StaggeredTile.fit(1),
      ),
    );
  }

  int _getItemCount() {
    if (_posts == null) 
    return 0;
    else 
    return _posts.length;
  }

  Future<Null> _fetchPostsList() async {
    var url = "https://yande.re/post.json";
    var params = {
      'limit': '20',
      'page': '1'
    };
    HttpCore.instance.get(url, (data){
      setState(() {
        _posts = getPostMoeList(data);
      });
      if (_posts != null && _posts.length > 0) {
        print('Date: ' + _posts[0].getCreatedDate());
      }
    }, params: params, errorCallback: (errorMsg){
      print('errorMsg: ' + errorMsg);
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
              //Center(child: CircularProgressIndicator()),
              Center(
                child: AspectRatio(
                  aspectRatio: post.getPostWidth()/post.getPostHeight(),
                  child: CachedNetworkImage(imageUrl: post.getPreviewUrl()),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Column(
              children: <Widget>[
                Text(
                  '#${post.getPostId()}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  '${post.getPostWidth()} x ${post.getPostHeight()}',
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
