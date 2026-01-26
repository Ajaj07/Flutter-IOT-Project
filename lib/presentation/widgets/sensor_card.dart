import 'package:flutter/material.dart';

class SensorCard extends StatelessWidget {
  final String title;
  final double value;
  final String unit;
  final IconData icon;
  final Color color;
  final double? threshold;
  final bool isEnabled;

  const SensorCard({
    Key? key,
    required this.title,
    required this.value,
    required this.unit,
    required this.icon,
    required this.color,
    this.threshold,
    this.isEnabled = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isExceeded = threshold != null && value > threshold!;
    
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
                    color: color.withAlpha(26),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: color, size: 24),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            value.toStringAsFixed(1),
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            unit,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            
            // Gauge visualization
            SizedBox(
              height: 8,
              width: double.infinity,
              child: CustomPaint(
                painter: GaugePainter(
                  value: value,
                  maxValue: title == 'Temperature' ? 50.0 : 100.0,
                  color: color,
                  threshold: threshold,
                ),
              ),
            ),
            const SizedBox(height: 8),
            
            if (threshold != null) ...[
              Row(
                children: [
                  Icon(
                    isExceeded ? Icons.warning : Icons.check_circle,
                    size: 16,
                    color: isExceeded ? Colors.orange : Colors.green,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Threshold: ${threshold!.toStringAsFixed(1)}$unit',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                  if (!isEnabled) ...[
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Text(
                        'DISABLED',
                        style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class GaugePainter extends CustomPainter {
  final double value;
  final double maxValue;
  final Color color;
  final double? threshold;

  GaugePainter({
    required this.value,
    required this.maxValue,
    required this.color,
    this.threshold,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey[300]!
      ..strokeWidth = size.height;

    // Background
    canvas.drawLine(Offset.zero, Offset(size.width, 0), paint);

    // Value indicator
    paint.color = color;
    final valueWidth = (value / maxValue) * size.width;
    canvas.drawLine(Offset.zero, Offset(valueWidth, 0), paint);

    // Threshold indicator
    if (threshold != null) {
      paint.color = Colors.orange;
      paint.strokeWidth = 2;
      final thresholdX = (threshold! / maxValue) * size.width;
      canvas.drawLine(
        Offset(thresholdX, -2),
        Offset(thresholdX, size.height + 2),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
} 