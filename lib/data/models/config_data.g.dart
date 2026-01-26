// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'config_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ConfigData _$ConfigDataFromJson(Map<String, dynamic> json) => ConfigData(
  tempThreshold: (json['tempThreshold'] as num).toDouble(),
  humidityThreshold: (json['humidityThreshold'] as num).toDouble(),
  tempControlEnabled: json['tempControlEnabled'] as bool,
  humidityControlEnabled: json['humidityControlEnabled'] as bool,
);

Map<String, dynamic> _$ConfigDataToJson(ConfigData instance) =>
    <String, dynamic>{
      'tempThreshold': instance.tempThreshold,
      'humidityThreshold': instance.humidityThreshold,
      'tempControlEnabled': instance.tempControlEnabled,
      'humidityControlEnabled': instance.humidityControlEnabled,
    };
