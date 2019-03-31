import 'package:flutter/material.dart';
import 'package:flexbooru/helper/booru.dart';
import 'package:flexbooru/model/post_base.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flexbooru/helper/database.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
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
    
    return FutureBuilder(
        future: _postsFuture,
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return Center(child: CircularProgressIndicator());
            default:
              var posts = snapshot.data;
              if (posts != null) {
                return _buildPhotoGallery(context, posts);
              } else {
                return Center(child: Text('none posts'),);
              }
          }
        },
      );
  }

  Widget _buildPhotoGallery(BuildContext context, List<PostBase> posts) {
    return PhotoViewGallery(
      backgroundDecoration: BoxDecoration(color: Colors.black),
      pageController: _pageController,
      scrollPhysics: const BouncingScrollPhysics(),
      pageOptions: posts.map<PhotoViewGalleryPageOptions>((post) {
        return PhotoViewGalleryPageOptions(
          imageProvider: CachedNetworkImageProvider(
            post.getLargerUrl(),
            headers: {
              "User-Agent": webViewUserAgent
            }
          ),
          minScale: PhotoViewComputedScale.contained,
          heroTag: posts[_currentPageIndex].getPostId() == post.getPostId() ? post.getPostId().toString() : "",
        );
      }).toList(),
      loadingChild: Center(
        child: CircularProgressIndicator(),
      ),
      onPageChanged: (int index) {
        setState(() {
          _currentPageIndex = index;
        });
      },
    );
  }
}