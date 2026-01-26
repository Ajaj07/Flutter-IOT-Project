import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/sensor_provider.dart';

class ManualControlPage extends StatefulWidget {
  const ManualControlPage({Key? key}) : super(key: key);

  @override
  State<ManualControlPage> createState() => _ManualControlPageState();
}

class _ManualControlPageState extends State<ManualControlPage> {
  Duration _autoOffDuration = const Duration(minutes: 30);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.tune),
            SizedBox(width: 8),
            Text('Manual Control'),
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
                // Current Status Card
                Card(
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Current Status',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Container(
                              width: 12,
                              height: 12,
                              decoration: BoxDecoration(
                                color: provider.currentData?.isRelayOn == true 
                                    ? Colors.green 
                                    : Colors.red,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Relay: ${provider.currentData?.isRelayOn == true ? "ON" : "OFF"}',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: provider.currentData?.isRelayOn == true 
                                    ? Colors.green 
                                    : Colors.red,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(
                              provider.currentData?.manualMode == true 
                                  ? Icons.touch_app 
                                  : Icons.auto_awesome,
                              size: 16,
                              color: provider.currentData?.manualMode == true 
                                  ? Colors.blue 
                                  : Colors.green,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Mode: ${provider.currentData?.manualMode == true ? "Manual" : "Automatic"}',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // Manual Control Card
                Card(
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Manual Control',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        
                        // Relay Toggle
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: provider.isLoading 
                                    ? null 
                                    : () => _toggleRelay(provider),
                                icon: Icon(provider.currentData?.isRelayOn == true 
                                    ? Icons.power_off 
                                    : Icons.power),
                                label: Text(provider.currentData?.isRelayOn == true 
                                    ? 'Turn OFF' 
                                    : 'Turn ON'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: provider.currentData?.isRelayOn == true 
                                      ? Colors.red 
                                      : Colors.green,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                ),
                              ),
                            ),
                          ],
                        ),
                        
                        const SizedBox(height: 16),
                        
                        // Mode Toggle
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: provider.isLoading 
                                    ? null 
                                    : () => _toggleMode(provider),
                                icon: Icon(provider.currentData?.manualMode == true 
                                    ? Icons.auto_awesome 
                                    : Icons.touch_app),
                                label: Text(provider.currentData?.manualMode == true 
                                    ? 'Switch to Auto' 
                                    : 'Switch to Manual'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: provider.currentData?.manualMode == true 
                                      ? Colors.green 
                                      : Colors.blue,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // Timer Control Card
                Card(
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Timer Control',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        
                        // Auto-off Duration
                        Text(
                          'Auto-off Duration: ${_formatDuration(_autoOffDuration)}',
                          style: const TextStyle(fontSize: 16),
                        ),
                        Slider(
                          value: _autoOffDuration.inMinutes.toDouble(),
                          min: 5,
                          max: 120,
                          divisions: 23,
                          label: _formatDuration(_autoOffDuration),
                          onChanged: (value) {
                            setState(() {
                              _autoOffDuration = Duration(minutes: value.toInt());
                            });
                          },
                        ),
                        
                        const SizedBox(height: 16),
                        
                        // Timer Buttons
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: provider.isLoading 
                                    ? null 
                                    : () => _startTimer(provider),
                                icon: const Icon(Icons.timer),
                                label: const Text('Start Timer'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.orange,
                                  foregroundColor: Colors.white,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: provider.isLoading 
                                    ? null 
                                    : () => _stopTimer(provider),
                                icon: const Icon(Icons.stop),
                                label: const Text('Stop Timer'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.grey,
                                  foregroundColor: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                
                const Spacer(),
                
                // Loading Indicator
                if (provider.isLoading) ...[
                  const Center(
                    child: Column(
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 16),
                        Text('Processing...'),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  String _formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes % 60;
    
    if (hours > 0) {
      return '${hours}h ${minutes}m';
    } else {
      return '${minutes}m';
    }
  }

  Future<void> _toggleRelay(SensorProvider provider) async {
    final success = await provider.toggleRelay();
    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Relay turned ${provider.currentData?.isRelayOn == true ? "ON" : "OFF"}'),
          backgroundColor: Colors.green,
        ),
      );
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to toggle relay'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _toggleMode(SensorProvider provider) async {
    final success = await provider.toggleManualMode();
    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Switched to ${provider.currentData?.manualMode == true ? "Manual" : "Automatic"} mode'),
          backgroundColor: Colors.green,
        ),
      );
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to switch mode'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _startTimer(SensorProvider provider) async {
    // This would need to be implemented in the provider
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Timer started for ${_formatDuration(_autoOffDuration)}'),
        backgroundColor: Colors.orange,
      ),
    );
  }

  Future<void> _stopTimer(SensorProvider provider) async {
    // This would need to be implemented in the provider
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Timer stopped'),
        backgroundColor: Colors.grey,
      ),
    );
  }
} 