// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api.shift.class.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ApiShift _$ApiShiftFromJson(Map<String, dynamic> json) => ApiShift(
  json['id'] as String,
  name: json['name'] as String,
  dtStart: DateTime.parse(json['dtStart'] as String),
  dtEnd: DateTime.parse(json['dtEnd'] as String),
  earning: (json['earning'] as num).toDouble(),
  uid: json['uid'] as String?,
);

Map<String, dynamic> _$ApiShiftToJson(ApiShift instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'dtStart': instance.dtStart.toIso8601String(),
  'dtEnd': instance.dtEnd.toIso8601String(),
  'earning': instance.earning,
  'uid': instance.uid,
};
