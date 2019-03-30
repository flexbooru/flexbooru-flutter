import 'package:dio/dio.dart';
import 'package:flexbooru/model/post_dan_one.dart';
import 'package:flexbooru/model/pool_dan_one.dart';
import 'package:flexbooru/model/tag_dan_one.dart';
import 'package:flexbooru/network/http_core.dart';

class BaseUrlHelper {
  static String posts(String scheme, String host) {
    return "$scheme://$host/post/index.json";
  }
  static String popular(String scheme, String host, String scale) {
    return "$scheme://$host/post/popular_by_$scale.json";
  }
  static String pools(String scheme, String host) {
    return "$scheme://$host/pool/index.json";
  }
  static String tags(String scheme, String host) {
    return "$scheme://$host/tag/index.json";
  }
}

class DanOneApi {

  DanOneApi._internal();
  
  static DanOneApi instance = DanOneApi._internal();
  factory DanOneApi() => instance;

  Future<List<PostDanOne>> getPosts(
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
      return getPostDanOneList(
          list: response.data, 
          scheme: scheme,
          host: host,
          keyword: params['tags']);
    } else return null;
  }

  Future<List<PostDanOne>> getPopularPosts(
    String scheme,
    String host, 
    String scale,
    Map<String, dynamic> params) async {

    Response response;
    try {
      response = await HttpCore.instance.get(BaseUrlHelper.popular(scheme, host, scale), params: params);
    } catch (e) {
      print(e.toString());
    }
    if (response != null && response.statusCode >= 200 && response.statusCode < 300) {
      return getPostDanOneList(
          list: response.data, 
          scheme: scheme,
          host: host,
          keyword: scale);
    } else return null;
  }

  Future<List<PoolDanOne>> getPools(
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
        return getPoolDanOneList(response.data);
      } else return null;
  }

  Future<List<TagDanOne>> getTags(
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
        return getTagDanOneList(response.data);
      } else return null;
  }
}