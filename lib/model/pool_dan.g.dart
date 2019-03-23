// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pool_dan.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PoolDan _$PoolDanFromJson(Map<String, dynamic> json) {
  return PoolDan(
      json['id'] as int,
      json['name'] as String,
      json['created_at'] as String,
      json['updated_at'] as String,
      json['creator_id'] as int,
      json['description'] as String,
      json['is_active'] as bool,
      json['is_deleted'] as bool,
      (json['post_ids'] as List)?.map((e) => e as int)?.toList(),
      json['category'] as String,
      json['creator_name'] as String,
      json['post_count'] as int);
}

Map<String, dynamic> _$PoolDanToJson(PoolDan instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
      'creator_id': instance.creatorId,
      'description': instance.description,
      'is_active': instance.isActive,
      'is_deleted': instance.isDeleted,
      'post_ids': instance.postIds,
      'category': instance.category,
      'creator_name': instance.creatorName,
      'post_count': instance.postCount
    };
