import 'package:json_annotation/json_annotation.dart';

part 'date_dan_one.g.dart';

@JsonSerializable(nullable: true)
class DateDan extends Object {

  @JsonKey(name: 'json_class')
  String jsonClass;

  @JsonKey(name: 'n')
  int n;

  @JsonKey(name: 's')
  int s;

  DateDan(
    this.jsonClass,
    this.n,
    this.s,
  );

  factory DateDan.fromJson(Map<String, dynamic> srcJson) => _$DateDanFromJson(srcJson);

  Map<String, dynamic> toJson() => _$DateDanToJson(this);

}