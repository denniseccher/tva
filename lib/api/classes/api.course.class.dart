import 'package:firebase_auth/firebase_auth.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:miss_minutes/classes/course.class.dart';

part 'api.course.class.g.dart';

@JsonSerializable()
class ApiCourse{
  final String? id;
  final String name;
  final String location;
  final String? colorHex;
  final String? uid;

  ApiCourse({ required this.id, required this.name, required this.location, required this.colorHex, required this.uid });

  factory ApiCourse.fromMain(Course course) => ApiCourse(
    id: course.id,
    name: course.name,
    location: course.location,
    colorHex: course.colorHex,
    uid: FirebaseAuth.instance.currentUser?.uid
  );

  factory ApiCourse.fromJson(Map<String, dynamic> json) => _$ApiCourseFromJson(json);
  Map<String, dynamic> toJson() => _$ApiCourseToJson(this);

  ApiCourse copyWith({
    String? id,
    String? name,
    String? location,
    String? colorHex,
    String? uid,
  }) {
    return ApiCourse(
      // Usa il nuovo valore se fornito (diverso da null), altrimenti usa il valore corrente (this).
      // Questa è l'implementazione standard e più semplice.
      id: id ?? this.id,
      name: name ?? this.name,
      location: location ?? this.location,
      colorHex: colorHex ?? this.colorHex,
      uid: uid ?? this.uid,
    );
  }
}