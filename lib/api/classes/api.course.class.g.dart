// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api.course.class.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ApiCourse _$ApiCourseFromJson(Map<String, dynamic> json) => ApiCourse(
  id: json['id'] as String?,
  name: json['name'] as String,
  location: json['location'] as String,
  colorHex: json['colorHex'] as String,
);

Map<String, dynamic> _$ApiCourseToJson(ApiCourse instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'location': instance.location,
  'colorHex': instance.colorHex,
};
