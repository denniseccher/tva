import 'package:json_annotation/json_annotation.dart';

part 'api.course.class.g.dart';

@JsonSerializable()
class ApiCourse{
  final String? id;
  final String name;
  final String location;
  final String? colorHex;

  ApiCourse({required this.id, required this.name, required this.location, required this.colorHex});

  factory ApiCourse.fromJson(Map<String, dynamic> json) => _$ApiCourseFromJson(json);
  Map<String, dynamic> toJson() => _$ApiCourseToJson(this);
}