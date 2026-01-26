import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../providers/sensor_provider.dart';
import 'package:intl/intl.dart';

class ChartsPage extends StatefulWidget {
  const ChartsPage({Key? key}) : super(key: key);

  @override
  State<ChartsPage> createState() => _ChartsPageState();
}

class _ChartsPageState extends State<ChartsPage> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.analytics),
            SizedBox(width: 8),
            Text('Sensor Charts'),
          ],
        ),
      ),
      body: Consumer<SensorProvider>(
        builder: (context, provider, child) {
          final historicalData = provider.historicalData;
          
          if (historicalData.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.analytics_outlined, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'No data available',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Start monitoring to see charts',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          return Column(
            children: [
              // Tab Bar
              Container(
                margin: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: _buildTabButton('Temperature', 0, Icons.thermostat, Colors.red),
                    ),
                    Expanded(
                      child: _buildTabButton('Humidity', 1, Icons.water_drop, Colors.blue),
                    ),
                  ],
                ),
              ),
              
              // Chart
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: _selectedIndex == 0
                      ? _buildTemperatureChart(historicalData)
                      : _buildHumidityChart(historicalData),
                ),
              ),
              
              // Statistics
              Container(
                padding: const EdgeInsets.all(16),
                child: _buildStatistics(historicalData),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildTabButton(String title, int index, IconData icon, Color color) {
    final isSelected = _selectedIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedIndex = index),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? color : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: isSelected ? Colors.white : color, size: 20),
            const SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black87,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTemperatureChart(List<dynamic> data) {
    if (data.length < 2) {
      return const Center(
        child: Text('Not enough data to draw a chart. More data is needed.'),
      );
    }
    return LineChart(
      LineChartData(
        gridData: const FlGridData(show: true),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
              getTitlesWidget: (value, meta) {
                if (value % 10 == 0) {
                  return Text('${value.toInt()}°', style: const TextStyle(fontSize: 10));
                }
                return const Text('');
              },
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 22,
              getTitlesWidget: (value, meta) {
                final date = DateTime.fromMillisecondsSinceEpoch(value.toInt());
                return SideTitleWidget(
                  axisSide: meta.axisSide,
                  child: Text(
                    DateFormat('HH:mm').format(date),
                    style: const TextStyle(fontSize: 10),
                  ),
                );
              },
              interval: (data.last.timestamp - data.first.timestamp) / 4,
            ),
          ),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(show: true),
        lineBarsData: [
          LineChartBarData(
            spots: data.map((d) {
              return FlSpot((d.timestamp as int).toDouble(), d.temperature as double);
            }).toList(),
            isCurved: true,
            color: Colors.red,
            barWidth: 3,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              color: Colors.red.withAlpha(50),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHumidityChart(List<dynamic> data) {
    if (data.length < 2) {
      return const Center(
        child: Text('Not enough data to draw a chart. More data is needed.'),
      );
    }
    return LineChart(
      LineChartData(
        gridData: const FlGridData(show: true),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
              getTitlesWidget: (value, meta) {
                if (value % 20 == 0) {
                  return Text('${value.toInt()}%', style: const TextStyle(fontSize: 10));
                }
                return const Text('');
              },
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 22,
              getTitlesWidget: (value, meta) {
                final date = DateTime.fromMillisecondsSinceEpoch(value.toInt());
                return SideTitleWidget(
                  axisSide: meta.axisSide,
                  child: Text(
                    DateFormat('HH:mm').format(date),
                    style: const TextStyle(fontSize: 10),
                  ),
                );
              },
               interval: (data.last.timestamp - data.first.timestamp) / 4,
            ),
          ),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(show: true),
        lineBarsData: [
          LineChartBarData(
            spots: data.map((d) {
               return FlSpot((d.timestamp as int).toDouble(), d.humidity as double);
            }).toList(),
            isCurved: true,
            color: Colors.blue,
            barWidth: 3,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              color: Colors.blue.withAlpha(50),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatistics(List<dynamic> data) {
    if (data.isEmpty) return const SizedBox.shrink();

    final temperatures = data.map((d) => d.temperature as double).toList();
    final humidities = data.map((d) => d.humidity as double).toList();

    final tempStats = _calculateStats(temperatures);
    final humidityStats = _calculateStats(humidities);

    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Statistics',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    'Temperature',
                    tempStats,
                    Icons.thermostat,
                    Colors.red,
                    '°C',
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildStatCard(
                    'Humidity',
                    humidityStats,
                    Icons.water_drop,
                    Colors.blue,
                    '%',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, Map<String, double> stats, IconData icon, Color color, String unit) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(width: 8),
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 8),
        _buildStatRow('Current', stats['current']?.toStringAsFixed(1) ?? '0.0', unit),
        _buildStatRow('Average', stats['average']?.toStringAsFixed(1) ?? '0.0', unit),
        _buildStatRow('Min', stats['min']?.toStringAsFixed(1) ?? '0.0', unit),
        _buildStatRow('Max', stats['max']?.toStringAsFixed(1) ?? '0.0', unit),
      ],
    );
  }

  Widget _buildStatRow(String label, String value, String unit) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 12)),
          Text('$value$unit', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Map<String, double> _calculateStats(List<double> values) {
    if (values.isEmpty) return {};
    
    final current = values.last;
    final average = values.reduce((a, b) => a + b) / values.length;
    final min = values.reduce((a, b) => a < b ? a : b);
    final max = values.reduce((a, b) => a > b ? a : b);
    
    return {
      'current': current,
      'average': average,
      'min': min,
      'max': max,
    };
  }
} 