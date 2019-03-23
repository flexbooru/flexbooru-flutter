import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:flexbooru_flutter/helper/booru_helper.dart';
import 'package:flexbooru_flutter/constants.dart';
import 'post_base.dart';

part 'post_dan.g.dart';

List<PostDan> getPostDanList({
  List<dynamic> list, 
  String scheme, 
  String host, 
  String keyword}) {
  
  List<PostDan> result = [];
  list?.forEach((item) {
    PostDan post = PostDan.fromJson(item);
    post.type = BooruHelper.index(BooruType.danbooru);
    post.postId = post.id;
    post.scheme = scheme;
    post.host = host;
    post.keyword = keyword;
    result.add(post);
  });
  return result;
}

@JsonSerializable(nullable: true)
class PostDan extends PostBase {

  @JsonKey(name: 'id')
  int id;

  @JsonKey(name: 'created_at')
  String createdAt;

  @JsonKey(name: 'uploader_id')
  int uploaderId;

  @JsonKey(name: 'score')
  int score;

  @JsonKey(name: 'source')
  String source;

  @JsonKey(name: 'md5')
  String md5;

  @JsonKey(name: 'rating')
  String rating;

  @JsonKey(name: 'image_width')
  int imageWidth;

  @JsonKey(name: 'image_height')
  int imageHeight;

  @JsonKey(name: 'tag_string')
  String tagString;

  @JsonKey(name: 'is_note_locked')
  bool isNoteLocked;

  @JsonKey(name: 'fav_count')
  int favCount;

  @JsonKey(name: 'file_ext')
  String fileExt;

  @JsonKey(name: 'is_rating_locked')
  bool isRatingLocked;

  @JsonKey(name: 'parent_id')
  int parentId;

  @JsonKey(name: 'has_children')
  bool hasChildren;

  @JsonKey(name: 'tag_count_general')
  int tagCountGeneral;

  @JsonKey(name: 'tag_count_artist')
  int tagCountArtist;

  @JsonKey(name: 'tag_count_character')
  int tagCountCharacter;

  @JsonKey(name: 'tag_count_copyright')
  int tagCountCopyright;

  @JsonKey(name: 'file_size')
  int fileSize;

  @JsonKey(name: 'is_status_locked')
  bool isStatusLocked;

  @JsonKey(name: 'pool_string')
  String poolString;

  @JsonKey(name: 'up_score')
  int upScore;

  @JsonKey(name: 'down_score')
  int downScore;

  @JsonKey(name: 'is_pending')
  bool isPending;

  @JsonKey(name: 'is_flagged')
  bool isFlagged;

  @JsonKey(name: 'is_deleted')
  bool isDeleted;

  @JsonKey(name: 'tag_count')
  int tagCount;

  @JsonKey(name: 'updated_at')
  String updatedAt;

  @JsonKey(name: 'is_banned')
  bool isBanned;

  @JsonKey(name: 'pixiv_id')
  int pixivId;

  @JsonKey(name: 'has_active_children')
  bool hasActiveChildren;

  @JsonKey(name: 'bit_flags')
  int bitFlags;

  @JsonKey(name: 'tag_count_meta')
  int tagCountMeta;

  @JsonKey(name: 'uploader_name')
  String uploaderName;

  @JsonKey(name: 'has_large')
  bool hasLarge;

  @JsonKey(name: 'has_visible_children')
  bool hasVisibleChildren;

  @JsonKey(name: 'children_ids')
  String childrenIds;

  @JsonKey(name: 'is_favorited')
  bool isFavorited;

  @JsonKey(name: 'tag_string_general')
  String tagStringGeneral;

  @JsonKey(name: 'tag_string_character')
  String tagStringCharacter;

  @JsonKey(name: 'tag_string_copyright')
  String tagStringCopyright;

  @JsonKey(name: 'tag_string_artist')
  String tagStringArtist;

  @JsonKey(name: 'tag_string_meta')
  String tagStringMeta;

  @JsonKey(name: 'file_url')
  String fileUrl;

  @JsonKey(name: 'large_file_url')
  String largeFileUrl;

  @JsonKey(name: 'preview_file_url')
  String previewFileUrl;

  PostDan(
    this.id,
    this.createdAt,
    this.uploaderId,
    this.score,
    this.source,
    this.md5,
    this.rating,
    this.imageWidth,
    this.imageHeight,
    this.tagString,
    this.isNoteLocked,
    this.favCount,
    this.fileExt,
    this.isRatingLocked,
    this.parentId,
    this.hasChildren,
    this.tagCountGeneral,
    this.tagCountArtist,
    this.tagCountCharacter,
    this.tagCountCopyright,
    this.fileSize,
    this.isStatusLocked,
    this.poolString,
    this.upScore,
    this.downScore,
    this.isPending,
    this.isFlagged,
    this.isDeleted,
    this.tagCount,
    this.updatedAt,
    this.isBanned,
    this.pixivId,
    this.hasActiveChildren,
    this.bitFlags,
    this.tagCountMeta,
    this.uploaderName,
    this.hasLarge,
    this.hasVisibleChildren,
    this.childrenIds,
    this.isFavorited,
    this.tagStringGeneral,
    this.tagStringCharacter,
    this.tagStringCopyright,
    this.tagStringArtist,
    this.tagStringMeta,
    this.fileUrl,
    this.largeFileUrl,
    this.previewFileUrl);

  factory PostDan.fromJson(Map<String, dynamic> srcJson) => _$PostDanFromJson(srcJson);

  @override
  Map<String, dynamic> toJson() => _$PostDanToJson(this);

  @override
  int getPostId() {
    return id;
  }

  @override
  String getLargerUrl() {
    return getSampleUrl();
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
    return imageHeight;
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
    return imageWidth;
  }

  @override
  String getPreviewUrl() {
    return checkUrl(previewFileUrl);
  }

  @override
  String getSampleUrl() {
    if (largeFileUrl == null || largeFileUrl.isEmpty) {
      return getPreviewUrl();
    }
    return checkUrl(largeFileUrl);
  }

  @override
  String getCreatedDate() {
    return DateFormat.yMMMMd("en_US").add_jm().format(DateFormat(PATTERN_DATE_DAN).parse(createdAt));
  }

  @override
  String getUpdatedDate() {
    String date = updatedAt;
    if (date == null) {
      date = createdAt;
    }
    return DateFormat.yMMMMd("en_US").add_jm().format(DateFormat(PATTERN_DATE_DAN).parse(date));
  }
}