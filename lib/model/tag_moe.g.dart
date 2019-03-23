// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tag_moe.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TagMoe _$TagMoeFromJson(Map<String, dynamic> json) {
  return TagMoe(json['id'] as int, json['name'] as String, json['count'] as int,
      json['type'] as int, json['ambiguous'] as bool);
}

Map<String, dynamic> _$TagMoeToJson(TagMoe instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'count': instance.count,
      'type': instance.type,
      'ambiguous': instance.ambiguous
    };
