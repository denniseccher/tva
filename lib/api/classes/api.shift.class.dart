import 'package:json_annotation/json_annotation.dart';

part 'api.shift.class.g.dart';

@JsonSerializable()
class ApiShift{
  final String id;
  final String name;
  final DateTime dtStart;
  final DateTime dtEnd;
  final double earning;

  ApiShift(this.id, {required this.name, required this.dtStart, required this.dtEnd, required this.earning});

  factory ApiShift.fromJson(Map<String, dynamic> json) => _$ApiShiftFromJson(json);
  Map<String, dynamic> toJson() => _$ApiShiftToJson(this);
}

Map<Duration, double> prezzario = {
  Duration(minutes: 45): 12.0,
  Duration(hours: 1, minutes: 30): 20.0,
  // Aggiungi altri turni e prezzi qui
};