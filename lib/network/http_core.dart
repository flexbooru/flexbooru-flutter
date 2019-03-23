import 'package:dio/dio.dart';

class HttpCore {
  
  Dio _dio;

  HttpCore._internal() {
    _dio = Dio();
    _dio.options.connectTimeout = 10000;
    _dio.options.receiveTimeout = 10000;
    _dio.options.headers = {
      "User-Agent": "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/73.0.3683.75 Safari/537.36"
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
