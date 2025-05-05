// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api.shift.class.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ApiShift _$ApiShiftFromJson(Map<String, dynamic> json) => ApiShift(
  json['id'] as String,
  course:
      json['course'] == null
          ? null
          : Course.fromJson(json['course'] as Map<String, dynamic>),
  dtStart: DateTime.parse(json['dtStart'] as String),
  dtEnd: DateTime.parse(json['dtEnd'] as String),
  earning: (json['earning'] as num).toDouble(),
  uid: json['uid'] as String?,
);

Map<String, dynamic> _$ApiShiftToJson(ApiShift instance) => <String, dynamic>{
  'id': instance.id,
  'course': instance.course,
  'dtStart': instance.dtStart.toIso8601String(),
  'dtEnd': instance.dtEnd.toIso8601String(),
  'earning': instance.earning,
  'uid': instance.uid,
};
