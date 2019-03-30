import 'package:json_annotation/json_annotation.dart'; 
import 'tag_base.dart';
part 'tag_dan_one.g.dart';

List<TagDanOne> getTagDanOneList(List<dynamic> list) {
  List<TagDanOne> result = [];
  list?.forEach((item) {
    result.add(TagDanOne.fromJson(item));
  });
  return result;
}

@JsonSerializable()
  class TagDanOne extends TagBase {

  @JsonKey(name: 'type')
  int type;

  @JsonKey(name: 'count')
  int count;

  @JsonKey(name: 'name')
  String name;

  @JsonKey(name: 'id')
  int id;

  @JsonKey(name: 'ambiguous')
  bool ambiguous;

  TagDanOne(this.type,this.count,this.name,this.id,this.ambiguous,);

  factory TagDanOne.fromJson(Map<String, dynamic> srcJson) => _$TagDanOneFromJson(srcJson);

  Map<String, dynamic> toJson() => _$TagDanOneToJson(this);

  @override
  int getTagId() => id;

  @override
  String getTagName() => name;

}