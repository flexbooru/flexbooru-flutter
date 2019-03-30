import 'package:flutter/foundation.dart';

enum BooruType { danbooru, moebooru, danbooru_one, gelbooru}

class Booru extends Object {
  Booru({
    this.uid, 
    @required this.type,
    @required this.name,
    @required this.scheme,
    @required this.host,
    @required this.hashSalt
    });
    
  int uid = -1;
  BooruType type = BooruType.danbooru;
  String name;
  String scheme = 'http';
  String host;
  String hashSalt; 
}

class BooruHelper {

  static int index(BooruType type) {
    int index = -1;
    switch (type) {
      case BooruType.danbooru:
        index = 0;
        break;
      case BooruType.moebooru:
        index = 1;
        break;
      case BooruType.danbooru_one:
        index = 2;
        break;
      case BooruType.gelbooru:
        index = 3;
        break;
    }
    return index;
  }

  static BooruType type(int index) {
    BooruType type = BooruType.danbooru;
    switch (index) {
      case 0:
        type = BooruType.danbooru;
        break;
      case 1:
        type = BooruType.moebooru;
        break;
      case 2:
        type = BooruType.danbooru_one;
        break;
      case 3:
        type = BooruType.gelbooru;
        break;
    }
    return type;
  }

  static String name(BooruType type) {
    String name = "";
    switch (type) {
      case BooruType.danbooru:
        name = "Danbooru";
        break;
      case BooruType.moebooru:
        name = "Moebooru";
        break;
      case BooruType.danbooru_one:
        name = "Danbooru 1.x";
        break;
      case BooruType.gelbooru:
        name = "Gelbooru";
        break;
    }
    return name;
  }
}