import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flexbooru/model/post_base.dart';
import 'package:flexbooru/constants.dart' show webViewUserAgent;
import 'package:flexbooru/page/browse_page.dart';
import 'package:flexbooru/helper/booru.dart';

class PostTile extends StatelessWidget {

  const PostTile(this.post, this.index);

  final PostBase post;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              AspectRatio(
                aspectRatio: post.getPostWidth() / post.getPostHeight(),
                child: Hero(
                  child: Image(
                    fit: BoxFit.cover,
                    image: CachedNetworkImageProvider(
                      post.getPreviewUrl(),
                      headers: {
                        "User-Agent": webViewUserAgent
                      }
                    ),
                  ),
                  tag: post.getPostId().toString(),
                  placeholderBuilder: (context, widget) => Placeholder(color: Colors.grey[300]),
                ),
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
              ),
            ],
          ),
          Positioned.fill(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => BrowsePage(
                        BooruHelper.type(post.type), post.host, post.keyword, index)
                    )
                  );
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}
