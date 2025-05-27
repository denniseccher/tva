import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:miss_minutes/api/classes/api.course.class.dart';

part 'course.class.g.dart';

@JsonSerializable()
class Course extends Equatable{
  final String? id;
  final String name;
  final String location;
  final String? colorHex;

  const Course({required this.id, required this.name, required this.location, required this.colorHex});

  factory Course.fromApi(ApiCourse apiCourse) => Course(
    id: apiCourse.id,
    name: apiCourse.name,
    location: apiCourse.location,
    colorHex: apiCourse.colorHex
  );
  
  factory Course.fromJson(Map<String, dynamic> json) => _$CourseFromJson(json);
  Map<String, dynamic> toJson() => _$CourseToJson(this);

  @override
  String toString() {
    return '''
id:       ${id ?? 'N/A'}
name:     $name
location: $location
colorHex: ${colorHex ?? 'N/A'}''';
  }
  
  @override
  List<Object?> get props => [id, name, location, colorHex];  
}