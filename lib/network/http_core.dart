import 'dart:convert';

import 'package:dio/dio.dart';

class HttpCore {
  
  Dio _dio;

  HttpCore._internal() {
    _dio = new Dio();
    _dio.options.connectTimeout = 5000;
    _dio.options.receiveTimeout = 10000;
    _dio.options.headers = {
      "User-Agent": "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/73.0.3683.75 Safari/537.36"
      };
  }

  static HttpCore instance = HttpCore._internal();

  factory HttpCore() => instance;
  
  static const String GET = "get";
  static const String POST = "post";

  void get(String url, Function callback,
  {Map<String, String> params, Function errorCallback}) {
    _request(url, callback, 
    method: GET, params: params, errorCallback: errorCallback);
  }
  void post(String url, Function callback,
  {Map<String, String> params, Function errorCallback}) {
    _request(url, callback, 
    method: POST, params: params, errorCallback: errorCallback);
  }

  void _request(String url, Function callback,
      {String method,
      Map<String, String> params,
      Function errorCallback}) async {
        String errorMsg = "";
        int statusCode;
        try {
          Response response;
          if (method == GET) {
            if (params != null && params.isNotEmpty) {
              StringBuffer sb = new StringBuffer("?");
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
          statusCode = response.statusCode;
          print(statusCode);
          if (statusCode < 200 || statusCode > 300) {
            errorMsg = "code: " + statusCode.toString();
            _handError(errorCallback, errorMsg);
            return;
          }
          if (callback != null) {
            List data = response.data;
            callback(data);
          }
      } catch (exception) {
            _handError(errorCallback, exception.toString());
      }
  }

  void _handError(Function errorCallBack, String errorMsg) {
    if (errorCallBack != null) {
      errorCallBack(errorMsg);
    }
  }
}
