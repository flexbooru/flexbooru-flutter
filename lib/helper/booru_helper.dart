
enum BooruType { danbooru, moebooru, danbooru_one, gelbooru}

class BooruHelper {

  static int index(BooruType type) {
    switch (type) {
      case BooruType.danbooru:
        return 0;
      case BooruType.moebooru:
        return 1;
      case BooruType.danbooru_one:
        return 2;
      case BooruType.gelbooru:
        return 3;
    }
    return -1;
  }
}