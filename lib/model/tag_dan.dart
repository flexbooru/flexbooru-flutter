import 'package:json_annotation/json_annotation.dart';
import 'tag_base.dart';
  
part 'tag_dan.g.dart';

List<TagDan> getTagDanList(List<dynamic> list) {
  List<TagDan> result = [];
  list?.forEach((item) {
    result.add(TagDan.fromJson(item));
  });
  return result;
}

@JsonSerializable(nullable: true)
class TagDan extends TagBase {

  @JsonKey(name: 'id')
  int id;

  @JsonKey(name: 'name')
  String name;

  @JsonKey(name: 'post_count')
  int postCount;

  @JsonKey(name: 'related_tags')
  String relatedTags;

  @JsonKey(name: 'related_tags_updated_at')
  String relatedTagsUpdatedAt;

  @JsonKey(name: 'category')
  int category;

  @JsonKey(name: 'created_at')
  String createdAt;

  @JsonKey(name: 'updated_at')
  String updatedAt;

  @JsonKey(name: 'is_locked')
  bool isLocked;

  TagDan(this.id,this.name,this.postCount,this.relatedTags,this.relatedTagsUpdatedAt,this.category,this.createdAt,this.updatedAt,this.isLocked,);

  factory TagDan.fromJson(Map<String, dynamic> srcJson) => _$TagDanFromJson(srcJson);

  Map<String, dynamic> toJson() => _$TagDanToJson(this);

  @override
  int getTagId() => id;

  @override
  String getTagName() => name;
}