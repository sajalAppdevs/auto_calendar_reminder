import 'package:auto_calendar_reminder/domain/domain_export.dart';
import 'package:auto_calendar_reminder/main.dart';
import 'package:auto_calendar_reminder/presentation/data_controllers.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAppRepository extends Mock implements AppRepository {}

class MockAppDataController extends Mock implements AppDataController {}

class TestUtils {
  static Future<void> pumpApp(WidgetTester tester,
      {required AppDataController dataController}) async {
    await tester.pumpWidget(
      MyApp(
        dataController: dataController,
      ),
    );
  }
}
