// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sensor_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SensorData _$SensorDataFromJson(Map<String, dynamic> json) => SensorData(
  temperature: (json['temperature'] as num).toDouble(),
  humidity: (json['humidity'] as num).toDouble(),
  relayState: json['relayState'] as String,
  manualMode: json['manualMode'] as bool,
  tempThreshold: (json['tempThreshold'] as num).toDouble(),
  humidityThreshold: (json['humidityThreshold'] as num).toDouble(),
  tempControlEnabled: json['tempControlEnabled'] as bool,
  humidityControlEnabled: json['humidityControlEnabled'] as bool,
  timestamp: DateTime.parse(json['timestamp'] as String),
);

Map<String, dynamic> _$SensorDataToJson(SensorData instance) =>
    <String, dynamic>{
      'temperature': instance.temperature,
      'humidity': instance.humidity,
      'relayState': instance.relayState,
      'manualMode': instance.manualMode,
      'tempThreshold': instance.tempThreshold,
      'humidityThreshold': instance.humidityThreshold,
      'tempControlEnabled': instance.tempControlEnabled,
      'humidityControlEnabled': instance.humidityControlEnabled,
      'timestamp': instance.timestamp.toIso8601String(),
    };
