import 'package:json_annotation/json_annotation.dart';
import 'package:miss_minutes/classes/course.class.dart';
import 'package:miss_minutes/classes/option.class.dart';

part 'api.shift.class.g.dart';

@JsonSerializable()
class ApiShift{
  final String id;
  final Option? option;
  final Course? course;
  final DateTime dtStart;
  final DateTime dtEnd;
  final double earning;
  final String? uid;

  ApiShift(this.id, { this.option, required this.course, required this.dtStart, required this.dtEnd, required this.earning, required this.uid });

  factory ApiShift.fromJson(Map<String, dynamic> json) => _$ApiShiftFromJson(json);
  Map<String, dynamic> toJson() => _$ApiShiftToJson(this);
}

Map<Duration, double> prezzario = {
  Duration(minutes: 45): 12.0,
  Duration(hours: 1, minutes: 30): 20.0,
  // Aggiungi altri turni e prezzi qui
};