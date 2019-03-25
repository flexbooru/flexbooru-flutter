import 'package:dio/dio.dart';
import 'package:flexbooru_flutter/model/post_moe.dart';
import 'package:flexbooru_flutter/model/pool_moe.dart';
import 'package:flexbooru_flutter/model/tag_moe.dart';
import 'package:flexbooru_flutter/network/http_core.dart';
import 'package:flexbooru_flutter/constants.dart';

class BaseUrlHelper {
  static String posts(String scheme, String host) {
    return "$scheme://$host/post.json";
  }
  static String popular(String scheme, String host) {
    return "$scheme://$host/post/popular_recent.json";
  }
  static String pools(String scheme, String host) {
    return "$scheme://$host/pool.json";
  }
  static String tags(String scheme, String host) {
    return "$scheme://$host/tag.json";
  }
}

class MoeApi {

  MoeApi._internal();
  
  static MoeApi instance = MoeApi._internal();
  factory MoeApi() => instance;

  Future<List<PostMoe>> getPosts(
    String scheme,
    String host, 
    Map<String, dynamic> params) async {

    Response response;
    try {
      response = await HttpCore.instance.get(BaseUrlHelper.posts(scheme, host), params: params);
    } catch (e) {
      print(e.toString());
    }
    if (response != null && response.statusCode >= 200 && response.statusCode < 300) {
      return getPostMoeList(
          list: response.data, 
          scheme: scheme,
          host: host,
          keyword: params['tags']);
    } else return [];
  }

  Future<List<PostMoe>> getPopularPosts(
    String scheme,
    String host, 
    Map<String, dynamic> params) async {

    Response response;
    try {
      response = await HttpCore.instance.get(BaseUrlHelper.popular(scheme, host), params: params);
    } catch (e) {
      print(e.toString());
    }
    if (response != null && response.statusCode >= 200 && response.statusCode < 300) {
      return getPostMoeList(
          list: response.data, 
          scheme: scheme,
          host: host,
          keyword: params[PERIOD_KEY]);
    } else return [];
  }

  Future<List<PoolMoe>> getPools(
    String scheme,
    String host, 
    Map<String, dynamic> params) async {

      Response response;
      try {
        response = await HttpCore.instance.get(BaseUrlHelper.pools(scheme, host), params: params);
      } catch (e) {
        print(e.toString());
      }
      if (response != null && response.statusCode >= 200 && response.statusCode < 300) {
        return getPoolMoeList(response.data);
      } else return [];
  }

  Future<List<TagMoe>> getTags(
    String scheme,
    String host, 
    Map<String, dynamic> params) async {

      Response response;
      try {
        response = await HttpCore.instance.get(BaseUrlHelper.tags(scheme, host), params: params);
      } catch (e) {
        print(e.toString());
      }
      if (response != null && response.statusCode >= 200 && response.statusCode < 300) {
        return getTagMoeList(response.data);
      } else return [];
  }
}