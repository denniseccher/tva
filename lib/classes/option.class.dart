import 'package:json_annotation/json_annotation.dart';
import 'package:miss_minutes/api/classes/api.option.class.dart';

part 'option.class.g.dart';

// dart run build_runner build
@JsonSerializable()
class Option{
  final String? value;
  final String? label;
  final String? location;

  Option({required this.value, required this.label, required this.location});

  factory Option.fromApi(ApiOption apiOption) => Option(value: apiOption.value, label: apiOption.label, location: apiOption.location);

  factory Option.fromJson(Map<String, dynamic> json) => _$OptionFromJson(json);
  Map<String, dynamic> toJson() => _$OptionToJson(this);
}