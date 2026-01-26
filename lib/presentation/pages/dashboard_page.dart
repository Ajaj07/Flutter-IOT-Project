import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/sensor_provider.dart';
import '../providers/auth_provider.dart';
import '../widgets/sensor_card.dart';
import '../widgets/relay_control_card.dart';
import '../widgets/connection_status.dart';
import 'configuration_page.dart';
import 'charts_page.dart';
import 'manual_control_page.dart';
import 'login_page.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SensorProvider>().initialize();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.home_outlined),
            SizedBox(width: 8),
            Text('Environmental Control'),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => context.read<SensorProvider>().fetchSensorData(),
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ConfigurationPage()),
            ),
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.account_circle),
            onSelected: (value) async {
              if (value == 'logout') {
                final authProvider = context.read<AuthProvider>();
                await authProvider.signOut();
                if (mounted) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                  );
                }
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'logout',
                child: Row(
                  children: [
                    const Icon(Icons.logout, color: Colors.red),
                    const SizedBox(width: 8),
                    const Text('Logout'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: Consumer<SensorProvider>(
        builder: (context, provider, child) {
          if (provider.currentData == null && provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return RefreshIndicator(
            onRefresh: () => provider.fetchSensorData(),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Connection Status
                  ConnectionStatus(
                    isConnected: provider.isConnected,
                    errorMessage: provider.errorMessage,
                  ),
                  const SizedBox(height: 16),

                  // Sensor Data Cards
                  Row(
                    children: [
                      Expanded(
                        child: SensorCard(
                          title: 'Temperature',
                          value: provider.currentData?.temperature ?? 0.0,
                          unit: '°C',
                          icon: Icons.thermostat,
                          color: Colors.red,
                          threshold: provider.currentData?.tempThreshold,
                          isEnabled: provider.currentData?.tempControlEnabled ?? true,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: SensorCard(
                          title: 'Humidity',
                          value: provider.currentData?.humidity ?? 0.0,
                          unit: '%',
                          icon: Icons.water_drop,
                          color: Colors.blue,
                          threshold: provider.currentData?.humidityThreshold,
                          isEnabled: provider.currentData?.humidityControlEnabled ?? true,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Relay Control Card
                  RelayControlCard(
                    isRelayOn: provider.currentData?.isRelayOn ?? false,
                    isManualMode: provider.currentData?.manualMode ?? false,
                    onToggleMode: () => provider.toggleManualMode(),
                    onToggleRelay: () => provider.toggleRelay(),
                    isLoading: provider.isLoading,
                  ),
                  const SizedBox(height: 24),

                  // Quick Actions
                  const Text(
                    'Quick Actions',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ChartsPage(),
                            ),
                          ),
                          icon: const Icon(Icons.analytics),
                          label: const Text('View Charts'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ManualControlPage(),
                            ),
                          ),
                          icon: const Icon(Icons.tune),
                          label: const Text('Manual Control'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
} 