import 'package:dio/dio.dart';
import 'package:flexbooru_flutter/model/post_moe.dart';
import 'package:flexbooru_flutter/network/http_core.dart';

class BaseUrlHelper {
  static String posts(String scheme, String host) {
    return "$scheme://$host/post.json";
  }
}

class MoeApi {

  MoeApi._internal();
  
  static MoeApi instance = MoeApi._internal();
  factory MoeApi() => instance;

  Future<List<PostMoe>> getPosts(
    String scheme,
    String host, 
    Map<String, String> params) async {

    Response response;
    try {
      response = await HttpCore.instance.get(BaseUrlHelper.posts(scheme, host), params: params);
    } catch (e) {
      print(e.toString());
    }
    if (response != null && response.statusCode >= 200 && response.statusCode < 300) {
      var data = response.data;
      if (data != null) {
        return getPostMoeList(
          list: data, 
          scheme: scheme,
          host: host,
          keyword: params['tags']);
      } else return [];
    } else return [];
  }
}