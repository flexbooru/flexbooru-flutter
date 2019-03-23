
enum BooruType { danbooru, moebooru, danbooru_one, gelbooru}

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
        type = BooruType.danbooru;
        break;
      case 3:
        type = BooruType.danbooru_one;
        break;
      case 4:
        type = BooruType.gelbooru;
        break;
    }
    return type;
  }
}