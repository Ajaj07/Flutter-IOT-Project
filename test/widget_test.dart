import 'package:environmental_control_app/domain/repositories/sensor_repository.dart';
import 'package:environmental_control_app/main.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';

// Import the generated mock file, which will be created by build_runner
import 'widget_test.mocks.dart';

// Annotation to generate a mock class for SensorRepository.
@GenerateMocks([SensorRepository])
void main() {
  late MockSensorRepository mockSensorRepository;

  // Set up the mock repository before each test.
  setUp(() {
    mockSensorRepository = MockSensorRepository();
  });

  testWidgets('Renders DashboardPage and verifies title', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MyApp(repository: mockSensorRepository));

    // Verify that the main screen shows the title.
    expect(find.text('Environmental Control'), findsOneWidget);
  });
}
