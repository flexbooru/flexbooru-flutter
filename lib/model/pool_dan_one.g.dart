// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pool_dan_one.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PoolDanOne _$PoolDanOneFromJson(Map<String, dynamic> json) {
  return PoolDanOne(
      json['user_id'] as int,
      json['is_public'] as bool,
      json['post_count'] as int,
      json['name'] as String,
      json['updated_at'] == null
          ? null
          : DateDan.fromJson(json['updated_at'] as Map<String, dynamic>),
      json['id'] as int,
      json['created_at'] == null
          ? null
          : DateDan.fromJson(json['created_at'] as Map<String, dynamic>));
}

Map<String, dynamic> _$PoolDanOneToJson(PoolDanOne instance) =>
    <String, dynamic>{
      'user_id': instance.userId,
      'is_public': instance.isPublic,
      'post_count': instance.postCount,
      'name': instance.name,
      'updated_at': instance.updatedAt,
      'id': instance.id,
      'created_at': instance.createdAt
    };
