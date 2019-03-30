import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart'; 
import 'date_dan_one.dart';
import 'pool_base.dart';

part 'pool_dan_one.g.dart';

List<PoolDanOne> getPoolDanOneList(List<dynamic> list) {
  List<PoolDanOne> result = [];
  list?.forEach((item) {
    result.add(PoolDanOne.fromJson(item));
  });
  return result;
}

@JsonSerializable()
  class PoolDanOne extends PoolBase {

  @JsonKey(name: 'user_id')
  int userId;

  @JsonKey(name: 'is_public')
  bool isPublic;

  @JsonKey(name: 'post_count')
  int postCount;

  @JsonKey(name: 'name')
  String name;

  @JsonKey(name: 'updated_at')
  DateDan updatedAt;

  @JsonKey(name: 'id')
  int id;

  @JsonKey(name: 'created_at')
  DateDan createdAt;

  PoolDanOne(this.userId,this.isPublic,this.postCount,this.name,this.updatedAt,this.id,this.createdAt,);

  factory PoolDanOne.fromJson(Map<String, dynamic> srcJson) => _$PoolDanOneFromJson(srcJson);

  Map<String, dynamic> toJson() => _$PoolDanOneToJson(this);

  @override
  int getCreatorId() => userId;

  @override
  String getCreatorName() => getPoolName();

  @override
  String getPoolDate() => DateFormat.yMMMMd("en_US").add_jm()
    .format(DateTime.fromMicrosecondsSinceEpoch(updatedAt.s * 1000 * 1000));

  @override
  String getPoolDescription() => '';

  @override
  int getPoolId() => id;

  @override
  String getPoolName() => name;

  @override
  int getPostCount() => postCount;

}