import 'package:flutter/foundation.dart';
import '../../data/models/sensor_data.dart';
import '../../data/models/config_data.dart';
import '../../domain/repositories/sensor_repository.dart';
import '../../core/errors/exceptions.dart';
import 'dart:async';

class SensorProvider extends ChangeNotifier {
  final SensorRepository _repository;
  
  SensorProvider({required SensorRepository repository})
      : _repository = repository;

  SensorData? _currentData;
  bool _isLoading = false;
  String? _errorMessage;
  bool _isConnected = false;
  Timer? _dataTimer;
  Duration _updateInterval = const Duration(seconds: 5);
  final List<SensorData> _historicalData = [];

  // Getters
  SensorData? get currentData => _currentData;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isConnected => _isConnected;
  List<SensorData> get historicalData => List.unmodifiable(_historicalData);
  Duration get updateInterval => _updateInterval;

  // Public methods
  Future<void> initialize() async {
    await fetchSensorData();
    startAutoUpdate();
  }

  Future<void> fetchSensorData() async {
    try {
      _setLoading(true);
      _clearError();
      
      final data = await _repository.getSensorData();
      _currentData = data;
      _isConnected = true;
      
      // Add to historical data (keep last 100 readings)
      _historicalData.add(data);
      if (_historicalData.length > 100) {
        _historicalData.removeAt(0);
      }
      
    } catch (e) {
      _isConnected = false;
      if (e is NetworkException) {
        _setError('Connection failed: ${e.message}');
      } else {
        _setError('Error: ${e.toString()}');
      }
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> updateConfiguration(ConfigData config) async {
    try {
      _setLoading(true);
      _clearError();
      
      final success = await _repository.updateConfig(config);
      if (success) {
        // Update current data with new config
        if (_currentData != null) {
          _currentData = _currentData!.copyWith(
            tempThreshold: config.tempThreshold,
            humidityThreshold: config.humidityThreshold,
            tempControlEnabled: config.tempControlEnabled,
            humidityControlEnabled: config.humidityControlEnabled,
          );
        }
        await Future.delayed(const Duration(milliseconds: 500));
        await fetchSensorData();
      }
      return success;
    } catch (e) {
      _setError('Failed to update configuration: ${e.toString()}');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> toggleManualMode() async {
    if (_currentData == null) return false;
    
    try {
      _setLoading(true);
      _clearError();
      
      final success = await _repository.setManualControl(
        manualMode: !_currentData!.manualMode,
      );
      
      if (success) {
        await Future.delayed(const Duration(milliseconds: 500));
        await fetchSensorData();
      }
      return success;
    } catch (e) {
      _setError('Failed to toggle manual mode: ${e.toString()}');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> toggleRelay() async {
    if (_currentData == null || !_currentData!.manualMode) return false;
    
    try {
      _setLoading(true);
      _clearError();
      
      final success = await _repository.setManualControl(
        manualMode: true,
        relayState: !_currentData!.isRelayOn,
      );
      
      if (success) {
        await Future.delayed(const Duration(milliseconds: 500));
        await fetchSensorData();
      }
      return success;
    } catch (e) {
      _setError('Failed to toggle relay: ${e.toString()}');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  void setUpdateInterval(Duration interval) {
    _updateInterval = interval;
    _restartAutoUpdate();
  }

  void startAutoUpdate() {
    _dataTimer?.cancel();
    _dataTimer = Timer.periodic(_updateInterval, (_) => fetchSensorData());
  }

  void stopAutoUpdate() {
    _dataTimer?.cancel();
  }

  void _restartAutoUpdate() {
    stopAutoUpdate();
    startAutoUpdate();
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _errorMessage = error;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _dataTimer?.cancel();
    super.dispose();
  }
} 