// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'course.class.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Course _$CourseFromJson(Map<String, dynamic> json) => Course(
  id: json['id'] as String?,
  name: json['name'] as String,
  location: json['location'] as String,
  colorHex: json['colorHex'] as String?,
);

Map<String, dynamic> _$CourseToJson(Course instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'location': instance.location,
  'colorHex': instance.colorHex,
};
