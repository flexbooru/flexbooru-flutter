import 'package:json_annotation/json_annotation.dart';
import 'tag_base.dart';

part 'tag_moe.g.dart';

@JsonSerializable(nullable: true)
class TagMoe extends TagBase {

  @JsonKey(name: 'id')
  int id;

  @JsonKey(name: 'name')
  String name;

  @JsonKey(name: 'count')
  int count;

  @JsonKey(name: 'type')
  int type;

  @JsonKey(name: 'ambiguous')
  bool ambiguous;

  TagMoe(this.id,this.name,this.count,this.type,this.ambiguous,);

  factory TagMoe.fromJson(Map<String, dynamic> srcJson) => _$TagMoeFromJson(srcJson);

  Map<String, dynamic> toJson() => _$TagMoeToJson(this);

  @override
  int getTagId() => id;

  @override
  String getTagName() => name;
}