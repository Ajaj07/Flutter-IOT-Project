import '../../data/models/sensor_data.dart';
import '../../data/models/config_data.dart';

abstract class SensorRepository {
  Future<SensorData> getSensorData();
  Future<bool> updateConfig(ConfigData config);
  Future<bool> setManualControl({
    required bool manualMode,
    bool? relayState,
  });
  Stream<SensorData> getSensorDataStream(Duration interval);
} 