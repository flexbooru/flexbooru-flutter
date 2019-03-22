import 'package:flexbooru_flutter/model/post_dan.dart';
import 'package:flexbooru_flutter/network/http_core.dart';

class DanApi {

  DanApi._internal();
  
  static DanApi instance = DanApi._internal();
  factory DanApi() => instance;

  List<PostDan> getPosts(url, Map<String, String> params) {
    HttpCore.instance.get(url, (data) {
      List<PostDan> posts = getPostDanList(data);
      return posts;
    }, params: params, errorCallback: (errorMsg) {
      print("error:" + errorMsg);
      return null;
    });
  }
}