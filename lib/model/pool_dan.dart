import 'package:json_annotation/json_annotation.dart'; 
import 'pool_base.dart';
  
part 'pool_dan.g.dart';

const PATTERN_DAN = "yyyy-MM-dd'T'HH:mm:ss.sss";

@JsonSerializable(nullable: true)
class PoolDan extends PoolBase {

  @JsonKey(name: 'id')
  int id;

  @JsonKey(name: 'name')
  String name;

  @JsonKey(name: 'created_at')
  String createdAt;

  @JsonKey(name: 'updated_at')
  String updatedAt;

  @JsonKey(name: 'creator_id')
  int creatorId;

  @JsonKey(name: 'description')
  String description;

  @JsonKey(name: 'is_active')
  bool isActive;

  @JsonKey(name: 'is_deleted')
  bool isDeleted;

  @JsonKey(name: 'post_ids')
  List<int> postIds;

  @JsonKey(name: 'category')
  String category;

  @JsonKey(name: 'creator_name')
  String creatorName;

  @JsonKey(name: 'post_count')
  int postCount;

  PoolDan(this.id,this.name,this.createdAt,this.updatedAt,this.creatorId,this.description,this.isActive,this.isDeleted,this.postIds,this.category,this.creatorName,this.postCount,);

  factory PoolDan.fromJson(Map<String, dynamic> srcJson) => _$PoolDanFromJson(srcJson);

  Map<String, dynamic> toJson() => _$PoolDanToJson(this);

  @override
  int getCreatorId() => creatorId;

  @override
  String getCreatorName() => creatorName;

  @override
  String getPoolDate() {
    // TODO: implement getPoolDate
    return null;
  }

  @override
  String getPoolDescription() => description;

  @override
  int getPoolId() => id;

  @override
  String getPoolName() => name;

  @override
  int getPostCount() => postCount;

}