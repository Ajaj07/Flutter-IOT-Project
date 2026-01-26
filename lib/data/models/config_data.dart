import 'package:json_annotation/json_annotation.dart';

part 'config_data.g.dart';

@JsonSerializable()
class ConfigData {
  final double tempThreshold;
  final double humidityThreshold;
  final bool tempControlEnabled;
  final bool humidityControlEnabled;

  const ConfigData({
    required this.tempThreshold,
    required this.humidityThreshold,
    required this.tempControlEnabled,
    required this.humidityControlEnabled,
  });

  factory ConfigData.fromJson(Map<String, dynamic> json) => _$ConfigDataFromJson(json);
  Map<String, dynamic> toJson() => _$ConfigDataToJson(this);
} 