import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:flexbooru/constants.dart';
import 'pool_base.dart';
  
part 'pool_moe.g.dart';

List<PoolMoe> getPoolMoeList(List<dynamic> list) {
  List<PoolMoe> result = [];
  list?.forEach((item) {
    result.add(PoolMoe.fromJson(item));
  });
  return result;
}

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
  int getCreatorId() => userId;

  @override
  String getCreatorName() => getPoolName();

  @override
  String getPoolDate() {
    String date = updatedAt;
    if (updatedAt.contains('T')) {
      date = DateFormat.yMMMMd("en_US").add_jm().format(DateFormat(PATTERN_DATE_MOE_T).parse(updatedAt));
    } else if (updatedAt.contains(' ')) {
      date = DateFormat.yMMMMd("en_US").add_jm().format(DateFormat(PATTERN_DATE_MOE).parse(updatedAt));
    }
    return date;
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