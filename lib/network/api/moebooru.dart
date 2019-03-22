import 'package:dio/dio.dart';
import 'package:flexbooru_flutter/model/post_moe.dart';
import 'package:flexbooru_flutter/network/http_core.dart';

class MoeApi {

  MoeApi._internal();
  
  static MoeApi instance = MoeApi._internal();
  factory MoeApi() => instance;

  Future<List<PostMoe>> getPosts(String url, Map<String, String> params) async {
    Response response;
    try {
      response = await HttpCore.instance.get(url, params: params);
    } catch (e) {
      print(e.toString());
    }
    if (response != null && response.statusCode >= 200 && response.statusCode < 300) {
      var data = response.data;
      if (data != null) {
        return getPostMoeList(data);
      } else return [];
    } else return [];
  }
}