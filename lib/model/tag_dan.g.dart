// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tag_dan.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TagDan _$TagDanFromJson(Map<String, dynamic> json) {
  return TagDan(
      json['id'] as int,
      json['name'] as String,
      json['post_count'] as int,
      json['related_tags'] as String,
      json['related_tags_updated_at'] as String,
      json['category'] as int,
      json['created_at'] as String,
      json['updated_at'] as String,
      json['is_locked'] as bool);
}

Map<String, dynamic> _$TagDanToJson(TagDan instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'post_count': instance.postCount,
      'related_tags': instance.relatedTags,
      'related_tags_updated_at': instance.relatedTagsUpdatedAt,
      'category': instance.category,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
      'is_locked': instance.isLocked
    };
