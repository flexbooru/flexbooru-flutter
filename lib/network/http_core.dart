import 'package:dio/dio.dart';
import 'package:flexbooru/constants.dart' show webViewUserAgent;

class HttpCore {
  
  Dio _dio;

  HttpCore._internal() {
    _dio = Dio();
    _dio.options.connectTimeout = 10000;
    _dio.options.receiveTimeout = 10000;
    _dio.options.headers = {
      "User-Agent": webViewUserAgent
      };
  }

  static HttpCore instance = HttpCore._internal();

  factory HttpCore() => instance;
  
  static const String GET = "get";
  static const String POST = "post";

  Future<Response> get(String url, {Map<String, dynamic> params}) =>
    _request(url, method: GET, params: params);
  
  Future<Response> post(String url, {Map<String, dynamic> params}) =>
    _request(url, method: POST, params: params);

  Future<Response> _request(String url, {String method, Map<String, dynamic> params}) async {
    Response response;
    if (method == GET) {
      if (params != null && params.isNotEmpty) {
        StringBuffer sb = StringBuffer("?");
        params.forEach((key, value) {
          sb.write("$key" + "=" + "$value" + "&");
        });
        String paramStr = sb.toString();
        paramStr = paramStr.substring(0, paramStr.length - 1);
        url += paramStr;
      }
      print(url);
      response = await _dio.get(url);
    } else if (method == POST) {
      if (params != null && params.isNotEmpty) {
        response = await _dio.post(url, data: params);
      } else {
        response = await _dio.post(url);
      }
    }
    return response;
  }
}
