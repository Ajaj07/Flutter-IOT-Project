import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'presentation/providers/sensor_provider.dart';
import 'presentation/providers/auth_provider.dart';
import 'presentation/pages/dashboard_page.dart';
import 'presentation/pages/login_page.dart';
import 'presentation/pages/splash_page.dart';
import 'data/repositories/sensor_repository_impl.dart';
import 'data/repositories/auth_repository_impl.dart';
import 'domain/repositories/sensor_repository.dart';
import 'domain/repositories/auth_repository.dart';
import 'core/network/api_client.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize dependencies
  final prefs = await SharedPreferences.getInstance();
  final connectivity = Connectivity();
  final apiClient = ApiClient();
  
  // Create repositories
  final sensorRepository = SensorRepositoryImpl(
    apiClient: apiClient,
    prefs: prefs,
    connectivity: connectivity,
  );
  
  final authRepository = AuthRepositoryImpl(prefs: prefs);
  
  runApp(MyApp(
    sensorRepository: sensorRepository,
    authRepository: authRepository,
  ));
}

class MyApp extends StatelessWidget {
  final SensorRepository sensorRepository;
  final AuthRepository authRepository;
  
  const MyApp({
    super.key, 
    required this.sensorRepository,
    required this.authRepository,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => SensorProvider(repository: sensorRepository),
        ),
        ChangeNotifierProvider(
          create: (context) => AuthProvider(repository: authRepository),
        ),
      ],
      child: MaterialApp(
        title: 'Environmental Control',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.green,
            brightness: Brightness.light,
          ),
          useMaterial3: true,
          appBarTheme: const AppBarTheme(
            centerTitle: true,
            elevation: 2,
          ),
          cardTheme: CardThemeData(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
        home: const AuthWrapper(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({Key? key}) : super(key: key);

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeAuth();
  }

  Future<void> _initializeAuth() async {
    final authProvider = context.read<AuthProvider>();
    await authProvider.initialize();
    if (mounted) {
      setState(() {
        _isInitialized = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return const SplashPage();
    }

    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        if (authProvider.isAuthenticated) {
          return const DashboardPage();
        } else {
          return const LoginPage();
        }
      },
    );
  }
}
