import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/network/api_client.dart';
import '../../core/errors/exceptions.dart';
import '../../domain/repositories/sensor_repository.dart';
import '../models/sensor_data.dart';
import '../models/config_data.dart';
import 'dart:convert';

class SensorRepositoryImpl implements SensorRepository {
  final ApiClient _apiClient;
  final SharedPreferences _prefs;
  final Connectivity _connectivity;

  SensorRepositoryImpl({
    required ApiClient apiClient,
    required SharedPreferences prefs,
    required Connectivity connectivity,
  })  : _apiClient = apiClient,
        _prefs = prefs,
        _connectivity = connectivity;

  @override
  Future<SensorData> getSensorData() async {
    try {
      final connectivityResult = await _connectivity.checkConnectivity();
      if (connectivityResult == ConnectivityResult.none) {
        return _getCachedSensorData();
      }

      final response = await _apiClient.post('/api/data', {});
      final sensorData = SensorData.fromJson({
        ...response,
        'timestamp': DateTime.now().toIso8601String(),
      });

      await _cacheSensorData(sensorData);
      return sensorData;
    } catch (e) {
      return _getCachedSensorData();
    }
  }

  @override
  Future<bool> updateConfig(ConfigData config) async {
    try {
      await _apiClient.post('/api/config', config.toJson());
      await _cacheConfig(config);
      return true;
    } catch (e) {
      throw NetworkException('Failed to update configuration: $e');
    }
  }

  @override
  Future<bool> setManualControl({
    required bool manualMode,
    bool? relayState,
  }) async {
    try {
      final body = <String, dynamic>{'manualMode': manualMode};
      if (relayState != null) {
        body['relayState'] = relayState;
      }
      
      await _apiClient.post('/api/manual', body);
      return true;
    } catch (e) {
      throw NetworkException('Failed to set manual control: $e');
    }
  }

  @override
  Stream<SensorData> getSensorDataStream(Duration interval) async* {
    while (true) {
      try {
        yield await getSensorData();
      } catch (e) {
        yield _getCachedSensorData();
      }
      await Future.delayed(interval);
    }
  }

  Future<void> _cacheSensorData(SensorData data) async {
    await _prefs.setString('cached_sensor_data', jsonEncode(data.toJson()));
  }

  SensorData _getCachedSensorData() {
    final cachedJson = _prefs.getString('cached_sensor_data');
    if (cachedJson != null) {
      final data = jsonDecode(cachedJson) as Map<String, dynamic>;
      return SensorData.fromJson(data);
    }
    
    return SensorData(
      temperature: 0.0,
      humidity: 0.0,
      relayState: 'OFF',
      manualMode: false,
      tempThreshold: 30.0,
      humidityThreshold: 60.0,
      tempControlEnabled: true,
      humidityControlEnabled: true,
      timestamp: DateTime.now(),
    );
  }

  Future<void> _cacheConfig(ConfigData config) async {
    await _prefs.setString('cached_config', jsonEncode(config.toJson()));
  }
} 