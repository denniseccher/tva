import 'package:miss_minutes/api/classes/api.course.class.dart';

class Course{
  final String? id;
  final String name;
  final String location;
  final String? colorHex;

  Course({required this.id, required this.name, required this.location, required this.colorHex});

  factory Course.fromApi(ApiCourse apiCourse) => Course(
    id: apiCourse.id,
    name: apiCourse.name,
    location: apiCourse.location,
    colorHex: apiCourse.colorHex
  );
}