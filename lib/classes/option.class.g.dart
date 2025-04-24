// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'option.class.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Option _$OptionFromJson(Map<String, dynamic> json) => Option(
  value: json['value'] as String?,
  label: json['label'] as String?,
  location: json['location'] as String?,
);

Map<String, dynamic> _$OptionToJson(Option instance) => <String, dynamic>{
  'value': instance.value,
  'label': instance.label,
  'location': instance.location,
};
