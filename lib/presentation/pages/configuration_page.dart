import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/sensor_provider.dart';
import '../../data/models/config_data.dart';

class ConfigurationPage extends StatefulWidget {
  const ConfigurationPage({Key? key}) : super(key: key);

  @override
  State<ConfigurationPage> createState() => _ConfigurationPageState();
}

class _ConfigurationPageState extends State<ConfigurationPage> {
  late double _tempThreshold;
  late double _humidityThreshold;
  late bool _tempControlEnabled;
  late bool _humidityControlEnabled;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadCurrentConfig();
    });
  }

  void _loadCurrentConfig() {
    final provider = context.read<SensorProvider>();
    final currentData = provider.currentData;
    if (currentData != null) {
      setState(() {
        _tempThreshold = currentData.tempThreshold;
        _humidityThreshold = currentData.humidityThreshold;
        _tempControlEnabled = currentData.tempControlEnabled;
        _humidityControlEnabled = currentData.humidityControlEnabled;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.settings),
            SizedBox(width: 8),
            Text('Configuration'),
          ],
        ),
      ),
      body: Consumer<SensorProvider>(
        builder: (context, provider, child) {
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Temperature Configuration
                Card(
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.thermostat, color: Colors.red),
                            SizedBox(width: 8),
                            Text(
                              'Temperature Control',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        
                        // Temperature Threshold
                        Text(
                          'Temperature Threshold: ${_tempThreshold.toStringAsFixed(1)}°C',
                          style: const TextStyle(fontSize: 16),
                        ),
                        Slider(
                          value: _tempThreshold,
                          min: 15.0,
                          max: 40.0,
                          divisions: 50,
                          label: '${_tempThreshold.toStringAsFixed(1)}°C',
                          onChanged: (value) {
                            setState(() {
                              _tempThreshold = value;
                            });
                          },
                        ),
                        
                        // Temperature Control Toggle
                        SwitchListTile(
                          title: const Text('Enable Temperature Control'),
                          subtitle: const Text('Automatically control based on temperature'),
                          value: _tempControlEnabled,
                          onChanged: (value) {
                            setState(() {
                              _tempControlEnabled = value;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // Humidity Configuration
                Card(
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.water_drop, color: Colors.blue),
                            SizedBox(width: 8),
                            Text(
                              'Humidity Control',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        
                        // Humidity Threshold
                        Text(
                          'Humidity Threshold: ${_humidityThreshold.toStringAsFixed(1)}%',
                          style: const TextStyle(fontSize: 16),
                        ),
                        Slider(
                          value: _humidityThreshold,
                          min: 30.0,
                          max: 90.0,
                          divisions: 60,
                          label: '${_humidityThreshold.toStringAsFixed(1)}%',
                          onChanged: (value) {
                            setState(() {
                              _humidityThreshold = value;
                            });
                          },
                        ),
                        
                        // Humidity Control Toggle
                        SwitchListTile(
                          title: const Text('Enable Humidity Control'),
                          subtitle: const Text('Automatically control based on humidity'),
                          value: _humidityControlEnabled,
                          onChanged: (value) {
                            setState(() {
                              _humidityControlEnabled = value;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                
                const Spacer(),
                
                // Save Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: provider.isLoading
                        ? null
                        : () => _saveConfiguration(provider),
                    icon: provider.isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.save),
                    label: Text(provider.isLoading ? 'Saving...' : 'Save Configuration'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> _saveConfiguration(SensorProvider provider) async {
    final config = ConfigData(
      tempThreshold: _tempThreshold,
      humidityThreshold: _humidityThreshold,
      tempControlEnabled: _tempControlEnabled,
      humidityControlEnabled: _humidityControlEnabled,
    );

    final success = await provider.updateConfiguration(config);
    
    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Configuration saved successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to save configuration'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
} 