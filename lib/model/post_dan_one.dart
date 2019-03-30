import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:flexbooru/helper/booru.dart';
import 'package:flexbooru/constants.dart';
import 'date_dan_one.dart';
import 'post_base.dart';

part 'post_dan_one.g.dart';

List<PostDanOne> getPostDanOneList({
  List<dynamic> list, 
  String scheme, 
  String host, 
  String keyword}) {
  
  List<PostDanOne> result = [];
  list?.forEach((item) {
    PostDanOne post = PostDanOne.fromJson(item);
    post.type = BooruHelper.index(BooruType.danbooru_one);
    post.postId = post.id;
    post.scheme = scheme;
    post.host = host;
    post.keyword = keyword;
    result.add(post);
  });
  return result;
}

@JsonSerializable(nullable: true)
class PostDanOne extends PostBase {

  @JsonKey(name: 'status')
  String status;

  @JsonKey(name: 'creator_id')
  int creatorId;

  @JsonKey(name: 'preview_width')
  int previewWidth;

  @JsonKey(name: 'source')
  String source;

  @JsonKey(name: 'author')
  String author;

  @JsonKey(name: 'width')
  int width;

  @JsonKey(name: 'score')
  int score;

  @JsonKey(name: 'preview_height')
  int previewHeight;

  @JsonKey(name: 'has_comments')
  bool hasComments;

  @JsonKey(name: 'sample_width')
  int sampleWidth;

  @JsonKey(name: 'has_children')
  bool hasChildren;

  @JsonKey(name: 'sample_url')
  String sampleUrl;

  @JsonKey(name: 'file_url')
  String fileUrl;

  @JsonKey(name: 'sample_height')
  int sampleHeight;

  @JsonKey(name: 'md5')
  String md5;

  @JsonKey(name: 'tags')
  String tags;

  @JsonKey(name: 'change')
  int change;

  @JsonKey(name: 'has_notes')
  bool hasNotes;

  @JsonKey(name: 'rating')
  String rating;

  @JsonKey(name: 'id')
  int id;

  @JsonKey(name: 'height')
  int height;

  @JsonKey(name: 'preview_url')
  String previewUrl;

  @JsonKey(name: 'file_size')
  int fileSize;

  @JsonKey(name: 'created_at')
  DateDan createdAt;

  PostDanOne(
    this.status,
    this.creatorId,
    this.previewWidth,
    this.source,
    this.author,
    this.width,
    this.score,
    this.previewHeight,
    this.hasComments,
    this.sampleWidth,
    this.hasChildren,
    this.sampleUrl,
    this.fileUrl,
    this.sampleHeight,
    this.md5,
    this.tags,
    this.change,
    this.hasNotes,
    this.rating,
    this.id,
    this.height,
    this.previewUrl,
    this.fileSize,
    this.createdAt,
  );

  factory PostDanOne.fromJson(Map<String, dynamic> srcJson) => _$PostDanOneFromJson(srcJson);

  Map<String, dynamic> toJson() => _$PostDanOneToJson(this);

  @override
  String getLargerUrl() => getSampleUrl();

  @override
  String getOriginUrl() {
    if (fileUrl == null || fileUrl.isEmpty) {
      return getLargerUrl();
    }
    return checkUrl(fileUrl);
  }

  @override
  int getPostHeight() => height;

  @override
  int getPostId() => id;

  @override
  String getPostRating() => rating;

  @override
  int getPostScore() => score;

  @override
  int getPostWidth() => width;

  @override
  String getPreviewUrl() => checkUrl(previewUrl);

  @override
  String getSampleUrl() {
    if(sampleUrl == null || sampleUrl.isEmpty) {
      return getPreviewUrl();
    }
    return checkUrl(sampleUrl);
  }

  @override
  String getCreatedDate() => DateFormat.yMMMMd("en_US").add_jm()
    .format(DateTime.fromMicrosecondsSinceEpoch(createdAt.s * 1000 * 1000));

  @override
  String getUpdatedDate() => DateFormat.yMMMMd("en_US").add_jm()
    .format(DateTime.fromMicrosecondsSinceEpoch(change * 1000 * 1000));

}