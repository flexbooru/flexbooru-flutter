import 'package:dio/dio.dart';
import 'package:flexbooru_flutter/model/post_dan.dart';
import 'package:flexbooru_flutter/network/http_core.dart';

class BaseUrlHelper {
  static String posts(String scheme, String host) {
    return "$scheme://$host/posts.json";
  }
}

class DanApi {

  DanApi._internal();
  
  static DanApi instance = DanApi._internal();
  factory DanApi() => instance;

  Future<List<PostDan>> getPosts(
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
        return getPostDanList(
          list: data, 
          scheme: scheme,
          host: host,
          keyword: params['tags']);
      } else return [];
    } else return [];
  }
}