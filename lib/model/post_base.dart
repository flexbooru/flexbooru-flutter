import 'package:json_annotation/json_annotation.dart';

abstract class PostBase extends Object {
  @JsonKey(ignore: true)
  int uid = 0;
  @JsonKey(ignore: true)
  int type = 0;
  @JsonKey(ignore: true)
  int postId = 0;
  @JsonKey(ignore: true)
  String scheme = 'http';
  @JsonKey(ignore: true)
  String host = '';
  @JsonKey(ignore: true)
  String keyword = '';

  String checkUrl(String url) {
    if (url.contains('\\/')) {
      url = url.replaceAll('\\/', '/');
    }
    if (url.startsWith('http')) {
      return url;
    } else if (url.startsWith('//')) {
      return '$scheme:$url';
    } else if (url.startsWith('/')) {
      return '$scheme://$host$url';
    } else {
      return url;
    }
  }

  Map<String, dynamic> toJson();

  int getPostId();
  int getPostWidth();
  int getPostHeight();
  int getPostScore();
  String getPostRating();
  String getPreviewUrl();
  String getSampleUrl();
  String getLargerUrl();
  String getOriginUrl();
  String getCreatedDate();
  String getUpdatedDate();
}