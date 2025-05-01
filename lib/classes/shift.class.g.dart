// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shift.class.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Shift _$ShiftFromJson(Map<String, dynamic> json) => Shift(
  json['id'] as String,
  option:
      json['option'] == null
          ? null
          : Option.fromJson(json['option'] as Map<String, dynamic>),
  dtStart: DateTime.parse(json['dtStart'] as String),
  dtEnd: DateTime.parse(json['dtEnd'] as String),
  earning: (json['earning'] as num).toDouble(),
  uid: json['uid'] as String,
);

Map<String, dynamic> _$ShiftToJson(Shift instance) => <String, dynamic>{
  'id': instance.id,
  'option': instance.option?.toJson(),
  'dtStart': instance.dtStart.toIso8601String(),
  'dtEnd': instance.dtEnd.toIso8601String(),
  'earning': instance.earning,
  'uid': instance.uid,
};
