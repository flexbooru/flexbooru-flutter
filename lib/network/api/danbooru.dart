import 'package:dio/dio.dart';
import 'package:flexbooru_flutter/model/post_dan.dart';
import 'package:flexbooru_flutter/network/http_core.dart';

class DanApi {

  DanApi._internal();
  
  static DanApi instance = DanApi._internal();
  factory DanApi() => instance;

  Future<List<PostDan>> getPosts(String url, Map<String, String> params) async {
    Response response;
    try {
      response = await HttpCore.instance.get(url, params: params);
    } catch (e) {
      print(e.toString());
    }
    if (response != null && response.statusCode >= 200 && response.statusCode < 300) {
      var data = response.data;
      if (data != null) {
        return getPostDanList(data);
      } else return [];
    } else return [];
  }
}