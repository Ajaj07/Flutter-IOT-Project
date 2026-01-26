import 'package:flutter/material.dart';

class RelayControlCard extends StatelessWidget {
  final bool isRelayOn;
  final bool isManualMode;
  final VoidCallback onToggleMode;
  final VoidCallback onToggleRelay;
  final bool isLoading;

  const RelayControlCard({
    Key? key,
    required this.isRelayOn,
    required this.isManualMode,
    required this.onToggleMode,
    required this.onToggleRelay,
    this.isLoading = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.orange.withAlpha(26),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.power, color: Colors.orange, size: 24),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    'Relay Control',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // Relay Status
            Row(
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: isRelayOn ? Colors.green : Colors.red,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'Status: ${isRelayOn ? "ON" : "OFF"}',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: isRelayOn ? Colors.green : Colors.red,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            
            // Mode Status
            Row(
              children: [
                Icon(
                  isManualMode ? Icons.touch_app : Icons.auto_awesome,
                  size: 16,
                  color: isManualMode ? Colors.blue : Colors.green,
                ),
                const SizedBox(width: 8),
                Text(
                  'Mode: ${isManualMode ? "Manual" : "Automatic"}',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // Control Buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: isLoading ? null : onToggleMode,
                    icon: Icon(isManualMode ? Icons.auto_awesome : Icons.touch_app),
                    label: Text(isManualMode ? 'Auto Mode' : 'Manual Mode'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isManualMode ? Colors.green : Colors.blue,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: (isLoading || !isManualMode) ? null : onToggleRelay,
                    icon: Icon(isRelayOn ? Icons.power_off : Icons.power),
                    label: Text(isRelayOn ? 'Turn OFF' : 'Turn ON'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isRelayOn ? Colors.red : Colors.green,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            
            if (isLoading) ...[
              const SizedBox(height: 12),
              const Center(
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
} 