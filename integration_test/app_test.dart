import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import '../test/util.dart';
import 'home_screen_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  
  late MockAppRepository repository;
  // late AppDataController dataController;
  late HomeScreenTestCases homeScreenTestCases;

  setUp(
    () {
      repository = MockAppRepository();
      // dataController = AppDataController(repository: repository);

      homeScreenTestCases = HomeScreenTestCases(repository);
    },
  );
  group(
    "Test HomeScreen",
    () {
      // testWidgets(
      //   'Ensure CircularProgressIndicator shows in loading state',
      //   (WidgetTester tester) async {
      //     await homeScreenTestCases.testLoadingState(tester);
      //   },
      // );

      testWidgets(
        'Ensure error material banner shows in error state',
        (WidgetTester tester) async {
          await homeScreenTestCases.testErrorState(tester);
        },
      );

      // testWidgets(
      //   'Ensure error empty list text shows when list empty',
      //   (WidgetTester tester) async {
      //     await homeScreenTestCases.testEmptyState(tester);
      //   },
      // );

      // testWidgets(
      //   'Ensure listview  shows when events successfully loads',
      //   (WidgetTester tester) async {
      //     await homeScreenTestCases.testDataLoadedState(tester);
      //   },
      // );
    },
  );
}
