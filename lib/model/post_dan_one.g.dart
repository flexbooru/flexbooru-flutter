// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_dan_one.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PostDanOne _$PostDanOneFromJson(Map<String, dynamic> json) {
  return PostDanOne(
      json['status'] as String,
      json['creator_id'] as int,
      json['preview_width'] as int,
      json['source'] as String,
      json['author'] as String,
      json['width'] as int,
      json['score'] as int,
      json['preview_height'] as int,
      json['has_comments'] as bool,
      json['sample_width'] as int,
      json['has_children'] as bool,
      json['sample_url'] as String,
      json['file_url'] as String,
      json['sample_height'] as int,
      json['md5'] as String,
      json['tags'] as String,
      json['change'] as int,
      json['has_notes'] as bool,
      json['rating'] as String,
      json['id'] as int,
      json['height'] as int,
      json['preview_url'] as String,
      json['file_size'] as int,
      json['created_at'] == null
          ? null
          : DateDan.fromJson(json['created_at'] as Map<String, dynamic>));
}

Map<String, dynamic> _$PostDanOneToJson(PostDanOne instance) =>
    <String, dynamic>{
      'status': instance.status,
      'creator_id': instance.creatorId,
      'preview_width': instance.previewWidth,
      'source': instance.source,
      'author': instance.author,
      'width': instance.width,
      'score': instance.score,
      'preview_height': instance.previewHeight,
      'has_comments': instance.hasComments,
      'sample_width': instance.sampleWidth,
      'has_children': instance.hasChildren,
      'sample_url': instance.sampleUrl,
      'file_url': instance.fileUrl,
      'sample_height': instance.sampleHeight,
      'md5': instance.md5,
      'tags': instance.tags,
      'change': instance.change,
      'has_notes': instance.hasNotes,
      'rating': instance.rating,
      'id': instance.id,
      'height': instance.height,
      'preview_url': instance.previewUrl,
      'file_size': instance.fileSize,
      'created_at': instance.createdAt
    };
