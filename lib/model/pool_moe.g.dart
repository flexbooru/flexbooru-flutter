// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pool_moe.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PoolMoe _$PoolMoeFromJson(Map<String, dynamic> json) {
  return PoolMoe(
      json['id'] as int,
      json['name'] as String,
      json['created_at'] as String,
      json['updated_at'] as String,
      json['user_id'] as int,
      json['is_public'] as bool,
      json['post_count'] as int,
      json['description'] as String);
}

Map<String, dynamic> _$PoolMoeToJson(PoolMoe instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
      'user_id': instance.userId,
      'is_public': instance.isPublic,
      'post_count': instance.postCount,
      'description': instance.description
    };
