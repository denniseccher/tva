import 'package:json_annotation/json_annotation.dart';
import 'package:miss_minutes/api/classes/api.shift.class.dart';
import 'package:miss_minutes/classes/option.class.dart';

part 'shift.class.g.dart';

@JsonSerializable()
class Shift{
  final String id;
  final Option? option;
  final DateTime dtStart;
  final DateTime dtEnd;
  final double earning;
  final String uid;

  Shift(this.id, {required this.option, required this.dtStart, required this.dtEnd, required this.earning, required this.uid});

  factory Shift.fromApi(ApiShift apiShift) => Shift(
    apiShift.id,
    option: apiShift.option,
    dtStart: apiShift.dtStart,
    dtEnd: apiShift.dtEnd,
    earning: apiShift.earning,
    uid: apiShift.uid ?? ''
  );
  factory Shift.fromJson(Map<String, dynamic> json) => _$ShiftFromJson(json);
  Map<String, dynamic> toJson() => _$ShiftToJson(this);
}

Map<Duration, double> prezzario = {
  Duration(minutes: 45): 12.0,
  Duration(hours: 1, minutes: 30): 20.0,
  // Aggiungi altri turni e prezzi qui
};