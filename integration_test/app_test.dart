import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import '../test/util.dart';
import 'home_screen_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  late MockAppRepository repository;
  late HomeScreenTestCases homeScreenTestCases;

  setUp(
    () {
      repository = MockAppRepository();

      homeScreenTestCases = HomeScreenTestCases(repository);
    },
  );
  group(
    "Test HomeScreen",
    () {
      testWidgets(
        'Ensure CircularProgressIndicator shows in loading state',
        (WidgetTester tester) async {
          await homeScreenTestCases.testLoadingState(tester);
        },
      );

      testWidgets(
        'Ensure error material banner shows in error state',
        (WidgetTester tester) async {
          await homeScreenTestCases.testErrorState(tester);
        },
      );

      testWidgets(
        'Ensure error empty list text shows when list empty',
        (WidgetTester tester) async {
          await homeScreenTestCases.testEmptyState(tester);
        },
      );

      testWidgets(
        'Ensure listview  shows when events successfully loads',
        (WidgetTester tester) async {
          await homeScreenTestCases.testDataLoadedState(tester);
        },
      );

      testWidgets(
        "Ensure material banner dismissed when cancel button tapped",
        (tester) async {
          await homeScreenTestCases
              .testMaterialBannerDismissedOnCancelPressed(tester);
        },
      );

      testWidgets(
        "Ensure AddOptionsScreen is navigated to when FAB tapped",
        (tester) async {
          await homeScreenTestCases.testFABPressed(tester);
        },
      );

      testWidgets(
        "Ensure event item is deleted when ListTile dragged",
        (tester) async {
          await homeScreenTestCases.testOnItemDraggedDelete(tester);
        },
      );
    },
  );
}
