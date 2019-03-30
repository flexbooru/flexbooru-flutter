// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tag_dan_one.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TagDanOne _$TagDanOneFromJson(Map<String, dynamic> json) {
  return TagDanOne(json['type'] as int, json['count'] as int,
      json['name'] as String, json['id'] as int, json['ambiguous'] as bool);
}

Map<String, dynamic> _$TagDanOneToJson(TagDanOne instance) => <String, dynamic>{
      'type': instance.type,
      'count': instance.count,
      'name': instance.name,
      'id': instance.id,
      'ambiguous': instance.ambiguous
    };
