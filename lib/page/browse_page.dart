import 'package:flutter/material.dart';
import 'package:flexbooru/helper/booru.dart';
import 'package:flexbooru/model/post_base.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flexbooru/helper/database.dart';
import 'package:photo_view/photo_view.dart';
import 'package:flexbooru/constants.dart' show webViewUserAgent;

class BrowsePage extends StatefulWidget {
  BrowsePage(this.type, this.host, this.keyword, this.initPosition, {Key key}) : super(key: key);
  final BooruType type;
  final String host;
  final String keyword;
  final int initPosition;
  @override
  State<StatefulWidget> createState() => _BrowerPageState();
}

class _BrowerPageState extends State<BrowsePage> {
  
  int _currentPageIndex;
  PageController _pageController;

  Future<List<PostBase>> _postsFuture;

  @override
  void initState() {
    super.initState();
    _currentPageIndex = widget.initPosition;
    _pageController = PageController(initialPage: widget.initPosition);
    _postsFuture = DatabaseHelper.instance.getPosts(
      type: widget.type, 
      host: widget.host, 
      keyword: widget.keyword,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: FutureBuilder(
        future: _postsFuture,
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return Center(child: CircularProgressIndicator());
            default:
              var posts = snapshot.data;
              if (posts != null) {
                return _buildPageView(context, posts);
              } else {
                return Center(child: Text('none posts'),);
              }
          }
        },
      ),
    );
  }

  Widget _buildPageView(BuildContext context, List<PostBase> posts) {
    return PageView.builder(
      controller: _pageController,
      itemCount: posts.length,
      itemBuilder: (context, index) {
        return Container(
          child: PhotoView(
            loadingChild: Center(
              child: CircularProgressIndicator(),
            ),
            imageProvider: CachedNetworkImageProvider(
              posts[index].getLargerUrl(),
              headers: {
                "User-Agent": webViewUserAgent
              }
            ),
          ),
        );
      },
    );
  }
}