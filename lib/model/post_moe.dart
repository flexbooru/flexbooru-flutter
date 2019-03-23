import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart'; 
import 'package:flexbooru_flutter/helper/booru_helper.dart';
import 'post_base.dart';

part 'post_moe.g.dart';

List<PostMoe> getPostMoeList({
  List<dynamic> list, 
  String scheme, 
  String host, 
  String keyword}) {

  List<PostMoe> result = [];
  list?.forEach((item) {
    PostMoe post = PostMoe.fromJson(item);
    post.type = BooruHelper.index(BooruType.moebooru);
    post.postId = post.id;
    post.scheme = scheme;
    post.host = host;
    post.keyword = keyword;
    result.add(post);
  });
  return result;
}

@JsonSerializable()
class PostMoe extends PostBase {

  @JsonKey(name: 'id')
  int id;

  @JsonKey(name: 'tags')
  String tags;

  @JsonKey(name: 'created_at')
  int createdAt;

  @JsonKey(name: 'updated_at')
  int updatedAt;

  @JsonKey(name: 'creator_id')
  int creatorId;

  @JsonKey(name: 'author')
  String author;

  @JsonKey(name: 'change')
  int change;

  @JsonKey(name: 'source')
  String source;

  @JsonKey(name: 'score')
  int score;

  @JsonKey(name: 'md5')
  String md5;

  @JsonKey(name: 'file_size')
  int fileSize;

  @JsonKey(name: 'file_ext')
  String fileExt;

  @JsonKey(name: 'file_url')
  String fileUrl;

  @JsonKey(name: 'is_shown_in_index')
  bool isShownInIndex;

  @JsonKey(name: 'preview_url')
  String previewUrl;

  @JsonKey(name: 'preview_width')
  int previewWidth;

  @JsonKey(name: 'preview_height')
  int previewHeight;

  @JsonKey(name: 'actual_preview_width')
  int actualPreviewWidth;

  @JsonKey(name: 'actual_preview_height')
  int actualPreviewHeight;

  @JsonKey(name: 'sample_url')
  String sampleUrl;

  @JsonKey(name: 'sample_width')
  int sampleWidth;

  @JsonKey(name: 'sample_height')
  int sampleHeight;

  @JsonKey(name: 'sample_file_size')
  int sampleFileSize;

  @JsonKey(name: 'jpeg_url')
  String jpegUrl;

  @JsonKey(name: 'jpeg_width')
  int jpegWidth;

  @JsonKey(name: 'jpeg_height')
  int jpegHeight;

  @JsonKey(name: 'jpeg_file_size')
  int jpegFileSize;

  @JsonKey(name: 'rating')
  String rating;

  @JsonKey(name: 'is_rating_locked')
  bool isRatingLocked;

  @JsonKey(name: 'has_children')
  bool hasChildren;

  @JsonKey(name: 'status')
  String status;

  @JsonKey(name: 'is_pending')
  bool isPending;

  @JsonKey(name: 'width')
  int width;

  @JsonKey(name: 'height')
  int height;

  @JsonKey(name: 'is_held')
  bool isHeld;

  @JsonKey(name: 'is_note_locked')
  bool isNoteLocked;

  @JsonKey(name: 'last_noted_at')
  int lastNotedAt;

  @JsonKey(name: 'last_commented_at')
  int lastCommentedAt;

  PostMoe(this.id,this.tags,this.createdAt,this.updatedAt,this.creatorId,this.author,this.change,this.source,this.score,this.md5,this.fileSize,this.fileExt,this.fileUrl,this.isShownInIndex,this.previewUrl,this.previewWidth,this.previewHeight,this.actualPreviewWidth,this.actualPreviewHeight,this.sampleUrl,this.sampleWidth,this.sampleHeight,this.sampleFileSize,this.jpegUrl,this.jpegWidth,this.jpegHeight,this.jpegFileSize,this.rating,this.isRatingLocked,this.hasChildren,this.status,this.isPending,this.width,this.height,this.isHeld,this.isNoteLocked,this.lastNotedAt,this.lastCommentedAt,);

  factory PostMoe.fromJson(Map<String, dynamic> srcJson) => _$PostMoeFromJson(srcJson);

  Map<String, dynamic> toJson() => _$PostMoeToJson(this);

  @override
  int getPostId() {
    return id;
  }

  @override
  String getLargerUrl() {
    if (jpegUrl == null || jpegUrl.isEmpty) {
      return getSampleUrl();
    }
    return checkUrl(jpegUrl);
  }

  @override
  String getOriginUrl() {
    if (fileUrl == null || fileUrl.isEmpty) {
      return getLargerUrl();
    }
    return checkUrl(fileUrl);
  }

  @override
  int getPostHeight() {
    return height;
  }

  @override
  String getPostRating() {
    return rating;
  }

  @override
  int getPostScore() {
    return score;
  }

  @override
  int getPostWidth() {
    return width;
  }

  @override
  String getPreviewUrl() {
    return checkUrl(previewUrl);
  }

  @override
  String getSampleUrl() {
    if (sampleUrl == null || sampleUrl.isEmpty) {
      return getPreviewUrl();
    }
    return checkUrl(sampleUrl);
  }

  @override
  String getCreatedDate() {
    return DateFormat.yMMMMd("en_US").add_jm().format(DateTime.fromMicrosecondsSinceEpoch(createdAt * 1000 * 1000));
  }

  @override
  String getUpdatedDate() {
    int time = updatedAt;
    if (time == null) {
      time = createdAt;
    }
    return DateFormat.yMMMMd("en_US").add_jm().format(DateTime.fromMicrosecondsSinceEpoch(time * 1000 * 1000));
  }
}