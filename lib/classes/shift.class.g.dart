// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shift.class.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Shift _$ShiftFromJson(Map<String, dynamic> json) => Shift(
  json['id'] as String,
  name: json['name'] as String,
  dtStart: DateTime.parse(json['dtStart'] as String),
  dtEnd: DateTime.parse(json['dtEnd'] as String),
  earning: (json['earning'] as num).toDouble(),
);

Map<String, dynamic> _$ShiftToJson(Shift instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'dtStart': instance.dtStart.toIso8601String(),
  'dtEnd': instance.dtEnd.toIso8601String(),
  'earning': instance.earning,
};
