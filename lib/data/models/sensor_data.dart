import 'package:json_annotation/json_annotation.dart';

part 'sensor_data.g.dart';

@JsonSerializable()
class SensorData {
  final double temperature;
  final double humidity;
  final String relayState;
  final bool manualMode;
  final double tempThreshold;
  final double humidityThreshold;
  final bool tempControlEnabled;
  final bool humidityControlEnabled;
  final DateTime timestamp;

  const SensorData({
    required this.temperature,
    required this.humidity,
    required this.relayState,
    required this.manualMode,
    required this.tempThreshold,
    required this.humidityThreshold,
    required this.tempControlEnabled,
    required this.humidityControlEnabled,
    required this.timestamp,
  });

  factory SensorData.fromJson(Map<String, dynamic> json) => _$SensorDataFromJson(json);
  Map<String, dynamic> toJson() => _$SensorDataToJson(this);

  bool get isRelayOn => relayState == 'ON';
  
  SensorData copyWith({
    double? temperature,
    double? humidity,
    String? relayState,
    bool? manualMode,
    double? tempThreshold,
    double? humidityThreshold,
    bool? tempControlEnabled,
    bool? humidityControlEnabled,
    DateTime? timestamp,
  }) {
    return SensorData(
      temperature: temperature ?? this.temperature,
      humidity: humidity ?? this.humidity,
      relayState: relayState ?? this.relayState,
      manualMode: manualMode ?? this.manualMode,
      tempThreshold: tempThreshold ?? this.tempThreshold,
      humidityThreshold: humidityThreshold ?? this.humidityThreshold,
      tempControlEnabled: tempControlEnabled ?? this.tempControlEnabled,
      humidityControlEnabled: humidityControlEnabled ?? this.humidityControlEnabled,
      timestamp: timestamp ?? this.timestamp,
    );
  }
} 