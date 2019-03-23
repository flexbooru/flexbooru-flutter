import 'package:json_annotation/json_annotation.dart';
import 'pool_base.dart';
  
part 'pool_moe.g.dart';


@JsonSerializable(nullable: true)
class PoolMoe extends PoolBase {

  @JsonKey(name: 'id')
  int id;

  @JsonKey(name: 'name')
  String name;

  @JsonKey(name: 'created_at')
  String createdAt;

  @JsonKey(name: 'updated_at')
  String updatedAt;

  @JsonKey(name: 'user_id')
  int userId;

  @JsonKey(name: 'is_public')
  bool isPublic;

  @JsonKey(name: 'post_count')
  int postCount;

  @JsonKey(name: 'description')
  String description;

  PoolMoe(this.id,this.name,this.createdAt,this.updatedAt,this.userId,this.isPublic,this.postCount,this.description,);

  factory PoolMoe.fromJson(Map<String, dynamic> srcJson) => _$PoolMoeFromJson(srcJson);

  Map<String, dynamic> toJson() => _$PoolMoeToJson(this);

  @override
  int getCreatorId() {
    // TODO: implement getCreatorId
    return null;
  }

  @override
  String getCreatorName() {
    // TODO: implement getCreatorName
    return null;
  }

  @override
  String getPoolDate() {
    // TODO: implement getPoolDate
    return null;
  }

  @override
  String getPoolDescription() {
    // TODO: implement getPoolDescription
    return null;
  }

  @override
  int getPoolId() {
    // TODO: implement getPoolId
    return null;
  }

  @override
  String getPoolName() {
    // TODO: implement getPoolName
    return null;
  }

  @override
  int getPostCount() {
    // TODO: implement getPostCount
    return null;
  }

}