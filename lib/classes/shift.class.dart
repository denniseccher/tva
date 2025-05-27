import 'package:json_annotation/json_annotation.dart';
import 'package:miss_minutes/api/classes/api.shift.class.dart';
import 'package:miss_minutes/classes/course.class.dart';

part 'shift.class.g.dart';

@JsonSerializable()
class Shift{
  final String id;
  final Course? course;
  final DateTime dtStart;
  final DateTime dtEnd;
  final double earning;
  final String uid;
  final String? description;

  Shift(this.id, { required this.course, required this.dtStart, required this.dtEnd, required this.earning, required this.uid, this.description });

  factory Shift.fromApi(ApiShift apiShift) => Shift(
    apiShift.id,
    course: apiShift.course,
    dtStart: apiShift.dtStart,
    dtEnd: apiShift.dtEnd,
    earning: apiShift.earning,
    uid: apiShift.uid ?? '',
    description: apiShift.description
  );

  factory Shift.fromJson(Map<String, dynamic> json) => _$ShiftFromJson(json);
  Map<String, dynamic> toJson() => _$ShiftToJson(this);
}

Map<Duration, double> prezzario = {
  Duration(minutes: 45): 12.0,
  Duration(hours: 1, minutes: 30): 20.0,
  // Aggiungi altri turni e prezzi qui
};