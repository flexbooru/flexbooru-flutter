

abstract class PostBase extends Object {
  int uid = 0;
  int type = 0;
  String scheme = 'http';
  String host = '';
  String keyword = '';

  String checkUrl(String url) {
    if (url.contains('\/')) {
      url = url.replaceAll('\/', '/');
    }
    if (url.startsWith('http')) {
      return url;
    } else if (url.startsWith('//')) {
      return '$scheme:$url';
    } else if (url.startsWith('/')) {
      return '$scheme://$host$url';
    } else {
      return url;
    }
  }

  int getPostId();
  int getPostWidth();
  int getPostHeight();
  int getPostScore();
  String getPostRating();
  String getPreviewUrl();
  String getSampleUrl();
  String getLargerUrl();
  String getOriginUrl();
  String getCreatedDate();
  String getUpdatedDate();
}