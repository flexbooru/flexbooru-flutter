import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flexbooru/model/post_base.dart';
import 'package:flexbooru/constants.dart' show webViewUserAgent;

class PostTile extends StatelessWidget {

  const PostTile(this.post);

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
                  aspectRatio: post.getPostWidth() / post.getPostHeight(),
                  child: Image(
                    fit: BoxFit.cover,
                    image: CachedNetworkImageProvider(
                      post.getPreviewUrl(),
                      headers: {
                        "User-Agent": webViewUserAgent
                      }
                    ),
                  ),
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
